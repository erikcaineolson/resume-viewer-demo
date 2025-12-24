<?php

declare(strict_types=1);

namespace App\Api;

/**
 * Immutable DTO for Profile data.
 */
readonly class ProfileDTO implements \JsonSerializable
{
    public function __construct(
        public string $name,
        public string $title,
        public string $email,
        public ?string $phone,
        public ?string $location,
        public ?string $summary,
        public ?string $linkedinUrl,
        public ?string $githubUrl,
        public ?string $websiteUrl,
    ) {}

    /**
     * Create a ProfileDTO from a database row.
     *
     * @param array<string, mixed> $row
     */
    public static function fromRow(array $row): self
    {
        $links = [];
        if (isset($row['links']) && is_string($row['links'])) {
            $links = json_decode($row['links'], true) ?? [];
        }

        return new self(
            name: $row['name'],
            title: $row['title'],
            email: $row['email'],
            phone: $row['phone'] ?? null,
            location: $row['location'] ?? null,
            summary: $row['summary'] ?? null,
            linkedinUrl: $links['linkedin'] ?? $row['linkedin_url'] ?? null,
            githubUrl: $links['github'] ?? $row['github_url'] ?? null,
            websiteUrl: $links['website'] ?? $row['website_url'] ?? null,
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
