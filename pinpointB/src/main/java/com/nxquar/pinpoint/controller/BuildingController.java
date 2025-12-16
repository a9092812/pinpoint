package com.nxquar.pinpoint.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.Model.Building;
import com.nxquar.pinpoint.service.BuildingService;
import com.nxquar.pinpoint.service.locationGeoJsonService.LocationParsingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/buildings")
public class BuildingController {

    @Autowired
    private LocationParsingService locationParsingService;

    @Autowired
    private BuildingService buildingService;

    @PostMapping(
            path = "/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<Building> uploadBuildingGeoJson(@RequestParam("file") MultipartFile file,  @RequestHeader("Authorization") String jwt) {
        try {
            String token = jwt.replace("Bearer ", "");

            ObjectMapper mapper = new ObjectMapper();
            JsonNode geoJson = mapper.readTree(file.getInputStream());
            Building building = locationParsingService.processGeoJsonBuilding(geoJson,token);
            return ResponseEntity.ok(building);
        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Building> getBuildingById(@PathVariable UUID id,
                                                    @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(buildingService.getBuildingById(id, token));
    }

    @GetMapping("/institute/{instituteId}")
    public ResponseEntity<List<Building>> getBuildingsByInstitute(@PathVariable UUID instituteId,
                                                                  @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(buildingService.getBuildingsByInstitute(instituteId, token));
    }

    @PutMapping("/{buildingId}/altitude")
    public ResponseEntity<MessageResponse> updateBaseAltitude(@PathVariable UUID buildingId,
                                                              @RequestParam String name,
                                                              @RequestParam Integer baseAltitude,
                                                              @RequestParam Integer ceilHeight,
                                                              @RequestHeader("Authorization") String jwt) {
        String token = jwt.replace("Bearer ", "");
        return ResponseEntity.ok(buildingService.updateBaseAltitude(name,baseAltitude, ceilHeight,buildingId, token));
    }
}
