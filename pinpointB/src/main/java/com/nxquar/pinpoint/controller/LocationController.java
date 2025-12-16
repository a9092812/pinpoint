package com.nxquar.pinpoint.controller;

 import com.nxquar.pinpoint.DTO.StudentLocationDto;
 import com.nxquar.pinpoint.service.locationGeoJsonService.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/location")
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/live/batch/{batchId}")
    public ResponseEntity<List<StudentLocationDto>> getLiveBatchLocations(@PathVariable UUID batchId) {
        return ResponseEntity.ok(locationService.getLiveLocationsForBatch(batchId));
    }

    @GetMapping("/history/student/{studentId}")
    public ResponseEntity<List<StudentLocationDto>> getStudentLocationHistory(
            @PathVariable UUID studentId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(locationService.getLocationHistoryForStudent(studentId, start, end));
    }
}
