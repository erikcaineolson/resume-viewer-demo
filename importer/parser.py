"""
XML Resume Parser - Parses resume.xml into typed dataclasses.
"""
from datetime import date
from pathlib import Path
from xml.etree import ElementTree as ET

from .models import Experience, Profile, Resume, Skill


def parse_resume_xml(path: Path) -> Resume:
    """Parse resume.xml into typed dataclasses."""
    tree = ET.parse(path)
    root = tree.getroot()

    # Parse profile
    p = root.find('profile')
    if p is None:
        raise ValueError("Missing <profile> element in resume.xml")

    links = {
        link.get('type'): link.text
        for link in p.findall('links/link')
    }

    profile = Profile(
        name=p.findtext('name', ''),
        title=p.findtext('title', ''),
        email=p.findtext('email', ''),
        phone=p.findtext('phone'),
        location=p.findtext('location'),
        summary=p.findtext('summary'),
        linkedin=links.get('linkedin'),
        github=links.get('github'),
        website=links.get('website'),
    )

    # Parse experiences
    experiences = []
    for exp in root.findall('.//experiences/experience'):
        end_date_str = exp.findtext('endDate')
        experiences.append(Experience(
            company=exp.findtext('company', ''),
            title=exp.findtext('title', ''),
            start_date=date.fromisoformat(exp.findtext('startDate', '')),
            end_date=date.fromisoformat(end_date_str) if end_date_str else None,
            summary=exp.findtext('description/summary'),
            accomplishments=[
                a.text or ''
                for a in exp.findall('description/accomplishment')
            ],
            skills=[s.text or '' for s in exp.findall('skills/skill')],
        ))

    # Parse skills
    skills = [
        Skill(
            name=s.text or '',
            category=s.get('category', 'tool'),
            proficiency=int(s.get('proficiency', '3'))
        )
        for s in root.findall('.//skills/skill')
        if s.get('category')  # Only top-level skills have category attribute
    ]

    return Resume(profile=profile, experiences=experiences, skills=skills)
