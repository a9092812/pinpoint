package com.nxquar.pinpoint.service;


import com.nxquar.pinpoint.DTO.AdminRequest;
import com.nxquar.pinpoint.DTO.AdminResponse;
import com.nxquar.pinpoint.DTO.AuthRequest;
import com.nxquar.pinpoint.DTO.MessageResponse;

import java.util.List;
import java.util.UUID;

public interface AdminService {
    MessageResponse createAdmin(AuthRequest request, String jwt);
    AdminResponse getAdminById(UUID adminId, String jwt);
    List<AdminResponse> getAllAdminsByInstitute(String jwt);
    public AdminResponse getAdminByEmail(String email, String jwt);
    MessageResponse updateAdmin(UUID adminId, AdminRequest request, String jwt);
    MessageResponse deleteAdmin(UUID adminId, String jwt);
}
