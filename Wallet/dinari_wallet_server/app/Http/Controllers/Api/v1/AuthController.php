<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use App\Mail\VerifyMail;
use App\Models\Account;
use App\Models\VerificationCode;
use GuzzleHttp\Client;

class AuthController extends Controller
{
    ////////////create a User////////////
    public function register(Request $request)
    {
        $rules = [
            'email' => 'required|string|unique:users',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        $pin = $this->generatePin();
        $user = User::create([
            'email' => $request->email,
            'pin' => $pin,
        ]);
        $token = $user->createToken('Personal Access Token')->plainTextToken;

        $user = User::where('email', $request->email)->first();
        $user->api_token = $token;
        $user->save();

        $response = ['user' => $user, 'token' => $token];    
        $otp = $this->generateOtp();       
        $codeVerification = VerificationCode::create([
            'user_id' => $user->id,
            'otp' => $otp,
            'pin' => $pin
        ]);
        $this->createAccount($token);
        Mail::to($user->email)->send(new VerifyMail($codeVerification));
        return response()->json($response, 201);
    }


    ////////generate otp//////////
    public function generateOtp() {
        $otp = '';
        for ($i = 0; $i < 5; $i++) {
            $otp = $otp . mt_rand(0, 9);
        }
        $check = VerificationCode::where('otp', $otp)->first();

        if($check) {
            $this->generatePin();
        } else {
            return $otp;
        }
    }


    ////////////verify user//////////////
    public function verification(Request $request,$id){
          $rules = [
            'otp' => 'required|string'
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }       
        $otp = VerificationCode::where('otp', $request->otp)->first();
        if ($otp && $request->otp) {
            $verifyUser = VerificationCode::where('user_id', $id)->first();
            if(isset($verifyUser)){
                $user = $verifyUser->user;
                if(!$user->verified){
                    $verifyUser->user->verified=1;
                    $verifyUser->user->save();
                    // $response = ['message'=>'verified'];
                    return response()->json($user, 200);                }
                else{
                    // $response = ['message'=>'verified'];
                    return response()->json($user, 200);
                }
            }
            else{
                $response = ['message' => 'error'];
                return response()->json($response, 400);          
              }
        }
        else {
            $response = ['message' => 'Enter valid verification code'];
            return response()->json($response, 400); 
        }  
    }

    ////////view pin///////////
    public function viewPrivateKey(Request $request){
        $rules = [
            'pin'=>'required|string'
        ];
        $validator = Validator::make($request->all(),$rules);
        if($validator->fails()){
            return response()->json($validator->errors(),400);
        }
        $user = User::where('pin',$request->pin)->first();
        if($user && $request->pin){
            $response = ['user' => $user];
response()->json($response);
        }

    }

    ////////login//////////////
    public function login(Request $request)
    {
        $rules = [
            'pin' => 'required|string'
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }       
        $user = User::where('pin', $request->pin)->first();
        if ($user->verified == 1) {
          if ($user && $request->pin) {
            $token = $user->createToken('Personal Access Token')->plainTextToken;
            $response = ['user' => $user, 'token' => $token];
            return response()->json($response, 200);
        }
        $response = ['message' => 'Incorrect email or password'];
        return response()->json($response, 400);
        }
        $response = ['message' => 'Account not verified!!'];
        return response()->json($response, 400);
    }



        ////////generate otp//////////
    public function generatePin() {
        $pin = '';
        for ($i = 0; $i < 4; $i++) {
            $pin = $pin . mt_rand(0, 9);
        }

        $check = User::where('pin', $pin)->first();

        if($check) {
            $this->generatePin();
        } else {
            return $pin;
        }
    }

    ////////////create a User account////////////
    public function createAccount($token) {
        $user = User::where('api_token', $token)->first();
        $client = new Client();
        $resp = $client->get('https://dinari-wallet.herokuapp.com/ewallet/' . $user->pin);

        $resp = json_decode($resp->getBody());

        // return $resp;
        
        // check if it is the first account, second, etc
        $account_check = Account::where('user_id', $user->id)->latest()->first();
        if($account_check) {
            $acc = explode(' ', $account_check->name);

            // return $acc;
            $name = 'Account ' . (string)((int)$acc[1] + 1);
        } else {
            $name = 'Account 1';
        }
        // create account
        $account = new Account;
        $account->private_key = $resp->private_key;
        $account->public_key = $resp->public_key;
        $account->address = $resp->address;
        $account->name = $name;
        $account->balance = 0;
        $account->user_id = $user->id;

        $account->save();

        return;
    }
    


}
