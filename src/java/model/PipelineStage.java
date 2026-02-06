/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hello
 */
public class PipelineStage {

    public int stageId;
    public int pipelineId;
    public String stageCode;
    public String stageName;
    public int stageOrder;
    public int probability;
    public String stageType;
    public String colorCode;
    public boolean isActive;

    public PipelineStage() {
    }

    public PipelineStage(int stageId, int pipelineId, String stageCode, String stageName, int stageOrder, int probability, String stageType, String colorCode, boolean isActive) {
        this.stageId = stageId;
        this.pipelineId = pipelineId;
        this.stageCode = stageCode;
        this.stageName = stageName;
        this.stageOrder = stageOrder;
        this.probability = probability;
        this.stageType = stageType;
        this.colorCode = colorCode;
        this.isActive = isActive;
    }

    public int getStageId() {
        return stageId;
    }

    public void setStageId(int stageId) {
        this.stageId = stageId;
    }

    public int getPipelineId() {
        return pipelineId;
    }

    public void setPipelineId(int pipelineId) {
        this.pipelineId = pipelineId;
    }

    public String getStageCode() {
        return stageCode;
    }

    public void setStageCode(String stageCode) {
        this.stageCode = stageCode;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public int getStageOrder() {
        return stageOrder;
    }

    public void setStageOrder(int stageOrder) {
        this.stageOrder = stageOrder;
    }

    public int getProbability() {
        return probability;
    }

    public void setProbability(int probability) {
        this.probability = probability;
    }

    public String getStageType() {
        return stageType;
    }

    public void setStageType(String stageType) {
        this.stageType = stageType;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

}
