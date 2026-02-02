import '../model/datamodel.dart';

abstract class TaskRepository {
  Future<void> addTask(Datamodel datamodel);
  Future<List<Datamodel>> fetchTasks();
  Future<int> editTask(Datamodel datamodel);
  Future<int> deleteTask(int id);
}
