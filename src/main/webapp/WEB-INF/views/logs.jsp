<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<c:set var="role" value="${sessionScope.currentUserRole}" />

<main class="container" style="padding-top:30px; padding-bottom:50px;">

    <div style="margin-bottom:24px;">
        <h1 style="font-size:28px;">Safety Compliance Audit Trail</h1>
        <p style="color:var(--text-secondary); margin-top:4px;">Chronological register of safety operations and approvals dispatches</p>
    </div>

    <c:choose>
        <c:when test="${role != 'Admin'}">
            <div class="card" style="text-align:center; padding:50px 20px;">
                <span class="material-symbols-outlined" style="font-size:48px; color:var(--text-muted); margin-bottom:12px;">lock</span>
                <h3>Access Restricted to Administrator</h3>
                <p style="color:var(--text-secondary); margin-top:8px; max-width:500px; margin-left:auto; margin-right:auto;">
                    The global safety audit log registry contains sensitive administrative logs and is only accessible by users with the Admin role. Use the simulator dropdown in the navbar to switch.
                </p>
                <a href="${pageContext.request.contextPath}/dashboard?view=dashboard" class="btn btn-primary" style="margin-top:20px;">
                    Return to Dashboard
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Aggregated Audit Log table -->
            <div class="card" style="padding:0; overflow:hidden;">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="padding-left:24px;">Timestamp</th>
                                <th>Permit ID</th>
                                <th>Performed Action</th>
                                <th>Responsible Actor</th>
                                <th style="padding-right:24px;">Log Comments</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Iterate over all permits and pull out logs in a flattened list -->
                            <!-- Note: Normally we would query a DB or a sorted manager list, but in JSP we can use scriptlet or JSTL list logic -->
                            <!-- Let's run a JSTL loop and collect logs, sorting is implicit by seed chronological insertion -->
                            <c:set var="totalLogs" value="0" />
                            <c:forEach var="p" items="${sessionScope.permits}">
                                <c:forEach var="log" items="${p.logs}">
                                    <c:set var="totalLogs" value="${totalLogs + 1}" />
                                    <tr>
                                        <td style="padding-left:24px; font-family:monospace; font-size:12px; color:var(--text-secondary);">
                                            <c:out value="${fn:replace(log.timestamp, 'T', ' ')}" />
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/dashboard?view=details&id=${p.id}" style="font-family:monospace; font-weight:700;">
                                                <c:out value="${p.id}" />
                                            </a>
                                        </td>
                                        <td>
                                            <span style="font-weight:600;"><c:out value="${log.action}" /></span>
                                        </td>
                                        <td><c:out value="${log.actor}" /></td>
                                        <td style="padding-right:24px; font-size:13px; color:var(--text-secondary);">
                                            <c:out value="${log.comments}" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                            <c:if test="${totalLogs == 0}">
                                <tr>
                                    <td colspan="5" style="text-align:center; padding:40px; color:var(--text-muted);">
                                        No log entries registered in the active session.
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
