import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite_app/core/helper/database.dart';
import 'package:sqflite_app/feature/data/model/datamodel.dart';

part 'delete_task_state.dart';

class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  DatabaseHelper databaseHelper;
  DeleteTaskCubit(this.databaseHelper) : super(DeleteTaskInitial());

  void deleteTask(Datamodel datamodel) async {
    emit(DeleteTaskInitial());
    try {
      await databaseHelper.deleteTask(
        datamodel.id!,
      );
      emit(DeleteTaskSuccess());
    } catch (e) {
      emit(DeleteTaskFailure(message: e.toString()));
    }
  }
}
