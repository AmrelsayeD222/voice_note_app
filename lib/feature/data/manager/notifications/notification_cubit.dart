import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:voice_note_app/core/helper/data_base_service.dart';
import 'package:voice_note_app/core/helper/notification_service.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final DatabaseService databaseHelper;
  final NotificationService _notificationService = NotificationService();

  NotificationCubit(this.databaseHelper) : super(const NotificationInitial());

  Future<void> fetchPendingNotifications() async {
    emit(NotificationLoading(state.notifications));
    try {
      final pending = await _notificationService.getPendingNotifications();
      emit(NotificationFetchedSuccess(pending));
    } catch (e) {
      emit(NotificationError(e.toString(), state.notifications));
    }
  }

  Future<void> viewPendingNotifications() async {
    emit(NotificationLoading(state.notifications));
    try {
      final pending = await _notificationService.getPendingNotifications();
      emit(NotificationShowDialogSuccess(pending));
    } catch (e) {
      emit(NotificationError(e.toString(), state.notifications));
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAll();
      final pending = await _notificationService.getPendingNotifications();
      emit(NotificationCancelledSuccess(pending));
    } catch (e) {
      emit(NotificationError(e.toString(), state.notifications));
    }
  }

  Future<void> manageTaskNotification(Datamodel task) async {
    if (task.reminder != null && task.reminder!.isNotEmpty) {
      try {
        final scheduledDate = DateTime.parse(task.reminder!);
        if (scheduledDate.isAfter(DateTime.now())) {
          List<String> words = task.title.trim().split(RegExp(r'\s+'));
          String displayTitle =
              words.length > 2 ? '${words.take(2).join(' ')}...' : task.title;

          await _notificationService.scheduleAtDateTime(
              scheduledDate, task.id!, displayTitle);
        }
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
        emit(NotificationError(
            'Error scheduling notification: $e', state.notifications));
      }
    } else {
      await cancelNotification(task.id!);
    }
  }

  Future<void> makeNotification(Datamodel datamodel) async {
    emit(NotificationLoading(state.notifications));
    try {
      await databaseHelper.editTask(datamodel);
      await manageTaskNotification(datamodel);

      final pending = await _notificationService.getPendingNotifications();
      emit(NotificationScheduledSuccess(pending));
    } catch (e) {
      emit(NotificationError(e.toString(), state.notifications));
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationService.cancel(id);
      final pending = await _notificationService.getPendingNotifications();
      emit(NotificationFetchedSuccess(pending));
    } catch (e) {
      emit(NotificationError(e.toString(), state.notifications));
    }
  }
}
