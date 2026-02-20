<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\VehicleController;
use App\Http\Controllers\Api\FuelRecordController;
use App\Http\Controllers\Api\FuelPriceController;
use App\Http\Controllers\Api\SyncController;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/social-login', [AuthController::class, 'socialLogin']);

// Public fuel prices
Route::get('/fuel-prices', [FuelPriceController::class, 'index']);
Route::get('/fuel-prices/city/{city}', [FuelPriceController::class, 'byCity']);
Route::get('/fuel-prices/history', [FuelPriceController::class, 'history']);

// Protected routes
Route::middleware('auth:api')->group(function () {
    // Auth
    Route::get('/user', [AuthController::class, 'me']);
    Route::put('/user', [AuthController::class, 'updateProfile']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Vehicles
    Route::apiResource('vehicles', VehicleController::class);

    // Fuel Records
    Route::apiResource('fuel-records', FuelRecordController::class);
    Route::get('/fuel-records/vehicle/{vehicleId}', [FuelRecordController::class, 'vehicleRecords']);

    // Sync
    Route::post('/sync/upload', [SyncController::class, 'upload']);
    Route::get('/sync/download', [SyncController::class, 'download']);
    Route::get('/sync/changes', [SyncController::class, 'changes']);
});
