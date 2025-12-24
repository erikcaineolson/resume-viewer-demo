<?php

use App\Http\Controllers\ResumeController;
use Illuminate\Support\Facades\Route;

Route::get('/profile', [ResumeController::class, 'profile']);
Route::get('/experiences', [ResumeController::class, 'experiences']);
Route::get('/skills', [ResumeController::class, 'skills']);
Route::get('/resume', [ResumeController::class, 'show']);
Route::get('/resume/pdf', [ResumeController::class, 'downloadPdf']);
