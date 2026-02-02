import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voice_note_app/feature/data/repos/task_repository.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final TaskRepository taskRepository;
  AddTaskCubit(this.taskRepository) : super(AddTaskInitial());

  Future<void> addTask(Datamodel datamodel) async {
    emit(AddTaskInitial());
    try {
      await taskRepository.addTask(datamodel);
      emit(AddTaskSuccess());
      titleController.clear();
      descriptionController.clear();
    } catch (e) {
      emit(AddTaskFailure(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
