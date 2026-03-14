package enums;

public enum NotificationCategory {
    SYSTEM("Hệ thống"),
    SALES("Kinh doanh"),
    SUPPORT("Hỗ trợ"),
    MARKETING("Marketing"),
    SLA("SLA");

    private final String vietnamese;

    NotificationCategory(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}
