package com.nxquar.pinpoint.controller;


import com.nxquar.pinpoint.DTO.dashboard.LiveClassDto;
import com.nxquar.pinpoint.DTO.dashboard.UpcomingPeriodDto;
import com.nxquar.pinpoint.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/admin/live-classes")
    public ResponseEntity<List<LiveClassDto>> getAdminLiveClasses(@RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(dashboardService.getLiveClassesForAdmin(token));
    }

    @GetMapping("/student/upcoming-period")
    public ResponseEntity<UpcomingPeriodDto> getStudentUpcomingPeriod(@RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(dashboardService.getUpcomingPeriodForStudent(token));
    }
}
