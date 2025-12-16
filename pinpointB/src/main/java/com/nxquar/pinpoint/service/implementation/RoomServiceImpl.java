package com.nxquar.pinpoint.service.implementation;

import org.locationtech.jts.io.geojson.GeoJsonWriter;
import com.nxquar.pinpoint.DTO.RoomMapDto;
import com.nxquar.pinpoint.Model.Room;
import com.nxquar.pinpoint.Model.Users.Admin;
import com.nxquar.pinpoint.Model.Users.Institute;
import com.nxquar.pinpoint.Repository.AdminRepo;
import com.nxquar.pinpoint.Repository.InstituteRepo;
import com.nxquar.pinpoint.Repository.RoomRepo;
import com.nxquar.pinpoint.service.RoomService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
@Service
public class RoomServiceImpl implements RoomService {

    @Autowired
    private RoomRepo roomRepo;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private InstituteRepo instituteRepo;

    @Autowired
    private AdminRepo adminRepo;

    private UUID resolveInstituteIdFromJWT(String jwt) {
        String email = jwtService.extractUserName(jwt);

        Institute institute = instituteRepo.findByEmail(email);
        if (institute != null) return institute.getId();

        Admin admin = adminRepo.findByEmail(email);
        if (admin != null && admin.getInstitute() != null) return admin.getInstitute().getId();

        throw new AccessDeniedException("Unauthorized: Cannot determine institute from token.");
    }

    @Override
    public Room getRoomById(UUID id, String jwt) {
        UUID instituteId = resolveInstituteIdFromJWT(jwt);
        Room room = roomRepo.findById(id).orElseThrow(() ->
                new EntityNotFoundException("Room not found")
        );

        if (!room.getFloor().getBuilding().getInstitute().getId().equals(instituteId)) {
            throw new AccessDeniedException("You are not authorized to access this room.");
        }

        return room;
    }

    @Override
    public List<Room> getRoomsByFloor(Integer level, String jwt) {
        UUID instituteId = resolveInstituteIdFromJWT(jwt);
        List<Room> rooms = roomRepo.findByFloorLevel(level);
        return rooms.stream()
                .filter(room -> room.getFloor().getBuilding().getInstitute().getId().equals(instituteId))
                .toList();
    }

    @Override
    public List<Room> getRoomsByBuilding(UUID buildingId, String jwt) {
        UUID instituteId = resolveInstituteIdFromJWT(jwt);
        List<Room> rooms = roomRepo.findRoomsByBuilding(buildingId);
        return rooms.stream()
                .filter(room -> room.getFloor().getBuilding().getInstitute().getId().equals(instituteId))
                .toList();
    }

    @Override
    public List<Room> getRoomsByInstitute(UUID instituteId, String jwt) {
        UUID requesterInstituteId = resolveInstituteIdFromJWT(jwt);
        if (!instituteId.equals(requesterInstituteId)) {
            throw new AccessDeniedException("Access denied to this institute's rooms.");
        }
        return roomRepo.findRoomsByInstitute(instituteId);
    }


    @Override
    public List<RoomMapDto> getRoomsForMap(UUID buildingId, String token) {
        GeoJsonWriter writer = new GeoJsonWriter();

        return roomRepo.findRoomsByBuilding(buildingId)
                .stream()
                .map(room -> new RoomMapDto(
                        room.getId(),
                        room.getName(),
                        room.getType(),
                        room.getFloorLevel(),
                        writer.write(room.getGeometry())
                ))
                .toList();
    }
}
