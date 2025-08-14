import 'package:ecodataatlas/features/authentication/repos/authentication_repo.dart';
import 'package:ecodataatlas/features/authentication/views/login_screen.dart';
import 'package:ecodataatlas/features/authentication/views/sign_up_screen.dart';
import 'package:ecodataatlas/features/home/views/home_screen.dart';
import 'package:ecodataatlas/features/settings/views/settings_screen.dart';
import 'package:ecodataatlas/features/users/views/user_profile_screen.dart';
import 'package:ecodataatlas/router/router_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: "/home",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeURL &&
            state.matchedLocation != LoginScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: SignUpScreen.routeURL,
        name: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeURL,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteURL.home,
        name: RouteName.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/profile/:username",
        name: UserProfileScreen.routeName,
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          final tab = state.uri.queryParameters['tab'] ?? "";
          return UserProfileScreen(username: username, tab: tab);
        },
      ),
      GoRoute(
        path: RouteURL.settings,
        name: RouteName.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
