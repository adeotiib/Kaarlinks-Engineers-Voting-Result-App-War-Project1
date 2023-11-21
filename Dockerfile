# Stage 1: Build Stage
FROM ubuntu:latest as builder

# Set the working directory
WORKDIR /app

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install build dependencies
RUN apt-get install -y wget unzip openjdk-17-jdk git maven

# Clone the repository
RUN git clone https://github.com/JendareyTechnologies/Jendarey-Engineers-Voting-Result-App-War-Project1.git

# Navigate to the project directory
WORKDIR /app/Jendarey-Engineers-Voting-Result-App-War-Project1

# Build the application war file using Maven
RUN mvn clean install

# Stage 2: Runtime Stage
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Copy artifacts from the build stage
COPY --from=builder /app/Jendarey-Engineers-Voting-Result-App-War-Project1/target/votingappweb.war /app/

# Install runtime dependencies
RUN apt-get update && apt-get install -y wget unzip openjdk-17-jdk

# Download and unzip Tomcat
ARG TOMCAT_VERSION="10.1.14"
ARG TOMCAT_DIR="apache-tomcat-$TOMCAT_VERSION"
RUN wget "https://dlcdn.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/$TOMCAT_DIR.zip" && \
    unzip "$TOMCAT_DIR.zip" && \
    rm -rf "$TOMCAT_DIR.zip" && \
    mv "$TOMCAT_DIR" tomcat10

# Set permissions and ownership
RUN chmod 755 -R tomcat10 && \
    useradd -r -u 1001 -m -d /app -s /sbin/nologin -c "Tomcat User" tomcat && \
    chown -R tomcat:tomcat tomcat10

# Move the application war file to Tomcat's webapps directory
RUN cp votingappweb.war tomcat10/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Switch to the 'tomcat' user
USER tomcat

# Start Tomcat
CMD ["./tomcat10/bin/startup.sh"]



# docker build . -t jendaredocker/jendarey-voting-app-new
# docker run -d -p 10000:8080 --name=voting-app-one jendaredocker/jendarey-voting-app-new:latest

# Please you use tomcat 10.1.13
# download tomcat 10.1.13-jdk17
# copy the .war file to the `webapps` directory in tomcat:10.1.13-jdk17
# cp target/a23-webpage.war tomcat:10.1.13-jdk17:/usr/local/tomcat/webapps/
# Start the Tomcat container




# docker-compose up
# docker exec -it ac7 bash 
# ls /usr/local/tomcat/logs
# cat /usr/local/tomcat/logs
# docker logs jendarey-tech-mongo-1

# docker run -d -p 10000:8080 --name=voting-app4 jendaredocker/jendarey-voting-app-one:latest

# docker pull 10.1.13-jdk17
# Copy the .war file to the `webapps` directory
# docker cp target/a23-webpage.war tomcat:10.1.13-jdk17:/usr/local/tomcat/webapps/
# Start the Tomcat container
# docker run -it -p 8080:8080 tomcat:10.1.13-jdk17
# docker compose up
# docker exec -it ac7 bash 
# /usr/local/tomcat/logs#
# docker logs jendarey-tech-mongo-1
