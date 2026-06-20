import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuIndexProvider = NotifierProvider<MenuIndexNotifier, int>(MenuIndexNotifier.new);

class MenuIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void onItemTapped(int index) {
    state = index;
  }
}
