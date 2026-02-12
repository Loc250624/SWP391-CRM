/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dbConnection.DBContext;
import model.Pipeline;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PipelineDAO extends DBContext {

    /**
     * Get all active pipelines
     */
    public List<Pipeline> getAllActivePipelines() {
        List<Pipeline> pipelines = new ArrayList<>();
        String sql = "SELECT * FROM pipelines WHERE is_active = 1 ORDER BY is_default DESC, pipeline_name";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Pipeline pipeline = extractPipelineFromResultSet(rs);
                pipelines.add(pipeline);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pipelines;
    }

    /**
     * Get all pipelines (including inactive)
     */
    public List<Pipeline> getAllPipelines() {
        List<Pipeline> pipelines = new ArrayList<>();
        String sql = "SELECT * FROM pipelines ORDER BY is_default DESC, pipeline_name";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Pipeline pipeline = extractPipelineFromResultSet(rs);
                pipelines.add(pipeline);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pipelines;
    }

    /**
     * Get pipeline by ID
     */
    public Pipeline getPipelineById(int pipelineId) {
        String sql = "SELECT * FROM pipelines WHERE pipeline_id = ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, pipelineId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractPipelineFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get default pipeline
     */
    public Pipeline getDefaultPipeline() {
        String sql = "SELECT * FROM pipelines WHERE is_default = 1 AND is_active = 1";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractPipelineFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Insert new pipeline
     */
    public boolean insertPipeline(Pipeline pipeline) {
        String sql = "INSERT INTO pipelines "
                + "(pipeline_code, pipeline_name, description, is_default, is_active, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, pipeline.getPipelineCode());
            stmt.setString(2, pipeline.getPipelineName());
            stmt.setString(3, pipeline.getDescription());
            stmt.setBoolean(4, pipeline.isIsDefault());
            stmt.setBoolean(5, pipeline.isIsActive());
            setNullableInt(stmt, 6, pipeline.getCreatedBy());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update existing pipeline
     */
    public boolean updatePipeline(Pipeline pipeline) {
        String sql = "UPDATE pipelines SET "
                + "pipeline_name = ?, description = ?, is_default = ?, is_active = ? "
                + "WHERE pipeline_id = ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, pipeline.getPipelineName());
            stmt.setString(2, pipeline.getDescription());
            stmt.setBoolean(3, pipeline.isIsDefault());
            stmt.setBoolean(4, pipeline.isIsActive());
            stmt.setInt(5, pipeline.getPipelineId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===== HELPER METHODS =====
    /**
     * Extract Pipeline object from ResultSet
     */
    private Pipeline extractPipelineFromResultSet(ResultSet rs) throws SQLException {
        Pipeline pipeline = new Pipeline();

        pipeline.setPipelineId(rs.getInt("pipeline_id"));
        pipeline.setPipelineCode(rs.getString("pipeline_code"));
        pipeline.setPipelineName(rs.getString("pipeline_name"));
        pipeline.setDescription(rs.getString("description"));
        pipeline.setIsDefault(rs.getBoolean("is_default"));
        pipeline.setIsActive(rs.getBoolean("is_active"));
        pipeline.setCreatedAt(getNullableLocalDateTime(rs, "created_at"));
        pipeline.setCreatedBy(getNullableInt(rs, "created_by"));

        return pipeline;
    }

    /**
     * Set nullable integer parameter
     */
    private void setNullableInt(PreparedStatement stmt, int index, Integer value) throws SQLException {
        if (value == null) {
            stmt.setNull(index, Types.INTEGER);
        } else {
            stmt.setInt(index, value);
        }
    }

    /**
     * Get nullable integer from ResultSet
     */
    private Integer getNullableInt(ResultSet rs, String columnName) throws SQLException {
        int value = rs.getInt(columnName);
        return rs.wasNull() ? null : value;
    }

    /**
     * Get nullable LocalDateTime from ResultSet
     */
    private LocalDateTime getNullableLocalDateTime(ResultSet rs, String columnName) throws SQLException {
        Timestamp timestamp = rs.getTimestamp(columnName);
        return timestamp != null ? timestamp.toLocalDateTime() : null;
    }
}
