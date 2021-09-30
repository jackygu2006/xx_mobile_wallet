import 'package:wallet/app.dart';
import 'package:wallet/common/consts.dart';
import 'package:wallet/common/types/pluginDisabled.dart';
import 'package:wallet/service/walletApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:polkawallet_plugin_acala/polkawallet_plugin_acala.dart';
// import 'package:polkawallet_plugin_bifrost/polkawallet_plugin_bifrost.dart';
// import 'package:polkawallet_plugin_chainx/polkawallet_plugin_chainx.dart';
// import 'package:polkawallet_plugin_edgeware/polkawallet_plugin_edgeware.dart';
// import 'package:polkawallet_plugin_karura/polkawallet_plugin_karura.dart';
import 'package:polkawallet_plugin_kusama/polkawallet_plugin_kusama.dart';
// import 'package:polkawallet_plugin_laminar/polkawallet_plugin_laminar.dart';
// import 'package:polkawallet_plugin_statemine/polkawallet_plugin_statemine.dart';
import 'package:polkawallet_plugin_xxnetwork/polkawallet_plugin_xxnetwork.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(get_storage_container);
  await Firebase.initializeApp();

  final plugins = [
    PluginKusama(name: 'polkadot'),
    PluginKusama(),
    PluginXxnetwork(name: 'protonet'),
    // PluginXxnetwork(name: 'xxnetwork'),
    // PluginKarura(),
    // PluginStatemine(),
    // PluginAcala(),
    // PluginBifrost(),
    // PluginChainX(),
    // PluginEdgeware(),
    // PluginLaminar(),
  ];

  final pluginsConfig = await WalletApi.getPluginsConfig();
  Map<String, bool> a = {"visible": true, 'enabled': true};
  pluginsConfig['protonet'] = a;
  pluginsConfig['xxnetwork'] = a;

  print(pluginsConfig);
  print(plugins);
  // {polkadot: {visible: true, enabled: true}, kusama: {visible: true, enabled: true}, karura: {visible: true, enabled: true}, statemine: {visible: true, enabled: true}, acala-tc6: {visible: true, enabled: true}, laminar-tc3: {visible: true, enabled: true}, edgeware: {visible: true, enabled: true}, chainx: {visible: true, enabled: true}, bifrost: {visible: true, enabled: true}}
  if (pluginsConfig != null) {
    plugins.removeWhere((i) => !pluginsConfig[i.basic.name]['visible']);
  }
  print(plugins);

  runApp(WalletApp(
      plugins,
      [
        PluginDisabled(
            'xxnetwork', Image.asset('assets/images/public/xxnetwork_gray.png'))
      ],
      BuildTargets.apk));
}
