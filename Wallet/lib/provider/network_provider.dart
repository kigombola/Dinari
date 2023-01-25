import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkProvider extends ChangeNotifier {
  List<Network> _networks = [];
  Network _currentNetwork;

  List<Network> get networks => _networks;
  Network get currentNetwork => _currentNetwork;
  getNetworkData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var net = [
      sp.getString('network_id'),
      sp.getString('network_name'),
      sp.getString('network_ip_address'),
      sp.getString('network_port')
    ];
    return net;
  }

  //////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_id');
  }

///////save network///////
  Future<void> showNetworks() async {
    var userid = await getUserData();
    print('NETWORKS');
    final dataList = await DbHelper.getNetworks(userid);
    print(dataList);
    _networks = [];
    if (dataList != null) {
      _networks = dataList
          .map((item) => Network(
                name: item.name,
                id: item.id,
                ipAddress: item.ipAddress,
                portNo: item.portNo,
                chain: item.chain,
                status: item.status,
              ))
          .toList();
    }
    notifyListeners();
  }

/////////insert//////////
  Future<void> insertDefaultNetwork() async {
    var userId = await getUserData();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    Network nModel = Network(
        name: "Dinari",
        ipAddress: "161.35.23.208",
        chain: 1214,
        portNo: "8545",
        status: "active",
        userId: userId);
    print('DEF NET ADDED');
    DbHelper.addNetwork(nModel).then((value) {
      if (value != null) {
        sp.setString("network_id", value.toString());
        sp.setString("network_name", 'Dinari');
        sp.setString("network_ip_address", "161.35.23.208");
        sp.setString("network_port", "8545");
        sp.setString("network_status", "active");
        notifyListeners();
      }
    });
    notifyListeners();
  }

  /////////insert//////////
  Future<void> insertNewNetwork(
      {@required String name,
      @required String ipaddress,
      @required String port,
      @required String chain}) async {
    var userId = await getUserData();
    Network nModel = Network(
      name: name,
      ipAddress: ipaddress,
      chain: int.parse(chain),
      portNo: port,
      status: 'inactive',
      userId: userId,
    );
    print('NEW NET ADDED');
    DbHelper.addNetwork(nModel).then((value) {
      if (value != null) {
        notifyListeners();
      }
    });
    notifyListeners();
  }

  setCurrentNetwork(String id) async {
    final net = await DbHelper.getSingleNetwork(id);
    _currentNetwork = Network.fromMap(net);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("network_id", id);
    sp.setString("network_name", _currentNetwork.name);
    sp.setString("network_ip_address", _currentNetwork.ipAddress);
    sp.setString("network_port", _currentNetwork.portNo);
    await DbHelper.updateNetworkStatus(id);
    notifyListeners();
  }
}
