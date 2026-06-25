<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<footer style="margin-top:auto; padding:30px 0; border-top:var(--border-width) solid var(--border-color); text-align:center; font-size:12px; color:var(--text-muted); background-color:var(--bg-surface); transition:background-color var(--transition-normal), border-color var(--transition-normal);">
    <div class="container">
        <p>&copy; 2026 IronFlow Systems. Digital Permit-To-Work Platform. Steel Plant Hazard Operations Management.</p>
        <p style="margin-top:5px; font-size:10px;">Simulation Mode Active | Persistent Session Memory Storage</p>
    </div>
</footer>

<!-- Sliding Notifications Simulation Hub -->
<div class="notif-sidebar" id="notif-sidebar">
    <div class="notif-sidebar-header">
        <h3><span class="material-symbols-outlined">quick_reference_all</span> Alerts Simulator</h3>
        <button id="notif-sidebar-close"
                style="background:none; border:none; color:var(--text-secondary); cursor:pointer; font-size:20px;">
            <span class="material-symbols-outlined">close</span>
        </button>
    </div>

    <p style="font-size:11px; color:var(--text-muted); margin-bottom:15px; line-height:1.3;">
        This panel logs SMS/Email dispatches triggered by permit submission and approval workflows in real time.
    </p>

    <div class="notif-feed">
        <c:choose>
            <c:when test="${not empty sessionScope.notifications}">
                <c:forEach var="notif" items="${sessionScope.notifications}">
                    <div class="notif-card">
                        <div class="notif-meta">
                            <span class="notif-tag tag-${fn:toLowerCase(notif.type)}">
                                <c:out value="${notif.type}" />
                            </span>
                            <span>
                                To: <c:out value="${notif.recipient}" /> |
                                <c:out value="${notif.timestamp}" />
                            </span>
                        </div>
                        <div class="notif-body">
                            <c:out value="${notif.content}" />
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="text-align:center; padding:40px 0; color:var(--text-muted);">
                    <span class="material-symbols-outlined" style="font-size:40px; margin-bottom:10px;">mail_lock</span>
                    <p>No notifications triggered yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Load application scripts -->
<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>6+