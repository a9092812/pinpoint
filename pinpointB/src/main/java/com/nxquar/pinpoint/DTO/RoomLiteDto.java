package com.nxquar.pinpoint.DTO;

import java.util.UUID;

public record RoomLiteDto(
        UUID id,
        String name,
        String type,
        Integer floorLevel
) {}
