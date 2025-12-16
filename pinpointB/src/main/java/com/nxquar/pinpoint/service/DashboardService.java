package com.nxquar.pinpoint.service;



import com.nxquar.pinpoint.DTO.dashboard.LiveClassDto;
import com.nxquar.pinpoint.DTO.dashboard.UpcomingPeriodDto;

import java.util.List;

public interface DashboardService {
    List<LiveClassDto> getLiveClassesForAdmin(String jwt);
    UpcomingPeriodDto getUpcomingPeriodForStudent(String jwt);
}
