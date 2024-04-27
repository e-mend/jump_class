<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{

    public function auth(Request $request)
    {
        try {
            $user = User::where('email', $request->email)->first();
    
            if(!$user || !Hash::check($request->password, $user->password)){
                throw ValidationException::withMessages([
                    'email' => ['The provided credentials are incorrect.'],
                ]);
            }

            $token =$user->createToken($request->device_name)->plainTextToken;

        } catch (\Throwable $th) {
            return response()->json([
                'message' => $th->getMessage()
            ]);
        }

        $user->tokens()->delete();

        return response()->json([
            'token' => $token
        ]);
    }

    // public function loginUser(): JsonResponse
    // {
    //     return response()->json([
    //         'love' => false
    //     ]);
    // }

    // public function registerUser(): JsonResponse
    // {
    //     return response()->json([
    //         'love' => false
    //     ]);
    // }

}
