package controller;

import dao.LeadStatusDAO;
import model.LeadStatus;
import java.util.List;

public class TestLeadStatus {
    public static void main(String[] args) {
        LeadStatusDAO dao = new LeadStatusDAO();
        List<LeadStatus> list = dao.getAll();

        if (list.isEmpty()) {
            System.out.println(" Bảng lead_status chưa có dữ liệu!");
        } else {
            for (LeadStatus ls : list) {
                System.out.println(
                    ls.getId() + " | " + ls.getCode() + " | " + ls.getName()
                );
            }
        }
    }
}
