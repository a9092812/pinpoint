package com.nxquar.pinpoint.DTO;

import java.util.UUID;

public record RoomMapDto(
        UUID id,
        String name,
        String type,
        Integer floorLevel,
        String geometry // GeoJSON
) {}
