package com.nxquar.pinpoint.DTO.dashboard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LiveClassDto {
    private UUID batchId;
    private String subject;
    private String batchName;
    private String time;
    private int presentStudents;
    private int totalStudents;
}
