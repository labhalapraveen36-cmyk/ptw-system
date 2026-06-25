<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<c:set var="role" value="${sessionScope.currentUserRole}" />
<c:set var="targetStatus" value="" />

<c:choose>
    <c:when test="${role == 'Supervisor'}">
        <c:set var="targetStatus" value="PENDING_SUPERVISOR" />
    </c:when>
    <c:when test="${role == 'Safety Officer'}">
        <c:set var="targetStatus" value="PENDING_SAFETY" />
    </c:when>
    <c:when test="${role == 'Manager'}">
        <c:set var="targetStatus" value="PENDING_MANAGER" />
    </c:when>
</c:choose>

<main class="container" style="padding-top:30px; padding-bottom:50px;">

    <div style="margin-bottom:24px;">
        <h1 style="font-size:28px;">Approvals Inbox Queue</h1>
        <p style="color:var(--text-secondary); margin-top:4px;">
            Awaiting clearance action for role: <strong><c:out value="${role}" /></strong>
        </p>
    </div>

    <!-- Info banner warning if Worker/Admin logs in here -->
    <c:choose>
        <c:when test="${role == 'Worker' || role == 'Admin'}">
            <div class="card" style="text-align:center; padding:50px 20px;">
                <span class="material-symbols-outlined" style="font-size:48px; color:var(--text-muted); margin-bottom:12px;">lock</span>
                <h3>Inbox Unavailable for <c:out value="${role}" /></h3>
                <p style="color:var(--text-secondary); margin-top:8px; max-width:500px; margin-left:auto; margin-right:auto;">
                    Only authorized safety certifiers (Supervisors, Safety Officers, and Managers) have approval queues. Use the simulator in the top-right to switch roles.
                </p>
                <a href="${pageContext.request.contextPath}/dashboard?view=dashboard" class="btn btn-primary" style="margin-top:20px;">
                    Return to Dashboard
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Pending Inbox Registry Table -->
            <div class="card" style="padding:0; overflow:hidden;">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="padding-left:24px;">Permit ID</th>
                                <th>Work Type</th>
                                <th>Location</th>
                                <th>Applicant</th>
                                <th>Risk Level</th>
                                <th>Proposed Start</th>
                                <th>Proposed End</th>
                                <th style="text-align:right; padding-right:24px;">Review Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="pendingItemsCount" value="0" />
                            <c:forEach var="p" items="${sessionScope.permits}">
                                <c:if test="${p.status == targetStatus}">
                                    <c:set var="pendingItemsCount" value="${pendingItemsCount + 1}" />
                                    <tr>
                                        <td style="padding-left:24px;">
                                            <a href="${pageContext.request.contextPath}/dashboard?view=details&id=${p.id}" style="font-family:monospace; font-weight:700;">
                                                <c:out value="${p.id}" />
                                            </a>
                                        </td>
                                        <td><c:out value="${p.workType}" /></td>
                                        <td><c:out value="${p.location}" /></td>
                                        <td><c:out value="${p.applicant}" /></td>
                                        <td>
                                            <span class="badge badge-risk-${fn:toLowerCase(p.riskLevel)}">
                                                <c:out value="${p.riskLevel}" />
                                            </span>
                                        </td>
                                        <td><c:out value="${fn:replace(p.startDate, 'T', ' ')}" /></td>
                                        <td><c:out value="${fn:replace(p.endDate, 'T', ' ')}" /></td>
                                        <td style="text-align:right; padding-right:24px;">
                                            <a href="${pageContext.request.contextPath}/dashboard?view=details&id=${p.id}" class="btn btn-primary" style="padding:6px 12px; font-size:12px; border-radius:4px; height:32px; background-color:var(--status-pending); color:#000000; font-weight:600;">
                                                Verify & Sign-off
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${pendingItemsCount == 0}">
                                <tr>
                                    <td colspan="8" style="text-align:center; padding:50px; color:var(--text-muted);">
                                        <span class="material-symbols-outlined" style="font-size:36px; color:var(--status-active); margin-bottom:10px;">check_circle</span>
                                        <p style="font-size:14px; font-weight:600; color:var(--text-primary);">Inbox Clear</p>
                                        <p style="font-size:12px; color:var(--text-secondary); margin-top:2px;">No work permits pending safety clearance for your role.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<jsp:include page="layout/footer.jsp" />
