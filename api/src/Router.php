<?php

declare(strict_types=1);

namespace App\Api;

/**
 * Simple functional router.
 */
readonly class Router
{
    public function __construct(
        private ResumeRepository $repository,
    ) {}

    public function handle(string $method, string $path): string
    {
        return match ([$method, $path]) {
            ['GET', '/api/profile'] => $this->jsonResponse($this->repository->getProfile()),
            ['GET', '/api/experiences'] => $this->jsonResponse($this->repository->getExperiences()->toArray()),
            ['GET', '/api/skills'] => $this->jsonResponse($this->repository->getSkills()->toArray()),
            default => $this->notFound(),
        };
    }

    private function jsonResponse(mixed $data): string
    {
        return json_encode($data, JSON_THROW_ON_ERROR | JSON_PRETTY_PRINT);
    }

    private function notFound(): string
    {
        http_response_code(404);
        return json_encode(['error' => 'Not Found']);
    }
}
