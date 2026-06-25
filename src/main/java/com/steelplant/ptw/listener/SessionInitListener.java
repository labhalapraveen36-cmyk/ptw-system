package com.steelplant.ptw.listener;

import com.steelplant.ptw.model.Permit;
import com.steelplant.ptw.util.MockData;

import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SessionInitListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Seed permits database into the session
        List<Permit> permits = MockData.generateSeedPermits();
        se.getSession().setAttribute("permits", permits);

        se.getSession().setAttribute("theme", "dark"); // Premium dark theme by default

        // Initialize simulated SMS/Email alert registry
        List<Map<String, String>> notifications = new ArrayList<>();
        
        // Add some seed notifications
        addMockNotification(notifications, "SMS", "Safety Officer", 
            "[PTW-ALERT] Permit PTW-1007 (Hot Work at Blast Furnace 1) requires Safety Verification.");
        addMockNotification(notifications, "Email", "Manager", 
            "Subject: PTW-1007 Authorization Request\n\nDear Manager,\nPermit PTW-1007 for Cutting pipes at Blast Furnace 1 requires your authorization.");
        addMockNotification(notifications, "System", "Worker", 
            "Permit PTW-1003 (Confined Space) has been started by Anil Deshmukh.");
        
        se.getSession().setAttribute("notifications", notifications);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // Clean up if needed
    }

    private void addMockNotification(List<Map<String, String>> list, String type, String recipient, String content) {
        Map<String, String> notif = new HashMap<>();
        notif.put("id", String.valueOf(System.currentTimeMillis() + list.size()));
        notif.put("timestamp", java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss")));
        notif.put("type", type);
        notif.put("recipient", recipient);
        notif.put("content", content);
        list.add(0, notif); // Newest first
    }
}
