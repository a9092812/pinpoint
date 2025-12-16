package com.nxquar.pinpoint.DTO;

import com.nxquar.pinpoint.DTO.branch.BatchListResponse;
import com.nxquar.pinpoint.Model.Address;
import com.nxquar.pinpoint.Model.Notice;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdminResponse {
    private UUID id;
    private String email;
    private String phone;
    private String name;
    private String role;
    private Address address;
    private UUID instituteId;
    private List<BatchListResponse> batches;
    private List<Notice> notices;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isVerified;
}
