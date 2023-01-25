// ignore_for_file: missing_required_param

import 'dart:convert';

import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/partner.dart';
import 'package:dinari_wallet/models/partnership_request.dart';
import 'package:dinari_wallet/utils/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PartnershipTrustProvider extends ChangeNotifier {
  List<PartnerTrustModel> _partnershipTrustList;
  List<PartnerModel> _partners = [];

  // getters
  List<PartnerTrustModel> get partnershipTrustList => _partnershipTrustList;
  List<PartnerModel> get partners => _partners;

  bool _isPatnershipOn = false;

  bool get isPatnershipOn => _isPatnershipOn;

  void switchPatnership(value) {
    _isPatnershipOn = value; 
    notifyListeners();
  }

  Future sendPartnershipRequest({
    @required String address,
    @required String partnerAddress,
    @required String status,
  }) async {
    final newPartnership = PartnerTrustModel(
        address: address,
        partnerAddress: partnerAddress,
        status: status);
    _partnershipTrustList.add(newPartnership);
    PartnerTrustModel pModel = PartnerTrustModel(
        address: newPartnership.address,
        partnerAddress: newPartnership.partnerAddress,
        status: newPartnership.status,
        );
    await DbHelper.sendRequest(pModel);
    notifyListeners();
  }

  Future<void> showPartnershipRequests() async {
    final dataList = await DbHelper.getRequests();
    _partnershipTrustList = dataList
        .map((item) => PartnerTrustModel(
            address: item.address,
            id: item.id,
            partnerAddress: item.partnerAddress,
            // recipientMessage: item.recipientMessage
            )
            )
        .toList();
    notifyListeners();
  }


////////////////////partnership//////////////
   Future savePartnership({
    @required String address,
    @required String partnerAddress,
    @required String status,
    @required String pairing_time
  }) async {
    PartnerModel pModel = PartnerModel(
        address: address,
        partnerAddress: partnerAddress,
        status: status,
        pairingTime: pairing_time
        );
    await DbHelper.savePatnership(pModel);
    print('DATAAAAAA');
    notifyListeners();
  }

    Future<void> showPartnerships() async {
    final dataList = await DbHelper.getPartnerships();
    // _partners = [];
    _partners = dataList
        .map((item) => PartnerModel(
            address: item.address,
            id: item.id,
            partnerAddress: item.partnerAddress,
            pairingTime: item.pairingTime
            )
            )
        .toList();
    notifyListeners();
  }


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

  checkDestinationAddress(String address) async {
    final data = await DbHelper.checkAddress(address);
    if(data == 1) {
      return true;
    } else {
      return false;
    }
  }
}
