/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dbConnection.DBContext;
import model.PipelineStage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PipelineStageDAO extends DBContext {

    /**
     * Get all stages for a specific pipeline
     */
    public List<PipelineStage> getStagesByPipelineId(int pipelineId) {
        List<PipelineStage> stages = new ArrayList<>();
        String sql = "SELECT * FROM pipeline_stages WHERE pipeline_id = ? AND is_active = 1 ORDER BY stage_order";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, pipelineId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PipelineStage stage = extractStageFromResultSet(rs);
                stages.add(stage);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return stages;
    }

    /**
     * Get all stages (all pipelines)
     */
    public List<PipelineStage> getAllStages() {
        List<PipelineStage> stages = new ArrayList<>();
        String sql = "SELECT * FROM pipeline_stages ORDER BY pipeline_id, stage_order";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                PipelineStage stage = extractStageFromResultSet(rs);
                stages.add(stage);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return stages;
    }

    /**
     * Get stage by ID
     */
    public PipelineStage getStageById(int stageId) {
        String sql = "SELECT * FROM pipeline_stages WHERE stage_id = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, stageId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractStageFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get first stage of a pipeline (for new opportunities)
     */
    public PipelineStage getFirstStageByPipelineId(int pipelineId) {
        String sql = "SELECT TOP 1 * FROM pipeline_stages "
                + "WHERE pipeline_id = ? AND is_active = 1 "
                + "ORDER BY stage_order";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, pipelineId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractStageFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Insert new stage
     */
    public boolean insertStage(PipelineStage stage) {
        String sql = "INSERT INTO pipeline_stages "
                + "(pipeline_id, stage_code, stage_name, stage_order, probability, stage_type, color_code, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, stage.getPipelineId());
            stmt.setString(2, stage.getStageCode());
            stmt.setString(3, stage.getStageName());
            stmt.setInt(4, stage.getStageOrder());
            stmt.setInt(5, stage.getProbability());
            stmt.setString(6, stage.getStageType());
            stmt.setString(7, stage.getColorCode());
            stmt.setBoolean(8, stage.isIsActive());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update existing stage
     */
    public boolean updateStage(PipelineStage stage) {
        String sql = "UPDATE pipeline_stages SET "
                + "stage_name = ?, stage_order = ?, probability = ?, "
                + "stage_type = ?, color_code = ?, is_active = ? "
                + "WHERE stage_id = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setString(1, stage.getStageName());
            stmt.setInt(2, stage.getStageOrder());
            stmt.setInt(3, stage.getProbability());
            stmt.setString(4, stage.getStageType());
            stmt.setString(5, stage.getColorCode());
            stmt.setBoolean(6, stage.isIsActive());
            stmt.setInt(7, stage.getStageId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===== HELPER METHODS =====
    /**
     * Extract PipelineStage object from ResultSet
     */
    private PipelineStage extractStageFromResultSet(ResultSet rs) throws Exception {
        PipelineStage stage = new PipelineStage();

        stage.setStageId(rs.getInt("stage_id"));
        stage.setPipelineId(rs.getInt("pipeline_id"));
        stage.setStageCode(rs.getString("stage_code"));
        stage.setStageName(rs.getString("stage_name"));
        stage.setStageOrder(rs.getInt("stage_order"));
        stage.setProbability(rs.getInt("probability"));
        stage.setStageType(rs.getString("stage_type"));
        stage.setColorCode(rs.getString("color_code"));
        stage.setIsActive(rs.getBoolean("is_active"));

        return stage;
    }
}
