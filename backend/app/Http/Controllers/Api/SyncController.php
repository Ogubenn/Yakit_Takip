<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Vehicle;
use App\Models\FuelRecord;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class SyncController extends Controller
{
    public function upload(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'vehicles' => 'required|array',
            'fuel_records' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        DB::beginTransaction();

        try {
            $user = auth()->user();
            $syncedData = [
                'vehicles' => [],
                'fuel_records' => [],
            ];

            // Sync Vehicles
            foreach ($request->vehicles as $vehicleData) {
                $vehicle = $user->vehicles()->updateOrCreate(
                    ['id' => $vehicleData['id']],
                    $vehicleData
                );
                $syncedData['vehicles'][] = $vehicle;
            }

            // Sync Fuel Records
            foreach ($request->fuel_records as $recordData) {
                // Verify vehicle exists and belongs to user
                $vehicle = $user->vehicles()->find($recordData['vehicle_id']);
                
                if ($vehicle) {
                    $record = FuelRecord::updateOrCreate(
                        ['id' => $recordData['id']],
                        $recordData
                    );
                    $syncedData['fuel_records'][] = $record;
                }
            }

            DB::commit();

            return response()->json([
                'message' => 'Data synced successfully',
                'data' => $syncedData,
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Sync failed',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function download()
    {
        $user = auth()->user();

        return response()->json([
            'vehicles' => $user->vehicles()->active()->get(),
            'fuel_records' => $user->fuelRecords()->get(),
            'synced_at' => now(),
        ]);
    }

    public function changes(Request $request)
    {
        $since = $request->get('since', now()->subDays(7));
        $user = auth()->user();

        return response()->json([
            'vehicles' => $user->vehicles()
                              ->where('updated_at', '>=', $since)
                              ->get(),
            'fuel_records' => $user->fuelRecords()
                                   ->where('updated_at', '>=', $since)
                                   ->get(),
            'synced_at' => now(),
        ]);
    }
}
