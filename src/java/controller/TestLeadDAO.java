package controller;

import dao.LeadDAO;
import model.Lead;
import java.util.List;

public class TestLeadDAO {
    public static void main(String[] args) {
        LeadDAO dao = new LeadDAO();
        List<Lead> leads = dao.getLeadsForPipeline();

       System.out.println("=== BEFORE ===");
dao.getLeadsForPipeline().forEach(l ->
        System.out.println(l.getId() + " | " + l.getFullName() + " | " + l.getLeadStatusId() + " (" + l.getLeadStatusName() + ")")
);

boolean ok = dao.updateLeadStatus(4, 2); // ví dụ đổi lead id=4 sang CONTACTED
System.out.println("Update result = " + ok);

System.out.println("=== AFTER ===");
dao.getLeadsForPipeline().forEach(l ->
        System.out.println(l.getId() + " | " + l.getFullName() + " | " + l.getLeadStatusId() + " (" + l.getLeadStatusName() + ")")
);

    }
}
