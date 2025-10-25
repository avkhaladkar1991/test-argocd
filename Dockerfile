# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY ../app/package*.json ./
RUN npm install
COPY ../app .
RUN npm run build || echo "No build step for now"

# Runtime stage
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app .
EXPOSE 8080
CMD ["node", "server.js"]
