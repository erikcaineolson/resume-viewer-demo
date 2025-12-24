"""
Data models for Resume parsing.
"""
from dataclasses import dataclass, field
from datetime import date
from typing import Optional


@dataclass
class Profile:
    name: str
    title: str
    email: str
    phone: Optional[str] = None
    location: Optional[str] = None
    summary: Optional[str] = None
    linkedin: Optional[str] = None
    github: Optional[str] = None
    website: Optional[str] = None


@dataclass
class Experience:
    company: str
    title: str
    start_date: date
    end_date: Optional[date]
    summary: Optional[str]
    accomplishments: list[str] = field(default_factory=list)
    skills: list[str] = field(default_factory=list)


@dataclass
class Skill:
    name: str
    category: str
    proficiency: int = 3


@dataclass
class Resume:
    profile: Profile
    experiences: list[Experience] = field(default_factory=list)
    skills: list[Skill] = field(default_factory=list)
