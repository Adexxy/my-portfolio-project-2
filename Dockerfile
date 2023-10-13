# Use the official Node.js image as the base image
FROM node:lts-alpine3.18

# Set the working directory inside the container
WORKDIR /app

# Copy the artifact into the container
COPY commerce-app.tar.gz .

# Extract the artifact
RUN tar -xzvf commerce-app.tar.gz

# Set the working directory to the extracted artifact
WORKDIR /app/build

# Expose the port your Node.js application will run on
EXPOSE 3000

# Run the Node.js application
CMD ["npm", "start"]
