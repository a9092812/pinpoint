package com.nxquar.pinpoint.DTO.dashboard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UpcomingPeriodDto {
    private String subject;
    private String time; // e.g., "10:00 AM - 11:00 AM"
    private String roomName;
}