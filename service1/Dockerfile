# Use the official Node.js image as the base image
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code to the container
COPY . .

# Expose the port the application listens on
EXPOSE 3000

# Command to run the application
CMD [ "node", "index.js" ]
