-- Resume Database Schema
-- PostgreSQL 14+

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    location VARCHAR(255),
    summary TEXT,
    links JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_profiles_links ON profiles USING GIN(links);

CREATE TYPE skill_category AS ENUM (
    'language', 'framework', 'tool', 'platform', 'methodology'
);

CREATE TABLE skills (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category skill_category NOT NULL,
    proficiency_level SMALLINT NOT NULL DEFAULT 3
        CHECK (proficiency_level BETWEEN 1 AND 5),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE experiences (
    id SERIAL PRIMARY KEY,
    company VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    summary TEXT,
    is_current BOOLEAN GENERATED ALWAYS AS (end_date IS NULL) STORED,
    search_vector tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', company), 'A') ||
        setweight(to_tsvector('english', title), 'B') ||
        setweight(to_tsvector('english', COALESCE(summary, '')), 'C')
    ) STORED,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_experiences_search ON experiences USING GIN(search_vector);

CREATE TABLE experience_accomplishments (
    id SERIAL PRIMARY KEY,
    experience_id INT REFERENCES experiences(id) ON DELETE CASCADE,
    accomplishment TEXT NOT NULL,
    sort_order SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE experience_skills (
    experience_id INT REFERENCES experiences(id) ON DELETE CASCADE,
    skill_id INT REFERENCES skills(id) ON DELETE CASCADE,
    PRIMARY KEY (experience_id, skill_id)
);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER skills_updated_at BEFORE UPDATE ON skills
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER experiences_updated_at BEFORE UPDATE ON experiences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
