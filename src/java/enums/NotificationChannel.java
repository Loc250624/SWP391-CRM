package enums;

public enum NotificationChannel {
    IN_APP("Trong ứng dụng"),
    EMAIL("Email"),
    SMS("SMS"),
    PUSH("Push notification");

    private final String vietnamese;

    NotificationChannel(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}
