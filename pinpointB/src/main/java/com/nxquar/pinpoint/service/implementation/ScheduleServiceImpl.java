package com.nxquar.pinpoint.service.implementation;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.timetable.DayScheduleDto;
import com.nxquar.pinpoint.DTO.timetable.PeriodDto;
import com.nxquar.pinpoint.DTO.timetable.request.DayScheduleRequest;
import com.nxquar.pinpoint.Model.Timetable.DaySchedule;
import com.nxquar.pinpoint.Model.Timetable.Timetable;
import com.nxquar.pinpoint.Repository.DayScheduleRepo;
import com.nxquar.pinpoint.Repository.TimeTableRepo;
import com.nxquar.pinpoint.service.ScheduleService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;


@Service
public class ScheduleServiceImpl implements ScheduleService {
    @Autowired
    private DayScheduleRepo dayScheduleRepo;
    @Autowired
    private TimeTableRepo timeTableRepo;
    @Autowired
    JwtService jwtService;

    @Override
    public DaySchedule createSchedule(DayScheduleRequest scheduleRequest, String jwt) {
        String role = jwtService.extractRole(jwt);
        boolean isInstitute = role.equals("INSTITUTE");
        boolean isAdmin = role.equals("ADMIN");

        if (!(isInstitute || isAdmin)) {
            throw new AccessDeniedException("You are not Authorized for creating a schedule");
        }

        // 1. Find the parent Timetable using the ID from the request DTO
        Timetable timetable = timeTableRepo.findById(scheduleRequest.getTimetableId())
                .orElseThrow(() -> new EntityNotFoundException("Timetable not found with ID: " + scheduleRequest.getTimetableId()));

        // 2. Create the new DaySchedule and link it to the parent
        DaySchedule newSchedule = new DaySchedule();
        newSchedule.setTimetable(timetable); // This now works correctly
        newSchedule.setDayOfWeek(scheduleRequest.getDayOfWeek());

        // Note: This standalone method does not create the periods from the request.
        // The "all-in-one" method in TimetableServicesImpl is more complete.

        return dayScheduleRepo.save(newSchedule);
    }

    @Override
    public DayScheduleDto getScheduleById(UUID id, String jwt) {
        DaySchedule schedule = dayScheduleRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Schedule not found"));

        List<PeriodDto> periodDtos = schedule.getPeriods().stream()
                .map(PeriodDto::fromEntity)
                .toList();

        return new DayScheduleDto(
                schedule.getId(),
                schedule.getDayOfWeek(),
                periodDtos
        );
    }


    @Override
    public List<DaySchedule> getSchedulesByTimetableId(UUID timetableId, String jwt) {
        Timetable timetable = timeTableRepo.findById(timetableId)
                .orElseThrow(() -> new EntityNotFoundException("Timetable not found"));

        return timetable.getDaySchedules();
    }

    @Transactional
    @Override
    public DaySchedule addDaySchedule(UUID timetableId, DaySchedule newSchedule) {
        Timetable timetable = timeTableRepo.findById(timetableId)
                .orElseThrow(() -> new EntityNotFoundException("Timetable not found with id: " + timetableId));

        newSchedule.setTimetable(timetable);
        return dayScheduleRepo.save(newSchedule);
    }

    @Override
    public DayScheduleDto updateSchedule(DaySchedule updatedSchedule, String jwt) {
        DaySchedule existingSchedule = dayScheduleRepo.findById(updatedSchedule.getId())
                .orElseThrow(() -> new EntityNotFoundException("DaySchedule not found"));

        String role = jwtService.extractRole(jwt);
        if (!(role.equals("INSTITUTE") || role.equals("ADMIN"))) {
            throw new AccessDeniedException("You are not authorized to update this schedule");
        }

        if (updatedSchedule.getDayOfWeek() != null) {
            existingSchedule.setDayOfWeek(updatedSchedule.getDayOfWeek());
        }

        DaySchedule saved = dayScheduleRepo.save(existingSchedule);

        // Map to DTO
        List<PeriodDto> periodDtos = saved.getPeriods().stream()
                .map(PeriodDto::fromEntity)
                .toList();

        return new DayScheduleDto(
                saved.getId(),
                saved.getDayOfWeek(),
                periodDtos
        );
    }

    @Override
    public MessageResponse deleteSchedule(UUID id, String jwt) {
        DaySchedule schedule = dayScheduleRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Schedule not found"));

        String email = jwtService.extractUserName(jwt);
        if (!schedule.getTimetable().getBatch().getInstitute().getEmail().equals(email)) {
            throw new AccessDeniedException("You are not authorized to delete this schedule");
        }

        dayScheduleRepo.delete(schedule);
        return new MessageResponse("DaySchedule deleted successfully");
    }
}