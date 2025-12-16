package com.nxquar.pinpoint.service.implementation;


import com.nxquar.pinpoint.DTO.dashboard.LiveClassDto;
import com.nxquar.pinpoint.DTO.dashboard.UpcomingPeriodDto;
import com.nxquar.pinpoint.Model.Batch;
import com.nxquar.pinpoint.Model.Timetable.Period;
import com.nxquar.pinpoint.Model.Users.Admin;
import com.nxquar.pinpoint.Model.Users.User;
import com.nxquar.pinpoint.Repository.AdminRepo;
import com.nxquar.pinpoint.Repository.AttendanceRepo;
import com.nxquar.pinpoint.Repository.UserRepo;
import com.nxquar.pinpoint.service.DashboardService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired private AdminRepo adminRepo;
    @Autowired private UserRepo userRepo;
    @Autowired private AttendanceRepo attendanceRepo;
    @Autowired private JwtService jwtService;

    @Override
    public List<LiveClassDto> getLiveClassesForAdmin(String jwt) {
        String email = jwtService.extractUserName(jwt);
        Admin admin = adminRepo.findByEmail(email);
        if (admin == null) {
            throw new EntityNotFoundException("Admin not found");
        }

        List<LiveClassDto> liveClasses = new ArrayList<>();
        LocalTime now = LocalTime.now();
        String dayOfWeek = java.time.LocalDate.now().getDayOfWeek().name();

        for (Batch batch : admin.getBatch()) {
            Optional<Period> maybePeriod = attendanceRepo.findCurrentPeriodByBatch(batch.getId(), dayOfWeek, now);

            maybePeriod.ifPresent(period -> {
                int totalStudents = batch.getStudents().size();
                int presentStudents = (int) batch.getStudents().stream()
                        .filter(student -> attendanceRepo.findByStudentAndPeriod(student, period).isPresent())
                        .count();

                liveClasses.add(new LiveClassDto(
                        batch.getId(),
                        period.getSubject().getName(),
                        batch.getName(),
                        period.getStartTime() + " - " + period.getEndTime(),
                        presentStudents,
                        totalStudents
                ));
            });
        }
        return liveClasses;
    }

    @Override
    public UpcomingPeriodDto getUpcomingPeriodForStudent(String jwt) {
        String email = jwtService.extractUserName(jwt);
        User student = userRepo.findByEmail(email);
//                .orElseThrow(() -> new EntityNotFoundException("Student not found"));

        LocalTime now = LocalTime.now();
        String dayOfWeek = java.time.LocalDate.now().getDayOfWeek().name();
        Optional<Period> maybePeriod = attendanceRepo.findCurrentPeriodByBatch(student.getBatch().getId(), dayOfWeek, now);

        if (maybePeriod.isPresent()) {
            Period period = maybePeriod.get();
            return new UpcomingPeriodDto(
                    period.getSubject().getName(),
                    period.getStartTime() + " - " + period.getEndTime(),
                    period.getSite().getName()
            );
        }
        // TODO: Implement logic to find the actual *next* period if none is live.
        return new UpcomingPeriodDto("No upcoming class", "", "");
    }
}

// ---
