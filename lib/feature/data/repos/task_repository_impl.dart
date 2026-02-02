import 'package:voice_note_app/core/helper/data_base_service.dart';
import '../model/datamodel.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseService _databaseService;

  TaskRepositoryImpl(this._databaseService);

  @override
  Future<void> addTask(Datamodel datamodel) async {
    await _databaseService.addTask(datamodel);
  }

  @override
  Future<List<Datamodel>> fetchTasks() async {
    return await _databaseService.fetchTasks();
  }

  @override
  Future<int> editTask(Datamodel datamodel) async {
    return await _databaseService.editTask(datamodel);
  }

  @override
  Future<int> deleteTask(int id) async {
    return await _databaseService.deleteTask(id);
  }
}
