package com.nxquar.pinpoint.controller;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.timetable.DayScheduleDto;
import com.nxquar.pinpoint.DTO.timetable.request.DayScheduleRequest;
import com.nxquar.pinpoint.Model.Timetable.DaySchedule;
import com.nxquar.pinpoint.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/schedules")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    @PostMapping
    public ResponseEntity<DaySchedule> createSchedule(@RequestBody DayScheduleRequest request,
                                                      @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(scheduleService.createSchedule(request, token));
    }

    @GetMapping("/{id}")
    public ResponseEntity<DayScheduleDto> getScheduleById(@PathVariable UUID id,
                                                          @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(scheduleService.getScheduleById(id, token));
    }

    @GetMapping("/timetable/{timetableId}")
    public ResponseEntity<List<DaySchedule>> getSchedulesByTimetable(@PathVariable UUID timetableId,
                                                                     @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(scheduleService.getSchedulesByTimetableId(timetableId, token));
    }

    @PostMapping("/timetable/{timetableId}")
    public ResponseEntity<DaySchedule> addDaySchedule(@PathVariable UUID timetableId,
                                                      @RequestBody DaySchedule newSchedule) {
        return ResponseEntity.ok(scheduleService.addDaySchedule(timetableId, newSchedule));
    }
    @PutMapping
    public ResponseEntity<DayScheduleDto> updateSchedule(@RequestBody DaySchedule updatedSchedule,
                                                         @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(scheduleService.updateSchedule(updatedSchedule, token));
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<MessageResponse> deleteSchedule(@PathVariable UUID id,
                                                          @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(scheduleService.deleteSchedule(id, token));
    }
}
