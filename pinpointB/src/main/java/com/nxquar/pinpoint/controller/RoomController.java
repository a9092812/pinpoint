package com.nxquar.pinpoint.controller;

import com.nxquar.pinpoint.DTO.RoomMapDto;
import com.nxquar.pinpoint.Model.Room;
import com.nxquar.pinpoint.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomService roomService;

    @GetMapping("/{id}")
    public ResponseEntity<Room> getRoomById(@PathVariable UUID id,
                                            @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(roomService.getRoomById(id, token));
    }

    @GetMapping("/floor/{level}")
    public ResponseEntity<List<Room>> getRoomsByFloor(@PathVariable Integer level,
                                                      @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(roomService.getRoomsByFloor(level, token));
    }

    @GetMapping("/building/{buildingId}")
    public ResponseEntity<List<Room>> getRoomsByBuilding(@PathVariable UUID buildingId,
                                                         @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(roomService.getRoomsByBuilding(buildingId, token));
    }

    @GetMapping("/building/{buildingId}/map")
    public ResponseEntity<List<RoomMapDto>> getRoomsForMap(
            @PathVariable UUID buildingId,
            @RequestHeader("Authorization") String jwt
    ) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(roomService.getRoomsForMap(buildingId, token));
    }


    @GetMapping("/institute/{instituteId}")
    public ResponseEntity<List<Room>> getRoomsByInstitute(@PathVariable UUID instituteId,
                                                          @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(roomService.getRoomsByInstitute(instituteId, token));
    }
}
