import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/constants/connection_checker.dart';
import 'package:blog_app/core/constants/db_linkup.dart';
import 'package:blog_app/features/ai_assistant/data/ai_remote_data_source.dart';
import 'package:blog_app/features/ai_assistant/data/ai_repository_impl.dart';
import 'package:blog_app/features/ai_assistant/data/ai_repository.dart';
import 'package:blog_app/features/ai_assistant/data/send_message.dart';
import 'package:blog_app/features/ai_assistant/presentation/bloc/ai_bloc.dart';
import 'package:blog_app/features/auth/data/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/auth_repository.dart';
import 'package:blog_app/features/auth/domain/auth_usecases.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/posts/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/posts/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/posts/data/datasources/blog_repository_impl.dart';
import 'package:blog_app/features/posts/domain/post_repository.dart';
import 'package:blog_app/features/posts/domain/post_usecases.dart';
import 'package:blog_app/features/posts/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/activity_tracking/data/activity_local_data_source.dart';
import 'package:blog_app/features/activity_tracking/data/activity_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  debugPrint('Starting initDependencies...');

  // 1. Initialize Supabase
  try {
    debugPrint('Initializing Supabase...');
    final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnonKey,
    );
    serviceLocator.registerLazySingleton(() => supabase.client);
    debugPrint('Supabase initialized.');
  } catch (e) {
    debugPrint('Supabase init failed: $e');
  }

  // 2. Initialize Hive
  try {
    debugPrint('Initializing Hive...');
    final appDir = await getApplicationDocumentsDirectory();
    Hive.defaultDirectory = appDir.path;
    
    final blogsBox = Hive.box(name: 'blogs');
    final activityBox = Hive.box(name: 'activity');

    serviceLocator.registerLazySingleton<Box>(() => blogsBox, instanceName: 'blogsBox');
    serviceLocator.registerLazySingleton<Box>(() => activityBox, instanceName: 'activityBox');
    debugPrint('Hive initialized.');
  } catch (e) {
    debugPrint('Hive init failed: $e');
    // Register fallbacks
    serviceLocator.registerLazySingleton<Box>(() => Hive.box(name: 'blogs'), instanceName: 'blogsBox');
    serviceLocator.registerLazySingleton<Box>(() => Hive.box(name: 'activity'), instanceName: 'activityBox');
  }

  // 3. Register Core Features
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );

  _initAuth();
  _initBlog();
  _initAiAssistant();
  _initActivityTracking();
  
  debugPrint('initDependencies completed.');
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserLogout(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        userLogout: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(serviceLocator(instanceName: 'blogsBox')),
    )
    ..registerFactory<PostRepository>(
      () => PostRepositoryImpl(serviceLocator(), serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => UploadPost(serviceLocator()))
    ..registerFactory(() => GetAllPosts(serviceLocator()))
    ..registerLazySingleton(
      () => PostsBloc(
        uploadPost: serviceLocator(),
        getAllPosts: serviceLocator(),
      ),
    );
}

void _initAiAssistant() {
  serviceLocator
    ..registerFactory<AiRemoteDataSource>(
      () => AiRemoteDataSourceImpl(),
    )
    ..registerFactory<AiRepository>(
      () => AiRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => SendMessage(serviceLocator()))
    ..registerLazySingleton(
      () => AiBloc(serviceLocator()),
    );
}

void _initActivityTracking() {
  serviceLocator
    ..registerFactory<ActivityLocalDataSource>(
      () => ActivityLocalDataSourceImpl(serviceLocator(instanceName: 'activityBox')),
    )
    ..registerLazySingleton(
      () => ActivityManager(serviceLocator()),
    );
}
