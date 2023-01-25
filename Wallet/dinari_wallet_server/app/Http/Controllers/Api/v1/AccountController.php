<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\Account;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class AccountController extends Controller
{
  public function account($id){
    $account = Account::where('user_id', $id)->first();
    return response()->json($account);
  }

  public function index()
    {
        $data = Account::all()->pluck('address');
        return $data;
    }
////////////get account name////////
    public function userAccounts($id)
    {
        // $data = Account::where('user_id',$id)->pluck('name','balance');
        $data = DB::table('accounts')
        ->select(array('name', 'balance'))
        ->get();

        return response()->json($data);
    }


    ///////////////get balance////////////////////
    public function getBalance($address){
        
      $apiUrl = '161.35.23.208:8545';
      $address = 0x18b1b0C33f6b92f5CD70C7020AB9D66FE28E3D98;
      $userAddress = $address;
      $data = [
          'address' =>$userAddress,
          'id'=> '4',
          'jsonrpc' => '2.0',
          'method' => 'eth_getBalance',
      ];

      $headers = [
          'content-type' => 'application/json'
      ];

      $response = Http::withHeaders($headers)->get($apiUrl, $data);

      $statusCode = $response->status();
      $responseBody = json_decode($response->getBody(), true);

      dd($responseBody);
  }

}
