package enums;

public enum TargetType {
    INDIVIDUAL("Cá nhân"),
    ROLE("Theo vai trò"),
    DEPARTMENT("Theo phòng ban"),
    ALL("Toàn bộ hệ thống");

    private final String vietnamese;

    TargetType(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}
