package com.steelplant.ptw.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Permit implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String workType;
    private String location;
    private String riskLevel;
    private String applicant;
    private String description;
    private String startDate;
    private String endDate;
    private String status; // DRAFT, PENDING_SUPERVISOR, PENDING_SAFETY, PENDING_MANAGER, APPROVED, IN_PROGRESS, COMPLETED, REJECTED, MODIFICATION_REQUIRED
    
    private List<String> preChecklist = new ArrayList<>();
    private List<String> ppe = new ArrayList<>();
    
    private String supervisorComment;
    private String safetyOfficerComment;
    private String managerComment;
    
    private String supervisor;
    private String safetyOfficer;
    private String manager;
    
    private String createdAt;
    private List<ActivityLog> logs = new ArrayList<>();

    public Permit() {}

    public Permit(String id, String workType, String location, String riskLevel, String applicant, 
                  String description, String startDate, String endDate, String status, String createdAt) {
        this.id = id;
        this.workType = workType;
        this.location = location;
        this.riskLevel = riskLevel;
        this.applicant = applicant;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getWorkType() {
        return workType;
    }

    public void setWorkType(String workType) {
        this.workType = workType;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getRiskLevel() {
        return riskLevel;
    }

    public void setRiskLevel(String riskLevel) {
        this.riskLevel = riskLevel;
    }

    public String getApplicant() {
        return applicant;
    }

    public void setApplicant(String applicant) {
        this.applicant = applicant;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<String> getPreChecklist() {
        return preChecklist;
    }

    public void setPreChecklist(List<String> preChecklist) {
        this.preChecklist = preChecklist;
    }

    public List<String> getPpe() {
        return ppe;
    }

    public void setPpe(List<String> ppe) {
        this.ppe = ppe;
    }

    public String getSupervisorComment() {
        return supervisorComment;
    }

    public void setSupervisorComment(String supervisorComment) {
        this.supervisorComment = supervisorComment;
    }

    public String getSafetyOfficerComment() {
        return safetyOfficerComment;
    }

    public void setSafetyOfficerComment(String safetyOfficerComment) {
        this.safetyOfficerComment = safetyOfficerComment;
    }

    public String getManagerComment() {
        return managerComment;
    }

    public void setManagerComment(String managerComment) {
        this.managerComment = managerComment;
    }

    public String getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }

    public String getSafetyOfficer() {
        return safetyOfficer;
    }

    public void setSafetyOfficer(String safetyOfficer) {
        this.safetyOfficer = safetyOfficer;
    }

    public String getManager() {
        return manager;
    }

    public void setManager(String manager) {
        this.manager = manager;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public List<ActivityLog> getLogs() {
        return logs;
    }

    public void setLogs(List<ActivityLog> logs) {
        this.logs = logs;
    }

    public void addLog(ActivityLog log) {
        this.logs.add(log);
    }
}
