<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<c:set var="p" value="${requestScope.permit}" />

<!-- Determine current step for visual timeline -->
<c:set var="stepDraft" value="completed" />
<c:set var="stepSupervisor" value="" />
<c:set var="stepSafety" value="" />
<c:set var="stepManager" value="" />
<c:set var="stepApproved" value="" />
<c:set var="stepProgress" value="" />
<c:set var="stepClosed" value="" />

<c:choose>
    <c:when test="${p.status == 'DRAFT'}">
        <c:set var="stepDraft" value="current" />
    </c:when>
    <c:when test="${p.status == 'MODIFICATION_REQUIRED'}">
        <c:set var="stepDraft" value="current" />
    </c:when>
    <c:when test="${p.status == 'PENDING_SUPERVISOR'}">
        <c:set var="stepSupervisor" value="current" />
    </c:when>
    <c:when test="${p.status == 'PENDING_SAFETY'}">
        <c:set var="stepSupervisor" value="completed" />
        <c:set var="stepSafety" value="current" />
    </c:when>
    <c:when test="${p.status == 'PENDING_MANAGER'}">
        <c:set var="stepSupervisor" value="completed" />
        <c:set var="stepSafety" value="completed" />
        <c:set var="stepManager" value="current" />
    </c:when>
    <c:when test="${p.status == 'APPROVED'}">
        <c:set var="stepSupervisor" value="completed" />
        <c:set var="stepSafety" value="completed" />
        <c:if test="${p.riskLevel == 'High'}">
            <c:set var="stepManager" value="completed" />
        </c:if>
        <c:set var="stepApproved" value="current" />
    </c:when>
    <c:when test="${p.status == 'IN_PROGRESS'}">
        <c:set var="stepSupervisor" value="completed" />
        <c:set var="stepSafety" value="completed" />
        <c:if test="${p.riskLevel == 'High'}">
            <c:set var="stepManager" value="completed" />
        </c:if>
        <c:set var="stepApproved" value="completed" />
        <c:set var="stepProgress" value="current" />
    </c:when>
    <c:when test="${p.status == 'COMPLETED'}">
        <c:set var="stepSupervisor" value="completed" />
        <c:set var="stepSafety" value="completed" />
        <c:if test="${p.riskLevel == 'High'}">
            <c:set var="stepManager" value="completed" />
        </c:if>
        <c:set var="stepApproved" value="completed" />
        <c:set var="stepProgress" value="completed" />
        <c:set var="stepClosed" value="completed" />
    </c:when>
    <c:when test="${p.status == 'REJECTED'}">
        <c:set var="stepSupervisor" value="rejected" />
        <c:set var="stepSafety" value="rejected" />
        <c:set var="stepManager" value="rejected" />
    </c:when>
</c:choose>

<main class="container" style="padding-top:30px; padding-bottom:50px;">

    <!-- Title bar & print/back actions -->
    <div class="card-title-bar" style="margin-bottom:24px;">
        <div>
            <div style="display:flex; align-items:center; gap:12px;">
                <h1 style="font-size:28px; font-family:var(--font-heading); font-weight:800;">
                    Permit <c:out value="${p.id}" />
                </h1>

                <span class="badge badge-${fn:toLowerCase(p.status)}">
                    <c:out value="${fn:replace(p.status, '_', ' ')}" />
                </span>

                <span class="badge badge-risk-${fn:toLowerCase(p.riskLevel)}">
                    <c:out value="${p.riskLevel}" /> Risk
                </span>
            </div>

            <p style="color:var(--text-secondary); margin-top:4px;">
                Registered on: <c:out value="${fn:replace(p.createdAt, 'T', ' ')}" />
            </p>
        </div>

        <div style="display:flex; gap:12px;">
            <a href="${pageContext.request.contextPath}/dashboard?view=permits" class="btn btn-secondary">
                <span class="material-symbols-outlined">arrow_back</span> Registry List
            </a>

            <button onclick="window.print();" class="btn btn-secondary">
                <span class="material-symbols-outlined">print</span> Print Permit
            </button>
        </div>
    </div>

    <!-- Error message if validation fails -->
    <c:if test="${not empty requestScope.error}">
        <div style="padding:16px; background-color:rgba(239,68,68,0.1); border:1px solid var(--status-rejected); border-radius:var(--radius-sm); color:var(--status-rejected); margin-bottom:24px; font-weight:600;">
            <span class="material-symbols-outlined" style="margin-right:8px;">error</span>
            <c:out value="${requestScope.error}" />
        </div>
    </c:if>

    <!-- Visual timeline stepper -->
    <div class="card" style="margin-bottom:24px; padding:20px;">
        <h4 style="font-size:12px; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.5px; margin-bottom:10px;">
            Approval Flow Process
        </h4>

        <div class="timeline-stepper">
            <div class="timeline-node ${stepDraft}">
                <div class="timeline-dot">1</div>
                <div class="timeline-text">Draft Created</div>
            </div>

            <div class="timeline-node ${p.status == 'REJECTED' && empty p.supervisor ? 'rejected' : stepSupervisor}">
                <div class="timeline-dot">2</div>
                <div class="timeline-text">Supervisor Approval</div>
            </div>

            <div class="timeline-node ${p.status == 'REJECTED' && not empty p.supervisor && empty p.safetyOfficer ? 'rejected' : stepSafety}">
                <div class="timeline-dot">3</div>
                <div class="timeline-text">Safety Verification</div>
            </div>

            <c:if test="${p.riskLevel == 'High'}">
                <div class="timeline-node ${p.status == 'REJECTED' && not empty p.safetyOfficer && empty p.manager ? 'rejected' : stepManager}">
                    <div class="timeline-dot">4</div>
                    <div class="timeline-text">Manager Auth</div>
                </div>
            </c:if>

            <div class="timeline-node ${stepApproved}">
                <div class="timeline-dot">
                    <span class="material-symbols-outlined" style="font-size:14px;">check</span>
                </div>
                <div class="timeline-text">Approved</div>
            </div>

            <div class="timeline-node ${stepProgress}">
                <div class="timeline-dot">
                    <span class="material-symbols-outlined" style="font-size:14px;">engineering</span>
                </div>
                <div class="timeline-text">In Progress</div>
            </div>

            <div class="timeline-node ${stepClosed}">
                <div class="timeline-dot">
                    <span class="material-symbols-outlined" style="font-size:14px;">lock</span>
                </div>
                <div class="timeline-text">Closed</div>
            </div>
        </div>
    </div>

    <!-- Detail Splits (Details on left, workflow panel on right) -->
    <div class="detail-grid">

        <!-- Left: Permit details and Checklist -->
        <div style="display:flex; flex-direction:column; gap:24px;">

            <!-- Metadata details -->
            <div class="card">
                <div class="detail-section">
                    <h3 class="detail-header">Work Scope Context</h3>

                    <div class="info-grid">
                        <div class="info-cell">
                            <span class="info-label">Type of Work</span>
                            <span class="info-val" style="font-weight:600;">
                                <c:out value="${p.workType}" />
                            </span>
                        </div>

                        <div class="info-cell">
                            <span class="info-label">Safety Location</span>
                            <span class="info-val">
                                <c:out value="${p.location}" />
                            </span>
                        </div>

                        <div class="info-cell" style="margin-top:12px;">
                            <span class="info-label">Applicant (Worker)</span>
                            <span class="info-val">
                                <c:out value="${p.applicant}" />
                            </span>
                        </div>

                        <div class="info-cell" style="margin-top:12px;">
                            <span class="info-label">Schedule Window</span>
                            <span class="info-val">
                                Start: <c:out value="${fn:replace(p.startDate, 'T', ' ')}" /><br>
                                End: <c:out value="${fn:replace(p.endDate, 'T', ' ')}" />
                            </span>
                        </div>
                    </div>

                    <div style="margin-top:20px; border-top:1px solid var(--border-color); padding-top:15px;">
                        <span class="info-label">Description of Activity</span>
                        <p style="font-size:14px; margin-top:6px; white-space:pre-wrap; line-height:1.6;">
                            <c:out value="${p.description}" />
                        </p>
                    </div>
                </div>
            </div>

            <!-- Checklists -->
            <div class="card">
                <h3 class="detail-header">Enforced Site Safety Measures</h3>

                <div class="detail-section">
                    <h4 style="font-size:14px; margin-bottom:12px; display:flex; align-items:center; gap:8px;">
                        <span class="material-symbols-outlined" style="color:var(--status-active);">playlist_add_check</span>
                        Precautions Verification Checklist
                    </h4>

                    <div style="display:flex; flex-direction:column; gap:8px;">
                        <c:forEach var="item" items="${p.preChecklist}">
                            <div style="display:flex; align-items:center; gap:10px; font-size:14px; padding:8px 12px; border-radius:6px; background-color:var(--bg-app); border:1px solid var(--border-color);">
                                <span class="material-symbols-outlined" style="color:var(--status-active); font-size:18px;">check_circle</span>
                                <span><c:out value="${item}" /></span>
                            </div>
                        </c:forEach>

                        <c:if test="${empty p.preChecklist}">
                            <p style="color:var(--text-muted); font-size:13px;">No precautions checklist defined.</p>
                        </c:if>
                    </div>
                </div>

                <div class="detail-section" style="margin-top:20px;">
                    <h4 style="font-size:14px; margin-bottom:12px; display:flex; align-items:center; gap:8px;">
                        <span class="material-symbols-outlined" style="color:var(--primary);">shield</span>
                        Mandatory PPE Gear
                    </h4>

                    <div style="display:flex; flex-wrap:wrap; gap:8px;">
                        <c:forEach var="item" items="${p.ppe}">
                            <span class="badge" style="background-color:rgba(var(--primary-rgb),0.1); color:var(--primary); border:1px solid rgba(var(--primary-rgb),0.2); padding:6px 12px; border-radius:6px;">
                                <c:out value="${item}" />
                            </span>
                        </c:forEach>

                        <c:if test="${empty p.ppe}">
                            <p style="color:var(--text-muted); font-size:13px;">No PPE specified.</p>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Audit Trail Logs -->
            <div class="card">
                <h3 class="detail-header">System Audit Trail History</h3>

                <div class="audit-list">
                    <c:forEach var="log" items="${p.logs}">
                        <div class="audit-node">
                            <div class="audit-time">
                                <c:out value="${fn:substring(log.timestamp, 11, 16)}" />
                            </div>

                            <div class="audit-marker"></div>

                            <div class="audit-content">
                                <div class="audit-title">
                                    <span><c:out value="${log.action}" /></span>
                                    <span class="audit-actor"><c:out value="${log.actor}" /></span>
                                </div>

                                <c:if test="${not empty log.comments}">
                                    <p class="audit-msg">
                                        <em>Comments: "<c:out value="${log.comments}" />"</em>
                                    </p>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>

        <!-- Right: Actions Portal (Workflow/Execution) -->
        <div style="display:flex; flex-direction:column; gap:24px;">

            <!-- Contextual workflow panel based on status and user role -->
            <c:set var="showApprovalForm" value="false" />

            <c:choose>
                <c:when test="${p.status == 'PENDING_SUPERVISOR' && sessionScope.currentUserRole == 'Supervisor'}">
                    <c:set var="showApprovalForm" value="true" />
                </c:when>
                <c:when test="${p.status == 'PENDING_SAFETY' && sessionScope.currentUserRole == 'Safety Officer'}">
                    <c:set var="showApprovalForm" value="true" />
                </c:when>
                <c:when test="${p.status == 'PENDING_MANAGER' && sessionScope.currentUserRole == 'Manager'}">
                    <c:set var="showApprovalForm" value="true" />
                </c:when>
            </c:choose>

            <c:choose>
                <c:when test="${showApprovalForm}">
                    <div class="card" style="border-color:var(--status-pending); background-color:rgba(245,158,11,0.02);">
                        <h3 style="margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                            <span class="material-symbols-outlined" style="color:var(--status-pending);">security</span>
                            Approval Sign-Off Panel
                        </h3>

                        <p style="color:var(--text-secondary); font-size:13px; margin-bottom:15px;">
                            Verify the work scope, safety checklists, and site isolation. Please submit comments below.
                            Comments are required for rejections or modification requests.
                        </p>

                        <form action="${pageContext.request.contextPath}/approve" method="post" id="approvalForm">
                            <input type="hidden" name="id" value="${p.id}" />
                            <input type="hidden" name="approvalAction" id="approvalActionInput" value="approve" />

                            <div class="form-group">
                                <label for="comment">Approver Audit Comments</label>
                                <textarea name="comment" id="comment" rows="4"
                                          placeholder="Describe safety checklist verifications, checks performed on site, or reason for rejection..."></textarea>
                            </div>

                            <div style="display:flex; flex-direction:column; gap:8px;">
                                <button type="submit"
                                        onclick="document.getElementById('approvalActionInput').value='approve';"
                                        class="btn btn-success" style="width:100%;">
                                    <span class="material-symbols-outlined">check</span>
                                    Approve & Verify Safety
                                </button>

                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px;">
                                    <button type="submit"
                                            onclick="document.getElementById('approvalActionInput').value='modify';"
                                            class="btn btn-secondary"
                                            style="color:var(--status-modify); border-color:var(--status-modify);">
                                        <span class="material-symbols-outlined">edit_note</span>
                                        Request Mod
                                    </button>

                                    <button type="submit"
                                            onclick="document.getElementById('approvalActionInput').value='reject';"
                                            class="btn btn-danger">
                                        <span class="material-symbols-outlined">close</span>
                                        Reject
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </c:when>

                <c:when test="${sessionScope.currentUserRole == 'Worker' && p.applicant == sessionScope.currentUsername && (p.status == 'APPROVED' || p.status == 'IN_PROGRESS')}">
                    <div class="card" style="border-color:var(--status-active); background-color:rgba(16,185,129,0.02);">
                        <h3 style="margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                            <span class="material-symbols-outlined" style="color:var(--status-active);">play_circle</span>
                            Work Execution Portal
                        </h3>

                        <c:choose>
                            <c:when test="${p.status == 'APPROVED'}">
                                <p style="color:var(--text-secondary); font-size:13px; margin-bottom:20px;">
                                    This permit has been fully authorized. Check all PPE, confirm with standby teams,
                                    and click below to commence work.
                                </p>

                                <form action="${pageContext.request.contextPath}/permit" method="post">
                                    <input type="hidden" name="id" value="${p.id}" />
                                    <input type="hidden" name="action" value="startWork" />

                                    <button type="submit" class="btn btn-success" style="width:100%; height:50px;">
                                        <span class="material-symbols-outlined">play_arrow</span>
                                        Start On-Site Work
                                    </button>
                                </form>
                            </c:when>

                            <c:when test="${p.status == 'IN_PROGRESS'}">
                                <p style="color:var(--text-secondary); font-size:13px; margin-bottom:20px;">
                                    Work is actively in progress at <c:out value="${p.location}" />.
                                    Once the task is completed and the site is cleared of debris and hazards,
                                    click below to sign off.
                                </p>

                                <form action="${pageContext.request.contextPath}/permit" method="post">
                                    <input type="hidden" name="id" value="${p.id}" />
                                    <input type="hidden" name="action" value="completeWork" />

                                    <button type="submit" class="btn btn-primary"
                                            style="width:100%; height:50px; background-color:var(--status-draft);">
                                        <span class="material-symbols-outlined">lock</span>
                                        Complete & Sign Off
                                    </button>
                                </form>
                            </c:when>
                        </c:choose>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="card">
                        <h3 style="margin-bottom:15px;">Safety Action Portal</h3>

                        <c:choose>
                            <c:when test="${p.status == 'DRAFT'}">
                                <p style="color:var(--text-secondary); font-size:13px; margin-bottom:15px;">
                                    This permit is currently saved as a draft. Click edit to review safety checklists
                                    or submit it for supervisor verification.
                                </p>

                                <c:if test="${sessionScope.currentUserRole == 'Worker'}">
                                    <a href="${pageContext.request.contextPath}/dashboard?view=create&id=${p.id}"
                                       class="btn btn-primary" style="width:100%;">
                                        <span class="material-symbols-outlined">edit</span>
                                        Edit & Submit Request
                                    </a>
                                </c:if>
                            </c:when>

                            <c:when test="${p.status == 'MODIFICATION_REQUIRED'}">
                                <p style="color:var(--text-secondary); font-size:13px; margin-bottom:15px;">
                                    Approving safety officers requested corrections. Read the comments in the audit trail,
                                    modify the values, and resubmit.
                                </p>

                                <c:if test="${sessionScope.currentUserRole == 'Worker'}">
                                    <a href="${pageContext.request.contextPath}/dashboard?view=create&id=${p.id}"
                                       class="btn btn-primary"
                                       style="width:100%; background-color:var(--status-modify);">
                                        <span class="material-symbols-outlined">published_with_changes</span>
                                        Modify & Resubmit
                                    </a>
                                </c:if>
                            </c:when>

                            <c:when test="${p.status == 'REJECTED'}">
                                <div style="padding:15px; border-radius:var(--radius-sm); border:1px solid rgba(239,68,68,0.2); background-color:rgba(239,68,68,0.03); color:var(--status-rejected); font-size:13px; font-weight:600; display:flex; gap:10px; align-items:center;">
                                    <span class="material-symbols-outlined">gpp_bad</span>
                                    <span>Work Denied: Safety clearance rejected. A new permit request must be created for this activity.</span>
                                </div>
                            </c:when>

                            <c:when test="${p.status == 'COMPLETED'}">
                                <div style="padding:15px; border-radius:var(--radius-sm); border:1px solid rgba(16,185,129,0.2); background-color:rgba(16,185,129,0.03); color:var(--status-active); font-size:13px; font-weight:600; display:flex; gap:10px; align-items:center;">
                                    <span class="material-symbols-outlined">check_circle</span>
                                    <span>Permit Closed: Work successfully completed. Safety isolations cleared.</span>
                                </div>
                            </c:when>

                            <c:when test="${p.status == 'EXPIRED'}">
                                <div style="padding:15px; border-radius:var(--radius-sm); border:1px solid rgba(120,113,108,0.2); background-color:rgba(120,113,108,0.03); color:var(--status-expired); font-size:13px; font-weight:600; display:flex; gap:10px; align-items:center;">
                                    <span class="material-symbols-outlined">history</span>
                                    <span>Permit Expired: The schedule window elapsed without task completion.</span>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div style="padding:15px; border-radius:var(--radius-sm); border:1px solid var(--border-color); background-color:var(--bg-app); font-size:13px; color:var(--text-secondary); text-align:center;">
                                    <span class="material-symbols-outlined" style="font-size:36px; color:var(--text-muted); margin-bottom:8px;">hourglass_top</span>
                                    <p>Awaiting authorization from the next safety stage.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Approver Sign-off Details -->
            <div class="card">
                <h3>Sign-off Registry</h3>

                <div style="margin-top:15px; display:flex; flex-direction:column; gap:16px;">

                    <div style="border-left:3px solid ${not empty p.supervisor ? 'var(--status-active)' : 'var(--border-color)'}; padding-left:12px;">
                        <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:700;">
                            Supervisor Stage
                        </div>

                        <div style="font-weight:600; font-size:14px; margin-top:2px;">
                            <c:out value="${not empty p.supervisor ? p.supervisor : 'Awaiting sign-off'}" />
                        </div>

                        <c:if test="${not empty p.supervisorComment}">
                            <p style="font-size:12px; color:var(--text-secondary); margin-top:4px; font-style:italic;">
                                "<c:out value="${p.supervisorComment}" />"
                            </p>
                        </c:if>
                    </div>

                    <div style="border-left:3px solid ${not empty p.safetyOfficer ? 'var(--status-active)' : 'var(--border-color)'}; padding-left:12px;">
                        <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:700;">
                            Safety Officer Stage
                        </div>

                        <div style="font-weight:600; font-size:14px; margin-top:2px;">
                            <c:out value="${not empty p.safetyOfficer ? p.safetyOfficer : 'Awaiting verification'}" />
                        </div>

                        <c:if test="${not empty p.safetyOfficerComment}">
                            <p style="font-size:12px; color:var(--text-secondary); margin-top:4px; font-style:italic;">
                                "<c:out value="${p.safetyOfficerComment}" />"
                            </p>
                        </c:if>
                    </div>

                    <c:if test="${p.riskLevel == 'High'}">
                        <div style="border-left:3px solid ${not empty p.manager ? 'var(--status-active)' : 'var(--border-color)'}; padding-left:12px;">
                            <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:700;">
                                Manager Stage (High Risk)
                            </div>

                            <div style="font-weight:600; font-size:14px; margin-top:2px;">
                                <c:out value="${not empty p.manager ? p.manager : 'Awaiting authorization'}" />
                            </div>

                            <c:if test="${not empty p.managerComment}">
                                <p style="font-size:12px; color:var(--text-secondary); margin-top:4px; font-style:italic;">
                                    "<c:out value="${p.managerComment}" />"
                                </p>
                            </c:if>
                        </div>
                    </c:if>

                </div>
            </div>

        </div>
    </div>
</main>

<jsp:include page="layout/footer.jsp" />