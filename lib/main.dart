import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pt_todo_app/core/colors.dart';
import 'package:pt_todo_app/data/datasources/local_data_source.dart';
import 'package:pt_todo_app/data/datasources/todo_data_source.dart';
import 'package:pt_todo_app/data/repositories/task_repository_impl.dart';
import 'package:pt_todo_app/domain/usecases/get_tasks_use_case.dart';
import 'package:pt_todo_app/domain/usecases/save_task_use_case.dart';
import 'package:pt_todo_app/presentation/home/bloc/home_cubit.dart';
import 'package:pt_todo_app/presentation/home/bloc/theme_cubit.dart';
import 'package:pt_todo_app/presentation/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final remoteDS = TodoDataSource();
  final localDS = LocalDataSource(sharedPreferences: prefs);

  final repository = TaskRepositoryImpl(
    remoteDataSource: remoteDS,
    localDataSource: localDS,
  );

  final getTasksUseCase = GetTasksUseCase(repository);
  final saveTaskUseCase = SaveTaskUseCase(repository);

  // proveemos el HomeCubit a todo el arbol de widgets
  // de esta forma todas las pantallas nuevas pueden ver el HomeCubit
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            getTasksUseCase: getTasksUseCase,
            saveTaskUseCase: saveTaskUseCase,
          )..loadTasks(), // apenas se crea el Cubit cargamos la lista de tareas.
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ), // cubit para controlar el modo claro/oscuro de la app
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TODO app',
          themeMode: mode,
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: mainColor, brightness: .light),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: .fromSeed(seedColor: mainColor, brightness: .dark),
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
