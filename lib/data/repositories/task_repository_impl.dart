import 'package:pt_todo_app/data/datasources/local_data_source.dart';
import 'package:pt_todo_app/data/datasources/todo_data_source.dart';
import 'package:pt_todo_app/data/models/task_model.dart';
import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TodoDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<TaskEntity>> getTasks({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final localTasks = await localDataSource.getCachedTasks();
      if (localTasks.isNotEmpty) return localTasks;
    }

    try {
      final remoteTasks = await remoteDataSource.fetchTasks();

      for (var task in remoteTasks) {
        await localDataSource.cacheTask(task);
      }

      return await localDataSource.getCachedTasks();
    } catch (e) {
      return await localDataSource.getCachedTasks();
    }
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
    );
    await localDataSource.cacheTask(model);
  }
}
