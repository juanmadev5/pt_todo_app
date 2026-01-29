import 'package:pt_todo_app/domain/entities/task_entity.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<TaskEntity> tasks;
  HomeSuccess(this.tasks);
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
