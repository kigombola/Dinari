<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\Partnership;
use App\Models\Partnership_request;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class Partnership_requestController extends Controller
{
    public function sendRequest(Request $request){
$validator = Validator::make($request->all(),[
    'address' => 'required',
    'partner_address' => 'required',
    'recipient_message' => 'required',
]);
if($validator->fails())
{
    return response()->json($validator->errors(),400);
}
        $data = new Partnership_request([
                'address' => $request->get('address'),
                'partner_address' => $request->get('partner_address'),
                'recipient_message' => $request->get('recipient_message'),
                'status' => 'New',
                'time' => now(),
        ]);

        $data->save();
        return response()->json($data);
    }
}
