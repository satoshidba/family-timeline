# Stage 1: Build the React application
FROM node:22-alpine AS build-stage
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./
# COPY yarn.lock ./ # Uncomment if using Yarn

# Install dependencies
RUN npm install
# RUN yarn install # Uncomment if using Yarn

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the application using a lightweight web server (Nginx)
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# Remove default Nginx static assets
RUN rm -rf ./*

# Copy static assets from the build stage
COPY --from=build-stage /app/build .

# Nginx configuration for Single Page Applications (SPA)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
