# Use the official Tomcat 10 image with Java 17
FROM tomcat:10.1.14-jdk17

# Remove the default Tomcat webapps to keep it clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the Maven target directory to Tomcat's webapps directory
# Renaming it to ROOT.war ensures it serves on the root path (/) instead of (/digital-ptw-system)
COPY target/digital-ptw-system.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start the Tomcat server
CMD ["catalina.sh", "run"]
