import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voice_note_app/core/helper/data_base_service.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final DataBaseService databaseHelper;
  AddTaskCubit(this.databaseHelper) : super(AddTaskInitial());

  Future<void> addTask(Datamodel datamodel) async {
    emit(AddTaskInitial());
    try {
      await databaseHelper.addTask(datamodel);
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
