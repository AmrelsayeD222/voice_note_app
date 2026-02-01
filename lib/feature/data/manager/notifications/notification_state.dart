part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  final List<String> notifications;
  const NotificationState([this.notifications = const []]);

  @override
  List<Object> get props => [notifications];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial([super.notifications = const []]);
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading([super.notifications]);
}

final class NotificationFetchedSuccess extends NotificationState {
  const NotificationFetchedSuccess(super.notifications);
}

final class NotificationScheduledSuccess extends NotificationState {
  const NotificationScheduledSuccess([super.notifications]);
}

final class NotificationCancelledSuccess extends NotificationState {
  const NotificationCancelledSuccess([super.notifications]);
}

final class NotificationShowDialogSuccess extends NotificationState {
  const NotificationShowDialogSuccess(super.notifications);
}

final class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message, [super.notifications = const []]);

  @override
  List<Object> get props => [message, notifications];
}
