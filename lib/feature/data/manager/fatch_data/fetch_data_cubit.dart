import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:voice_note_app/feature/data/repos/task_repository.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

part 'fetch_data_state.dart';

class FetchDataCubit extends Cubit<FetchDataState> {
  final TaskRepository taskRepository;
  FetchDataCubit(this.taskRepository) : super(FetchDataInitial());

  Future<void> fetchData() async {
    emit(FetchDataLoading());
    try {
      final List<Datamodel> tasks = await taskRepository.fetchTasks();
      emit(FetchDataSuccess(tasks: tasks));
    } catch (e) {
      emit(FetchDataError(message: e.toString()));
    }
  }
}
