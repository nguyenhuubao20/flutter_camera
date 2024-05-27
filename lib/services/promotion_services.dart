import 'package:smart_pos/utils/share_pref.dart';

import '../models/promotion_model.dart';
import '../utils/request.dart';

class PromotionServices {
  Future<List<PromotionPointify>> getListPromotionOfStore() async {
    String? storeId = await getStoreId();
    if (storeId == null) return [];
    final res = await request.get(
      'stores/$storeId/promotions',
    );
    var jsonList = res.data;
    List<PromotionPointify> listPromotion = [];
    for (var item in jsonList) {
      PromotionPointify res = PromotionPointify.fromJson(item);
      listPromotion.add(res);
    }
    return listPromotion;
  }
}
