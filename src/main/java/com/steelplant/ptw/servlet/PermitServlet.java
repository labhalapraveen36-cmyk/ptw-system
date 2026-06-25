package com.steelplant.ptw.servlet;

import com.steelplant.ptw.model.Permit;
import com.steelplant.ptw.model.ActivityLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class PermitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final DateTimeFormatter timeLogFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        @SuppressWarnings("unchecked")
        List<Permit> permits = (List<Permit>) getServletContext().getAttribute("globalPermits");
        if (permits == null) {
            permits = new ArrayList<>();
            getServletContext().setAttribute("globalPermits", permits);
        }

        String username = (String) session.getAttribute("currentUsername");
        String role = (String) session.getAttribute("currentUserRole");
        LocalDateTime now = LocalDateTime.now();

        if ("submit".equals(action) || "draft".equals(action)) {
            // Read parameters for Create/Update
            String id = request.getParameter("id");
            String workType = request.getParameter("workType");
            String location = request.getParameter("location");
            String riskLevel = request.getParameter("riskLevel");
            String description = request.getParameter("description");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            String[] checklistArray = request.getParameterValues("preChecklist");
            List<String> checklist = checklistArray != null ? Arrays.asList(checklistArray) : new ArrayList<>();

            String[] ppeArray = request.getParameterValues("ppe");
            List<String> ppeList = ppeArray != null ? Arrays.asList(ppeArray) : new ArrayList<>();

            Permit permit = null;
            boolean isNew = false;

            if (id != null && !id.trim().isEmpty()) {
                // Editing existing
                for (Permit p : permits) {
                    if (id.equals(p.getId())) {
                        permit = p;
                        break;
                    }
                }
            }

            if (permit == null) {
                // Creating new
                isNew = true;
                int nextIdNum = 1001 + permits.size();
                String generatedId = "PTW-" + nextIdNum;
                // Double check uniqueness
                boolean unique = false;
                while (!unique) {
                    unique = true;
                    for (Permit p : permits) {
                        if (generatedId.equals(p.getId())) {
                            nextIdNum++;
                            generatedId = "PTW-" + nextIdNum;
                            unique = false;
                            break;
                        }
                    }
                }
                
                permit = new Permit();
                permit.setId(generatedId);
                permit.setCreatedAt(now.format(formatter));
                permit.setApplicant(username);
            }

            // Populate/Update fields
            permit.setWorkType(workType);
            permit.setLocation(location);
            permit.setRiskLevel(riskLevel);
            permit.setDescription(description);
            permit.setStartDate(startDate);
            permit.setEndDate(endDate);
            permit.setPreChecklist(checklist);
            permit.setPpe(ppeList);

            String status = "draft".equals(action) ? "DRAFT" : "PENDING_SUPERVISOR";
            permit.setStatus(status);

            // Log activity
            String logAction = isNew ? ("Permit Created (" + status + ")") : ("Permit Updated (" + status + ")");
            String logComment = "Work Type: " + workType + ", Location: " + location + ", Risk: " + riskLevel;
            permit.addLog(new ActivityLog(now.format(formatter), logAction, username + " (" + role + ")", logComment));

            if (isNew) {
                permits.add(permit);
            }

            // Update global attribute
            getServletContext().setAttribute("globalPermits", permits);

            // Add notification if submitted
            if ("PENDING_SUPERVISOR".equals(status)) {
                String smsText = String.format("[PTW-ALERT] Permit %s (%s at %s) submitted by %s. Supervisor approval required.", 
                        permit.getId(), workType, location, username);
                addNotification(session, "SMS", "Supervisor", smsText);
                
                String emailText = String.format("Subject: Action Required: Review Permit Request %s\n\nDear Supervisor,\nA new permit request %s has been submitted for %s work at %s by %s. Please log in to review and authorize.", 
                        permit.getId(), permit.getId(), workType, location, username);
                addNotification(session, "Email", "Supervisor", emailText);
            }

            response.sendRedirect(request.getContextPath() + "/dashboard?view=permits");
            return;

        } else if ("startWork".equals(action)) {
            String id = request.getParameter("id");
            Permit p = findPermit(permits, id);
            if (p != null && "APPROVED".equals(p.getStatus())) {
                p.setStatus("IN_PROGRESS");
                p.addLog(new ActivityLog(now.format(formatter), "Started Work", username + " (" + role + ")", "Work commenced on site."));
                session.setAttribute("permits", permits);

                addNotification(session, "System", "All", String.format("Work started on Permit %s (%s at %s) by %s.", 
                        p.getId(), p.getWorkType(), p.getLocation(), username));
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?view=details&id=" + id);
            return;

        } else if ("completeWork".equals(action)) {
            String id = request.getParameter("id");
            Permit p = findPermit(permits, id);
            if (p != null && "IN_PROGRESS".equals(p.getStatus())) {
                p.setStatus("COMPLETED");
                p.addLog(new ActivityLog(now.format(formatter), "Completed Work", username + " (" + role + ")", "Work finished. Safety isolations cleared."));
                session.setAttribute("permits", permits);

                addNotification(session, "System", "All", String.format("Work completed and signed off for Permit %s at %s.", 
                        p.getId(), p.getLocation()));
                
                // Alert supervisor/safety officer
                addNotification(session, "SMS", "Safety Officer", String.format("[PTW-INFO] Permit %s has been closed by %s. Safety audit trail finalized.", 
                        p.getId(), username));
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?view=details&id=" + id);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private Permit findPermit(List<Permit> permits, String id) {
        if (permits != null && id != null) {
            for (Permit p : permits) {
                if (id.equals(p.getId())) {
                    return p;
                }
            }
        }
        return null;
    }

    private void addNotification(HttpSession session, String type, String recipient, String content) {
        @SuppressWarnings("unchecked")
        List<Map<String, String>> list = (List<Map<String, String>>) getServletContext().getAttribute("globalNotifications");
        if (list == null) {
            list = new ArrayList<>();
            getServletContext().setAttribute("globalNotifications", list);
        }
        Map<String, String> notif = new HashMap<>();
        notif.put("id", UUID.randomUUID().toString());
        notif.put("timestamp", LocalDateTime.now().format(timeLogFormatter));
        notif.put("type", type);
        notif.put("recipient", recipient);
        notif.put("content", content);
        list.add(0, notif); // Newest first
        session.setAttribute("notifications", list);
    }
}
