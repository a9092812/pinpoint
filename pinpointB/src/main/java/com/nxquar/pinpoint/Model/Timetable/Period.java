package com.nxquar.pinpoint.Model.Timetable;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nxquar.pinpoint.Model.Room;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.time.LocalTime;
import java.util.UUID;

@Entity
@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Period {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    private int periodNumber; // 1, 2, 3...
    private String name; // "Period 1", "Lecture 2", "Lunch"
    
    private LocalTime startTime;
    private LocalTime endTime;
    
    @ManyToOne
    private Subject subject; // Null for breaks/lunch
    
//    @ManyToOne
//    private User teacher; // Optional
@ManyToOne
@JsonIgnore
@ToString.Exclude
@EqualsAndHashCode.Exclude
private Room site;



    @ManyToOne
    @JsonIgnore
    private DaySchedule daySchedule;
}