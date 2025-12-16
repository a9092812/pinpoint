package com.nxquar.pinpoint.controller;

import com.nxquar.pinpoint.DTO.AdminRequest;
import com.nxquar.pinpoint.DTO.AdminResponse;
import com.nxquar.pinpoint.DTO.AuthRequest;
import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admins")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @GetMapping("/email/{email}")
    public ResponseEntity<AdminResponse> getAdminByEmail(@PathVariable String email,
                                                         @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(adminService.getAdminByEmail(email, token));
    }

    @PostMapping
    public ResponseEntity<MessageResponse> createAdmin(@RequestBody AuthRequest request,
                                                       @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(adminService.createAdmin(request, token));
    }
    @GetMapping("/{adminId}")
    public ResponseEntity<AdminResponse> getAdminById(@PathVariable UUID adminId,
                                                      @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(adminService.getAdminById(adminId, token));
    }

    @GetMapping("/institute/{instituteId}")
    public ResponseEntity<List<AdminResponse>> getAdminsByInstitute(@PathVariable UUID instituteId,
                                                                    @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(adminService.getAllAdminsByInstitute(token));
    }


    @PutMapping("/{adminId}")
    public ResponseEntity<MessageResponse> updateAdmin(@PathVariable UUID adminId,
                                                       @RequestBody AdminRequest request,
                                                       @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(adminService.updateAdmin(adminId, request, token));
    }

    @DeleteMapping("/{adminId}")
    public ResponseEntity<MessageResponse> deleteAdmin(@PathVariable UUID adminId,
                                                       @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(adminService.deleteAdmin(adminId, token));
    }
}
