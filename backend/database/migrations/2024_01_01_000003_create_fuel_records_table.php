<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fuel_records', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('vehicle_id')->constrained()->onDelete('cascade');
            $table->dateTime('date');
            $table->decimal('liters', 8, 2);
            $table->decimal('price_per_liter', 8, 2);
            $table->decimal('total_cost', 10, 2);
            $table->integer('odometer')->nullable();
            $table->string('station')->nullable();
            $table->string('city')->nullable();
            $table->boolean('is_full_tank')->default(true);
            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();
            
            $table->index(['vehicle_id', 'date']);
            $table->index('city');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fuel_records');
    }
};
