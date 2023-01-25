<?php

use App\Http\Controllers\Api\v1\AccountController;
use App\Http\Controllers\Api\v1\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/


Route::post('/send/email', [AuthController::class, 'sendEmail']);


// Route::post('/auth/login', [AuthController::class, 'login']);
// Route::post('/auth/verifyUser/{userId}', [AuthController::class, 'verification']);
// Route::post('/view/privatekey', [AuthController::class, 'viewPrivateKey']);
// Route::post('add-account/{token}', 'Api\v1\AuthController@createAccount');

// Route::get('/get-addresses', 'Api\v1\AccountController@index');
// Route::get('/auth/account/{userId}', [AccountController::class, 'account']);
// Route::get('user/accounts/{userId}',[AccountController::class,'userAccounts']);
// Route::post('balance',[AccountController::class,'getBalance']);




Route::post('/send-request', 'Api\v1\Partnership_requestController@sendRequest');

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
