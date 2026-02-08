package enums;

public enum TaskStatus {
    PENDING("Chờ xử lý"),
    IN_PROGRESS("Đang thực hiện"),
    COMPLETED("Hoàn thành"),
    CANCELLED("Đã hủy");

    private final String vietnamese;

    TaskStatus(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}