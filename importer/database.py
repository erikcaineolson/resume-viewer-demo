"""
Database operations for importing resume data.
"""
import os
from contextlib import asynccontextmanager
from typing import AsyncGenerator

import asyncpg

from .models import Resume

DATABASE_URL = os.getenv(
    'DATABASE_URL',
    'postgresql://resume_user:resume_pass@localhost:5432/resume'
)


async def get_connection() -> asyncpg.Connection:
    """Get a database connection."""
    return await asyncpg.connect(DATABASE_URL)


@asynccontextmanager
async def transaction() -> AsyncGenerator[asyncpg.Connection, None]:
    """Context manager for database transactions."""
    conn = await get_connection()
    try:
        async with conn.transaction():
            yield conn
    finally:
        await conn.close()


async def import_resume(resume: Resume) -> None:
    """Import a Resume into the database."""
    async with transaction() as conn:
        # Clear existing data
        await conn.execute('DELETE FROM experience_skills')
        await conn.execute('DELETE FROM experience_accomplishments')
        await conn.execute('DELETE FROM experiences')
        await conn.execute('DELETE FROM skills')
        await conn.execute('DELETE FROM profiles')

        # Insert profile
        links = {}
        if resume.profile.linkedin:
            links['linkedin'] = resume.profile.linkedin
        if resume.profile.github:
            links['github'] = resume.profile.github
        if resume.profile.website:
            links['website'] = resume.profile.website

        await conn.execute('''
            INSERT INTO profiles (name, title, email, phone, location, summary, links)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
        ''', resume.profile.name, resume.profile.title, resume.profile.email,
            resume.profile.phone, resume.profile.location, resume.profile.summary,
            links)

        # Insert skills
        skill_ids = {}
        for skill in resume.skills:
            skill_id = await conn.fetchval('''
                INSERT INTO skills (name, category, proficiency_level)
                VALUES ($1, $2::skill_category, $3)
                ON CONFLICT (name) DO UPDATE SET proficiency_level = $3
                RETURNING id
            ''', skill.name, skill.category, skill.proficiency)
            skill_ids[skill.name] = skill_id

        # Insert experiences
        for exp in resume.experiences:
            exp_id = await conn.fetchval('''
                INSERT INTO experiences (company, title, start_date, end_date, summary)
                VALUES ($1, $2, $3, $4, $5)
                RETURNING id
            ''', exp.company, exp.title, exp.start_date, exp.end_date, exp.summary)

            # Insert accomplishments
            for i, accomplishment in enumerate(exp.accomplishments):
                await conn.execute('''
                    INSERT INTO experience_accomplishments (experience_id, accomplishment, sort_order)
                    VALUES ($1, $2, $3)
                ''', exp_id, accomplishment, i)

            # Link skills
            for skill_name in exp.skills:
                if skill_name in skill_ids:
                    await conn.execute('''
                        INSERT INTO experience_skills (experience_id, skill_id)
                        VALUES ($1, $2)
                        ON CONFLICT DO NOTHING
                    ''', exp_id, skill_ids[skill_name])
