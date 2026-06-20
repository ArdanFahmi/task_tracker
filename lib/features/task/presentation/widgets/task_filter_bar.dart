import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/widgets/main_chips.dart';
import 'package:task_tracker/features/task/providers/task_filter_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/enums/task_status.dart';

class TaskFilterBar extends ConsumerWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(taskFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            ref,
            label: "All",
            isSelected: selectedFilter == null,
            onTap: () => ref.read(taskFilterProvider.notifier).setFilter(null),
          ),
          const SizedBox(width: 8),
          ...TaskStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
                ref,
                label: status.label,
                isSelected: selectedFilter == status,
                onTap: () => ref.read(taskFilterProvider.notifier).setFilter(status),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(WidgetRef ref, {required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: MainChips(
        title: label,
        colorBadge: isSelected ? AppColors.primaryColor : Colors.transparent,
        colorTitle: isSelected ? AppColors.secondaryColor : AppColors.neutralColor,
        paddingHorizontal: 24,
        paddingVertical: 8,
        radius: 8,
        enableBorder: !isSelected,
        borderColor: AppColors.borderPrimary,
      ),
    );
  }
}
