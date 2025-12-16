package com.nxquar.pinpoint.DTO.timetable.request;

import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class TimetableRequest {
    private UUID id;
    private String name;
    private UUID batchId;
    private List<DayScheduleRequest> schedules;
}
