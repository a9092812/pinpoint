package com.nxquar.pinpoint.controller;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.timetable.request.TimetableRequest;
import com.nxquar.pinpoint.DTO.timetable.TimetableDetailDto;
import com.nxquar.pinpoint.Model.Timetable.Timetable;
import com.nxquar.pinpoint.service.TimetableServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/timetables")
public class TimetableController {

    @Autowired
    private TimetableServices timetableServices;

    @GetMapping("/{id}")
    public ResponseEntity<TimetableDetailDto> getTimetableById(
            @PathVariable UUID id,
            @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(timetableServices.getTimeTableById(id, token));
    }


    @GetMapping
    public ResponseEntity<List<Timetable>> getAllTimetables(@RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(timetableServices.getTimeTable(token));
    }

    @PostMapping
    public ResponseEntity<Timetable> createTimetable(@RequestBody TimetableRequest dto,
                                                     @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(timetableServices.createTimeTable(dto, token));
    }

    @PutMapping
    public ResponseEntity<Timetable> updateTimetable(@RequestBody TimetableRequest updatedDto,
                                                     @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(timetableServices.updateTimeTable(updatedDto, token));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<MessageResponse> deleteTimetable(@PathVariable UUID id,
                                                           @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(timetableServices.deleteTimeTable(id, token));
    }

    @GetMapping("/batch/{batchId}")
    public ResponseEntity<Timetable> getTimetableByBatchId(
            @PathVariable UUID batchId,
            @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(timetableServices.getTimeTableByBatchId(batchId, token));
    }

}
