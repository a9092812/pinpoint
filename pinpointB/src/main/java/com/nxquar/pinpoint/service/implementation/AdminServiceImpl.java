package com.nxquar.pinpoint.service.implementation;

import com.nxquar.pinpoint.DTO.AdminRequest;
import com.nxquar.pinpoint.DTO.AdminResponse;
import com.nxquar.pinpoint.DTO.AuthRequest;
import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.Model.Users.Admin;

import com.nxquar.pinpoint.Model.Users.Institute;
import com.nxquar.pinpoint.Repository.AdminRepo;
import com.nxquar.pinpoint.Repository.InstituteRepo;
import com.nxquar.pinpoint.constant.Role;
import com.nxquar.pinpoint.mapper.AdminMapper;
import com.nxquar.pinpoint.service.AdminService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;


@Service

public class AdminServiceImpl implements AdminService {

    @Autowired
    AdminRepo adminRepo;

    @Autowired
    JwtService jwtService;
    @Autowired
    InstituteRepo instituteRepo;
    PasswordEncoder encoder= new BCryptPasswordEncoder();


    @Override
    public MessageResponse createAdmin(AuthRequest req, String jwt) {
//        @PreAuthorize("hasRole('ROLE_INSTITUTE')")

        String jwtEmail= jwtService.extractUserName(jwt);
        Institute institute= instituteRepo.findByEmail(jwtEmail);
        String hashedPassword = encoder.encode(req.getPassword());
        req.setPassword(hashedPassword);
        if (institute == null) {
            throw new EntityNotFoundException("Institute not found for email: " + jwtEmail);
        }
        Admin admin= new Admin();

        admin.setEmail(req.getEmail());
        admin.setPhone(req.getPhone());
        admin.setPassword(req.getPassword());
        admin.setInstitute(institute);
        admin.setRole(Role.ADMIN);

        adminRepo.save(admin);
        return new MessageResponse("Admin created SucessFully");

    }

    @Override
    public AdminResponse getAdminById(UUID adminId, String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(jwtEmail);
        Admin admin = adminRepo.findById(adminId).orElseThrow(() -> new EntityNotFoundException("Admin not found"));
        if (institute != null && !admin.getInstitute().getId().equals(institute.getId())) {
            throw new AccessDeniedException("You are not allowed to access this Admin.");
        }
        if (!admin.getEmail().equals(jwtEmail))
            throw new AccessDeniedException("You are not allowed to access this Admin.");

        return AdminMapper.toResponse(admin);
    }



    @Override
    public List<AdminResponse> getAllAdminsByInstitute(String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(jwtEmail);

        if (institute == null)
            throw new AccessDeniedException("Invalid Institute");

        return adminRepo.findByInstituteId(institute.getId()).stream()
                .map(AdminMapper::toResponse)
                .toList();
    }
    @Override
    public AdminResponse getAdminByEmail(String email, String jwt) {

        Admin admin = adminRepo.findByEmail(email);

        return AdminMapper.toResponse(admin);
    }


    @Override
    public MessageResponse updateAdmin(UUID adminId, AdminRequest request, String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(jwtEmail);
        Admin admin = adminRepo.findById(adminId).orElseThrow(() -> new EntityNotFoundException("admin not Found"));
        boolean isInstitute = institute != null && admin.getInstitute().getId().equals(institute.getId());
        boolean isSelf = admin.getEmail().equals(jwtEmail);

        if (!isInstitute && !isSelf) {
            throw new AccessDeniedException("You cannot modify this admin");
        }
        if (request.getPhone() != null) {
            admin.setPhone(request.getPhone());
        }
//        if (request.getEmail() != null) {
//            admin.setEmail(request.getEmail());
//        }
        if (request.getAddress() != null) {
            admin.setAddress(request.getAddress());
        }
        if (request.getName() != null) {
            admin.setName(request.getName());
        }


        adminRepo.save(admin);
        return new MessageResponse("Admin Updated");
    }

    @Override
    public MessageResponse deleteAdmin(UUID adminId, String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(jwtEmail);
        Admin admin = adminRepo.findById(adminId).orElseThrow(() -> new EntityNotFoundException("admin not Found"));

        if (institute != null && !admin.getInstitute().getId().equals(institute.getId())) {
            throw new AccessDeniedException("You Can Not Delete This Admin");
        }
        if (!admin.getEmail().equals(jwtEmail)) {
            throw new AccessDeniedException("You Can Not Delete This Admin");
        }
        adminRepo.deleteById(adminId);
        return new MessageResponse("Admin Deleted SucessFully");
    }
}
