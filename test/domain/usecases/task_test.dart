import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/domain/repositories/task_repository.dart';
import 'package:pt_todo_app/domain/usecases/get_tasks_use_case.dart';
import 'package:pt_todo_app/domain/usecases/save_task_use_case.dart';

// archivo que generará build_runner (dart run build_runner build)
import 'task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late GetTasksUseCase getTasksUseCase;
  late SaveTaskUseCase saveTaskUseCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    getTasksUseCase = GetTasksUseCase(mockRepository);
    saveTaskUseCase = SaveTaskUseCase(mockRepository);
  });

  final tTask = TaskEntity(id: 1, title: 'Test Task', isCompleted: false);
  final tTasksList = [tTask];

  group('Task UseCases Tests con Mockito', () {
    test('Debe obtener la lista de tareas del repositorio', () async {
      // Configuramos el comportamiento del mock
      when(
        mockRepository.getTasks(forceRefresh: anyNamed('forceRefresh')),
      ).thenAnswer((_) async => tTasksList);

      final result = await getTasksUseCase();

      expect(result, tTasksList);
      verify(
        mockRepository.getTasks(forceRefresh: anyNamed('forceRefresh')),
      ).called(1);
    });

    test('Debe llamar al repositorio para guardar una tarea', () async {
      when(
        mockRepository.saveTask(any),
      ).thenAnswer((_) async => Future.value());

      await saveTaskUseCase(tTask);

      verify(mockRepository.saveTask(tTask)).called(1);
    });
  });
}
