<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dinari wallet</title>
</head>
<body>
   <h3>Hello,</h3> 
   <h4>Thanks for getting started with our Dinari wallet!</h4>
   <h4>We need a little more information to complete your registration, including a confirmation of your email address and login pin.</h4>
   <h4>Please check your verification code and your pin for Dinari wallet</h4>
   <p>verification code: <b>{{$body->otp}}</b></p>
   <p>pin: <b>{{$body->pin}}</b></p>
   <p style="font-size:10px">Thank you,<br>@Dinari_wallet team</p>
</body>
</html>