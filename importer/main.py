"""
FastAPI application for Resume PDF generation and data API.
"""
import os
from pathlib import Path

from fastapi import FastAPI, Response
from fastapi.middleware.cors import CORSMiddleware

from .database import import_resume
from .parser import parse_resume_xml
from .pdf import generate_pdf

app = FastAPI(
    title="Resume Viewer API",
    description="PDF generation and resume data API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

RESUME_PATH = Path(os.getenv('RESUME_PATH', 'resume.xml'))


def get_resume():
    """Load and parse the resume XML."""
    return parse_resume_xml(RESUME_PATH)


@app.get("/api/resume.pdf")
async def download_pdf():
    """Generate and download resume as PDF."""
    resume = get_resume()
    pdf = generate_pdf(resume)
    return Response(
        content=pdf.read(),
        media_type="application/pdf",
        headers={"Content-Disposition": "attachment; filename=resume.pdf"}
    )


@app.get("/api/profile")
async def get_profile():
    """Get profile/contact information."""
    resume = get_resume()
    return {
        "name": resume.profile.name,
        "title": resume.profile.title,
        "email": resume.profile.email,
        "phone": resume.profile.phone,
        "location": resume.profile.location,
        "summary": resume.profile.summary,
        "linkedin": resume.profile.linkedin,
        "github": resume.profile.github,
        "website": resume.profile.website,
    }


@app.get("/api/experiences")
async def get_experiences():
    """Get all experiences."""
    resume = get_resume()
    return [
        {
            "id": i + 1,
            "company": exp.company,
            "title": exp.title,
            "startDate": exp.start_date.isoformat(),
            "endDate": exp.end_date.isoformat() if exp.end_date else None,
            "summary": exp.summary,
            "accomplishments": exp.accomplishments,
            "skills": exp.skills,
            "isCurrent": exp.end_date is None,
        }
        for i, exp in enumerate(resume.experiences)
    ]


@app.get("/api/skills")
async def get_skills():
    """Get all skills."""
    resume = get_resume()
    return [
        {
            "id": i + 1,
            "name": skill.name,
            "category": skill.category,
            "proficiency": skill.proficiency,
        }
        for i, skill in enumerate(resume.skills)
    ]


@app.post("/api/import")
async def import_to_database():
    """Import resume data into the database."""
    resume = get_resume()
    await import_resume(resume)
    return {"status": "ok", "message": "Resume imported successfully"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
