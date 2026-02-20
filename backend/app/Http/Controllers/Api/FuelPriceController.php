<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FuelPrice;
use Illuminate\Http\Request;

class FuelPriceController extends Controller
{
    public function index(Request $request)
    {
        $query = FuelPrice::current();

        if ($request->has('city')) {
            $query->forCity($request->city);
        }

        if ($request->has('fuel_type')) {
            $query->forFuelType($request->fuel_type);
        }

        $prices = $query->get()->groupBy(['city', 'fuel_type'])
                       ->map(fn($cityGroup) => $cityGroup->map->first());

        return response()->json($prices);
    }

    public function byCity($city)
    {
        $prices = FuelPrice::current()
                          ->forCity($city)
                          ->get()
                          ->groupBy('fuel_type')
                          ->map->first();

        return response()->json($prices);
    }

    public function history(Request $request)
    {
        $days = $request->get('days', 30);
        
        $query = FuelPrice::where('effective_date', '>=', now()->subDays($days))
                          ->orderBy('effective_date', 'desc');

        if ($request->has('city')) {
            $query->forCity($request->city);
        }

        if ($request->has('fuel_type')) {
            $query->forFuelType($request->fuel_type);
        }

        $prices = $query->get();

        return response()->json($prices);
    }
}
