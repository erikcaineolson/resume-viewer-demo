"""
PDF Resume Generator using ReportLab.
"""
from io import BytesIO

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer

from .models import Resume


def generate_pdf(resume: Resume) -> BytesIO:
    """Generate a PDF resume from Resume data."""
    buffer = BytesIO()
    doc = SimpleDocTemplate(
        buffer,
        pagesize=letter,
        topMargin=50,
        bottomMargin=50,
        leftMargin=60,
        rightMargin=60,
    )
    styles = getSampleStyleSheet()

    # Custom styles (prefixed to avoid conflicts with default stylesheet)
    styles.add(ParagraphStyle(
        'ResumeName',
        fontSize=24,
        leading=28,
        spaceAfter=4,
        textColor=colors.HexColor('#1a1a2e')
    ))
    styles.add(ParagraphStyle(
        'ResumeSubtitle',
        fontSize=14,
        leading=18,
        spaceAfter=8,
        textColor=colors.HexColor('#4a4a6a')
    ))
    styles.add(ParagraphStyle(
        'ResumeSection',
        fontSize=12,
        spaceBefore=16,
        spaceAfter=8,
        textColor=colors.HexColor('#1a1a2e'),
        fontName='Helvetica-Bold'
    ))
    styles.add(ParagraphStyle(
        'ResumeJob',
        fontSize=11,
        spaceBefore=8,
        spaceAfter=4,
        textColor=colors.HexColor('#1a1a2e'),
    ))
    styles.add(ParagraphStyle(
        'ResumeBullet',
        fontSize=10,
        leftIndent=20,
        spaceAfter=2,
    ))

    story = []

    # Header
    story.append(Paragraph(resume.profile.name, styles['ResumeName']))
    story.append(Paragraph(resume.profile.title, styles['ResumeSubtitle']))

    # Contact line
    contact_parts = [resume.profile.email]
    if resume.profile.phone:
        contact_parts.append(resume.profile.phone)
    if resume.profile.location:
        contact_parts.append(resume.profile.location)
    story.append(Paragraph(' | '.join(contact_parts), styles['Normal']))

    # Links
    links = []
    if resume.profile.linkedin:
        links.append(f'<a href="{resume.profile.linkedin}">LinkedIn</a>')
    if resume.profile.github:
        links.append(f'<a href="{resume.profile.github}">GitHub</a>')
    if resume.profile.website:
        links.append(f'<a href="{resume.profile.website}">Website</a>')
    if links:
        story.append(Paragraph(' | '.join(links), styles['Normal']))

    story.append(Spacer(1, 20))

    # Summary
    if resume.profile.summary:
        story.append(Paragraph("Summary", styles['ResumeSection']))
        story.append(Paragraph(resume.profile.summary.strip(), styles['Normal']))

    # Experience
    story.append(Paragraph("Experience", styles['ResumeSection']))
    for exp in resume.experiences:
        end = exp.end_date.strftime('%b %Y') if exp.end_date else 'Present'
        start = exp.start_date.strftime('%b %Y')
        story.append(Paragraph(
            f"<b>{exp.title}</b> at {exp.company}",
            styles['ResumeJob']
        ))
        story.append(Paragraph(
            f"<i>{start} - {end}</i>",
            styles['Normal']
        ))
        if exp.summary:
            story.append(Paragraph(exp.summary, styles['Normal']))
        for accomplishment in exp.accomplishments:
            story.append(Paragraph(f"* {accomplishment}", styles['ResumeBullet']))
        story.append(Spacer(1, 8))

    # Skills
    story.append(Paragraph("Skills", styles['ResumeSection']))
    by_category: dict[str, list[str]] = {}
    for skill in resume.skills:
        by_category.setdefault(skill.category, []).append(skill.name)
    for cat, names in by_category.items():
        story.append(Paragraph(
            f"<b>{cat.title()}:</b> {', '.join(names)}",
            styles['Normal']
        ))

    doc.build(story)
    buffer.seek(0)
    return buffer
