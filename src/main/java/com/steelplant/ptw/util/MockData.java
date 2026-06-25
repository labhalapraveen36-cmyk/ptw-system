package com.steelplant.ptw.util;

import com.steelplant.ptw.model.Permit;
import com.steelplant.ptw.model.ActivityLog;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MockData {

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    public static List<String> getChecklistForWorkType(String workType) {
        switch (workType) {
            case "Hot Work":
                return Arrays.asList(
                    "Gas test completed and gas-free verified (LEL < 1%)",
                    "Fire extinguisher kept ready at the spot",
                    "Flammable materials removed within 10m radius",
                    "Fire watch observer appointed and positioned"
                );
            case "Confined Space Entry":
                return Arrays.asList(
                    "Oxygen level checked (Target: 19.5% - 23.5%)",
                    "Toxic gas level verified zero (CO, H2S)",
                    "Standby person appointed at entry point",
                    "Continuous mechanical air ventilation active"
                );
            case "Work at Heights":
                return Arrays.asList(
                    "Scaffolding inspected and tagged green",
                    "Safety net installed below the work area",
                    "Anchor point verified for lifeline/harness",
                    "Wind speed and weather conditions check completed"
                );
            case "Electrical Maintenance":
                return Arrays.asList(
                    "LOTO (Lock Out Tag Out) applied at breaker panel",
                    "Voltage tester used to verify zero energy state",
                    "Insulating mats placed underfoot",
                    "Barricade and warning signs placed around panels"
                );
            case "Welding":
                return Arrays.asList(
                    "Welding machine grounding verified",
                    "Flame-resistant screens placed to protect passersby",
                    "Welding area verified dry and clean",
                    "Gas cylinder valves and hoses inspected for leaks"
                );
            default:
                return Arrays.asList("Area safety inspection completed", "Housekeeping done");
        }
    }

    public static List<String> getPpeForWorkType(String workType) {
        switch (workType) {
            case "Hot Work":
                return Arrays.asList("Safety Helmet", "Leather Apron", "Welding Shield", "Fireproof Gloves", "Safety Goggles");
            case "Confined Space Entry":
                return Arrays.asList("Safety Helmet", "SCBA / Airline Respirator", "Multi-Gas Detector", "Safety Harness", "Communication Radio");
            case "Work at Heights":
                return Arrays.asList("Safety Helmet with Chin Strap", "Full Body Safety Harness", "Double Shock-Absorbing Lanyard", "Safety Shoes (Non-slip)");
            case "Electrical Maintenance":
                return Arrays.asList("Safety Helmet", "Arc Flash Face Shield", "Insulated Rubber Gloves (Class 00/0)", "Dielectric Safety Shoes");
            case "Welding":
                return Arrays.asList("Safety Helmet", "Welding Mask", "Leather Welding Gloves", "Safety Boots", "Dust Mask/Respirator");
            default:
                return Arrays.asList("Safety Helmet", "Safety Shoes", "High-Visibility Vest", "Safety Glasses");
        }
    }

    public static List<Permit> generateSeedPermits() {
        List<Permit> permits = new ArrayList<>();
        LocalDateTime now = LocalDateTime.of(2026, 6, 22, 21, 15); // Consistent with local time

        // 1. Completed Permit
        Permit p1 = new Permit("PTW-1001", "Electrical Maintenance", "Blast Furnace 1", "Medium", 
                               "Rajesh Kumar", "Repair of feed conveyor motor breaker", 
                               now.minusDays(2).format(formatter), now.minusDays(2).plusHours(6).format(formatter), 
                               "COMPLETED", now.minusDays(2).minusHours(1).format(formatter));
        p1.setPreChecklist(getChecklistForWorkType(p1.getWorkType()));
        p1.setPpe(getPpeForWorkType(p1.getWorkType()));
        p1.setSupervisor("Amit Sharma");
        p1.setSupervisorComment("LOTO verified and isolated. Safe to proceed.");
        p1.setSafetyOfficer("Vikram Singh");
        p1.setSafetyOfficerComment("Electrical checklist verified. Clearance granted.");
        p1.addLog(new ActivityLog(now.minusDays(2).minusHours(1).format(formatter), "Permit Created", "Rajesh Kumar (Worker)", "Initial submission."));
        p1.addLog(new ActivityLog(now.minusDays(2).minusMinutes(30).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "LOTO verified."));
        p1.addLog(new ActivityLog(now.minusDays(2).minusMinutes(10).format(formatter), "Verified by Safety Officer", "Vikram Singh (Safety Officer)", "Clearance granted."));
        p1.addLog(new ActivityLog(now.minusDays(2).format(formatter), "Started Work", "Rajesh Kumar (Worker)", "Maintenance started."));
        p1.addLog(new ActivityLog(now.minusDays(2).plusHours(5).format(formatter), "Completed Work", "Rajesh Kumar (Worker)", "Motor repair completed and tested. Breaker re-energized safely."));
        permits.add(p1);

        // 2. Expired Permit
        Permit p2 = new Permit("PTW-1002", "Work at Heights", "Coke Oven 2", "High", 
                               "Suresh Patil", "Inspection of structure structural beams", 
                               now.minusDays(1).format(formatter), now.minusDays(1).plusHours(4).format(formatter), 
                               "EXPIRED", now.minusDays(1).minusHours(2).format(formatter));
        p2.setPreChecklist(getChecklistForWorkType(p2.getWorkType()));
        p2.setPpe(getPpeForWorkType(p2.getWorkType()));
        p2.setSupervisor("Amit Sharma");
        p2.setSupervisorComment("Lifeline checks completed.");
        p2.setSafetyOfficer("Vikram Singh");
        p2.setSafetyOfficerComment("Harness inspections verified. High wind forecast for afternoon, proceed with caution.");
        p2.setManager("Dinesh Mehta");
        p2.setManagerComment("Authorized for high risk work at height.");
        p2.addLog(new ActivityLog(now.minusDays(1).minusHours(2).format(formatter), "Permit Created", "Suresh Patil (Worker)", "Annual structural inspection."));
        p2.addLog(new ActivityLog(now.minusDays(1).minusHours(1).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Approved."));
        p2.addLog(new ActivityLog(now.minusDays(1).minusMinutes(30).format(formatter), "Verified by Safety Officer", "Vikram Singh (Safety Officer)", "Approved."));
        p2.addLog(new ActivityLog(now.minusDays(1).minusMinutes(15).format(formatter), "Authorized by Manager", "Dinesh Mehta (Manager)", "Authorized."));
        p2.addLog(new ActivityLog(now.minusDays(1).format(formatter), "Started Work", "Suresh Patil (Worker)", "Climbing scaffold."));
        p2.addLog(new ActivityLog(now.minusDays(1).plusHours(4).format(formatter), "System Expiry Check", "System", "Permit duration elapsed without completion. Automatically marked expired."));
        permits.add(p2);

        // 3. In Progress Permit
        Permit p3 = new Permit("PTW-1003", "Confined Space Entry", "Oxygen Plant", "High", 
                               "Anil Deshmukh", "Cleaning of storage tank interior", 
                               now.minusHours(2).format(formatter), now.plusHours(4).format(formatter), 
                               "IN_PROGRESS", now.minusHours(4).format(formatter));
        p3.setPreChecklist(getChecklistForWorkType(p3.getWorkType()));
        p3.setPpe(getPpeForWorkType(p3.getWorkType()));
        p3.setSupervisor("Amit Sharma");
        p3.setSupervisorComment("O2 level log attached (20.9%). Standby watcher is present.");
        p3.setSafetyOfficer("Vikram Singh");
        p3.setSafetyOfficerComment("Gas levels monitored and verified zero toxics. Continuous blower active.");
        p3.setManager("Dinesh Mehta");
        p3.setManagerComment("Critical location cleaning authorized.");
        p3.addLog(new ActivityLog(now.minusHours(4).format(formatter), "Permit Created", "Anil Deshmukh (Worker)", "Routine cleaning."));
        p3.addLog(new ActivityLog(now.minusHours(3).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Approved."));
        p3.addLog(new ActivityLog(now.minusHours(2).minusMinutes(30).format(formatter), "Verified by Safety Officer", "Vikram Singh (Safety Officer)", "Clearance checked."));
        p3.addLog(new ActivityLog(now.minusHours(2).minusMinutes(15).format(formatter), "Authorized by Manager", "Dinesh Mehta (Manager)", "Clearance checked."));
        p3.addLog(new ActivityLog(now.minusHours(2).format(formatter), "Started Work", "Anil Deshmukh (Worker)", "Began entry."));
        permits.add(p3);

        // 4. Approved (Ready to Start)
        Permit p4 = new Permit("PTW-1004", "Hot Work", "Rolling Mill", "High", 
                               "Manish Gupta", "Welding support bracket on main motor", 
                               now.plusHours(1).format(formatter), now.plusHours(9).format(formatter), 
                               "APPROVED", now.minusHours(5).format(formatter));
        p4.setPreChecklist(getChecklistForWorkType(p4.getWorkType()));
        p4.setPpe(getPpeForWorkType(p4.getWorkType()));
        p4.setSupervisor("Amit Sharma");
        p4.setSupervisorComment("Welder certs checked. Area spark containment erected.");
        p4.setSafetyOfficer("Vikram Singh");
        p4.setSafetyOfficerComment("Gas sniff test zero LEL. Fire watch in position.");
        p4.setManager("Dinesh Mehta");
        p4.setManagerComment("Authorized for hot work near mill motors.");
        p4.addLog(new ActivityLog(now.minusHours(5).format(formatter), "Permit Created", "Manish Gupta (Worker)", "Urgent repair."));
        p4.addLog(new ActivityLog(now.minusHours(4).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Containment check."));
        p4.addLog(new ActivityLog(now.minusHours(3).format(formatter), "Verified by Safety Officer", "Vikram Singh (Safety Officer)", "Sniff test ok."));
        p4.addLog(new ActivityLog(now.minusHours(2).format(formatter), "Authorized by Manager", "Dinesh Mehta (Manager)", "Approved."));
        permits.add(p4);

        // 5. Pending Supervisor Approval
        Permit p5 = new Permit("PTW-1005", "Welding", "Power Plant", "Medium", 
                               "Vijay Yadav", "Fabrication of cooling water pipe brace", 
                               now.plusHours(2).format(formatter), now.plusHours(6).format(formatter), 
                               "PENDING_SUPERVISOR", now.minusHours(1).format(formatter));
        p5.setPreChecklist(getChecklistForWorkType(p5.getWorkType()));
        p5.setPpe(getPpeForWorkType(p5.getWorkType()));
        p5.addLog(new ActivityLog(now.minusHours(1).format(formatter), "Permit Submitted", "Vijay Yadav (Worker)", "Initial request."));
        permits.add(p5);

        // 6. Pending Safety Officer Verification
        Permit p6 = new Permit("PTW-1006", "Electrical Maintenance", "Coke Oven 2", "Medium", 
                               "Rajesh Kumar", "Relamping and lighting junction box wiring", 
                               now.plusHours(3).format(formatter), now.plusHours(7).format(formatter), 
                               "PENDING_SAFETY", now.minusHours(2).format(formatter));
        p6.setPreChecklist(getChecklistForWorkType(p6.getWorkType()));
        p6.setPpe(getPpeForWorkType(p6.getWorkType()));
        p6.setSupervisor("Amit Sharma");
        p6.setSupervisorComment("Isolated at Substation 3. LOTO applied.");
        p6.addLog(new ActivityLog(now.minusHours(2).format(formatter), "Permit Created", "Rajesh Kumar (Worker)", "Junction box repair."));
        p6.addLog(new ActivityLog(now.minusHours(1).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Substation isolation checked."));
        permits.add(p6);

        // 7. Pending Manager Authorization (High Risk Hot Work)
        Permit p7 = new Permit("PTW-1007", "Hot Work", "Blast Furnace 1", "High", 
                               "Vijay Yadav", "Cutting pipes at gas cleaning unit", 
                               now.plusHours(4).format(formatter), now.plusHours(8).format(formatter), 
                               "PENDING_MANAGER", now.minusHours(3).format(formatter));
        p7.setPreChecklist(getChecklistForWorkType(p7.getWorkType()));
        p7.setPpe(getPpeForWorkType(p7.getWorkType()));
        p7.setSupervisor("Amit Sharma");
        p7.setSupervisorComment("Gas purging done. Safety valves closed.");
        p7.setSafetyOfficer("Vikram Singh");
        p7.setSafetyOfficerComment("Gas detector active and double checked. Fire hose charged.");
        p7.addLog(new ActivityLog(now.minusHours(3).format(formatter), "Permit Created", "Vijay Yadav (Worker)", "Urgent cutting."));
        p7.addLog(new ActivityLog(now.minusHours(2).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Purged."));
        p7.addLog(new ActivityLog(now.minusHours(1).format(formatter), "Verified by Safety Officer", "Vikram Singh (Safety Officer)", "Gas sniff ok, water line ready."));
        permits.add(p7);

        // 8. Rejected Permit
        Permit p8 = new Permit("PTW-1008", "Confined Space Entry", "Rolling Mill", "High", 
                               "Anil Deshmukh", "Sump tank pump inspection", 
                               now.minusHours(6).format(formatter), now.minusHours(2).format(formatter), 
                               "REJECTED", now.minusHours(8).format(formatter));
        p8.setPreChecklist(getChecklistForWorkType(p8.getWorkType()));
        p8.setPpe(getPpeForWorkType(p8.getWorkType()));
        p8.setSupervisor("Amit Sharma");
        p8.setSupervisorComment("Rejecting due to heavy rain forecast causing sump flooding risk.");
        p8.addLog(new ActivityLog(now.minusHours(8).format(formatter), "Permit Created", "Anil Deshmukh (Worker)", "Sump pump inspection."));
        p8.addLog(new ActivityLog(now.minusHours(7).format(formatter), "Rejected by Supervisor", "Amit Sharma (Supervisor)", "Rejecting due to heavy rain forecast causing sump flooding risk."));
        permits.add(p8);

        // 9. Modification Required
        Permit p9 = new Permit("PTW-1009", "Work at Heights", "Power Plant", "High", 
                               "Suresh Patil", "Soot blower platform repairs", 
                               now.plusDays(1).format(formatter), now.plusDays(1).plusHours(8).format(formatter), 
                               "MODIFICATION_REQUIRED", now.minusHours(4).format(formatter));
        p9.setPreChecklist(getChecklistForWorkType(p9.getWorkType()));
        p9.setPpe(getPpeForWorkType(p9.getWorkType()));
        p9.setSupervisor("Amit Sharma");
        p9.setSupervisorComment("Approve, but needs scaffolding tag update.");
        p9.setSafetyOfficer("Vikram Singh");
        p9.setSafetyOfficerComment("Current scaffold tags are expired. Re-inspect scaffold and submit new certificate before approval.");
        p9.addLog(new ActivityLog(now.minusHours(4).format(formatter), "Permit Created", "Suresh Patil (Worker)", "Repair blower platform."));
        p9.addLog(new ActivityLog(now.minusHours(3).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Approved with condition."));
        p9.addLog(new ActivityLog(now.minusHours(2).format(formatter), "Modification Requested", "Vikram Singh (Safety Officer)", "Current scaffold tags are expired. Re-inspect scaffold and submit new certificate."));
        permits.add(p9);

        // 10. Approved Permit #2 (Ready to Start)
        Permit p10 = new Permit("PTW-1010", "Electrical Maintenance", "Blast Furnace 1", "Medium", 
                                "Rajesh Kumar", "Replacement of thermocouple sensor at slag runner", 
                                now.plusHours(1).format(formatter), now.plusHours(5).format(formatter), 
                                "APPROVED", now.minusHours(3).format(formatter));
        p10.setPreChecklist(getChecklistForWorkType(p10.getWorkType()));
        p10.setPpe(getPpeForWorkType(p10.getWorkType()));
        p10.setSupervisor("Amit Sharma");
        p10.setSupervisorComment("Thermocouple disconnected from power board 4.");
        p10.setSafetyOfficer("Vikram Singh");
        p10.setSafetyOfficerComment("Thermal shield PPE ready.");
        p10.addLog(new ActivityLog(now.minusHours(3).format(formatter), "Permit Created", "Rajesh Kumar (Worker)", "Slag thermocouple replacement."));
        p10.addLog(new ActivityLog(now.minusHours(2).format(formatter), "Approved by Supervisor", "Amit Sharma (Supervisor)", "Power isolated."));
        p10.addLog(new ActivityLog(now.minusHours(1).format(formatter), "Verified by Safety Officer", "Vikram Singh (Safety Officer)", "Safety wear check."));
        permits.add(p10);

        return permits;
    }
}
