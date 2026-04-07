package enums;

public enum DeliveryStatus {
    PENDING("Đang chờ"),
    SENT("Đã gửi"),
    DELIVERED("Đã nhận"),
    FAILED("Thất bại");

    private final String vietnamese;

    DeliveryStatus(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}
