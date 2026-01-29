import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskEntity>> call({bool forceRefresh = false}) async {
    return await repository.getTasks(forceRefresh: forceRefresh);
  }
}
