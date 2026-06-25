package com.steelplant.ptw.servlet;

import com.steelplant.ptw.model.Permit;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        String view = request.getParameter("view");

        // Initialize global data if not present
        if (getServletContext().getAttribute("globalPermits") == null) {
            getServletContext().setAttribute("globalPermits", com.steelplant.ptw.util.MockData.generateSeedPermits());
            getServletContext().setAttribute("globalNotifications", new ArrayList<java.util.Map<String, String>>());
        }
        
        // Link session pointers to global data
        session.setAttribute("permits", getServletContext().getAttribute("globalPermits"));
        session.setAttribute("notifications", getServletContext().getAttribute("globalNotifications"));
        if (session.getAttribute("theme") == null) {
            session.setAttribute("theme", "dark");
        }

        // Automatic expiry check on every page load to keep data fresh and realistic
        checkExpiredPermits(session);

        if (view == null || view.isEmpty()) {
            view = "dashboard";
        }

        String path;
        switch (view) {
            case "login":
                path = "/WEB-INF/views/login.jsp";
                break;
            case "permits":
                path = "/WEB-INF/views/permit-list.jsp";
                break;
            case "create":
                path = "/WEB-INF/views/permit-form.jsp";
                break;
            case "details":
                String id = request.getParameter("id");
                Permit permit = findPermitById(session, id);
                if (permit != null) {
                    request.setAttribute("permit", permit);
                    path = "/WEB-INF/views/permit-details.jsp";
                } else {
                    request.setAttribute("error", "Permit not found.");
                    path = "/WEB-INF/views/dashboard.jsp";
                }
                break;
            case "approvals":
                path = "/WEB-INF/views/approvals.jsp";
                break;
            case "analytics":
                path = "/WEB-INF/views/analytics.jsp";
                break;
            case "logs":
                path = "/WEB-INF/views/logs.jsp";
                break;
            case "dashboard":
            default:
                path = "/WEB-INF/views/dashboard.jsp";
                break;
        }

        request.getRequestDispatcher(path).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("switchTheme".equals(action)) {
            String theme = request.getParameter("theme");
            if (theme != null) {
                session.setAttribute("theme", theme);
            }
        }

        // Redirect back to the referrer or home dashboard
        String referer = request.getHeader("referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private Permit findPermitById(HttpSession session, String id) {
        @SuppressWarnings("unchecked")
        List<Permit> permits = (List<Permit>) session.getAttribute("permits");
        if (permits != null && id != null) {
            for (Permit p : permits) {
                if (id.equals(p.getId())) {
                    return p;
                }
            }
        }
        return null;
    }

    private void checkExpiredPermits(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Permit> permits = (List<Permit>) session.getAttribute("permits");
        if (permits == null) return;

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        boolean updated = false;

        for (Permit p : permits) {
            if ("APPROVED".equals(p.getStatus()) || "IN_PROGRESS".equals(p.getStatus()) || "PENDING_SUPERVISOR".equals(p.getStatus()) 
                    || "PENDING_SAFETY".equals(p.getStatus()) || "PENDING_MANAGER".equals(p.getStatus())) {
                try {
                    LocalDateTime end = LocalDateTime.parse(p.getEndDate(), formatter);
                    if (now.isAfter(end)) {
                        p.setStatus("EXPIRED");
                        p.addLog(new com.steelplant.ptw.model.ActivityLog(
                            now.format(formatter), 
                            "System Expiry Check", 
                            "System", 
                            "Permit validation window elapsed. Marked automatically as EXPIRED."
                        ));
                        updated = true;
                    }
                } catch (Exception e) {
                    // Ignore parsing issues
                }
            }
        }

        if (updated) {
            session.setAttribute("permits", permits);
        }
    }
}
