import 'dart:convert';
import 'package:dinari_wallet/models/partnership_request.dart';
import 'package:dinari_wallet/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TrustPatnershipProvider with ChangeNotifier {
   List<dynamic> _partnershipTrustList;

  // getters
  List<dynamic> get partnershipTrustList => _partnershipTrustList;
/////////send request///////
  Future<bool> sendRequest({
    @required String address,
    @required String partnershipAddress,
    @required String recipientMessage,
  }) async {
    bool hasError = false;

    final Map<String, dynamic> data = {
      'address': address,
      'partner_address': partnershipAddress,
      'recipient_message': recipientMessage,
    };
    notifyListeners();

    try {
      final http.Response response = await http.post(
        Uri.parse("${api1}send-request"),
        body: data,
      );
      print('object1');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        // final partnershipTrust = PartnerTrustModel.fromJson(data);

        // _partnershipTrustList.add(partnershipTrust);
        hasError = false;
        notifyListeners();
        print('AAAAAAAAAAAAAAA');
        print(_partnershipTrustList);
      }
    } catch (error) {
      print('---------------------------');
      print(error);
      hasError = true;
    }

    // _isSubmittingData = false;
    // notifyListeners();

    return hasError;
  }
}
