package model;

import java.sql.Date;

public class Sleep {
    private int id;
    private int userId;
    private int sleepHours;
    private Date sleepDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getSleepHours() { return sleepHours; }
    public void setSleepHours(int sleepHours) { this.sleepHours = sleepHours; }

    public Date getSleepDate() { return sleepDate; }
    public void setSleepDate(Date sleepDate) { this.sleepDate = sleepDate; }
}
