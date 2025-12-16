package com.nxquar.pinpoint.service;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.timetable.DayScheduleDto;
import com.nxquar.pinpoint.DTO.timetable.request.DayScheduleRequest;
import com.nxquar.pinpoint.Model.Timetable.DaySchedule;

import java.util.List;
import java.util.UUID;

public interface ScheduleService {
    DaySchedule createSchedule(DayScheduleRequest schedule, String jwt);

    DayScheduleDto getScheduleById(UUID id, String jwt);

    List<DaySchedule> getSchedulesByTimetableId(UUID timetableId, String jwt);

    DaySchedule addDaySchedule(UUID timetableId, DaySchedule newSchedule);

    DayScheduleDto updateSchedule(DaySchedule updatedSchedule, String jwt);

    MessageResponse deleteSchedule(UUID id, String jwt);
}
