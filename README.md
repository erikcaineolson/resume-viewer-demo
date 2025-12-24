# Resume Viewer Demo

An intentionally over-engineered resume viewer demonstrating a full-stack architecture with multiple technologies working together.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ resume.xml  │────▶│   Python    │────▶│ PostgreSQL  │
│             │     │  Importer   │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
              ┌───────────┐ ┌───────────┐
              │  PHP API  │ │  Laravel  │
              └───────────┘ └───────────┘
                    │             │
                    ▼             ▼
              ┌───────────┐ ┌───────────┐
              │   React   │ │    Vue    │
              └───────────┘ └───────────┘
```

## Technologies

- **Database**: PostgreSQL with JSONB, GIN indexes, full-text search
- **Python**: XML parsing, database import, PDF generation (ReportLab), FastAPI
- **PHP**: Functional REST API with immutable DTOs
- **Laravel**: Eloquent models, API gateway
- **Vue 3**: Composition API, Pinia store
- **React 18**: Hooks, functional components
- **Docker**: Multi-stage builds, Docker Compose orchestration

## Quick Start

1. Copy the example resume and add your data:
   ```bash
   cp resume.example.xml resume.xml
   # Edit resume.xml with your information
   ```

2. Start all services:
   ```bash
   docker-compose up -d
   ```

3. Access the application:
   - Vue UI: http://localhost:8080
   - React UI: http://localhost:8080/react
   - PHP API: http://localhost:8080/api
   - Laravel: http://localhost:8001/api
   - PDF Service: http://localhost:8000/api/resume.pdf

## Resume XML Format

See `resume.example.xml` for the full schema. Basic structure:

```xml
<resume>
  <profile>
    <name>Your Name</name>
    <title>Your Title</title>
    <email>you@example.com</email>
    <summary>Brief professional summary...</summary>
    <links>
      <link type="linkedin">https://linkedin.com/in/you</link>
      <link type="github">https://github.com/you</link>
    </links>
  </profile>

  <experiences>
    <experience>
      <company>Company Name</company>
      <title>Job Title</title>
      <startDate>2022-01</startDate>
      <!-- omit endDate for current position -->
      <description>
        <summary>Role overview...</summary>
        <accomplishment>Key achievement 1</accomplishment>
        <accomplishment>Key achievement 2</accomplishment>
      </description>
      <skills>
        <skill>PHP</skill>
        <skill>Laravel</skill>
      </skills>
    </experience>
  </experiences>

  <skills>
    <skill category="language" proficiency="5">PHP</skill>
    <skill category="framework" proficiency="4">Laravel</skill>
  </skills>
</resume>
```

## Project Structure

```
.
├── api/                    # Functional PHP REST API
│   ├── public/index.php
│   └── src/
├── frontend/
│   ├── vue/               # Vue 3 + Pinia
│   └── react/             # React 18 + Hooks
├── importer/              # Python XML parser + PDF service
├── laravel/               # Laravel API gateway
├── nginx/                 # Nginx config
├── schema/                # SQL schemas
│   ├── mysql.sql
│   └── postgresql.sql
├── docker-compose.yml
├── Dockerfile
├── resume.xml             # Your resume (gitignored)
└── resume.example.xml     # Template
```

## API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /api/profile` | Profile/contact info |
| `GET /api/experiences` | Work history with skills |
| `GET /api/skills` | All skills by category |
| `GET /api/resume.pdf` | Download PDF resume |

## Development

Run individual services for development:

```bash
# Python PDF service
cd importer && uvicorn main:app --reload

# PHP API (requires PHP 8.3+)
php -S localhost:8000 -t api/public

# Vue frontend
cd frontend/vue && npm run dev

# React frontend
cd frontend/react && npm run dev
```

## License

MIT
