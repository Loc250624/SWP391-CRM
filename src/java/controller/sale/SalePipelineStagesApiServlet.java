package controller.sale;

import dao.PipelineStageDAO;
import model.PipelineStage;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SalePipelineStagesApiServlet", urlPatterns = {"/sale/api/stages"})
public class SalePipelineStagesApiServlet extends HttpServlet {

    private PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String pipelineIdParam = request.getParameter("pipelineId");
        if (pipelineIdParam == null || pipelineIdParam.isEmpty()) {
            out.print("[]");
            return;
        }

        try {
            int pipelineId = Integer.parseInt(pipelineIdParam);
            List<PipelineStage> stages = stageDAO.getStagesByPipelineId(pipelineId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < stages.size(); i++) {
                PipelineStage s = stages.get(i);
                if (i > 0) json.append(",");
                json.append("{\"stageId\":").append(s.getStageId())
                    .append(",\"stageName\":\"").append(escapeJson(s.getStageName())).append("\"")
                    .append(",\"probability\":").append(s.getProbability())
                    .append(",\"stageType\":\"").append(escapeJson(s.getStageType() != null ? s.getStageType() : "open")).append("\"")
                    .append("}");
            }
            json.append("]");
            out.print(json.toString());
        } catch (NumberFormatException e) {
            out.print("[]");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
