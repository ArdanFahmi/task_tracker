import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/error/failure.dart';
import 'package:task_tracker/core/utils/input_decoration_helper.dart';
import 'package:task_tracker/core/widgets/custom_appbar.dart';
import 'package:task_tracker/core/widgets/custom_button.dart';
import 'package:task_tracker/core/widgets/custom_snackbar.dart';
import 'package:task_tracker/features/task/data/models/task.dart';
import 'package:task_tracker/features/task/providers/task_form_submitting_provider.dart';
import 'package:task_tracker/features/task/providers/task_notifier.dart';
import 'package:task_tracker/shared/enums/task_status.dart';
import 'package:toastification/toastification.dart';

class FormTaskScreen extends ConsumerStatefulWidget {
  final Task? existingTask; // null = mode add, non-null mode edit
  const FormTaskScreen({super.key, this.existingTask});

  bool get isEditMode => existingTask != null;

  @override
  ConsumerState<FormTaskScreen> createState() => _FormTaskScreenState();
}

class _FormTaskScreenState extends ConsumerState<FormTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  final _titleFocusNode = FocusNode();

  TextEditingController _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  TaskStatus _selectedStatus = TaskStatus.todo;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _selectedStatus = task?.status ?? TaskStatus.todo;
    _startDate = task?.startDate;
    _endDate = task?.endDate;
    _startDateController = TextEditingController(text: _formatDate(_startDate));
    _endDateController = TextEditingController(text: _formatDate(_endDate));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  bool get _isOverdue {
    final task = widget.existingTask;
    if (task == null) return false;
    if (task.status == TaskStatus.done) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
    return end.isBefore(today);
  }

  bool get _isDone => widget.existingTask?.status == TaskStatus.done;

  bool get _isDateLocked => _isOverdue || _isDone;

  bool get _isStatusLocked => _isDone;

  Future<void> _pickDate({required bool isStartDate}) async {
    final initial = isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? _startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
          _endDateController.text = '';
        }
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      showCustomSnackbar("Failed to save task", "Start date and end date are required", ToastificationType.error);
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      showCustomSnackbar("Failed to save task", "End date must be after start date", ToastificationType.error);
      return;
    }

    ref.read(taskFormSubmittingProvider.notifier).setSubmitting(true);

    try {
      if (widget.isEditMode) {
        final existing = widget.existingTask!;
        final updated = existing.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: _isDateLocked ? existing.startDate : _startDate,
          endDate: _isDateLocked ? existing.endDate : _endDate,
          status: _isStatusLocked ? existing.status : _selectedStatus,
        );
        await ref.read(taskProvider.notifier).updateTask(updated);

        if (!mounted) return;

        showCustomSnackbar("Success", "Task updated successfully", ToastificationType.success);
        Navigator.pop(context);
      } else {
        final newTask = Task(
          id: '',
          userId: '',
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          status: _selectedStatus,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(taskProvider.notifier).addTask(newTask);
        showCustomSnackbar("Success", "Task added successfully", ToastificationType.success);
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackbar("Failed to save task", getThrowErrorMsg(e), ToastificationType.error);
      }
    } finally {
      ref.read(taskFormSubmittingProvider.notifier).setSubmitting(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "TaskFlow",
        onBackPressed: () {
          Navigator.pop(context);
        },
        enableBackPressed: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditMode ? "Edit Task" : "New Task",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
              ),
              const SizedBox(height: 8),
              Text(
                "Capture what needs to be done. Keep it simple and focused.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.neutralColor),
              ),
              const SizedBox(height: 20),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final isSubmitting = ref.watch(taskFormSubmittingProvider);

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: AppColors.borderPrimary, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task Title', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
              decoration: buildInputDecoration(hintText: 'e.g. Design new landing page'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter task title';
                }
                return null;
              },
              onTapOutside: (event) {
                _titleFocusNode.unfocus();
              },
            ),
            const SizedBox(height: 16),
            Text('Desscription', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              minLines: 1,
              maxLines: null,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
              decoration: buildInputDecoration(hintText: "Add some detail about this task"),
              onTapOutside: (event) {
                _descriptionFocusNode.unfocus();
              },
            ),
            const SizedBox(height: 16),
            Text('Initial Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskStatus>(
              initialValue: _selectedStatus,
              onChanged: _isStatusLocked
                  ? null
                  : (value) {
                      if (value != null) setState(() => _selectedStatus = value);
                    },
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _isStatusLocked ? AppColors.darkTertiary : AppColors.neutralColor,
              ),
              decoration: buildInputDecoration(hintText: 'Select status').copyWith(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                fillColor: _isStatusLocked ? AppColors.borderPrimary.withValues(alpha: 0.1) : null,
                filled: _isStatusLocked,
              ),
              items: TaskStatus.values.map((status) {
                return DropdownMenuItem(value: status, child: Text(status.label));
              }).toList(),
              validator: (value) {
                if (value == null) return 'Please select status';
                return null;
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(SolarIconsBold.altArrowDown, color: AppColors.darkTertiary, size: 18),
              ),
            ),
            if (_isDone)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'This task is already done and cannot be changed.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.darkTertiary),
                ),
              ),
            const SizedBox(height: 16),
            Text('Start Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _startDateController,
              readOnly: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _isDateLocked ? AppColors.darkTertiary : AppColors.neutralColor,
              ),
              decoration: buildInputDecoration(hintText: 'Select start date').copyWith(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(SolarIconsOutline.calendarMinimalistic, size: 18, color: AppColors.darkTertiary),
                ),
                fillColor: _isDateLocked ? AppColors.borderPrimary.withValues(alpha: 0.1) : null,
                filled: _isDateLocked,
              ),
              onTap: _isDateLocked ? null : () => _pickDate(isStartDate: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please select start date';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('End Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _endDateController,
              readOnly: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _isDateLocked ? AppColors.darkTertiary : AppColors.neutralColor,
              ),
              decoration: buildInputDecoration(hintText: 'Select end date').copyWith(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(SolarIconsOutline.calendarMinimalistic, size: 18, color: AppColors.darkTertiary),
                ),
                fillColor: _isDateLocked ? AppColors.borderPrimary.withValues(alpha: 0.1) : null,
                filled: _isDateLocked,
              ),
              onTap: _isDateLocked ? null : () => _pickDate(isStartDate: false),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please select end date';
                return null;
              },
            ),
            if (_isOverdue)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'This task is overdue. Date cannot be changed.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.error500),
                ),
              ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                _handleSubmit();
              },
              title: widget.isEditMode ? "Update Task" : "Add Task",
              btnColor: AppColors.primaryColor,
              colorTitle: AppColors.secondaryColor,
              paddingVerticalContent: 16,
              fontSize: 16,
              isLoading: isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}
