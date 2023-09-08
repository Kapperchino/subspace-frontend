import 'package:frontend/notification/notificationPage.dart';
import 'package:go_router/go_router.dart';

class NotificationRoute {
  GoRoute getNotificationRoute() {
    return GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationPage());
  }
}
