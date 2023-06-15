import 'package:flutter/foundation.dart';

import '../Model/LedgerModel.dart';
import '../Utils/Constant.dart';

class ChangeStatusMoney extends ChangeNotifier {
  String userCd;

  bool payoutStatus = false;

  withdraw(String amount, dynamic addledger(LedgerModel ledMdl)) async {
    userCd = Constants.prefs.getString('logId');
    print("withdraw : " + userCd.toString());

    String amt = amount;

    print("Amt : " + amt);

    LedgerModel ledMdl = LedgerModel(
        val: '-' + amt,
        Amt: amt,
        Desc: "2",
        userCd: userCd,
        vchDate: DateTime.now().toString(),
        vchType: "21");
    addledger(ledMdl);

    notifyListeners();
  }

  isPayoutSuccessful(bool status) {
    payoutStatus = status;
    notifyListeners();
  }
}
