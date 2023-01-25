<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class VerifyMail extends Mailable
{
  use Queueable, SerializesModels;
  
  public $codeVerification;
  
  /**
  * Create a new message instance.
  *
  * @return void
  */
  public function __construct($codeVerification)
  {
    $this->codeVerification = $codeVerification;
  }

  /**
  * Build the message.
  *
  * @return $this
  */
  public function build()
  {
    return $this->subject('Email verification code')->
    view('emails.email_verification')->
    with([
        'body'=>$this->codeVerification,
    ]);
  }
}