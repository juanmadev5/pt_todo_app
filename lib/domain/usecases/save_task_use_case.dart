import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/domain/repositories/task_repository.dart';

class SaveTaskUseCase {
  final TaskRepository repository;

  SaveTaskUseCase(this.repository);

  Future<void> call(TaskEntity task) async {
    return await repository.saveTask(task);
  }
}
