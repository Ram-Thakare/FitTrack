package model;

public class HealthCalculator {

    // ================= BMR =================
    public static double calculateBMR(double weight, double height, int age, String gender) {
        double bmr;

        if (gender.equalsIgnoreCase("male")) {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        }
        return bmr;
    }

    // ================= Daily Calories =================
    public static double calculateDailyCalories(double bmr, String activityLevel) {
        double factor = 1.2; // sedentary default

        if (activityLevel.equalsIgnoreCase("light")) {
            factor = 1.375;
        } else if (activityLevel.equalsIgnoreCase("moderate")) {
            factor = 1.55;
        } else if (
            activityLevel.equalsIgnoreCase("active") ||
            activityLevel.equalsIgnoreCase("heavy")
        ) {
            factor = 1.725;
        }

        return bmr * factor;
    }

    // ================= Required Calories (ONE CALL) =================
    public static int getRequiredCalories(
            double weight,
            double height,
            int age,
            String gender,
            String activityLevel) {

        double bmr = calculateBMR(weight, height, age, gender);
        return (int) calculateDailyCalories(bmr, activityLevel);
    }

    // ================= Required Water =================
    public static float getRequiredWater(double weight) {
        return (float) ((weight * 35) / 1000); // liters
    }

    // ================= BMI =================
    public static double calculateBMI(int heightCm, int weightKg) {
        double heightM = heightCm / 100.0;
        return weightKg / (heightM * heightM);
    }

    public static String bmiStatus(double bmi) {
        if (bmi < 18.5)
            return "Underweight";
        else if (bmi < 24.9)
            return "Normal";
        else if (bmi < 29.9)
            return "Overweight";
        else
            return "Obese";
    }
}
