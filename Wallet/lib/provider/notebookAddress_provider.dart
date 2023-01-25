import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/notebook_Address.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotebookAddressProvider extends ChangeNotifier {
  List<NotebookAddress> _notebookAddress = [];
  List<NotebookAddress> _addressToDisplay = [];
  List<NotebookAddress> get addressToDisplay => _addressToDisplay;
  List<NotebookAddress> get notebookAddress => _notebookAddress;
  bool search = false;

  setSearch(bool state) {
    search = state;
    notifyListeners();
  }

  //////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_id');
  }

///////save network///////
  Future<void> getNotebookAddresses() async {
    var userid = await getUserData();
    final dataList = await DbHelper.getNotebookAddress(userid);
    print(dataList);
    _notebookAddress = [];
    _notebookAddress = dataList
        .map((item) => NotebookAddress(
            name: item.name, id: item.id, address: item.address))
        .toList();
    notifyListeners();
  }

  /////////insert//////////
  Future<void> insertNotebookAddress({
    @required String name,
    @required String address,
  }) async {
    var userId = await getUserData();
    NotebookAddress cModel =
        NotebookAddress(name: name, address: address, userId: userId);
    _notebookAddress.add(cModel);
    DbHelper.addNotebookAddress(cModel).then((value) {
      if (value != null) {
        print('address added');
        notifyListeners();
      }
    });
    notifyListeners();
  }

  onSearch(String name) {
    if (name == "") {
      _addressToDisplay.clear();
      notifyListeners();
    } else {
      _notebookAddress.forEach((address) {
        if (address.name.toLowerCase().contains(name.toLowerCase())) {
          _addressToDisplay.add(address);
        }
      });
      notifyListeners();
    }
  }

  
}
