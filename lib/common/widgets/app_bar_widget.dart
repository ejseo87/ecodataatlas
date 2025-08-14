import 'package:ecodataatlas/constants/sizes.dart';
import 'package:ecodataatlas/features/settings/view_models/settings_view_model.dart';
import 'package:ecodataatlas/features/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final bool showGear;
  const AppBarWidget({super.key, required this.showGear});

  void _onGearTap(BuildContext context) {
    context.pushNamed(SettingsScreen.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(settingsProvider).darkmode;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text("🌏 EcoDataAtlas 🌏".toUpperCase()),
      actions: showGear
          ? [
              GestureDetector(
                onTap: () => _onGearTap(context),
                child: Container(
                  height: (kToolbarHeight),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: Sizes.size20),
                  child: FaIcon(
                    FontAwesomeIcons.gear,
                    size: Sizes.size18,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
