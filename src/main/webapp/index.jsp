<%-- Redirects to Dashboard Servlet router --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.sendRedirect(request.getContextPath() + "/dashboard");
%>
