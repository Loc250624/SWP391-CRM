package enums;

public enum NotificationPriority {
    LOW("Thấp"),
    NORMAL("Bình thường"),
    HIGH("Cao"),
    URGENT("Khẩn cấp");

    private final String vietnamese;

    NotificationPriority(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}
