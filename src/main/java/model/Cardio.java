package model;

import java.sql.Date;

public class Cardio {
    private int id;
    private int userId;
    private String cardioType;
    private int duration;
    private int calories;
    private Date cardioDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCardioType() { return cardioType; }
    public void setCardioType(String cardioType) { this.cardioType = cardioType; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public Date getCardioDate() { return cardioDate; }
    public void setCardioDate(Date cardioDate) { this.cardioDate = cardioDate; }
}
