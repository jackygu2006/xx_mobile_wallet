// $$$$$$ AdBanner 广告Banner
import 'dart:async';

import 'package:polkawallet_ui/utils/index.dart';
import 'package:wallet/common/consts.dart';
import 'package:wallet/service/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';

class AdBanner extends StatefulWidget {
  AdBanner(this.service, this.connectedNode, this.changeToKusama,
      {this.canClose = false});

  final AppService service;
  final NetworkParams connectedNode;
  final bool canClose;
  final Future<void> Function() changeToKusama;

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  Future<void> _goToBanner(BuildContext context) async {
    UI.launchURL('https://xx.network');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        GestureDetector(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Image.asset('assets/images/public/banner.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => _goToBanner(context),
        ),
        widget.canClose
            ? Container(
                padding: EdgeInsets.only(top: 18, right: 20),
                child: GestureDetector(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white60,
                    size: 24,
                  ),
                  onTap: () {
                    widget.service.store.storage
                        .write(show_banner_status_key, 'closed');
                    widget.service.store.account.setBannerVisible(false);
                  },
                ),
              )
            : Container()
      ],
    );
  }
}
