document.addEventListener("DOMContentLoaded", function () {
    // 1. Notification Center Sidebar Toggling
    const notifBell = document.getElementById("notif-bell-trigger");
    const notifSidebar = document.getElementById("notif-sidebar");
    const notifClose = document.getElementById("notif-sidebar-close");

    if (notifBell && notifSidebar) {
        notifBell.addEventListener("click", function (e) {
            e.stopPropagation();
            notifSidebar.classList.toggle("open");
        });
    }

    if (notifClose && notifSidebar) {
        notifClose.addEventListener("click", function () {
            notifSidebar.classList.remove("open");
        });
    }

    // Close notification panel when clicking outside
    document.addEventListener("click", function (e) {
        if (notifSidebar && notifSidebar.classList.contains("open")) {
            if (!notifSidebar.contains(e.target) && e.target !== notifBell && !notifBell.contains(e.target)) {
                notifSidebar.classList.remove("open");
            }
        }
    });

    // 2. Multi-Step Form Wizard Navigation
    const steps = document.querySelectorAll(".wizard-step");
    const contents = document.querySelectorAll(".form-step-content");
    const nextBtns = document.querySelectorAll(".btn-next");
    const prevBtns = document.querySelectorAll(".btn-prev");

    let currentStepIndex = 0;

    function showStep(index) {
        if (index < 0 || index >= contents.length) return;
        
        // Hide all contents and remove active class from all steps
        contents.forEach(content => content.classList.remove("active"));
        steps.forEach((step, idx) => {
            step.classList.remove("active");
            if (idx < index) {
                step.classList.add("completed");
            } else {
                step.classList.remove("completed");
            }
        });

        // Show current step and set active
        contents[index].classList.add("active");
        steps[index].classList.add("active");
        steps[index].classList.remove("completed");
        
        currentStepIndex = index;
    }

    // Initialize wizard if present
    if (contents.length > 0) {
        showStep(0);
        
        // Add click events to wizard step headers
        steps.forEach((step, index) => {
            step.addEventListener("click", () => {
                // Only allow clicking steps we've completed or the next adjacent one
                if (index <= currentStepIndex || step.classList.contains("completed")) {
                    showStep(index);
                } else {
                    // Trigger "Next" validation
                    validateAndNext();
                }
            });
        });
    }

    function validateAndNext() {
        if (currentStepIndex === 0) {
            // Validate Step 1
            const workType = document.getElementById("workType").value;
            const location = document.getElementById("location").value;
            const riskLevel = document.getElementById("riskLevel").value;
            const description = document.getElementById("description").value;
            const startDate = document.getElementById("startDate").value;
            const endDate = document.getElementById("endDate").value;

            if (!workType || !location || !riskLevel || !description || !startDate || !endDate) {
                alert("Please fill in all fields in Step 1 before proceeding.");
                return;
            }
        }
        showStep(currentStepIndex + 1);
    }

    nextBtns.forEach(btn => {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            validateAndNext();
        });
    });

    prevBtns.forEach(btn => {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            showStep(currentStepIndex - 1);
        });
    });

    // 3. Dynamic Precautions Suggestion
    const workTypeSelect = document.getElementById("workType");
    const precautionsContainer = document.getElementById("dynamic-precautions");
    const ppeContainer = document.getElementById("dynamic-ppe");

    const precautionsData = {
        "Hot Work": [
            "Gas test completed and gas-free verified (LEL < 1%)",
            "Fire extinguisher kept ready at the spot",
            "Flammable materials removed within 10m radius",
            "Fire watch observer appointed and positioned"
        ],
        "Confined Space Entry": [
            "Oxygen level checked (Target: 19.5% - 23.5%)",
            "Toxic gas level verified zero (CO, H2S)",
            "Standby person appointed at entry point",
            "Continuous mechanical air ventilation active"
        ],
        "Work at Heights": [
            "Scaffolding inspected and tagged green",
            "Safety net installed below the work area",
            "Anchor point verified for lifeline/harness",
            "Wind speed and weather conditions check completed"
        ],
        "Electrical Maintenance": [
            "LOTO (Lock Out Tag Out) applied at breaker panel",
            "Voltage tester used to verify zero energy state",
            "Insulating mats placed underfoot",
            "Barricade and warning signs placed around panels"
        ],
        "Welding": [
            "Welding machine grounding verified",
            "Flame-resistant screens placed to protect passersby",
            "Welding area verified dry and clean",
            "Gas cylinder valves and hoses inspected for leaks"
        ]
    };

    const ppeData = {
        "Hot Work": ["Safety Helmet", "Leather Apron", "Welding Shield", "Fireproof Gloves", "Safety Goggles"],
        "Confined Space Entry": ["Safety Helmet", "SCBA / Airline Respirator", "Multi-Gas Detector", "Safety Harness", "Communication Radio"],
        "Work at Heights": ["Safety Helmet with Chin Strap", "Full Body Safety Harness", "Double Shock-Absorbing Lanyard", "Safety Shoes (Non-slip)"],
        "Electrical Maintenance": ["Safety Helmet", "Arc Flash Face Shield", "Insulated Rubber Gloves (Class 00/0)", "Dielectric Safety Shoes"],
        "Welding": ["Safety Helmet", "Welding Mask", "Leather Welding Gloves", "Safety Boots", "Dust Mask/Respirator"]
    };

    function updatePrecautionChecks() {
        if (!workTypeSelect || !precautionsContainer || !ppeContainer) return;
        
        const selectedWork = workTypeSelect.value;
        const checklists = precautionsData[selectedWork] || ["Area safety inspection completed", "Housekeeping done"];
        const ppes = ppeData[selectedWork] || ["Safety Helmet", "Safety Shoes", "High-Visibility Vest", "Safety Glasses"];

        // Clear dynamic elements
        precautionsContainer.innerHTML = "";
        ppeContainer.innerHTML = "";

        // Build Checkboxes for Precautions
        checklists.forEach((item, index) => {
            const label = document.createElement("label");
            label.className = "checkbox-card selected";
            
            const checkbox = document.createElement("input");
            checkbox.type = "checkbox";
            checkbox.name = "preChecklist";
            checkbox.value = item;
            checkbox.checked = true; // Recommend checks by default
            
            checkbox.addEventListener("change", function() {
                if (checkbox.checked) {
                    label.classList.add("selected");
                } else {
                    label.classList.remove("selected");
                }
            });

            label.appendChild(checkbox);
            label.appendChild(document.createTextNode(" " + item));
            precautionsContainer.appendChild(label);
        });

        // Build Checkboxes for PPE
        ppes.forEach((item, index) => {
            const label = document.createElement("label");
            label.className = "checkbox-card selected";
            
            const checkbox = document.createElement("input");
            checkbox.type = "checkbox";
            checkbox.name = "ppe";
            checkbox.value = item;
            checkbox.checked = true; // Recommend PPE checks by default

            checkbox.addEventListener("change", function() {
                if (checkbox.checked) {
                    label.classList.add("selected");
                } else {
                    label.classList.remove("selected");
                }
            });

            label.appendChild(checkbox);
            label.appendChild(document.createTextNode(" " + item));
            ppeContainer.appendChild(label);
        });

        // Update Review Section Summaries
        updateSummaryReview();
    }

    function updateSummaryReview() {
        const reviewType = document.getElementById("review-workType");
        const reviewLoc = document.getElementById("review-location");
        const reviewRisk = document.getElementById("review-riskLevel");
        const reviewStart = document.getElementById("review-startDate");
        const reviewEnd = document.getElementById("review-endDate");
        const reviewDesc = document.getElementById("review-description");

        if (reviewType) reviewType.textContent = document.getElementById("workType").value;
        if (reviewLoc) reviewLoc.textContent = document.getElementById("location").value;
        
        if (reviewRisk) {
            const val = document.getElementById("riskLevel").value;
            reviewRisk.textContent = val;
            reviewRisk.className = "badge badge-risk-" + val.toLowerCase();
        }

        if (reviewStart) {
            const dateStr = document.getElementById("startDate").value;
            reviewStart.textContent = dateStr ? dateStr.replace("T", " ") : "-";
        }
        if (reviewEnd) {
            const dateStr = document.getElementById("endDate").value;
            reviewEnd.textContent = dateStr ? dateStr.replace("T", " ") : "-";
        }
        if (reviewDesc) reviewDesc.textContent = document.getElementById("description").value;
    }

    if (workTypeSelect) {
        workTypeSelect.addEventListener("change", updatePrecautionChecks);
        // Run once on load to initialize first select option checks
        updatePrecautionChecks();

        // Listen for input changes in step 1 to update final review step 4
        document.getElementById("location").addEventListener("change", updateSummaryReview);
        document.getElementById("riskLevel").addEventListener("change", updateSummaryReview);
        document.getElementById("startDate").addEventListener("change", updateSummaryReview);
        document.getElementById("endDate").addEventListener("change", updateSummaryReview);
        document.getElementById("description").addEventListener("input", updateSummaryReview);
    }

    // 4. Client-side Search and Filter for Permit List Table
    const searchInput = document.getElementById("permitSearch");
    const filterWorkType = document.getElementById("filterWorkType");
    const filterStatus = document.getElementById("filterStatus");
    const filterLocation = document.getElementById("filterLocation");
    const tableRows = document.querySelectorAll(".data-table tbody tr");

    function filterTable() {
        if (!searchInput && !filterWorkType && !filterStatus && !filterLocation) return;

        const searchText = searchInput ? searchInput.value.toLowerCase() : "";
        const workVal = filterWorkType ? filterWorkType.value.toLowerCase() : "";
        const statusVal = filterStatus ? filterStatus.value.toLowerCase() : "";
        const locVal = filterLocation ? filterLocation.value.toLowerCase() : "";

        tableRows.forEach(row => {
            const idText = row.cells[0]?.textContent.toLowerCase() || "";
            const typeText = row.cells[1]?.textContent.toLowerCase() || "";
            const locText = row.cells[2]?.textContent.toLowerCase() || "";
            const applicantText = row.cells[3]?.textContent.toLowerCase() || "";
            const statusText = row.getAttribute("data-status")?.toLowerCase() || "";

            const matchesSearch = idText.includes(searchText) || applicantText.includes(searchText);
            const matchesWork = workVal === "" || typeText.includes(workVal);
            const matchesStatus = statusVal === "" || statusText === statusVal;
            const matchesLoc = locVal === "" || locText.includes(locVal);

            if (matchesSearch && matchesWork && matchesStatus && matchesLoc) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    }

    if (searchInput) searchInput.addEventListener("input", filterTable);
    if (filterWorkType) filterWorkType.addEventListener("change", filterTable);
    if (filterStatus) filterStatus.addEventListener("change", filterTable);
    if (filterLocation) filterLocation.addEventListener("change", filterTable);
});
