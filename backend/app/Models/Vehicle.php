<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Vehicle extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $fillable = [
        'user_id',
        'brand',
        'model',
        'year',
        'fuel_type',
        'engine_size',
        'plate_number',
        'color',
        'initial_odometer',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'year' => 'integer',
            'initial_odometer' => 'integer',
            'is_active' => 'boolean',
        ];
    }

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function fuelRecords()
    {
        return $this->hasMany(FuelRecord::class);
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
