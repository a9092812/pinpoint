package com.nxquar.pinpoint.service;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.Model.Building;

import java.util.List;
import java.util.UUID;

public interface BuildingService {

    Building getBuildingById(UUID id, String jwt);

    List<Building> getBuildingsByInstitute(UUID instituteId, String jwt);
MessageResponse updateBaseAltitude(String name,Integer baseAltitude, Integer ceilHeight, UUID BuildingId, String jwt );
}
