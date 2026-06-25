package com.steelplant.ptw.servlet;

import com.steelplant.ptw.model.User;
import com.steelplant.ptw.util.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Default to login page
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password"); // In production, hash this!
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");

            if (username == null || password == null || fullName == null || role == null || username.isEmpty() || password.isEmpty() || fullName.isEmpty() || role.isEmpty()) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            try {
                User user = userDAO.registerUser(username, password, fullName, role);
                if (user != null) {
                    // Registration successful, log them in
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("currentUsername", user.getFullName());
                    session.setAttribute("currentUserRole", user.getRole());
                    
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    request.setAttribute("error", "Registration failed. Username might already exist.");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                }
            } catch (RuntimeException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
        } else if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
                request.setAttribute("error", "Username and password are required.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            User user = userDAO.authenticateUser(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("currentUsername", user.getFullName());
                session.setAttribute("currentUserRole", user.getRole());

                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }
}
