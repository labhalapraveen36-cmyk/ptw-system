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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class ApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final DateTimeFormatter timeLogFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String id = request.getParameter("id");
        String action = request.getParameter("approvalAction"); // approve, reject, modify
        String comment = request.getParameter("comment");

        if (comment != null) {
            comment = comment.trim();
        } else {
            comment = "";
        }

        @SuppressWarnings("unchecked")
        List<Permit> permits = (List<Permit>) getServletContext().getAttribute("globalPermits");
        String username = (String) session.getAttribute("currentUsername");
        String role = (String) session.getAttribute("currentUserRole");
        LocalDateTime now = LocalDateTime.now();

        if (permits == null || id == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Permit permit = null;
        for (Permit p : permits) {
            if (id.equals(p.getId())) {
                permit = p;
                break;
            }
        }

        if (permit == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Permit+not+found");
            return;
        }

        // Validate comments for rejections or modification requests
        if (("reject".equals(action) || "modify".equals(action)) && comment.isEmpty()) {
            request.setAttribute("error", "Comments are required for Rejection or requesting Modification.");
            request.setAttribute("permit", permit);
            request.getRequestDispatcher("/WEB-INF/views/permit-details.jsp").forward(request, response);
            return;
        }

        boolean updated = false;
        String currentStatus = permit.getStatus();

        // 1. Supervisor Approval Step
        if ("Supervisor".equals(role) && "PENDING_SUPERVISOR".equals(currentStatus)) {
            permit.setSupervisor(username);
            permit.setSupervisorComment(comment);
            
            if ("approve".equals(action)) {
                permit.setStatus("PENDING_SAFETY");
                permit.addLog(new ActivityLog(now.format(formatter), "Approved by Supervisor", username + " (" + role + ")", comment.isEmpty() ? "Approved." : comment));
                
                // Trigger notifications to Safety Officer
                addNotification(session, "SMS", "Safety Officer", String.format("[PTW-ALERT] Permit %s (%s at %s) approved by Supervisor Amit Sharma. Safety Verification pending.", 
                        permit.getId(), permit.getWorkType(), permit.getLocation()));
                addNotification(session, "Email", "Safety Officer", String.format("Subject: Action Required: Safety Verification for %s\n\nDear Safety Officer,\nSupervisor Amit Sharma has approved permit request %s. Please review safety checklists and perform site verification.", 
                        permit.getId(), permit.getId()));
            } else if ("reject".equals(action)) {
                permit.setStatus("REJECTED");
                permit.addLog(new ActivityLog(now.format(formatter), "Rejected by Supervisor", username + " (" + role + ")", comment));
                
                // Notify applicant
                addNotification(session, "SMS", "Worker", String.format("[PTW-ALERT] Permit %s has been rejected by Supervisor Amit Sharma. Reason: %s", 
                        permit.getId(), comment));
            } else if ("modify".equals(action)) {
                permit.setStatus("MODIFICATION_REQUIRED");
                permit.addLog(new ActivityLog(now.format(formatter), "Modification Requested", username + " (" + role + ")", comment));
                
                // Notify applicant
                addNotification(session, "System", "Worker", String.format("Modification required on Permit %s. Comment: %s", 
                        permit.getId(), comment));
            }
            updated = true;
        }

        // 2. Safety Officer Verification Step
        else if ("Safety Officer".equals(role) && "PENDING_SAFETY".equals(currentStatus)) {
            permit.setSafetyOfficer(username);
            permit.setSafetyOfficerComment(comment);

            if ("approve".equals(action)) {
                if ("High".equals(permit.getRiskLevel())) {
                    permit.setStatus("PENDING_MANAGER");
                    permit.addLog(new ActivityLog(now.format(formatter), "Verified by Safety Officer", username + " (" + role + ")", "Safety measures verified. Forwarded to Manager for authorization. " + comment));
                    
                    // Alert Manager
                    addNotification(session, "SMS", "Manager", String.format("[PTW-ALERT] High Risk Permit %s (%s at %s) verified by Safety Officer. Manager authorization required.", 
                            permit.getId(), permit.getWorkType(), permit.getLocation()));
                } else {
                    permit.setStatus("APPROVED");
                    permit.addLog(new ActivityLog(now.format(formatter), "Verified by Safety Officer", username + " (" + role + ")", "Safety measures verified. Permit fully approved. " + comment));
                    
                    // Alert Worker
                    addNotification(session, "SMS", "Worker", String.format("[PTW-ALERT] Permit %s has been APPROVED. You may start work.", 
                            permit.getId()));
                }
            } else if ("reject".equals(action)) {
                permit.setStatus("REJECTED");
                permit.addLog(new ActivityLog(now.format(formatter), "Rejected by Safety Officer", username + " (" + role + ")", comment));
                
                // Notify Worker
                addNotification(session, "SMS", "Worker", String.format("[PTW-ALERT] Permit %s has been rejected by Safety Officer. Reason: %s", 
                        permit.getId(), comment));
            } else if ("modify".equals(action)) {
                permit.setStatus("MODIFICATION_REQUIRED");
                permit.addLog(new ActivityLog(now.format(formatter), "Modification Requested", username + " (" + role + ")", comment));
                
                addNotification(session, "System", "Worker", String.format("Safety Officer requested modification on Permit %s. Comment: %s", 
                        permit.getId(), comment));
            }
            updated = true;
        }

        // 3. Manager Authorization Step (Only for High Risk)
        else if ("Manager".equals(role) && "PENDING_MANAGER".equals(currentStatus)) {
            permit.setManager(username);
            permit.setManagerComment(comment);

            if ("approve".equals(action)) {
                permit.setStatus("APPROVED");
                permit.addLog(new ActivityLog(now.format(formatter), "Authorized by Manager", username + " (" + role + ")", "Manager authorization granted. " + comment));
                
                // Notify Worker
                addNotification(session, "SMS", "Worker", String.format("[PTW-ALERT] High-Risk Permit %s has been authorized by Manager Dinesh Mehta. You may start work.", 
                        permit.getId()));
            } else if ("reject".equals(action)) {
                permit.setStatus("REJECTED");
                permit.addLog(new ActivityLog(now.format(formatter), "Rejected by Manager", username + " (" + role + ")", comment));
                
                addNotification(session, "SMS", "Worker", String.format("[PTW-ALERT] High-Risk Permit %s rejected by Manager. Reason: %s",
                        permit.getId(), comment));
            } else if ("modify".equals(action)) {
                permit.setStatus("MODIFICATION_REQUIRED");
                permit.addLog(new ActivityLog(now.format(formatter), "Modification Requested", username + " (" + role + ")", comment));
                
                addNotification(session, "System", "Worker", String.format("Manager requested modification on Permit %s: %s",
                        permit.getId(), comment));
            }
            updated = true;
        }

        if (updated) {
            getServletContext().setAttribute("globalPermits", permits);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard?view=details&id=" + id);
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
        getServletContext().setAttribute("globalNotifications", list);
    }
}
