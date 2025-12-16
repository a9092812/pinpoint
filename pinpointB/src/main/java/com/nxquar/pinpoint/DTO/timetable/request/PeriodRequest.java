package com.nxquar.pinpoint.DTO.timetable.request;

import lombok.Data;

import java.util.UUID;

@Data
public class PeriodRequest {
    private String name; // e.g., "Period 1"
    private String startTime; // e.g., "09:00"
    private String endTime; // e.g., "10:00"
    private UUID subjectId;
    private UUID roomId;
    // The periodNumber can be inferred from the list order if needed
}