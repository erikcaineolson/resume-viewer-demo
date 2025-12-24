<?php

declare(strict_types=1);

namespace App\Api;

use PDO;

/**
 * Repository using functional composition.
 */
readonly class ResumeRepository
{
    public function __construct(
        private PDO $pdo,
    ) {}

    public function getProfile(): ?ProfileDTO
    {
        $stmt = $this->pdo->query('SELECT * FROM profiles LIMIT 1');
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ? ProfileDTO::fromRow($row) : null;
    }

    /**
     * @return Collection<ExperienceDTO>
     */
    public function getExperiences(): Collection
    {
        $stmt = $this->pdo->query(
            'SELECT * FROM experiences ORDER BY start_date DESC'
        );
        $experiences = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return Collection::from($experiences)->map(function (array $row): ExperienceDTO {
            $accomplishments = $this->getAccomplishments((int) $row['id']);
            $skills = $this->getExperienceSkills((int) $row['id']);
            return ExperienceDTO::fromRow($row, $accomplishments, $skills);
        });
    }

    /**
     * @return array<string>
     */
    private function getAccomplishments(int $experienceId): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT accomplishment FROM experience_accomplishments
             WHERE experience_id = ? ORDER BY sort_order'
        );
        $stmt->execute([$experienceId]);
        return array_column($stmt->fetchAll(PDO::FETCH_ASSOC), 'accomplishment');
    }

    /**
     * @return array<SkillDTO>
     */
    private function getExperienceSkills(int $experienceId): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT s.* FROM skills s
             JOIN experience_skills es ON es.skill_id = s.id
             WHERE es.experience_id = ?'
        );
        $stmt->execute([$experienceId]);
        return array_map(
            fn(array $row) => SkillDTO::fromRow($row),
            $stmt->fetchAll(PDO::FETCH_ASSOC)
        );
    }

    /**
     * @return Collection<SkillDTO>
     */
    public function getSkills(): Collection
    {
        $stmt = $this->pdo->query(
            'SELECT * FROM skills ORDER BY category, proficiency_level DESC'
        );
        return Collection::from($stmt->fetchAll(PDO::FETCH_ASSOC))
            ->map(fn(array $row) => SkillDTO::fromRow($row));
    }
}
