# Use an official Node.js image based on Alpine Linux for a lightweight image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the rest of the application source code
COPY . .

# Install pnpm globally and then install app dependencies
RUN npm install -g pnpm && pnpm i

# Install net-tools and alias findstr to grep to support port detection
RUN apk add --no-cache net-tools && ln -s /bin/grep /usr/local/bin/findstr

# Expose port 3000 (used by both next dev and make-agent)
EXPOSE 3000 3001

# Start the development environment (which runs concurrently next dev and make-agent)
CMD ["pnpm", "dev"]
