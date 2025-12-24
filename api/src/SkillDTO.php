<?php

declare(strict_types=1);

namespace App\Api;

/**
 * Immutable DTO for Skill data.
 */
readonly class SkillDTO implements \JsonSerializable
{
    public function __construct(
        public int $id,
        public string $name,
        public string $category,
        public int $proficiency,
    ) {}

    /**
     * Create a SkillDTO from a database row.
     *
     * @param array<string, mixed> $row
     */
    public static function fromRow(array $row): self
    {
        return new self(
            id: (int) $row['id'],
            name: $row['name'],
            category: $row['category'],
            proficiency: (int) $row['proficiency_level'],
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
