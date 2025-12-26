# Resume Viewer - Multi-stage Dockerfile
# Includes Python PDF service with ReportLab

# ============================================
# Stage 1: Python PDF Service & Importer
# ============================================
FROM python:3.12-slim AS python-service

WORKDIR /app

# Install system deps for PDF generation
RUN apt-get update && apt-get install -y --no-install-recommends \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY importer/ ./importer/
COPY resume.xml .

ENV PYTHONUNBUFFERED=1

# Run FastAPI PDF service
CMD ["uvicorn", "importer.main:app", "--host", "0.0.0.0", "--port", "8000"]


# ============================================
# Stage 2: Frontend Build (Vue)
# ============================================
FROM node:20-alpine AS vue-builder

WORKDIR /app
COPY frontend/vue/package*.json ./
RUN npm ci --frozen-lockfile

COPY frontend/vue/ ./
RUN npm run build


# ============================================
# Stage 3: Frontend Build (React)
# ============================================
FROM node:20-alpine AS react-builder

WORKDIR /app
COPY frontend/react/package*.json ./
RUN npm ci --frozen-lockfile

COPY frontend/react/ ./
RUN npm run build


# ============================================
# Stage 4: PHP API Runtime
# ============================================
FROM php:8.3-fpm-alpine AS php-api

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql opcache

WORKDIR /var/www/html
COPY api/ ./api/
COPY --from=vue-builder /app/dist ./public/vue/
COPY --from=react-builder /app/dist ./public/react/

RUN chown -R www-data:www-data /var/www/html
USER www-data

EXPOSE 9000
CMD ["php-fpm"]


# ============================================
# Stage 5: Nginx
# ============================================
FROM nginx:alpine AS nginx

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=php-api /var/www/html/public /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# ============================================
# Stage 6: Rails Admin Dashboard
# ============================================
FROM ruby:3.3-slim AS rails-admin

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install gems
COPY rails-admin/Gemfile ./
RUN bundle config set --local without 'development test' && \
    bundle install

# Copy application
COPY rails-admin/ ./

# Precompile assets
RUN SECRET_KEY_BASE=dummy bundle exec rake assets:precompile 2>/dev/null || true

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
