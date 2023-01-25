<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Partnership_request extends Model
{
    use HasFactory;

    protected $fillable = [
        'address',
        'partner_address',
        'recipient_message'
    ];
}
