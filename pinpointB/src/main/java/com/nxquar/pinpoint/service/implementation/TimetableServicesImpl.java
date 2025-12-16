package com.nxquar.pinpoint.service.implementation;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.timetable.TimetableDetailDto;
import com.nxquar.pinpoint.DTO.timetable.request.DayScheduleRequest;
import com.nxquar.pinpoint.DTO.timetable.request.PeriodRequest;
import com.nxquar.pinpoint.DTO.timetable.request.TimetableRequest;
import com.nxquar.pinpoint.Model.Batch;
import com.nxquar.pinpoint.Model.Room;
import com.nxquar.pinpoint.Model.Timetable.DaySchedule;
import com.nxquar.pinpoint.Model.Timetable.Period;
import com.nxquar.pinpoint.Model.Timetable.Subject;
import com.nxquar.pinpoint.Model.Timetable.Timetable;
import com.nxquar.pinpoint.Repository.*;
import com.nxquar.pinpoint.service.TimetableServices;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class TimetableServicesImpl implements TimetableServices {

    @Autowired
    private TimeTableRepo timeTableRepo;
    @Autowired
    private BatchRepo batchRepo;
    @Autowired
    private SubjectRepo subjectRepo; // Dependency for finding subjects
    @Autowired
    private RoomRepo roomRepo;     // Dependency for finding rooms
    @Autowired
    private JwtService jwtService;

    @Override
    public TimetableDetailDto getTimeTableById(UUID id, String jwt) {
        Timetable timetable = timeTableRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Timetable not found with ID: " + id));
        return TimetableDetailDto.fromEntity(timetable);
    }

    @Override
    public List<Timetable> getTimeTable(String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        return timeTableRepo.findByInstituteEmail(jwtEmail);
    }

    @Override
    @Transactional // Ensures all database operations succeed or fail together
    public Timetable createTimeTable(TimetableRequest dto, String jwt) {
        Batch batch = batchRepo.findById(dto.getBatchId())
                .orElseThrow(() -> new EntityNotFoundException("Batch not found with ID: " + dto.getBatchId()));

        Timetable timetable = new Timetable();
        timetable.setName(dto.getName());
        timetable.setBatch(batch);

        // Process and add schedules and periods from the DTO
        if (dto.getSchedules() != null) {
            List<DaySchedule> daySchedules = buildSchedulesFromRequest(dto.getSchedules(), timetable);
            timetable.setDaySchedules(daySchedules);
        }

        return timeTableRepo.save(timetable);
    }

    @Override
    @Transactional // Ensures all database operations succeed or fail together
    public Timetable updateTimeTable(TimetableRequest updatedDto, String jwt) {
        Timetable timetable = timeTableRepo.findById(updatedDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Timetable not found with ID: " + updatedDto.getId()));

        // Update basic timetable properties
        if (updatedDto.getName() != null) {
            timetable.setName(updatedDto.getName());
        }

        if (updatedDto.getBatchId() != null && !updatedDto.getBatchId().equals(timetable.getBatch().getId())) {
            Batch batch = batchRepo.findById(updatedDto.getBatchId())
                    .orElseThrow(() -> new EntityNotFoundException("Batch not found with ID: " + updatedDto.getBatchId()));
            timetable.setBatch(batch);
        }

        // For updates, the simplest strategy is to clear old schedules and add the new ones.
        // The `orphanRemoval = true` on the Timetable entity will handle deleting old entries.
        timetable.getDaySchedules().clear();
        timeTableRepo.saveAndFlush(timetable); // Persist the clearance of schedules

        // Process and add the new/updated schedules and periods from the DTO
        if (updatedDto.getSchedules() != null) {
            List<DaySchedule> daySchedules = buildSchedulesFromRequest(updatedDto.getSchedules(), timetable);
            timetable.getDaySchedules().addAll(daySchedules);
        }

        return timeTableRepo.save(timetable);
    }

    /**
     * Helper method to build a list of DaySchedule entities from the request DTO.
     */
    private List<DaySchedule> buildSchedulesFromRequest(List<DayScheduleRequest> scheduleRequests, Timetable timetable) {
        List<DaySchedule> daySchedules = new ArrayList<>();
        for (DayScheduleRequest scheduleRequest : scheduleRequests) {
            DaySchedule daySchedule = new DaySchedule();
            daySchedule.setDayOfWeek(scheduleRequest.getDayOfWeek());
            daySchedule.setTimetable(timetable);

            if (scheduleRequest.getPeriods() != null) {
                List<Period> periods = new ArrayList<>();
                for (PeriodRequest periodRequest : scheduleRequest.getPeriods()) {
                    Subject subject = subjectRepo.findById(periodRequest.getSubjectId())
                            .orElseThrow(() -> new EntityNotFoundException("Subject not found with ID: " + periodRequest.getSubjectId()));
                    Room room = roomRepo.findById(periodRequest.getRoomId())
                            .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + periodRequest.getRoomId()));

                    Period period = new Period();
                    period.setPeriodNumber(Integer.parseInt(periodRequest.getName()));
                    period.setName(periodRequest.getName());
                    period.setStartTime(LocalTime.parse(periodRequest.getStartTime()));
                    period.setEndTime(LocalTime.parse(periodRequest.getEndTime()));
                    period.setSubject(subject);
                    period.setSite(room);
                    period.setDaySchedule(daySchedule);
                    periods.add(period);
                }
                daySchedule.setPeriods(periods);
            }
            daySchedules.add(daySchedule);
        }
        return daySchedules;
    }


    @Override
    public MessageResponse deleteTimeTable(UUID id, String jwt) {
        if (!timeTableRepo.existsById(id)) {
            throw new EntityNotFoundException("Timetable not found with ID: " + id);
        }
        timeTableRepo.deleteById(id);
        return new MessageResponse("Timetable deleted successfully");
    }

    @Override
    public Timetable getTimeTableByBatchId(UUID id, String jwt) {
        return timeTableRepo.findByBatchId(id)
                .orElseThrow(() -> new EntityNotFoundException("Timetable not found for batch ID: " + id));
    }
}