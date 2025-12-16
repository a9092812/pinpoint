package com.nxquar.pinpoint.Repository;

import com.nxquar.pinpoint.Model.Timetable.Timetable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TimeTableRepo extends JpaRepository<Timetable, UUID> {

    @Query("SELECT t FROM Timetable t WHERE t.batch.institute.email = :email")
    List<Timetable> findByInstituteEmail(@Param("email") String email);
    Optional<Timetable> findByBatchId(UUID batchId);
}
