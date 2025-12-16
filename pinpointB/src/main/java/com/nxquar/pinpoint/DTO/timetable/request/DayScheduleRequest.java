package com.nxquar.pinpoint.DTO.timetable.request;

import lombok.Data;
import java.time.DayOfWeek;
import java.util.List;
import java.util.UUID;

@Data
public class DayScheduleRequest {
    private UUID timetableId; // ID of the Timetable this schedule belongs to
    private DayOfWeek dayOfWeek;
    private List<PeriodRequest> periods;
}