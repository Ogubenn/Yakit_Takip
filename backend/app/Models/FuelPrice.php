<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FuelPrice extends Model
{
    use HasFactory;

    protected $fillable = [
        'city',
        'fuel_type',
        'price',
        'source',
        'effective_date',
    ];

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'effective_date' => 'date',
        ];
    }

    // Scopes
    public function scopeForCity($query, $city)
    {
        return $query->where('city', $city);
    }

    public function scopeForFuelType($query, $fuelType)
    {
        return $query->where('fuel_type', $fuelType);
    }

    public function scopeCurrent($query)
    {
        return $query->whereDate('effective_date', '<=', now())
                    ->orderBy('effective_date', 'desc');
    }
}
