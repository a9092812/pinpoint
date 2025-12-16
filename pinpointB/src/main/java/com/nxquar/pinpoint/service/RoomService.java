package com.nxquar.pinpoint.service;

import com.nxquar.pinpoint.DTO.RoomMapDto;
import com.nxquar.pinpoint.Model.Room;

import java.util.List;
import java.util.UUID;

public interface RoomService {

    Room getRoomById(UUID id, String jwt);

    List<Room> getRoomsByFloor(Integer level, String jwt);

    List<Room> getRoomsByBuilding(UUID buildingId, String jwt);

    List<Room> getRoomsByInstitute(UUID instituteId, String jwt);

    List<RoomMapDto> getRoomsForMap(UUID buildingId, String token);

}
