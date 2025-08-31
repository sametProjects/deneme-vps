# 1. Build aşaması
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --frozen-lockfile

COPY . .
RUN npm run build

# 2. Production aşaması
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# sadece gerekli dosyaları kopyala
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]