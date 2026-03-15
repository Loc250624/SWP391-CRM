package enums;

public enum NotificationType {
    // Task
    TASK_ASSIGNED("Giao công việc"),
    TASK_COMPLETED("Hoàn thành công việc"),
    TASK_OVERDUE("Công việc quá hạn"),
    TASK_COMMENT("Bình luận công việc"),
    TASK_STATUS_CHANGED("Thay đổi trạng thái công việc"),

    // Lead
    LEAD_ASSIGNED("Giao lead"),
    LEAD_CONVERTED("Lead đã chuyển đổi"),
    LEAD_STATUS_CHANGED("Thay đổi trạng thái lead"),

    // Customer
    CUSTOMER_CREATED("Khách hàng mới"),
    CUSTOMER_STATUS_CHANGED("Thay đổi trạng thái khách hàng"),

    // Opportunity
    OPPORTUNITY_CREATED("Cơ hội mới"),
    OPPORTUNITY_WON("Cơ hội thắng"),
    OPPORTUNITY_LOST("Cơ hội thua"),
    OPPORTUNITY_STAGE_CHANGED("Thay đổi giai đoạn cơ hội"),

    // Quotation
    QUOTATION_SENT("Gửi báo giá"),
    QUOTATION_APPROVED("Duyệt báo giá"),
    QUOTATION_REJECTED("Từ chối báo giá"),
    QUOTATION_EXPIRING("Báo giá sắp hết hạn"),

    // Ticket
    TICKET_CREATED("Ticket mới"),
    TICKET_RESOLVED("Ticket đã xử lý"),

    // System
    SYSTEM_ANNOUNCEMENT("Thông báo hệ thống"),
    MANAGER_BROADCAST("Thông báo từ quản lý");

    private final String vietnamese;

    NotificationType(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getVietnamese() {
        return vietnamese;
    }
}
