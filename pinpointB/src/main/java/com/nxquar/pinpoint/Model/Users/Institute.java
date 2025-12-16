package com.nxquar.pinpoint.Model.Users;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.nxquar.pinpoint.Model.Address;
import com.nxquar.pinpoint.Model.Batch;
import com.nxquar.pinpoint.Model.Building;
import com.nxquar.pinpoint.Model.Timetable.Subject;
import com.nxquar.pinpoint.constant.Role;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Institute implements  AppUser {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(unique = true)
    private String email;

    private String phone;
    private String name;
    @JsonIgnore
    private String password;

    private String baseAltitude;
    @Enumerated(EnumType.STRING)
    private Role role=Role.INSTITUTE;

private String geoJsonUrl;
    @OneToOne
    private Address address;


    @OneToMany(mappedBy = "institute", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    @JsonIgnore
    private List<Building> buildings;

    @OneToMany(mappedBy = "institute", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Batch> batches;

    @OneToMany(mappedBy = "institute", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Subject> subjects;

    @JsonIgnore
    @OneToMany(mappedBy = "institute", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<User> userList=new ArrayList<>();
@JsonIgnore
@OneToMany(mappedBy = "institute", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Admin> adminList=new ArrayList<>();

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
    private String otp;
    private LocalDateTime otpExpiry;
    private boolean isVerified;
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = createdAt;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }


}
