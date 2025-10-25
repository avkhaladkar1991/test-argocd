# Use official Node.js Alpine image
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json from project root
COPY ../package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY ../ ./

# Expose app port (adjust if different)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
