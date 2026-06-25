<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="currentView" value="${param.view != null ? param.view : 'dashboard'}" />
<c:set var="username" value="${empty sessionScope.currentUsername ? 'User' : sessionScope.currentUsername}" />
<c:set var="notifications" value="${empty sessionScope.notifications ? null : sessionScope.notifications}" />

<header class="header-wrapper">
    <div class="container navbar">
        
        <!-- Logo and Brand -->
        <div class="brand-section">
            <div class="logo-icon">Fe</div>
            <div class="logo-text">
                <span class="logo-title"><b>IRONFLOW</b> PTW</span>
                <span class="logo-subtitle">Steel Plant Safety</span>
            </div>
        </div>

        <!-- Navigation Links -->
        <ul class="nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/dashboard?view=dashboard"
                   class="nav-link ${currentView == 'dashboard' ? 'active' : ''}">
                    <span class="material-symbols-outlined">dashboard</span> Dashboard
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/dashboard?view=permits"
                   class="nav-link ${currentView == 'permits' || currentView == 'details' ? 'active' : ''}">
                    <span class="material-symbols-outlined">assignment</span> Permit Registry
                </a>
            </li>

            <c:if test="${sessionScope.currentUserRole == 'Worker'}">
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard?view=create"
                       class="nav-link ${currentView == 'create' ? 'active' : ''}">
                        <span class="material-symbols-outlined">note_add</span> New Permit
                    </a>
                </li>
            </c:if>

            <c:if test="${sessionScope.currentUserRole != 'Worker' && sessionScope.currentUserRole != 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard?view=approvals"
                       class="nav-link ${currentView == 'approvals' ? 'active' : ''}">
                        <span class="material-symbols-outlined">fact_check</span> Approvals Inbox
                    </a>
                </li>
            </c:if>

            <li>
                <a href="${pageContext.request.contextPath}/dashboard?view=analytics"
                   class="nav-link ${currentView == 'analytics' ? 'active' : ''}">
                    <span class="material-symbols-outlined">monitoring</span> Analytics
                </a>
            </li>

            <c:if test="${sessionScope.currentUserRole == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard?view=logs"
                       class="nav-link ${currentView == 'logs' ? 'active' : ''}">
                        <span class="material-symbols-outlined">policy</span> Audit Logs
                    </a>
                </li>
            </c:if>
        </ul>

        <!-- Action Items -->
        <div class="navbar-actions">

            <!-- User Role Switcher -->
            <div class="user-simulator-panel">
                <div class="user-badge">
                    <c:out value="${fn:substring(username, 0, 1)}" />
                </div>

                <div class="user-info">
                    <span class="user-name"><c:out value="${username}" /></span>
                    <span class="user-role"><c:out value="${sessionScope.currentUserRole}" /></span>
                </div>
            </div>

            <!-- Theme Toggle -->
            <form action="${pageContext.request.contextPath}/dashboard" method="post" style="display:inline; margin:0;">
                <input type="hidden" name="action" value="switchTheme">
                <input type="hidden" name="theme" value="${sessionScope.theme == 'dark' ? 'light' : 'dark'}">

                <button type="submit" class="theme-toggle-btn" title="Toggle Light/Dark Theme">
                    <span class="material-symbols-outlined">
                        ${sessionScope.theme == 'dark' ? 'light_mode' : 'dark_mode'}
                    </span>
                </button>
            </form>

            <!-- Notifications -->
            <div class="notif-bell-wrapper" id="notif-bell-trigger" title="Open Notifications Simulation Center">
                <span class="material-symbols-outlined" style="font-size:26px; color:var(--text-secondary);">notifications</span>
                <span class="notif-badge">
                    <c:out value="${empty notifications ? 0 : fn:length(notifications)}" />
                </span>
            </div>

            <!-- Logout -->
            <a href="${pageContext.request.contextPath}/auth?action=logout"
               class="theme-toggle-btn"
               title="Logout & Reset Session"
               style="color:var(--status-rejected);">
                <span class="material-symbols-outlined">power_settings_new</span>
            </a>

        </div>
    </div>
</header>