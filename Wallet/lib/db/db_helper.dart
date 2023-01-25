import 'dart:ffi';

import 'package:dinari_wallet/models/account.dart';
import 'package:dinari_wallet/models/network.dart';
import 'package:dinari_wallet/models/notebook_Address.dart';
import 'package:dinari_wallet/models/partner.dart';
import 'package:dinari_wallet/models/partnership_request.dart';
import 'package:dinari_wallet/models/transaction.dart';
import 'package:dinari_wallet/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper {
  static Database _db;

  static const String dbName = 'dinari.db';

  static const String tableUser = 'user';
  static const String tableAccount = 'account';
  static const String tablePartnershipRequest = 'partnershipRequest';
  static const String tableTransaction = 'transactions';
  static const String tablePartnership = 'partnership';
  static const String tableNetwork = 'network';
  static const String tableNotebookAddress = 'notebookAddress';
  static const int version = 1;

///////table user fields/////
  static const String columnId = 'id';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';
  static const String columnVerified = 'verified';
  static const String columnOtp = 'otp';
///////table account fields/////
  static const String columnAccountId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnAddress = 'address';
  static const String columnPrivateKey = 'private_key';
  static const String columnPublicKey = 'public_key';
  static const String columnAccountName = 'name';
  static const String columnAccountBalance = 'balance';
  static const String columnEligibility = 'eligibility';
///////table partnership request fields/////
  static const String columnRequestPartnershipId = 'id';
  static const String columnrequestAddress = 'address';
  static const String columnPartnerAddress = 'partnership_address';
  static const String columnRecipientMessage = 'recipient_message';
  static const String columnPartnershipStatus = 'status';
///////table  transaction fields/////
  static const String columnTransactionId = 'id';
  static const String columnTransactionAddress = 'address';
  static const String columnOtherAddress = 'other_end_address';
  static const String columnTransactionType = 'transaction_type';
  static const String columnUserIdforTransa = 'user_id';
  static const String columnAccountIdforTransa = 'account_id';
  static const String columnAmount = 'amount';
  static const String columnChannel = 'channel';
  static const String columnsentTime = 'received_time';
  static const String columnconfirmationTime = 'confirmation_time';
  static const String columnStatus = 'status';
///////table  partner fields/////
  static const String columnUserAddress = 'address';
  static const String columnPartnertableAddress = 'partner_address';
  static const String columnPairingTime = 'pairing_time';
  static const String columnPartnerStatus = 'status';
///////table  network fields/////
  static const String columnName = 'name';
  static const String columnPort = 'port_number';
  static const String columnIpAddress = 'ip_address';
  static const String columnChainId = 'chain_id';
  static const String columnPStatus = 'status';
  static const String columnuserid = 'user_id';

  static Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  static _onCreate(Database db, int intVersion) async {
    ///user table
    await db.execute(
        """ CREATE TABLE $tableUser ($columnEmail TEXT, $columnPassword TEXT, $columnVerified BOOLEAN DEFAULT "false", $columnOtp INTEGER DEFAULT 0) """);

    /////account table
    await db.execute(
        """ CREATE TABLE $tableAccount ($columnUserId INTEGER, $columnPrivateKey TEXT, $columnPublicKey TEXT,$columnAddress TEXT, $columnAccountName TEXT , $columnAccountBalance DOUBLE, $columnEligibility TEXT DEFAULT 1) """);

    /////transaction table
    await db.execute(
        """ CREATE TABLE $tableTransaction ($columnTransactionAddress TEXT, $columnOtherAddress TEXT, $columnChannel TEXT, $columnAmount DOUBLE, $columnsentTime TEXT, $columnconfirmationTime TEXT, $columnStatus TEXT, $columnTransactionType TEXT, $columnAccountIdforTransa
        TEXT, $columnUserIdforTransa TEXT) """);

    /////network table
    await db.execute(
        """ CREATE TABLE $tableNetwork ($columnName TEXT, $columnPort TEXT, $columnIpAddress TEXT, $columnChainId INTEGER, $columnStatus TEXT, $columnuserid TEXT) """);

    /////partnership request table
    await db.execute(
        """ CREATE TABLE $tablePartnershipRequest ($columnPartnerAddress TEXT,$columnrequestAddress TEXT,$columnRecipientMessage TEXT, $columnPartnershipStatus TEXT) """);

    /////partnership table
    await db.execute(
        """ CREATE TABLE $tablePartnership($columnPartnertableAddress TEXT,$columnUserAddress TEXT,$columnPairingTime TIME,$columnPartnerStatus TEXT) """);

    /////notebook table
    await db.execute(
        """ CREATE TABLE $tableNotebookAddress($columnUserId TEXT, $columnAddress TEXT,$columnName TEXT) """);
  }

///////user table operations/////////
  static Future<int> saveData(User user) async {
    var dbClient = await db;
    var email = await dbClient.query(tableUser,
        columns: ['email'], where: 'email=?', whereArgs: [user.email]);
    var pin = await dbClient.query(tableUser,
        columns: ['password'], where: 'password=?', whereArgs: [user.password]);
    if (email.isEmpty && pin.isEmpty) {
      var res = await dbClient.insert(tableUser, user.toMap());
      print('user added');
      return res;
    } else {
      print('user found');
    }
    return null;
  }

  static Future<User> getLoginUser(String password) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT rowid, * FROM $tableUser WHERE "
        "$columnPassword = '$password' AND $columnVerified = 'true'");
    if (res.isNotEmpty) {
      print('logged in');
      return User.fromMap(res.first);
    }
    return null;
  }

  // Future updateUserVerificationColumn(bool verification) async {
  //   var dbClient = await db;
  //   var res = await dbClient
  //       .rawUpdate("UPDATE $tableUser SET verified = '$verification'");
  //   return res;
  // }

  static Future updateUserOtp(String otp) async {
    var dbClient = await db;
    var res = await dbClient.rawUpdate("UPDATE $tableUser SET otp = '$otp'");
    return res;
  }

  static Future verify(String otp) async {
    var dbClient = await db;
    var data = await dbClient.rawUpdate(
        "UPDATE $tableUser SET $columnVerified = 'true' WHERE $columnOtp = '$otp'");
    return data;
  }

  static Future<User> checkUserEmail(String email) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT rowid, * FROM $tableUser WHERE "
        "$columnEmail = '$email'");
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  static Future updatepin(String pin) async {
    var dbClient = await db;
    var res =
        await dbClient.rawUpdate("UPDATE $tableUser SET password = '$pin'");
    return res;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    var res = await dbClient?.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
    return res;
  }

  Future<int> deleteUser(String id) async {
    var dbClient = await db;
    var res = await dbClient
        .delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
    return res;
  }

  static getUser(String userId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        """SELECT rowid, * FROM $tableAccount WHERE 
              $columnUserId =? AND $columnAccountName LIKE 'Account%'""",
        [userId]);
    if (res.isEmpty) {
      return 'Account 1';
    } else {
      var account = res.last['name'];
      // print(res.toString());
      var name = account.toString().split(' ').toList();
      var newName = '${name[0]} ${int.parse(name[1]) + 1}';
      return newName;
    }
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await db;
    var res = await dbClient?.query("user");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : null;
    return list;
  }

  ////////account table operations///////////
  static Future<int> saveAccount(Account account) async {
    var dbClient = await db;
    return await dbClient.insert(tableAccount, account.toMap());
  }

  static Future<List<Account>> getAccount(String userId) async {
    var dbClient = await db;
    var res = await dbClient.query(tableAccount,
        columns: ['name,balance,user_id,rowid, address'],
        where: 'user_id=?',
        whereArgs: [userId]);
    List<Account> list =
        res.isNotEmpty ? res.map((c) => Account.fromMap(c)).toList() : null;
    return list;
  }

  static getAccounts(String userId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT rowid, * FROM $tableAccount WHERE user_id=?', [userId]);
    return res;
  }

  static Future updateBalance(String id, String balance) async {
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
        "UPDATE $tableAccount SET balance = '$balance' WHERE rowid = $id");
    return res;
  }

  static getSingleAccount(String accId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
      "SELECT rowid, * from $tableAccount where rowid = ? ",
      [accId],
    );
    return res.first;
  }

  static getSingleAccountBalance(String privkey) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
      "SELECT  * from $tableAccount where private_key = ? ",
      [privkey],
    );
    if (res.isNotEmpty) {
      return res.first['balance'];
    } else {
      return 0;
    }
  }

  static Future getPrivateKey(String userId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
      "SELECT private_key from $tableAccount where user_id = ? ",
      [userId],
    );
    return res.first;
  }

  ////////partnership request table operations///////////
  static Future sendRequest(PartnerTrustModel partner) async {
    var dbClient = await db;
    return await dbClient.insert(tablePartnershipRequest, partner.toMap());
  }

  static Future<List<PartnerTrustModel>> getRequests() async {
    var dbClient = await db;
    var res = await dbClient?.query("partnershipRequest");
    List<PartnerTrustModel> list = res.isNotEmpty
        ? res.map((c) => PartnerTrustModel.fromMap(c)).toList()
        : null;
    return list;
  }

  ////////partnership table operations///////////
  static Future savePatnership(PartnerModel partner) async {
    var dbClient = await db;
    return await dbClient.insert(tablePartnership, partner.toMap());
  }

  static Future<List<PartnerModel>> getPartnerships() async {
    var dbClient = await db;
    var res = await dbClient?.query("partnership", distinct: true);
    List<PartnerModel> list = res.isNotEmpty
        ? res.map((c) => PartnerModel.fromMap(c)).toList()
        : null;
    return list;
  }

  // static Future<List<PartnerModel>> getPartnership() async {
  //   var dbClient = await db;
  //   var res = await dbClient?.query("partnership");
  //   List<PartnerModel> list = res.isNotEmpty
  //       ? res.map((c) => PartnerModel.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }

  static checkAddress(String address) async {
    var dbClient = await db;
    var res = await dbClient
        ?.query(tableAccount, where: 'address =?', whereArgs: [address]);
    // var res = await dbClient.rawQuery('SELECT * FROM account WHERE address =?', [address]);
    return (res.length);
  }

  ////////transaction table operations///////////
  static Future<int> sendTransaction(TransactionModel transaction) async {
    var dbClient = await db;
    return await dbClient.insert(tableTransaction, transaction.toMap());
  }

  static Future<List<TransactionModel>> getTransactions(String address) async {
    var dbClient = await db;
    var res = await dbClient.query(tableTransaction,
        columns: [
          'amount,confirmation_time,received_time,transaction_type,channel,status,address,other_end_address,rowid,user_id,account_id'
        ],
        where: 'address=? OR other_end_address=?',
        whereArgs: [address, address],
        limit: 6,
        orderBy: 'confirmation_time DESC');
    print(res);
    List<TransactionModel> list = res.isNotEmpty
        ? res.map((c) => TransactionModel.fromMap(c)).toList()
        : null;
    return list;
  }

  static Future updateTransactionStatus(String address) async {
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
        "UPDATE $tableTransaction SET status = 'receive' WHERE other_end_address = $address");
    return res;
  }

  static getSuccessTransactions(String address) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $tableTransaction WHERE status=? AND address=?',
        ['successful', address]);
    var total = 0;
    if (res.isNotEmpty) {
      total = res.length;
    }
    return total;
  }

  ////////partner table  operations///////////
  static Future<List<PartnerModel>> getPartners() async {
    var dbClient = await db;
    var res = await dbClient?.query("partnershipRequest");
    List<PartnerModel> list = res.isNotEmpty
        ? res.map((c) => PartnerModel.fromMap(c)).toList()
        : null;
    return list;
  }

  static getSuccessTpRequests(String address) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $tablePartnershipRequest WHERE status=? AND address=?',
        ['successful', address]);
    var total = 0;
    if (res.isNotEmpty) {
      print('object');
      total = res.length;
    }
    return total;
  }

  static verifyPartners(String addressA, String addressB) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM $tablePartnership WHERE status=? AND address=? AND partner_address=?',
        ['paired', addressA, addressB]);

    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  ///////////////////////////network operations///////////////////////////////////
  static Future<int> addNetwork(Network network) async {
    var dbClient = await db;
    return await dbClient.insert(tableNetwork, network.toMap());
  }

  static Future<List<Network>> getNetworks(String userId) async {
    var dbClient = await db;
    var res = await dbClient.query(tableNetwork,
        columns: ['name,port_number,rowid, ip_address,chain_id,status,user_id'],
        where: 'user_id=?',
        whereArgs: [userId]);
    List<Network> list =
        res.isNotEmpty ? res.map((c) => Network.fromMap(c)).toList() : null;
    return list;
  }

  static getSingleNetwork(String netId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
      "SELECT rowid, * from $tableNetwork where rowid = ?",
      [netId],
    );
    return res.first;
  }

  static Future updateNetworkStatus(String netId) async {
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
        "UPDATE $tableNetwork SET status = 'active' WHERE rowid = $netId");
    return res;
  }

  //////NotebookAddress operations
  static Future<int> addNotebookAddress(NotebookAddress notebookAddress) async {
    var dbClient = await db;
    return await dbClient.insert(tableNotebookAddress, notebookAddress.toMap());
  }

  static Future<List<NotebookAddress>> getNotebookAddress(String userId) async {
    var dbClient = await db;
    var res = await dbClient.query(tableNotebookAddress,
        columns: ['name,rowid, address,user_id'],
        where: 'user_id=?',
        whereArgs: [userId]);
    List<NotebookAddress> list = res.isNotEmpty
        ? res.map((c) => NotebookAddress.fromMap(c)).toList()
        : null;
    return list;
  }
}
