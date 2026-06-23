package model;

import java.sql.Date;

public class Intake {

    private int id;
    private int userId;
    private Date intakeDate;
    private int calories;
    private float waterLiters;

    // Default constructor
    public Intake() {}

    // Constructor without id (for insert)
    public Intake(int userId, Date intakeDate, int calories, float waterLiters) {
        this.userId = userId;
        this.intakeDate = intakeDate;
        this.calories = calories;
        this.waterLiters = waterLiters;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getIntakeDate() { return intakeDate; }
    public void setIntakeDate(Date intakeDate) { this.intakeDate = intakeDate; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public float getWaterLiters() { return waterLiters; }
    public void setWaterLiters(float waterLiters) { this.waterLiters = waterLiters; }
}