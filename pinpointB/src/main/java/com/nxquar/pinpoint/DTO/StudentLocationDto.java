package com.nxquar.pinpoint.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudentLocationDto {
    private UUID studentId;
    private String studentName;
    private double latitude;
    private double longitude;
    private Integer floorLevel;
    private LocalDateTime timestamp;
}
