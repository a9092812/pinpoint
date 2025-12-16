package com.nxquar.pinpoint.service.implementation;

import com.nxquar.pinpoint.DTO.MessageResponse;
import com.nxquar.pinpoint.DTO.branch.BatchAdminDTO;
import com.nxquar.pinpoint.DTO.branch.BatchDetailResponse;
import com.nxquar.pinpoint.DTO.branch.BatchListResponse;
import com.nxquar.pinpoint.DTO.branch.BatchUserDTO;
import com.nxquar.pinpoint.Model.Batch;
import com.nxquar.pinpoint.Model.Users.Admin;
import com.nxquar.pinpoint.Model.Users.Institute;
import com.nxquar.pinpoint.Repository.AdminRepo;
import com.nxquar.pinpoint.Repository.BatchRepo;
import com.nxquar.pinpoint.Repository.InstituteRepo;
import com.nxquar.pinpoint.constant.Role;
import com.nxquar.pinpoint.service.BatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;


@Service

public class BatchServiceImpl implements BatchService {
    @Autowired
    InstituteRepo instituteRepo;

    @Autowired
    BatchRepo batchRepo;

    @Autowired
    AdminRepo adminRepo;


    @Autowired
    JwtService jwtService;

    @Override
    public Batch createBatch(Batch batch, String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(jwtEmail);

        if (institute == null) {
            throw new AccessDeniedException("Invalid institute access.");
        }

        batch.setInstitute(institute);
        return batchRepo.save(batch);
    }


    @Override
    public Batch updateBatch(UUID id, Batch batch, String jwt) {
        return null;
    }

    @Override
    public MessageResponse deleteBatch(UUID id, String jwt) {
        String jwtEmail = jwtService.extractUserName(jwt);
        Institute institute = instituteRepo.findByEmail(jwtEmail);

        if (institute == null) {
            throw new AccessDeniedException("Invalid token: Institute not found.");
        }

        Batch batch = batchRepo.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Batch not found with ID: " + id)
        );

        if (!batch.getInstitute().getId().equals(institute.getId())) {
            throw new AccessDeniedException("You are not authorized to delete this batch.");
        }

        batchRepo.deleteById(id);
        return new MessageResponse("Batch deleted successfully.");
    }

    @Override
    public BatchDetailResponse getBatchDetailsById(UUID id) {
        Batch batch = batchRepo.findById(id).orElseThrow();

        List<BatchUserDTO> students = batch.getStudents().stream().map(student ->
                new BatchUserDTO(
                        student.getId(),
                        student.getName(),
                        student.getPhone()
                )
        ).toList();

        List<BatchAdminDTO> admins = batch.getAdmins().stream().map(admin ->
                new BatchAdminDTO(
                        admin.getId(),
                        admin.getName()
                )
        ).toList();

        UUID timetableId = batch.getTimetable() != null ? batch.getTimetable().getId() : null;

        return new BatchDetailResponse(
                batch.getId(),
                batch.getName(),
                batch.getCode(),
                students,
                admins,
                timetableId
        );
    }




    public List<Batch> getAllBatches(String jwt) {
        String email = jwtService.extractUserName(jwt);

        Institute institute = instituteRepo.findByEmail(email);
        if (institute != null) {
            return batchRepo.findByInstitute_Id(institute.getId());
        }

        Admin admin = adminRepo.findByEmail(email);
        if (admin != null && admin.getInstitute() != null) {
            return batchRepo.findByInstitute_Id(admin.getInstitute().getId());
        }

        throw new AccessDeniedException("Only admins or institutes can view batches.");
    }
    @Override
    public List<BatchListResponse> getAllBatchSummaries(String jwt) {
        List<Batch> batches = getAllBatches(jwt);  // using your existing method
        return batches.stream()
                .map(batch -> new BatchListResponse(
                        batch.getId(),
                        batch.getName(),
                        batch.getCode()
                ))
                .toList();
    }


}
