FROM node:20-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY *.js ./

FROM node:20-slim
WORKDIR /app
RUN apt-get update && apt-get upgrade -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
RUN useradd --system --no-create-home appuser
COPY --from=build /app /app
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 3000
CMD ["node","servidor.js"]
