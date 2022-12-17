import 'package:auto_route/auto_route.dart';
import 'package:base_flutter_provider_project/routes/router_name.dart';
import 'package:base_flutter_provider_project/ui/home/home_screen.dart';
import 'package:base_flutter_provider_project/ui/splash/splash.dart';

import '../ui/home/products_by_categories.dart';

// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: RouterNames.splash,
      name: 'SplashRoute',
      page: Splash,
    ),
    AutoRoute(
      path: RouterNames.home,
      name: 'HomeRoute',
      page: HomePage,
    ),
    AutoRoute(
      path: RouterNames.product,
      name: 'ProductRoute',
      page: ProductPageByCategories,
    ),
  ],
)
class $AppRouter {}
