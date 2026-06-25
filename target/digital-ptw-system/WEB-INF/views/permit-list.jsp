<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<c:set var="preselectedLocation" value="${param.location != null ? param.location : ''}" />

<main class="container" style="padding-top:30px; padding-bottom:50px;">
    
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
        <div>
            <h1 style="font-size:28px;">Permit Registry Directory</h1>
            <p style="color:var(--text-secondary); margin-top:4px;">Search, audit, and track work permit statuses in real time</p>
        </div>
        <c:if test="${sessionScope.currentUserRole == 'Worker'}">
            <a href="${pageContext.request.contextPath}/dashboard?view=create" class="btn btn-primary">
                <span class="material-symbols-outlined">add_circle</span> Request Permit
            </a>
        </c:if>
    </div>

    <!-- Filters Section -->
    <div class="card" style="padding:20px; margin-bottom:24px;">
        <div style="display:grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap:16px; align-items:end;">
            
            <div class="form-group" style="margin:0;">
                <label for="permitSearch">Search Permit ID or Applicant</label>
                <div style="position:relative;">
                    <input type="text" id="permitSearch" placeholder="Type Permit ID (e.g. PTW-1001) or Applicant name..." style="padding-left:40px;" />
                    <span class="material-symbols-outlined" style="position:absolute; left:12px; top:12px; color:var(--text-muted);">search</span>
                </div>
            </div>

            <div class="form-group" style="margin:0;">
                <label for="filterWorkType">Work Type Filter</label>
                <select id="filterWorkType">
                    <option value="">All Types</option>
                    <option value="Hot Work">Hot Work</option>
                    <option value="Confined Space Entry">Confined Space Entry</option>
                    <option value="Work at Heights">Work at Heights</option>
                    <option value="Electrical Maintenance">Electrical Maintenance</option>
                    <option value="Welding">Welding</option>
                </select>
            </div>

            <div class="form-group" style="margin:0;">
                <label for="filterStatus">Status Filter</label>
                <select id="filterStatus">
                    <option value="">All Statuses</option>
                    <option value="DRAFT">Draft</option>
                    <option value="PENDING_SUPERVISOR">Pending Supervisor</option>
                    <option value="PENDING_SAFETY">Pending Safety</option>
                    <option value="PENDING_MANAGER">Pending Manager</option>
                    <option value="APPROVED">Approved</option>
                    <option value="IN_PROGRESS">In Progress</option>
                    <option value="COMPLETED">Completed</option>
                    <option value="REJECTED">Rejected</option>
                    <option value="EXPIRED">Expired</option>
                    <option value="MODIFICATION_REQUIRED">Mod Required</option>
                </select>
            </div>

            <div class="form-group" style="margin:0;">
                <label for="filterLocation">Location Filter</label>
                <select id="filterLocation">
                    <option value="">All Locations</option>
                    <option value="Blast Furnace 1" ${preselectedLocation == 'Blast Furnace 1' ? 'selected' : ''}>Blast Furnace 1</option>
                    <option value="Coke Oven 2" ${preselectedLocation == 'Coke Oven 2' ? 'selected' : ''}>Coke Oven 2</option>
                    <option value="Oxygen Plant" ${preselectedLocation == 'Oxygen Plant' ? 'selected' : ''}>Oxygen Plant</option>
                    <option value="Rolling Mill" ${preselectedLocation == 'Rolling Mill' ? 'selected' : ''}>Rolling Mill</option>
                    <option value="Power Plant" ${preselectedLocation == 'Power Plant' ? 'selected' : ''}>Power Plant</option>
                    <option value="Sinter Plant" ${preselectedLocation == 'Sinter Plant' ? 'selected' : ''}>Sinter Plant</option>
                </select>
            </div>

        </div>
    </div>

    <!-- Data Table Card -->
    <div class="card" style="padding:0; overflow:hidden;">
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="padding-left:24px;">Permit ID</th>
                        <th>Work Type</th>
                        <th>Location</th>
                        <th>Applicant</th>
                        <th>Time Window (Start / End)</th>
                        <th>Risk Level</th>
                        <th>Status</th>
                        <th style="text-align:right; padding-right:24px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${sessionScope.permits}">
                        <!-- Data status attribute used by JS client filter -->
                        <tr data-status="${p.status}">
                            <td style="padding-left:24px;">
                                <a href="${pageContext.request.contextPath}/dashboard?view=details&id=${p.id}" style="font-family:monospace; font-weight:700; font-size:14px;">
                                    <c:out value="${p.id}" />
                                </a>
                            </td>
                            <td><c:out value="${p.workType}" /></td>
                            <td><c:out value="${p.location}" /></td>
                            <td><c:out value="${p.applicant}" /></td>
                            <td style="font-size:12px; color:var(--text-secondary);">
                                <c:out value="${fn:replace(p.startDate, 'T', ' ')}" /><br>
                                <c:out value="${fn:replace(p.endDate, 'T', ' ')}" />
                            </td>
                            <td>
                                <span class="badge badge-risk-${fn:toLowerCase(p.riskLevel)}">
                                    <c:out value="${p.riskLevel}" />
                                </span>
                            </td>
                            <td>
                                <span class="badge badge-${fn:toLowerCase(p.status)}">
                                    <c:out value="${fn:replace(p.status, '_', ' ')}" />
                                </span>
                            </td>
                            <td style="text-align:right; padding-right:24px;">
                                <div style="display:flex; justify-content:flex-end; gap:8px;">
                                    <a href="${pageContext.request.contextPath}/dashboard?view=details&id=${p.id}" class="btn btn-secondary" style="padding:6px 12px; font-size:12px; border-radius:4px; height:32px;">
                                        Details
                                    </a>
                                    
                                    <!-- Edit Draft option for Workers -->
                                    <c:if test="${sessionScope.currentUserRole == 'Worker' && (p.status == 'DRAFT' || p.status == 'MODIFICATION_REQUIRED') && p.applicant == sessionScope.currentUsername}">
                                        <a href="${pageContext.request.contextPath}/dashboard?view=create&id=${p.id}" class="btn btn-primary" style="padding:6px 12px; font-size:12px; border-radius:4px; height:32px;">
                                            Edit
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sessionScope.permits}">
                        <tr>
                            <td colspan="8" style="text-align:center; padding:40px; color:var(--text-muted);">
                                No permits registered in the system session.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</main>

<jsp:include page="layout/footer.jsp" />

<!-- Trigger filtering check on load if location param is set -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const filterLoc = document.getElementById("filterLocation");
        if (filterLoc && filterLoc.value !== "") {
            // Trigger filter event
            const event = new Event('change');
            filterLoc.dispatchEvent(event);
        }
    });
</script>
