import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voice_note_app/feature/data/repos/task_repository.dart';
import 'package:voice_note_app/feature/data/manager/notifications/notification_cubit.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

part 'delete_task_state.dart';

class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  final TaskRepository taskRepository;
  final NotificationCubit notificationCubit;
  DeleteTaskCubit(this.taskRepository, this.notificationCubit)
      : super(DeleteTaskInitial());

  void deleteTask(Datamodel datamodel) async {
    emit(DeleteTaskInitial());
    try {
      await taskRepository.deleteTask(
        datamodel.id!,
      );
      await notificationCubit.cancelNotification(datamodel.id!);

      emit(DeleteTaskSuccess());
    } catch (e) {
      emit(DeleteTaskFailure(message: e.toString()));
    }
  }
}
