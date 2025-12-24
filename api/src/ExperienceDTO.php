<?php

declare(strict_types=1);

namespace App\Api;

/**
 * Immutable DTO for Experience data.
 */
readonly class ExperienceDTO implements \JsonSerializable
{
    /**
     * @param array<string> $accomplishments
     * @param array<SkillDTO> $skills
     */
    public function __construct(
        public int $id,
        public string $company,
        public string $title,
        public string $startDate,
        public ?string $endDate,
        public ?string $summary,
        public bool $isCurrent,
        public array $accomplishments = [],
        public array $skills = [],
    ) {}

    /**
     * Create an ExperienceDTO from a database row.
     *
     * @param array<string, mixed> $row
     * @param array<string> $accomplishments
     * @param array<SkillDTO> $skills
     */
    public static function fromRow(
        array $row,
        array $accomplishments = [],
        array $skills = []
    ): self {
        return new self(
            id: (int) $row['id'],
            company: $row['company'],
            title: $row['title'],
            startDate: $row['start_date'],
            endDate: $row['end_date'],
            summary: $row['summary'] ?? null,
            isCurrent: (bool) $row['is_current'],
            accomplishments: $accomplishments,
            skills: $skills,
        );
    }

    /**
     * @return array<string, mixed>
     */
    public function jsonSerialize(): array
    {
        return get_object_vars($this);
    }
}
