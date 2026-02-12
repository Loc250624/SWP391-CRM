<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.time.LocalDate,java.time.YearMonth,java.time.DayOfWeek,java.util.List,java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch công việc</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar_module4.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <h3>Lịch công việc theo tháng</h3>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <a class="btn btn-outline-primary ${viewType == 'personal' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/calendar?view=personal&month=${month}&year=${year}">Công việc của tôi</a>
                    <a class="btn btn-outline-primary ${viewType == 'team' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/calendar?view=team&month=${month}&year=${year}">Công việc của nhóm</a>
                </div>
                <form class="d-flex" method="get" action="${pageContext.request.contextPath}/sale/task/calendar">
                    <input type="hidden" name="view" value="${viewType}">
                    <input type="number" min="1" max="12" class="form-control me-2" name="month" value="${month}" style="width: 90px;">
                    <input type="number" min="2000" class="form-control me-2" name="year" value="${year}" style="width: 120px;">
                    <button type="submit" class="btn btn-primary">Xem</button>
                </form>
            </div>

            <%
                int thang = (Integer) request.getAttribute("month");
                int nam = (Integer) request.getAttribute("year");
                YearMonth ym = YearMonth.of(nam, thang);
                int soNgay = ym.lengthOfMonth();
                LocalDate ngayDau = ym.atDay(1);
                int viTriDau = ngayDau.getDayOfWeek().getValue();
                Map<LocalDate, List<model.Task>> mapTheoNgay = (Map<LocalDate, List<model.Task>>) request.getAttribute("taskByDate");
            %>

            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>T2</th>
                    <th>T3</th>
                    <th>T4</th>
                    <th>T5</th>
                    <th>T6</th>
                    <th>T7</th>
                    <th>CN</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int dem = 1;
                    boolean batDau = false;
                    for (int hang = 0; hang < 6; hang++) {
                        out.write("<tr>");
                        for (int cot = 1; cot <= 7; cot++) {
                            if (!batDau && cot == viTriDau) {
                                batDau = true;
                            }
                            if (batDau && dem <= soNgay) {
                                LocalDate ngay = ym.atDay(dem);
                                out.write("<td style='vertical-align: top; min-width: 120px;'>");
                                out.write("<div><strong>" + dem + "</strong></div>");
                                List<model.Task> list = mapTheoNgay.get(ngay);
                                if (list != null) {
                                    for (model.Task t : list) {
                                        out.write("<div><a href='" + request.getContextPath() + "/sale/task/detail?id=" + t.getTaskId() + "'>" + t.getTitle() + "</a></div>");
                                    }
                                }
                                out.write("</td>");
                                dem++;
                            } else {
                                out.write("<td></td>");
                            }
                        }
                        out.write("</tr>");
                        if (dem > soNgay) {
                            break;
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<jsp:include page="../../layout/script.jsp"/>
</body>
</html>
