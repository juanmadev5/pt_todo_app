import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/domain/usecases/get_tasks_use_case.dart';
import 'package:pt_todo_app/domain/usecases/save_task_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTasksUseCase _getTasksUseCase;
  final SaveTaskUseCase _saveTaskUseCase;

  HomeCubit({
    required GetTasksUseCase getTasksUseCase,
    required SaveTaskUseCase saveTaskUseCase,
  }) : _getTasksUseCase = getTasksUseCase,
       _saveTaskUseCase = saveTaskUseCase,
       super(HomeInitial());

  Future<void> loadTasks({bool isRefresh = false}) async {
    if (!isRefresh) emit(HomeLoading());
    try {
      final tasks = await _getTasksUseCase(forceRefresh: isRefresh);
      emit(HomeSuccess(tasks));
    } catch (e) {
      emit(HomeError("Error al cargar tareas"));
    }
  }

  Future<void> addTask(String title) async {
    try {
      final newTask = TaskEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        isCompleted: false,
      );

      await _saveTaskUseCase(newTask);
      await loadTasks();
    } catch (e) {
      emit(HomeError("No se pudo guardar la tarea"));
    }
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    try {
      final updatedTask = TaskEntity(
        id: task.id,
        title: task.title,
        isCompleted: !task.isCompleted,
      );

      await _saveTaskUseCase(updatedTask);

      await loadTasks();
    } catch (e) {
      emit(HomeError("No se pudo actualizar la tarea"));
    }
  }
}
