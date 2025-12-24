<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ExperienceAccomplishment extends Model
{
    protected $fillable = [
        'experience_id',
        'accomplishment',
        'sort_order',
    ];

    public $timestamps = false;

    public function experience(): BelongsTo
    {
        return $this->belongsTo(Experience::class);
    }
}
