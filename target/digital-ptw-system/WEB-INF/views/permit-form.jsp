<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<!-- Check if editing an existing permit (e.g. from draft or modification required) -->
<c:set var="editPermit" value="${null}" />
<c:if test="${not empty param.id}">
    <c:forEach var="p" items="${sessionScope.permits}">
        <c:if test="${p.id == param.id}">
            <c:set var="editPermit" value="${p}" />
        </c:if>
    </c:forEach>
</c:if>

<main class="container" style="padding-top:30px; padding-bottom:50px;">
    
    <div style="margin-bottom:24px;">
        <h1 style="font-size:28px;"><c:out value="${editPermit != null ? 'Edit Work Permit Request' : 'Create Safety Work Permit'}" /></h1>
        <p style="color:var(--text-secondary);">Submit hazardous operation authorization requests digitally.</p>
    </div>

    <div class="card" style="max-width:900px; margin:0 auto; padding:40px;">
        
        <!-- Multi-Step Stepper Header -->
        <div class="wizard-steps">
            <div class="wizard-step active" id="step-0-indicator">
                <div class="wizard-icon">1</div>
                <div class="wizard-label">Work Context</div>
            </div>
            <div class="wizard-step" id="step-1-indicator">
                <div class="wizard-icon">2</div>
                <div class="wizard-label">Hazards & Checks</div>
            </div>
            <div class="wizard-step" id="step-2-indicator">
                <div class="wizard-icon">3</div>
                <div class="wizard-label">Required PPE</div>
            </div>
            <div class="wizard-step" id="step-3-indicator">
                <div class="wizard-icon">4</div>
                <div class="wizard-label">Final Review</div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/permit" method="post" id="permitForm">
            <!-- Action specifies create/update -->
            <input type="hidden" name="id" value="${editPermit != null ? editPermit.id : ''}" />
            <input type="hidden" name="action" id="formActionSubmit" value="submit" />

            <!-- STEP 1: Work Context -->
            <div class="form-step-content active" id="step-0-content">
                <h3 style="margin-bottom:20px; border-bottom:var(--border-width) solid var(--border-color); padding-bottom:8px;">Step 1: Work Context & Scope</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="workType">Type of Hazardous Work *</label>
                        <select name="workType" id="workType" required>
                            <option value="Hot Work" ${editPermit.workType == 'Hot Work' ? 'selected' : ''}>Hot Work (Welding, Cutting, Grinding)</option>
                            <option value="Confined Space Entry" ${editPermit.workType == 'Confined Space Entry' ? 'selected' : ''}>Confined Space Entry (Tanks, Sumps, Silos)</option>
                            <option value="Work at Heights" ${editPermit.workType == 'Work at Heights' ? 'selected' : ''}>Work at Heights (Scaffold, Ladders > 1.8m)</option>
                            <option value="Electrical Maintenance" ${editPermit.workType == 'Electrical Maintenance' ? 'selected' : ''}>Electrical Maintenance (Isolation, Substation)</option>
                            <option value="Welding" ${editPermit.workType == 'Welding' ? 'selected' : ''}>Welding Operations</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="location">Plant Work Location *</label>
                        <select name="location" id="location" required>
                            <option value="Blast Furnace 1" ${editPermit.location == 'Blast Furnace 1' ? 'selected' : ''}>Blast Furnace 1</option>
                            <option value="Coke Oven 2" ${editPermit.location == 'Coke Oven 2' ? 'selected' : ''}>Coke Oven 2</option>
                            <option value="Oxygen Plant" ${editPermit.location == 'Oxygen Plant' ? 'selected' : ''}>Oxygen Plant</option>
                            <option value="Rolling Mill" ${editPermit.location == 'Rolling Mill' ? 'selected' : ''}>Rolling Mill</option>
                            <option value="Power Plant" ${editPermit.location == 'Power Plant' ? 'selected' : ''}>Power Plant</option>
                            <option value="Sinter Plant" ${editPermit.location == 'Sinter Plant' ? 'selected' : ''}>Sinter Plant</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="riskLevel">Evaluated Risk Level *</label>
                        <select name="riskLevel" id="riskLevel" required>
                            <option value="Low" ${editPermit.riskLevel == 'Low' ? 'selected' : ''}>Low (Standard operations)</option>
                            <option value="Medium" ${editPermit.riskLevel == 'Medium' ? 'selected' : ''}>Medium (Hazardous elements present)</option>
                            <option value="High" ${editPermit.riskLevel == 'High' ? 'selected' : ''}>High (Critical risk - requires Manager authorization)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Applicant (Worker)</label>
                        <input type="text" value="${sessionScope.currentUsername}" disabled />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="startDate">Proposed Start Date & Time *</label>
                        <input type="datetime-local" name="startDate" id="startDate" 
                               value="${editPermit != null ? editPermit.startDate : '2026-06-23T08:00'}" required />
                    </div>
                    <div class="form-group">
                        <label for="endDate">Proposed End Date & Time *</label>
                        <input type="datetime-local" name="endDate" id="endDate" 
                               value="${editPermit != null ? editPermit.endDate : '2026-06-23T16:00'}" required />
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Detailed Description of Work Activity *</label>
                    <textarea name="description" id="description" rows="4" placeholder="Describe mechanical isolations, welding specs, tools, and specific tasks..." required><c:out value="${editPermit != null ? editPermit.description : ''}" /></textarea>
                </div>

                <div class="form-actions" style="justify-content: flex-end;">
                    <button type="button" class="btn btn-primary btn-next">
                        Next: Safety Checks <span class="material-symbols-outlined">arrow_forward</span>
                    </button>
                </div>
            </div>

            <!-- STEP 2: Precaution Checklist -->
            <div class="form-step-content" id="step-1-content">
                <h3 style="margin-bottom:10px; border-bottom:var(--border-width) solid var(--border-color); padding-bottom:8px;">Step 2: Risk Assessment & Safety Precautions</h3>
                <p style="color:var(--text-muted); font-size:12px; margin-bottom:20px;">
                    Verify that the following precautions have been completed or scheduled on site. The system suggests these checklist items based on the work type selected.
                </p>

                <div class="form-group">
                    <label>Site Precautions Checklist (Tick to confirm compliance)</label>
                    <div class="precaution-grid" id="dynamic-precautions">
                        <!-- Loaded Dynamically via JS in app.js -->
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary btn-prev">
                        <span class="material-symbols-outlined">arrow_back</span> Back
                    </button>
                    <button type="button" class="btn btn-primary btn-next">
                        Next: Required PPE <span class="material-symbols-outlined">arrow_forward</span>
                    </button>
                </div>
            </div>

            <!-- STEP 3: PPE Selection -->
            <div class="form-step-content" id="step-2-content">
                <h3 style="margin-bottom:10px; border-bottom:var(--border-width) solid var(--border-color); padding-bottom:8px;">Step 3: Personal Protective Equipment (PPE)</h3>
                <p style="color:var(--text-muted); font-size:12px; margin-bottom:20px;">
                    Select the mandatory protective gear required for safety compliance.
                </p>

                <div class="form-group">
                    <label>Required Personal Protective Equipment</label>
                    <div class="precaution-grid" id="dynamic-ppe">
                        <!-- Loaded Dynamically via JS in app.js -->
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary btn-prev">
                        <span class="material-symbols-outlined">arrow_back</span> Back
                    </button>
                    <button type="button" class="btn btn-primary btn-next">
                        Next: Review & Submit <span class="material-symbols-outlined">arrow_forward</span>
                    </button>
                </div>
            </div>

            <!-- STEP 4: Review and Submit -->
            <div class="form-step-content" id="step-3-content">
                <h3 style="margin-bottom:20px; border-bottom:var(--border-width) solid var(--border-color); padding-bottom:8px;">Step 4: Sign-off and Submit Permit</h3>
                
                <div style="background-color:var(--bg-surface-hover); border:var(--border-width) solid var(--border-color); border-radius:var(--radius-sm); padding:20px; margin-bottom:24px; display:flex; flex-direction:column; gap:16px;">
                    <div style="display:grid; grid-template-columns:150px 1fr; border-bottom:1px solid var(--border-color); padding-bottom:8px;">
                        <strong>Work Type:</strong>
                        <span id="review-workType">-</span>
                    </div>
                    <div style="display:grid; grid-template-columns:150px 1fr; border-bottom:1px solid var(--border-color); padding-bottom:8px;">
                        <strong>Location:</strong>
                        <span id="review-location">-</span>
                    </div>
                    <div style="display:grid; grid-template-columns:150px 1fr; border-bottom:1px solid var(--border-color); padding-bottom:8px;">
                        <strong>Risk Level:</strong>
                        <span><span id="review-riskLevel" class="badge">-</span></span>
                    </div>
                    <div style="display:grid; grid-template-columns:150px 1fr; border-bottom:1px solid var(--border-color); padding-bottom:8px;">
                        <strong>Schedule Window:</strong>
                        <div>
                            Start: <span id="review-startDate">-</span><br>
                            End: <span id="review-endDate">-</span>
                        </div>
                    </div>
                    <div style="display:grid; grid-template-columns:150px 1fr;">
                        <strong>Description:</strong>
                        <span id="review-description">-</span>
                    </div>
                </div>

                <div style="padding:15px; border-radius:var(--radius-sm); border:var(--border-width) solid rgba(245,158,11,0.3); background-color:rgba(245,158,11,0.05); font-size:13px; color:var(--text-secondary); margin-bottom:24px; display:flex; gap:12px; align-items:center;">
                    <span class="material-symbols-outlined" style="color:var(--status-pending); font-size:32px;">verified</span>
                    <p>
                        <b>Declaration:</b> By submitting this request, I certify that I have inspected the workspace, verified standard hazards, and commit to enforcing the checks and wearing the protective gear specified.
                    </p>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary btn-prev">
                        <span class="material-symbols-outlined">arrow_back</span> Back
                    </button>
                    <div style="display:flex; gap:12px;">
                        <button type="submit" onclick="document.getElementById('formActionSubmit').value='draft';" class="btn btn-secondary">
                            <span class="material-symbols-outlined">save</span> Save Draft
                        </button>
                        <button type="submit" onclick="document.getElementById('formActionSubmit').value='submit';" class="btn btn-primary" style="background-color:var(--status-active);">
                            <span class="material-symbols-outlined">send</span> Submit Permit
                        </button>
                    </div>
                </div>
            </div>

        </form>

    </div>

</main>

<jsp:include page="layout/footer.jsp" />
