<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Experience extends Model
{
    protected $fillable = [
        'company',
        'title',
        'start_date',
        'end_date',
        'summary',
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
    ];

    protected $appends = ['is_current', 'duration_months'];

    public function skills(): BelongsToMany
    {
        return $this->belongsToMany(Skill::class, 'experience_skills');
    }

    public function accomplishments(): HasMany
    {
        return $this->hasMany(ExperienceAccomplishment::class)->orderBy('sort_order');
    }

    protected function isCurrent(): Attribute
    {
        return Attribute::get(fn () => $this->end_date === null);
    }

    protected function durationMonths(): Attribute
    {
        return Attribute::get(
            fn () => $this->start_date->diffInMonths($this->end_date ?? now())
        );
    }
}
