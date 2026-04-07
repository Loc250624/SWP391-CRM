package util;

import dao.CustomerDAO;
import dao.NotificationDAO;
import dao.QuotationDAO;
import dao.TaskAssigneeDAO;
import dao.TaskDAO;
import model.Customer;
import model.Quotation;
import model.Task;
import model.TaskAssignee;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class NotificationScheduler implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    // Track which tasks/quotations we already notified to avoid duplicates
    private final Set<String> sentKeys = java.util.Collections.synchronizedSet(new HashSet<>());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "NotificationScheduler");
            t.setDaemon(true);
            return t;
        });

        // Run every 30 minutes, initial delay 2 minutes (let app warm up)
        scheduler.scheduleAtFixedRate(this::checkOverdueTasks, 2, 30, TimeUnit.MINUTES);
        scheduler.scheduleAtFixedRate(this::checkUpcomingTasks, 3, 30, TimeUnit.MINUTES);
        scheduler.scheduleAtFixedRate(this::checkExpiringQuotations, 5, 60, TimeUnit.MINUTES);

        // Clean sent keys daily to prevent memory leak
        scheduler.scheduleAtFixedRate(() -> sentKeys.clear(), 24, 24, TimeUnit.HOURS);

        System.out.println("[NotificationScheduler] Started.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            System.out.println("[NotificationScheduler] Stopped.");
        }
    }

    private void checkOverdueTasks() {
        try {
            TaskDAO taskDAO = new TaskDAO();
            TaskAssigneeDAO taDAO = new TaskAssigneeDAO();
            List<Task> overdueTasks = taskDAO.getAllOverdueTasks();

            for (Task task : overdueTasks) {
                String key = "OVERDUE_" + task.getTaskId();
                if (sentKeys.contains(key)) continue;

                List<TaskAssignee> assignees = taDAO.getByTaskId(task.getTaskId());
                List<Integer> notifyIds = new ArrayList<>();
                for (TaskAssignee ta : assignees) {
                    if (!notifyIds.contains(ta.getUserId())) notifyIds.add(ta.getUserId());
                }
                if (task.getCreatedBy() != null && !notifyIds.contains(task.getCreatedBy())) {
                    notifyIds.add(task.getCreatedBy());
                }

                if (!notifyIds.isEmpty()) {
                    NotificationUtil.notifyTaskOverdue(
                            task.getTaskId(), task.getTaskCode(), task.getTitle(), notifyIds);
                    sentKeys.add(key);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void checkUpcomingTasks() {
        try {
            TaskDAO taskDAO = new TaskDAO();
            TaskAssigneeDAO taDAO = new TaskAssigneeDAO();
            // Tasks due within 24 hours
            List<Task> upcomingTasks = taskDAO.getAllUpcomingTasks(24);

            for (Task task : upcomingTasks) {
                String key = "REMINDER_" + task.getTaskId();
                if (sentKeys.contains(key)) continue;

                List<TaskAssignee> assignees = taDAO.getByTaskId(task.getTaskId());
                List<Integer> notifyIds = new ArrayList<>();
                for (TaskAssignee ta : assignees) {
                    if (!notifyIds.contains(ta.getUserId())) notifyIds.add(ta.getUserId());
                }

                if (!notifyIds.isEmpty()) {
                    NotificationUtil.notifyTaskReminder(
                            task.getTaskId(), task.getTaskCode(), task.getTitle(), notifyIds);
                    sentKeys.add(key);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void checkExpiringQuotations() {
        try {
            QuotationDAO quotDAO = new QuotationDAO();
            // Quotations expiring within 3 days
            List<Quotation> expiring = quotDAO.getExpiringQuotations(3);

            for (Quotation q : expiring) {
                String key = "QUOT_EXPIRING_" + q.getQuotationId();
                if (sentKeys.contains(key)) continue;

                List<Integer> notifyIds = new ArrayList<>();
                if (q.getCreatedBy() != null) notifyIds.add(q.getCreatedBy());
                if (q.getSentBy() != null && !notifyIds.contains(q.getSentBy())) {
                    notifyIds.add(q.getSentBy());
                }

                if (!notifyIds.isEmpty()) {
                    NotificationUtil.notifyQuotationExpiring(
                            q.getQuotationId(), q.getQuotationCode(), notifyIds);
                    sentKeys.add(key);
                }

                // Auto-send expiring reminder email to customer
                String emailKey = "QUOT_EXPIRING_EMAIL_" + q.getQuotationId();
                if (!sentKeys.contains(emailKey) && EmailSendUtil.isConfigured() && q.getCustomerId() != null) {
                    Customer cust = new CustomerDAO().getCustomerById(q.getCustomerId());
                    if (cust != null && cust.getEmail() != null && !cust.getEmail().isEmpty()) {
                        Map<String, String> vars = new HashMap<>();
                        vars.put("customer_name", cust.getFullName());
                        vars.put("quotation_code", q.getQuotationCode());
                        vars.put("valid_until", q.getValidUntil() != null ? q.getValidUntil().toString() : "");
                        vars.put("total_amount", q.getTotalAmount() != null ? q.getTotalAmount().toPlainString() : "0");
                        EmailSendUtil.sendWithTemplateAsync("QUOT_REMIND", vars,
                                cust.getEmail(), cust.getFullName(), null);
                        sentKeys.add(emailKey);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
