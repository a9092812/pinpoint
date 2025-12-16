package com.nxquar.pinpoint.service;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.timetable.request.TimetableRequest;
import com.nxquar.pinpoint.DTO.timetable.TimetableDetailDto;
import com.nxquar.pinpoint.Model.Timetable.Timetable;

import java.util.List;
import java.util.UUID;

public interface TimetableServices {
    TimetableDetailDto getTimeTableById(UUID id, String jwt);
    List<Timetable> getTimeTable(String jwt);
    Timetable createTimeTable(TimetableRequest timetable, String jwt);
    Timetable updateTimeTable(TimetableRequest updatedTimeTable, String jwt);
    MessageResponse deleteTimeTable(UUID id, String jwt);
   Timetable getTimeTableByBatchId(UUID id, String jwt);
}
