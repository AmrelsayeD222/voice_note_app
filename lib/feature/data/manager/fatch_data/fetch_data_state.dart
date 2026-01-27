part of 'fetch_data_cubit.dart';

@immutable
sealed class FetchDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class FetchDataInitial extends FetchDataState {}

final class FetchDataLoading extends FetchDataState {}

final class FetchDataSuccess extends FetchDataState {
  final List<Datamodel> tasks;
  FetchDataSuccess({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

final class FetchDataError extends FetchDataState {
  final String message;
  FetchDataError({required this.message});
}
