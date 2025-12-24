<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Profile extends Model
{
    protected $fillable = [
        'name',
        'title',
        'email',
        'phone',
        'location',
        'summary',
        'links',
    ];

    protected $casts = [
        'links' => 'array',
    ];

    public function getLinkedinUrlAttribute(): ?string
    {
        return $this->links['linkedin'] ?? null;
    }

    public function getGithubUrlAttribute(): ?string
    {
        return $this->links['github'] ?? null;
    }

    public function getWebsiteUrlAttribute(): ?string
    {
        return $this->links['website'] ?? null;
    }
}
