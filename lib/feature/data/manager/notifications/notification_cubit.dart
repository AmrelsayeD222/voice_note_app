import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:voice_note_app/core/helper/notification_service.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  // Can be injected, but for simplicity we use the singleton instance or pass it
  final NotificationService _notificationService = NotificationService();

  NotificationCubit() : super(NotificationInitial());

  Future<void> fetchPendingNotifications() async {
    emit(NotificationLoading());
    try {
      final pending = await _notificationService.getPendingNotifications();
      emit(NotificationLoaded(pending));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAll();
      emit(const NotificationLoaded([])); // Clear list after cancellation
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> manageTaskNotification(Datamodel task) async {
    if (task.reminder != null && task.reminder!.isNotEmpty) {
      try {
        final scheduledDate = DateTime.parse(task.reminder!);
        if (scheduledDate.isAfter(DateTime.now())) {
          await _notificationService.scheduleAtDateTime(scheduledDate);
        }
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
        emit(NotificationError('Error scheduling notification: $e'));
      }
    } else {
      await cancelNotification(task.id!);
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationService.cancel(id);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
