import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/qritem.dart' show QrItem;
import '../ui/home/model.dart';
import '../ui/home/view.dart';
import '../ui/qritem/model.dart';
import '../ui/qritem/view.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          HomeView(model: context.read<HomeViewModel>()..load()),
      routes: [
        GoRoute(
          path: 'qritem',
          builder: (context, state) => QrItemView(
            item: GoRouterState.of(context).extra! as QrItem,
            model: context.read<QrItemViewModel>(),
          ),
        ),
      ],
    ),
  ],
);
