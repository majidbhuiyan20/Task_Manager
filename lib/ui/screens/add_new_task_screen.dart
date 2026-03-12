import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../widgets/snack_bar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const String name = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(isAddNewTaskScreen: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.add_task_rounded,
                      size: 36,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Fill in the details below to create a new task",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: "Task title",
                      prefixIcon: Icon(Icons.title_rounded,
                          color: AppColors.textHint, size: 22),
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Task description",
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 96),
                        child: Icon(Icons.description_outlined,
                            color: AppColors.textHint, size: 22),
                      ),
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                    child: FilledButton(
                      onPressed: _onTapAddButton,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, size: 22),
                          SizedBox(width: 8),
                          Text("Create Task"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});

    Map<String, dynamic> bodyRequest = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "status": "New",
    };

    ApiResponse response = await ApiCaller.postRequest(
      url: Urls.createTask,
      body: bodyRequest,
    );
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextField();
      showSnackBarMessage(
          context, "Task added successfully", AppColors.statusCompleted);
    } else {
      showSnackBarMessage(
          context, response.errorMessage!, AppColors.statusCancelled);
    }
  }

  void _clearTextField() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
