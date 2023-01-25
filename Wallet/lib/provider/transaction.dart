import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/components/snackaBarSuccess.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/transaction.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class TransactionProvider extends ChangeNotifier {
  GenerateAccountProvider _accProvider;

  void update({@required GenerateAccountProvider accProvider}) {
    _accProvider = accProvider;
  }

  List<TransactionModel> _transactions;
  double _gasFee;
  bool loading = false;
  String updatedTime;

  bool get isLoading => loading;
  double get gasFee => _gasFee;
  List<TransactionModel> get transactions => _transactions;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  //////get account id from shared pref/////
  getAccountData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('account_id');
  }

  //////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_id');
  }

/////get send transaction fn/////
  sendTransaction(String partnerAddress, double amount, context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // var currentAccount =
    //     Provider.of<GenerateAccountProvider>(context, listen: false);
    // if (sp.getString("balance") != currentAccount.currentAccount.balance)
    //   updatedTime = DateTime.now().toIso8601String();
    String rpcUrl =
        'http://${sp.getString('network_ip_address')}:${sp.getString('network_port')}';
    final client = Web3Client(rpcUrl, Client());
    final credentials =
        EthPrivateKey.fromHex(_accProvider.currentAccount.privateKey);
    final etherAmount =
        EtherAmount.fromUnitAndValue(EtherUnit.ether, (amount).toInt());
    var id = await getUserData();
    var acc = await getAccountData();
    try {
      setLoading(true);
      notifyListeners();
      var signedTrans = await client
          .sendTransaction(
              credentials,
              Transaction(
                from: EthereumAddress.fromHex(
                    _accProvider.currentAccount.address),
                to: EthereumAddress.fromHex(partnerAddress),
                gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1),
                maxGas: 21000,
                value: etherAmount,
              ),
              chainId: 1214)
          .then((hashedtrans) async {
        if (hashedtrans.isNotEmpty) {
          print(hashedtrans);
          var block = await client.getBlockInformation(blockNumber: 'latest');
          print(block.timestamp.toLocal());
          setLoading(false);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          snackBarSuccessWidget(context, 'Successfully sent');
          final tmodel = TransactionModel(
              address: _accProvider.currentAccount.address,
              otherEndAddress: partnerAddress,
              amount: amount,
              confirmationTime: DateTime.now().toIso8601String(),
              receivedTime: DateTime.now()
                  .add(const Duration(seconds: 5))
                  .toIso8601String(),
              transactionType: "sent",
              channel: "on-chain",
              status: 'new',
              accId: acc,
              userId: id);
          await DbHelper.sendTransaction(tmodel).then((value) {
            print(value);
          });
          notifyListeners();
        }
      });
      return signedTrans;
    } catch (e) {
      setLoading(false);
      notifyListeners();
      // alertDialog(context, e.toString());
      alertDialog(context, "Insufficient funds for gas price");
      print(e);
    }
  }

  Future<void> showTransactions(address) async {
    final dataList = await DbHelper.getTransactions(address);
    print(dataList);
    _transactions = [];
    if (dataList != null) {
      _transactions = dataList
          .map((item) => TransactionModel(
                address: item.address,
                otherEndAddress: item.otherEndAddress,
                amount: item.amount,
                confirmationTime: item.confirmationTime,
                status: item.status,
                accId: item.accId,
                channel: item.channel,
                receivedTime: item.receivedTime,
                transactionType: item.transactionType,
                userId: item.userId,
                id: null,
              ))
          .toList();
    }
    notifyListeners();
  }

  getTransaction(address, amount) {
    final trans = Transaction(
      to: EthereumAddress.fromHex(address),
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 21000),
      maxGas: 21000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
    );
    _gasFee = trans.gasPrice.getValueInUnit(EtherUnit.ether);
    return trans;
  }
}
