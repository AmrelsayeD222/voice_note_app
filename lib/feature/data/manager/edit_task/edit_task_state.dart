part of 'edit_task_cubit.dart';

sealed class EditTaskState extends Equatable {
  const EditTaskState();

  @override
  List<Object> get props => [];
}

final class EditTaskInitial extends EditTaskState {}

final class EditTaskSuccess extends EditTaskState {}

final class EditTaskFailure extends EditTaskState {
  final String message;
  const EditTaskFailure({required this.message});
}
