# Etapa 1: Build React
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build

# Etapa 2: Serve static files
FROM nginx:alpine

# Copiază build-ul în nginx public folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiază config implicit (opțional, doar dacă ai nevoie de routing pentru SPA)
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
