package com.steelplant.ptw.model;

import java.io.Serializable;

public class ActivityLog implements Serializable {
    private static final long serialVersionUID = 1L;

    private String timestamp;
    private String action;
    private String actor;
    private String comments;

    public ActivityLog() {}

    public ActivityLog(String timestamp, String action, String actor, String comments) {
        this.timestamp = timestamp;
        this.action = action;
        this.actor = actor;
        this.comments = comments;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getActor() {
        return actor;
    }

    public void setActor(String actor) {
        this.actor = actor;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
}
