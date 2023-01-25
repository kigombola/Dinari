// ignore_for_file: prefer_final_fields, library_prefixes, depend_on_referenced_packages
import 'dart:math';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class GenerateAccountProvider extends ChangeNotifier {
 List<Account> _accountItem = [];
  Account _currentAccount;
  Account _privatekey;
  bool loading = false;

  bool get isLoading => loading;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Account get pkey => _privatekey;
  List<Account> get accountItem => _accountItem;
  Account get currentAccount => _currentAccount;

//////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_id');
  }

  //////get account id from shared pref/////
  getAccountData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('account_id');
  }

  // ///////save acc id to shared pref
  Future setSP(String id) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("account_id", id);
    notifyListeners();
  }

/////get acc balance fn/////
  getBalance() async {
        final SharedPreferences sp = await SharedPreferences.getInstance();
     String rpcUrl = 'http://${sp.getString('network_ip_address')}:${sp.getString('network_port')}';
    final client = Web3Client(rpcUrl, Client());
    final credentials = EthPrivateKey.fromHex(currentAccount.privateKey);
    final address = credentials.address;
    EtherAmount balance = await client.getBalance(address);
    return balance.getValueInUnit(EtherUnit.ether).toString();
  }
  generateKey() async {
    var rng = Random.secure();
    var credentials = EthPrivateKey.createRandom(rng);
    var address = await credentials.extractAddress();
    var pubkey = bytesToHex(credentials.encodedPublicKey);
    var privkey = bytesToHex(credentials.privateKey);
    var id = await getUserData();
    var accountName = await DbHelper.getUser(id);
    Account aModel = Account(
        privateKey: privkey,
        publicKey: pubkey,
        address: address.hex,
        name: accountName,
        balance: '0',
        userId: id);
    DbHelper.saveAccount(aModel).then((accData) async {
      setLoading(true);
      notifyListeners();
      if (accData != null) {
        setLoading(false);
        notifyListeners();
        SharedPreferences account = await SharedPreferences.getInstance();
        if (account.getString('account_id') == null) {
          setSP(accData.toString());
          print('ACCOUNT');
          print(accData);
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }

  /////////////////add account//////////////
  addAccount(String name) async {
    var rng = Random.secure();
    var credentials = EthPrivateKey.createRandom(rng);
    var address = await credentials.extractAddress();
    var pubkey = bytesToHex(credentials.encodedPublicKey);
    var privkey = bytesToHex(credentials.privateKey);
    var id = await getUserData();
    var accountName = await DbHelper.getUser(id);
    Account aModel = Account(
        privateKey: privkey,
        publicKey: pubkey,
        address: address.hex,
        name: name,
        balance: '0',
        userId: id);
    DbHelper.saveAccount(aModel).then((accData) async {
      setLoading(true);
      notifyListeners();
      if (accData != null) {
        setLoading(false);
        notifyListeners();
        SharedPreferences account = await SharedPreferences.getInstance();
        if (account.getString('account_id') == null) {
          setSP(accData.toString());
          print('ACCOUNT');
          print(accData);
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }


////////add existed an acc by private key and address
  addExistedAccount(
      String privateKey, String address, String accountName) async {
    setLoading(true);
    notifyListeners();
    var key = EthPrivateKey.fromHex(privateKey);
    var pubkey = bytesToHex(key.encodedPublicKey);
    var id = await getUserData();
    Account aModel = Account(
        privateKey: privateKey,
        publicKey: pubkey,
        address: address,
        name: accountName,
        balance: '0',
        userId: id);
    DbHelper.saveAccount(aModel).then((accData) async {
      setLoading(true);
      notifyListeners();
      if (accData != null) {
        setLoading(false);
        notifyListeners();
        SharedPreferences account = await SharedPreferences.getInstance();
        if (account.getString('account_id') == null) {
          setSP(accData.toString());
          notifyListeners();
        }
      }
    });
  }


///////import an account using private key////////
  importAccount(String privateKey, String accountName) async {
    var key = EthPrivateKey.fromHex(privateKey);
    var pubkey = bytesToHex(key.encodedPublicKey);
    var address = await key.extractAddress();
    var id = await getUserData();
    Account aModel = Account(
        privateKey: privateKey,
        publicKey: pubkey,
        address: address.hex,
        name: accountName,
        balance: '0',
        userId: id);
    DbHelper.saveAccount(aModel).then((accData) async {
      setLoading(true);
      notifyListeners();
      if (accData != null) {
        setLoading(false);
        notifyListeners();
        SharedPreferences account = await SharedPreferences.getInstance();
        if (account.getString('account_id') == null) {
          setSP(accData.toString());
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }


 //////// show account details //////////
  getAccount() async {
    var id = await getUserData();
    final accountList = await DbHelper.getAccount(id);
    _accountItem = [];
    _accountItem = accountList
        .map((e) => Account(
              address: e.address,
              balance: e.balance,
              name: e.name,
              privateKey: e.privateKey,
              publicKey: e.publicKey,
              userId: e.userId,
              id: e.id,
            ))
        .toList();
    notifyListeners();
  }

  ///get single account by acc id
  getCurrentAccount() async {
    final id = await getAccountData();
    print('CURRENT');
    print(id);
    final acc = await DbHelper.getSingleAccount(id);
    _currentAccount = Account.fromMap(acc);
    notifyListeners();
  }

  ///get single account by acc id///
  getPrivatekey() async {
    var id = await getUserData();
    final prv = await DbHelper.getPrivateKey(id);
    _privatekey = Account.fromMap(prv);
    notifyListeners();
  }

  setCurrentAccount(String id) async {
    await setSP(id);
    await getCurrentAccount();
    var newBalance = await getBalance();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("balance", newBalance);
    notifyListeners();    await DbHelper.updateBalance(id, newBalance.toString());
    notifyListeners();
  }

  updateAccounts() async {
    var id = await getUserData();
    var accounts = await DbHelper.getAccounts(id);
    for (var i in accounts) {
      var balance = await getSpecificAccountBalance(i['private_key']);
      await DbHelper.updateBalance(i['rowid'].toString(), balance.toString());
      notifyListeners();
    }
  }

  getSpecificAccountBalance(String privateKey) async {
        final SharedPreferences sp = await SharedPreferences.getInstance();
     String rpcUrl = 'http://${sp.getString('network_ip_address')}:${sp.getString('network_port')}';
    final client = Web3Client(rpcUrl, Client());
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;
    EtherAmount balance = await client.getBalance(address);
    return balance.getValueInUnit(EtherUnit.ether).toString();
  }
}
