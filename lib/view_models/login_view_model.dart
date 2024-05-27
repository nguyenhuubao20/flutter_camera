import 'package:get/get.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/models/account_model.dart';
import 'package:smart_pos/models/login_model.dart';
import 'package:smart_pos/services/account_services.dart';
import 'package:smart_pos/utils/share_pref.dart';
import 'package:smart_pos/view_models/index.dart';

import '../enums/status_enums.dart';
import '../utils/routes_constraints.dart';
import '../widgets/dialog.dart';

class LoginViewModel extends Model {
  AccountServices accountServices = AccountServices();
  AccountModel? accountModel;
  ViewStatus status = ViewStatus.Completed;
  late String? msg;

  void setState(ViewStatus newState, [String? msg]) {
    status = newState;
    msg = msg;
    notifyListeners();
  }

  void posLogin(String userName, String password) async {
    try {
      setState(ViewStatus.Loading);
      showLoadingDialog();
      accountServices
          .login(LoginModel(username: userName, password: password))
          .then((value) async => {
                accountModel = value,
                if (accountModel == null)
                  {
                    setState(ViewStatus.Error),
                    hideDialog(),
                    showAlertDialog(
                        title: "Đăng nhập thất bại",
                        content: "Vui lòng kiểm tra lại tài khoản và mật khẩu")
                  }
                else
                  {
                    await Get.find<MenuViewModel>().getMenuOfStore(),
                    await Get.find<CartViewModel>().getListPromotion(),
                    Get.offAllNamed(RouteHandler.HOME),
                    setState(ViewStatus.Completed),
                    hideDialog(),
                  }
              });
    } catch (e) {
      hideDialog();
      setState(ViewStatus.Error);
    }
  }

  Future<void> logout() async {
    Get.snackbar("Đăng xuất", "Đăng xuất thành công");
    // Get.find<CartViewModel>().clearCartData();
    await deleteToken();
    await Get.offAllNamed(RouteHandler.LOGIN);
  }
}
