import 'package:ecodataatlas/constants/gaps.dart';
import 'package:ecodataatlas/constants/sizes.dart';
import 'package:ecodataatlas/features/settings/view_models/settings_view_model.dart';
import 'package:ecodataatlas/features/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = "home";
  static const String routeURL = "/home";
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onGearTap(BuildContext context) {
    context.pushNamed(SettingsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final viewMode = ref.watch(settingsProvider).viewmode;

    final isDark = ref.watch(settingsProvider).darkmode;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              centerTitle: true,
              leadingWidth: 100,
              leading: TextButton(
                onPressed: () => {},
                child: viewMode == "all"
                    ? Text("Everyone's Mood")
                    : Text("My Mood"),
              ),
              title: Text("🔥 Mood 🔥".toUpperCase()),

              actions: [
                GestureDetector(
                  onTap: () => _onGearTap(context),
                  child: Container(
                    height: (kToolbarHeight),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: Sizes.size20),
                    child: FaIcon(
                      FontAwesomeIcons.gear,
                      size: Sizes.size18,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(child: Gaps.v32),
            SliverToBoxAdapter(child: Text("Hello")),
          ],
        ),
      ),
    );
  }
}
