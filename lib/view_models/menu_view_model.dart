import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/enums/status_enums.dart';

import '../enums/product_enum.dart';
import '../models/index.dart';
import '../services/index.dart';
import 'cart_view_model.dart';

class MenuViewModel extends Model {
  late Menu? currentMenu;
  MenuData? menuData;

  List<Product>? normalProducts = [];
  List<Category>? categories = [];
  List<Category>? subCategories = [];
  List<Product>? extraProducts = [];
  List<Product>? childProducts = [];
  List<Product>? productsFilter = [];
  ViewStatus status = ViewStatus.Completed;

  MenuViewModel() {
    menuData = MenuData();
    currentMenu = Menu();
  }

  void setState(ViewStatus newState, [String? msg]) {
    status = newState;
    msg = msg;
    notifyListeners();
  }

  Future<void> getMenuOfStore() async {
    try {
      currentMenu = await menuData?.getMenuOfStore();
      Get.find<CartViewModel>().getListPromotion();

      categories = currentMenu?.categories!
          .where((element) => element.type == CategoryTypeEnum.Normal)
          .toList();
      categories?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
      subCategories = currentMenu?.categories!
          .where((element) => element.type == CategoryTypeEnum.Child)
          .toList();
      subCategories?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
      normalProducts = currentMenu?.products!
          .where((element) =>
              element.type == ProductTypeEnum.SINGLE ||
              element.type == ProductTypeEnum.PARENT ||
              element.type == ProductTypeEnum.COMBO)
          .toList();
      extraProducts = currentMenu?.products!
          .where((element) => element.type == ProductTypeEnum.EXTRA)
          .toList();
      childProducts = currentMenu?.products!
          .where((element) => element.type == ProductTypeEnum.CHILD)
          .toList();
      productsFilter = normalProducts;
      handleChangeFilterProductByCategory(categories![0].id);
      productsFilter
          ?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void handleChangeFilterProductByCategory(String? categoryId) {
    if (categoryId == null) {
      productsFilter = normalProducts;
      productsFilter
          ?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
      notifyListeners();
    } else {
      productsFilter = normalProducts
          ?.where((element) => element.categoryId == categoryId)
          .toList();
      productsFilter
          ?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
      notifyListeners();
    }
  }

  List<Product>? getChildProductByParentProduct(String? productId) {
    List<Product> listChilds = childProducts!
        .where((element) => element.parentProductId == productId)
        .toList();

    List<Product> listChildsSorted = [];
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.SMALL) {
        listChildsSorted.add(item);
      }
    }
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.MEDIUM) {
        listChildsSorted.add(item);
      }
    }
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.LARGE) {
        listChildsSorted.add(item);
      }
    }
    return listChildsSorted;
  }

  List<Category>? getChildCategory(Category? cate) {
    List<Category>? listSubCate = [];
    subCategories?.forEach((element) {
      if (cate!.childCategoryIds!.any((e) => e == element.id)) {
        listSubCate.add(element);
      }
    });
    return listSubCate;
  }

  List<GroupProducts>? getGroupProductByComboProduct(String productId) {
    List<GroupProducts> listGroupProducts = [];
    if (currentMenu?.groupProducts == null) {
      return [];
    } else {
      for (GroupProducts item in currentMenu!.groupProducts!) {
        if (item.comboProductId == productId) {
          listGroupProducts.add(item);
        }
      }
      listGroupProducts.sort((a, b) => b.priority!.compareTo(a.priority!));
      return listGroupProducts;
    }
  }

  List<Product>? getExtraProductByNormalProduct(Product product) {
    return extraProducts
        ?.where(
            (element) => product.extraCategoryIds!.contains(element.categoryId))
        .toList();
  }

  List<Category>? getExtraCategoryByNormalProduct(String productMenuId) {
    List<Category> listExtraCategory = [];
    Product? product = normalProducts
        ?.firstWhereOrNull((element) => element.menuProductId == productMenuId);
    for (Category item in currentMenu!.categories!) {
      if (product!.extraCategoryIds!.contains(item.id)) {
        listExtraCategory.add(item);
      }
    }
    listExtraCategory
        .sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
    return listExtraCategory;
  }

  List<Category>? getExtraCategoryByChildProduct(String parentProductId) {
    List<Category> listExtraCategory = [];
    Product? product = normalProducts
        ?.firstWhereOrNull((element) => element.id == parentProductId);
    for (Category item in currentMenu!.categories!) {
      if (product!.extraCategoryIds!.contains(item.id)) {
        listExtraCategory.add(item);
      }
    }
    return listExtraCategory;
  }

  List<Product> getProductsByCategory(String? categoryId) {
    return extraProducts!
        .where((element) => element.categoryId == categoryId)
        .toList();
  }

  List<ProductsInGroup> getListProductInGroup(String? groupId) {
    List<ProductsInGroup> listProductInGroup = [];
    if (currentMenu!.productsInGroup == null) {
      return [];
    } else {
      for (ProductsInGroup item in currentMenu!.productsInGroup!) {
        if (item.groupProductId == groupId) {
          listProductInGroup.add(item);
        }
      }
      return listProductInGroup;
    }
  }

  Product getProductById(String id) {
    return currentMenu!.products!.firstWhere((element) => element.id == id);
  }
}
