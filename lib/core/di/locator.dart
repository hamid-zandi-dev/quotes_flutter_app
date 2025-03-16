import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quotes/core/utils/my_http_overrides.dart';
import 'package:quotes/core/utils/shared_preferences_manager.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/abstraction/remote_quotes_data_source.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/impl/quotes_data_source_impl.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/mapper/remote_quotes_mapper.dart';
import 'package:quotes/features/quote_list/data/repository/quotes_repository_impl.dart';
import 'package:quotes/features/quote_list/domain/use_case/get_quotes_use_case.dart';
import 'package:quotes/features/quote_list/domain/repository/quotes_repository.dart';
import 'package:quotes/features/quote_list/presentation/bloc/quote_list_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

setupInjection() async {
  await provideSharedPreferences();
  provideSharedPreferencesManager(locator());
  provideDioBaseOptions();
  provideDio();
  provideQuotesMappers();
  provideRemoteQuotesDataSource();
  provideQuotesRepository();
  provideQuotesUseCases();
  provideQuotesBloc();
}

Future<void> provideSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingletonIfAbsent<SharedPreferences>(sharedPreferences);
}

void provideSharedPreferencesManager(SharedPreferences sharedPreferences) {
  final sharedPreferencesManager = SharedPreferencesManager(sharedPreferences);
  locator.registerSingletonIfAbsent<SharedPreferencesManager>(sharedPreferencesManager);
}

void provideDio() {
  locator.registerSingletonIfAbsent<Dio>(Dio(locator()));
}

void provideDioBaseOptions() {
  HttpOverrides.global = MyHttpOverrides();
  var options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20)
  );
  locator.registerSingletonIfAbsent<BaseOptions>(options);
}

void provideQuotesMappers() {
  locator.registerSingletonIfAbsent<RemoteQuotesMapper>(RemoteQuotesMapper());
}

void provideRemoteQuotesDataSource() {
  locator.registerSingletonIfAbsent<RemoteQuotesDataSource>(
    RemoteQuotesDataSourceImpl(locator())
  );
}

void provideQuotesRepository() {
  locator.registerSingletonIfAbsent<QuotesRepository>(
    QuotesRepositoryImpl(locator(), locator())
  );
}

void provideQuotesUseCases() {
  locator.registerSingletonIfAbsent<GetQuotesUseCase>(
    GetQuotesUseCase(locator())
  );
}

void provideQuotesBloc() {
  locator.registerFactoryIfAbsent<QuoteListBloc>(
    () => QuoteListBloc(locator())
  );
}

extension GetItExtension on GetIt {
  void registerSingletonIfAbsent<T extends Object>(T instance) {
    if (!isRegistered<T>()) {
      registerSingleton<T>(instance);
    }
  }
  
  void registerFactoryIfAbsent<T extends Object>(FactoryFunc<T> factoryFunc) {
    if (!isRegistered<T>()) {
      registerFactory<T>(factoryFunc);
    }
  }
}


