
import 'package:frontend/intro/login.dart';
import 'package:frontend/intro/signup.dart';
import 'package:go_router/go_router.dart';


class AuthRoute {
  GoRoute getSignupRoute() {
    return GoRoute(path: 'signup', builder: (context, state) => const Signup());
  }

  GoRoute getLoginRoute() {
    return GoRoute(path: 'login', builder: (context, state) => const Login());
  }
}
