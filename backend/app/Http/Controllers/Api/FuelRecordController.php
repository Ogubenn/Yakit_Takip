<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FuelRecord;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class FuelRecordController extends Controller
{
    public function index(Request $request)
    {
        $query = FuelRecord::whereHas('vehicle', function ($q) {
            $q->where('user_id', auth()->id());
        });

        if ($request->has('vehicle_id')) {
            $query->forVehicle($request->vehicle_id);
        }

        $records = $query->recent()->get();

        return response()->json($records);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'vehicle_id' => 'required|uuid|exists:vehicles,id',
            'date' => 'required|date',
            'liters' => 'required|numeric|min:0',
            'price_per_liter' => 'required|numeric|min:0',
            'total_cost' => 'required|numeric|min:0',
            'odometer' => 'nullable|integer|min:0',
            'station' => 'nullable|string',
            'city' => 'nullable|string',
            'is_full_tank' => 'sometimes|boolean',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Verify vehicle belongs to user
        $vehicle = auth()->user()->vehicles()->findOrFail($request->vehicle_id);

        $record = $vehicle->fuelRecords()->create($request->all());

        return response()->json($record, 201);
    }

    public function show($id)
    {
        $record = FuelRecord::whereHas('vehicle', function ($q) {
            $q->where('user_id', auth()->id());
        })->findOrFail($id);

        return response()->json($record);
    }

    public function update(Request $request, $id)
    {
        $record = FuelRecord::whereHas('vehicle', function ($q) {
            $q->where('user_id', auth()->id());
        })->findOrFail($id);

        $validator = Validator::make($request->all(), [
            'date' => 'sometimes|date',
            'liters' => 'sometimes|numeric|min:0',
            'price_per_liter' => 'sometimes|numeric|min:0',
            'total_cost' => 'sometimes|numeric|min:0',
            'odometer' => 'nullable|integer|min:0',
            'station' => 'nullable|string',
            'city' => 'nullable|string',
            'is_full_tank' => 'sometimes|boolean',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $record->update($request->all());

        return response()->json($record);
    }

    public function destroy($id)
    {
        $record = FuelRecord::whereHas('vehicle', function ($q) {
            $q->where('user_id', auth()->id());
        })->findOrFail($id);

        $record->delete();

        return response()->json(['message' => 'Fuel record deleted successfully']);
    }

    public function vehicleRecords($vehicleId)
    {
        $vehicle = auth()->user()->vehicles()->findOrFail($vehicleId);
        $records = $vehicle->fuelRecords()->recent()->get();

        return response()->json($records);
    }
}
