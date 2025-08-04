# 1. Imagine de bază cu Node.js pentru build
FROM node:20 AS builder

# 2. Setează directorul de lucru
WORKDIR /app

# 3. Copiază fișierele în container
COPY package*.json ./
COPY vite.config.* ./
COPY . .

# 4. Instalează dependențele
RUN npm install

# 5. Rulează build-ul pentru producție
RUN npm run build

# ----------------------------

# 6. Imagine finală pentru serve static
FROM node:20 AS runner

# 7. Instalăm serverul care va servi conținutul
RUN npm install -g serve

# 8. Directorul de lucru final
WORKDIR /app

# 9. Copiem doar build-ul final
COPY --from=builder /app/dist ./dist

# 10. Expunem portul 80
EXPOSE 80

# 11. Comanda de start
CMD ["serve", "-s", "dist", "-l", "80"]
