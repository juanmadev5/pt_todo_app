import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks({bool forceRefresh = false});

  Future<void> saveTask(TaskEntity task);
}
