FROM node:20-alpine

WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Optional build step if needed
RUN npm run build || echo "No build step"

# Expose port and set start command
EXPOSE 3000
CMD ["npm", "start"]
