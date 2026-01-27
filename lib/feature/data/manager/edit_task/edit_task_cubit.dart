import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_app/core/helper/database.dart';
import 'package:sqflite_app/feature/data/model/datamodel.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final DatabaseHelper databaseHelper;
  EditTaskCubit(this.databaseHelper) : super(EditTaskInitial());

  void setInitialValues(Datamodel datamodel) {
    titleController.text = datamodel.title;
    descriptionController.text = datamodel.description;
  }

  Future<void> editTask(Datamodel datamodel) async {
    emit(EditTaskInitial());
    try {
      await databaseHelper.editTask(datamodel);

      emit(EditTaskSuccess());
    } catch (e) {
      emit(EditTaskFailure(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
