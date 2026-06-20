import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:task_tracker/features/task/presentation/screens/form_task_screen.dart';
import 'package:task_tracker/features/task/presentation/screens/task_list_screen.dart';
import '../../providers/menu_provider.dart';
import '../widgets/menu_bottom_nav.dart';

class Menu extends ConsumerWidget {
  static const String routeName = "menu";

  const Menu({super.key});

  static const List<Widget> _screens = [TaskListScreen(), FormTaskScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(menuIndexProvider);

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _screens),
      bottomNavigationBar: buildListMenuBottomNavigation(
        context,
        selectedIndex,
        ref.read(menuIndexProvider.notifier).onItemTapped,
      ),
    );
  }
}
