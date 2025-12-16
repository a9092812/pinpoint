package com.nxquar.pinpoint.service.locationGeoJsonService;

import com.fasterxml.jackson.databind.JsonNode;
import com.nxquar.pinpoint.Model.Building;
import com.nxquar.pinpoint.Model.Floor;
import com.nxquar.pinpoint.Model.Room;
import com.nxquar.pinpoint.Model.Users.Institute;
import com.nxquar.pinpoint.Repository.BuildingRepository;
import com.nxquar.pinpoint.Repository.InstituteRepo;
import com.nxquar.pinpoint.service.implementation.JwtService;
import jakarta.transaction.Transactional;
import org.locationtech.jts.geom.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class LocationParsingService {

    @Autowired
    private BuildingRepository buildingRepository;

    @Autowired
    private InstituteRepo instituteRepo;

    @Autowired
    private JwtService jwtService;

    private final GeometryFactory geometryFactory = new GeometryFactory();

    @Transactional
    public Building processGeoJsonBuilding(JsonNode geoJson, String jwt) {

        String email = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(email);
        if (institute == null) {
            throw new AccessDeniedException("Not an institute user");
        }

        Building building = new Building();
        building.setInstitute(institute);
        building.setFloors(new ArrayList<>());

        Map<Integer, List<JsonNode>> featuresByFloor = new HashMap<>();

        for (JsonNode feature : geoJson.get("features")) {
            int floorLevel = feature.get("properties").get("floor").asInt();
            featuresByFloor.computeIfAbsent(floorLevel, k -> new ArrayList<>()).add(feature);
        }

        for (Map.Entry<Integer, List<JsonNode>> entry : featuresByFloor.entrySet()) {

            Floor floor = new Floor();
            floor.setLevel(entry.getKey());
            floor.setBuilding(building);
            floor.setRooms(new ArrayList<>());
            building.getFloors().add(floor);

            for (JsonNode feature : entry.getValue()) {

                JsonNode props = feature.get("properties");

                Room room = new Room();
                room.setName(props.get("name").asText());
                room.setType(props.get("type").asText());
                room.setFloorLevel(props.get("floor").asInt());
                room.setFloor(floor);

                Geometry geometry = parseGeometry(feature.get("geometry"));

                // ✅ clean geometry
                geometry = geometry.buffer(0);

                // 🔴 CRITICAL: force MultiPolygon AFTER buffer
                if (geometry instanceof Polygon) {
                    geometry = geometryFactory.createMultiPolygon(
                            new Polygon[]{(Polygon) geometry}
                    );
                }

                geometry.setSRID(4326);
                room.setGeometry(geometry);

                floor.getRooms().add(room);
            }
        }

        return buildingRepository.save(building);
    }

    // ---------- Geometry helpers ----------

    private Geometry parseGeometry(JsonNode geometryNode) {
        String type = geometryNode.get("type").asText();
        JsonNode coords = geometryNode.get("coordinates");

        if ("Polygon".equals(type)) {
            return createPolygon(coords);
        }
        if ("MultiPolygon".equals(type)) {
            return createMultiPolygon(coords);
        }
        throw new IllegalArgumentException("Unsupported geometry type: " + type);
    }

    private Polygon createPolygon(JsonNode coordinates) {
        LinearRing shell = geometryFactory.createLinearRing(createCoordinates(coordinates.get(0)));
        LinearRing[] holes = new LinearRing[coordinates.size() - 1];
        for (int i = 1; i < coordinates.size(); i++) {
            holes[i - 1] = geometryFactory.createLinearRing(createCoordinates(coordinates.get(i)));
        }
        return geometryFactory.createPolygon(shell, holes);
    }

    private MultiPolygon createMultiPolygon(JsonNode coordinates) {
        Polygon[] polygons = new Polygon[coordinates.size()];
        for (int i = 0; i < coordinates.size(); i++) {
            polygons[i] = createPolygon(coordinates.get(i));
        }
        return geometryFactory.createMultiPolygon(polygons);
    }

    private Coordinate[] createCoordinates(JsonNode array) {
        Coordinate[] coords = new Coordinate[array.size()];
        for (int i = 0; i < array.size(); i++) {
            coords[i] = new Coordinate(
                    array.get(i).get(0).asDouble(),
                    array.get(i).get(1).asDouble()
            );
        }
        return coords;
    }
}
