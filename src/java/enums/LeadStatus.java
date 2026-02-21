/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package enums;

public enum LeadStatus {
    New, // Lead mới tạo, chưa assign
    Assigned, // Đã assign cho sales, chưa có opp
    Working, // Có opportunity đang active
    Converted, // Có opportunity Won (terminal)
    Unqualified,// Tất cả opportunity Lost (terminal)
    Nurturing, // Tạm dừng, follow sau
    Inactive    // Đã xóa/vô hiệu hóa
}
