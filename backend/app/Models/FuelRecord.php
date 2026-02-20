<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class FuelRecord extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $fillable = [
        'vehicle_id',
        'date',
        'liters',
        'price_per_liter',
        'total_cost',
        'odometer',
        'station',
        'city',
        'is_full_tank',
        'notes',
    ];

    protected function casts(): array
    {
        return [
            'date' => 'datetime',
            'liters' => 'decimal:2',
            'price_per_liter' => 'decimal:2',
            'total_cost' => 'decimal:2',
            'odometer' => 'integer',
            'is_full_tank' => 'boolean',
        ];
    }

    // Relationships
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class);
    }

    // Scopes
    public function scopeForVehicle($query, $vehicleId)
    {
        return $query->where('vehicle_id', $vehicleId);
    }

    public function scopeRecent($query)
    {
        return $query->orderBy('date', 'desc');
    }
}
