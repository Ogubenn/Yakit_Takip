<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fuel_prices', function (Blueprint $table) {
            $table->id();
            $table->string('city');
            $table->string('fuel_type'); // Benzin, Dizel, LPG
            $table->decimal('price', 8, 2);
            $table->string('source')->default('EPDK'); // EPDK, manual, etc
            $table->date('effective_date');
            $table->timestamps();
            
            $table->unique(['city', 'fuel_type', 'effective_date']);
            $table->index(['city', 'fuel_type']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fuel_prices');
    }
};
