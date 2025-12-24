<?php

namespace App\Http\Controllers;

use App\Models\Experience;
use App\Models\Profile;
use App\Models\Skill;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Http;

class ResumeController extends Controller
{
    /**
     * Get profile/contact information.
     */
    public function profile(): JsonResponse
    {
        $profile = Profile::first();

        return response()->json($profile);
    }

    /**
     * Get all experiences with skills and accomplishments.
     */
    public function experiences(): JsonResponse
    {
        $experiences = Experience::with(['skills', 'accomplishments'])
            ->orderByDesc('start_date')
            ->get();

        return response()->json($experiences);
    }

    /**
     * Get all skills grouped by category.
     */
    public function skills(): JsonResponse
    {
        $skills = Skill::orderBy('category')
            ->orderByDesc('proficiency_level')
            ->get();

        return response()->json($skills);
    }

    /**
     * Get complete resume data.
     */
    public function show(): JsonResponse
    {
        return response()->json([
            'profile' => Profile::first(),
            'experiences' => Experience::with(['skills', 'accomplishments'])
                ->orderByDesc('start_date')
                ->get(),
            'skills' => Skill::orderBy('category')
                ->orderByDesc('proficiency_level')
                ->get(),
        ]);
    }

    /**
     * Download resume as PDF.
     * Proxies to Python PDF microservice.
     */
    public function downloadPdf(): Response
    {
        $pdfServiceUrl = config('services.pdf.url', 'http://pdf-service:8000');

        $response = Http::timeout(30)->get("{$pdfServiceUrl}/api/resume.pdf");

        if ($response->failed()) {
            abort(503, 'PDF service unavailable');
        }

        return response($response->body(), 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => 'attachment; filename="resume.pdf"',
        ]);
    }
}
