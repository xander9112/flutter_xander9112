import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:xander9112/xander9112.dart';

abstract class ServiceLocator {
  static final GetIt getSL = GetIt.instance;

  /// Инициализация роутера
  Future<void> initRouter() async {}

  /// Инициализация провайдеров
  ///
  /// @env переменная окружения
  /// @useMock использовать ли моки
  Future<void> initProviders({EnvConfig? env, bool useMock = false}) async {}

  /// Инициализация репозиториев
  ///
  /// @env переменная окружения
  /// @useMock использовать ли моки
  Future<void> initRepositories({EnvConfig? env, bool useMock = false}) async {}

  /// Инициализация Use кейсов
  ///
  /// @env переменная окружения
  /// @useMock использовать ли моки
  Future<void> initUseCases({EnvConfig? env, bool useMock = false}) async {}

  /// Инициализация состояний
  ///
  /// @env переменная окружения
  /// @useMock использовать ли моки
  Future<void> initState({EnvConfig? env, bool useMock = false}) async {}

  /// @env переменная окружения
  /// @useMock использовать ли моки
  @mustCallSuper
  Future<void> init({EnvConfig? env, bool useMock = false}) async {
    await initRouter();

    await initProviders(env: env, useMock: useMock);

    await initRepositories(env: env, useMock: useMock);

    await initUseCases(env: env, useMock: useMock);

    await initState(env: env, useMock: useMock);
  }
}
