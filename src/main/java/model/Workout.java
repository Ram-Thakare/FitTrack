package model;

import java.sql.Date;

public class Workout {

    private int id;
    private int userId;
    private String workoutType;   // NEW
    private String workoutName;
    private double weight;
    private int reps;
    private Date workoutDate;

    // Getters and Setters

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getWorkoutType() {
        return workoutType;
    }
    public void setWorkoutType(String workoutType) {
        this.workoutType = workoutType;
    }

    public String getWorkoutName() {
        return workoutName;
    }
    public void setWorkoutName(String workoutName) {
        this.workoutName = workoutName;
    }

    public double getWeight() {
        return weight;
    }
    public void setWeight(double weight) {
        this.weight = weight;
    }

    public int getReps() {
        return reps;
    }
    public void setReps(int reps) {
        this.reps = reps;
    }

    public Date getWorkoutDate() {
        return workoutDate;
    }
    public void setWorkoutDate(Date workoutDate) {
        this.workoutDate = workoutDate;
    }
}
