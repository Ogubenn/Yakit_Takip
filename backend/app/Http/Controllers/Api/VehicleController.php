<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class VehicleController extends Controller
{
    public function index()
    {
        $vehicles = auth()->user()->vehicles()->active()->get();
        return response()->json($vehicles);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'brand' => 'required|string',
            'model' => 'required|string',
            'year' => 'required|integer|min:1900|max:' . (date('Y') + 1),
            'fuel_type' => 'required|string',
            'engine_size' => 'nullable|string',
            'plate_number' => 'nullable|string',
            'color' => 'nullable|string',
            'initial_odometer' => 'nullable|integer|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $vehicle = auth()->user()->vehicles()->create($request->all());

        return response()->json($vehicle, 201);
    }

    public function show($id)
    {
        $vehicle = auth()->user()->vehicles()->findOrFail($id);
        return response()->json($vehicle);
    }

    public function update(Request $request, $id)
    {
        $vehicle = auth()->user()->vehicles()->findOrFail($id);

        $validator = Validator::make($request->all(), [
            'brand' => 'sometimes|string',
            'model' => 'sometimes|string',
            'year' => 'sometimes|integer|min:1900|max:' . (date('Y') + 1),
            'fuel_type' => 'sometimes|string',
            'engine_size' => 'nullable|string',
            'plate_number' => 'nullable|string',
            'color' => 'nullable|string',
            'is_active' => 'sometimes|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $vehicle->update($request->all());

        return response()->json($vehicle);
    }

    public function destroy($id)
    {
        $vehicle = auth()->user()->vehicles()->findOrFail($id);
        $vehicle->delete();

        return response()->json(['message' => 'Vehicle deleted successfully']);
    }
}
