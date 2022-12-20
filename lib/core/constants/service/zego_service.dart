
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hellozegocloud/core/constants/secret_keys.dart';
import 'package:hellozegocloud/core/constants/service/handler/generate_token.dart';
import 'package:hellozegocloud/core/providers/zego_result_provider.dart';
import 'package:provider/provider.dart';
import 'package:zego_zim/zego_zim.dart';

class ZegoLoginService {
  ZIMUserInfo userInfo = ZIMUserInfo();
  final SecretConstants _constants = SecretConstants();
  List<String> invitees = []; // The list of the callee.

  createZegoConfig() {
    ZIMAppConfig appConfig = ZIMAppConfig();
    appConfig.appID = _constants.appId;
    appConfig.appSign = _constants.appSign;

    ZIM.create(appConfig);
  }

  logoutZego() {
    ZIM.getInstance()!.logout();
    print("ZımInfo $userInfo");
  }

  loginWithZego() async {
    userInfo.userName = "newName";
    userInfo.userID = "12345";

    await createZegoConfig();

    ZIM.getInstance()!.login(userInfo).then((value) {
      value;
    }).catchError((onError) {
      switch (onError.runtimeType) {
        //This will be triggered when login failed.
        case PlatformException:
          print(onError.code); //Return the error code when login failed.
          print(onError.message!); // Return the error indo when login failed.
          break;
        default:
      }
    });
  }

  loginWithZego2() async {
    userInfo.userName = "newName";
    userInfo.userID = "123456";

    String token = GenerateToken().generateToken();

    await createZegoConfig();

    ZIM.getInstance()!.login(userInfo, token).then((value) {
      value;
    }).catchError((onError) {
      print(onError.toString());
      switch (onError.runtimeType) {
        //This will be triggered when login failed.
        case PlatformException:
          print(onError.code); //Return the error code when login failed.
          print(onError.message!); // Return the error indo when login failed.
          break;
        default:
      }
    });
  }

  inviteZego(BuildContext context) {
    ZegoProvider zegoProvider =
        Provider.of<ZegoProvider>(context, listen: false);
    invitees.add("12345");
    ZIMCallInviteConfig callInviteConfig = ZIMCallInviteConfig();
    callInviteConfig.timeout = 200;

    ZIM
        .getInstance()!
        .callInvite(invitees, callInviteConfig)
        .then((value) =>
            {zegoProvider.callId = value.callID, zegoProvider.notify()})
        .catchError((onError) {
      print(onError.toString());
    });
  }

  acceptIniviteZego(BuildContext context) {
    ZegoProvider zegoProvider =
        Provider.of<ZegoProvider>(context, listen: false);
    ZIMCallAcceptConfig callAcceptConfig = ZIMCallAcceptConfig();
    ZIM
        .getInstance()!
        .callAccept(zegoProvider.callId, callAcceptConfig)
        .then((value) => {print(value.callID)})
        .catchError((onError) {});

    ZIMEventHandler.onCallInvitationAccepted = (info, callID, i) {
      print('Invitation Accepted: $info');
    };
  }
}
