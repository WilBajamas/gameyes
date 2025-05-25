// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart'
    as _i646;
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart'
    as _i267;
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart'
    as _i857;
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart'
    as _i3;
import 'package:gaming_library_assessment_flutter/features/featured/data/repository/featured_repository_impl.dart'
    as _i870;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart'
    as _i787;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_case/fetch_featured_use_case.dart'
    as _i1013;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart'
    as _i857;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/featured_filter_cubit.dart'
    as _i11;
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart'
    as _i592;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart'
    as _i750;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart'
    as _i187;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_detail_repository_impl.dart'
    as _i400;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_screenshots_repository_impl.dart'
    as _i991;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart'
    as _i534;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart'
    as _i634;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart'
    as _i238;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart'
    as _i488;
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart'
    as _i278;
import 'package:gaming_library_assessment_flutter/features/games/data/repository/games_repository_impl.dart'
    as _i424;
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart'
    as _i1005;
import 'package:gaming_library_assessment_flutter/features/games/domain/use_case/fetch_games_use_case.dart'
    as _i846;
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart'
    as _i868;
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart'
    as _i1017;
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart'
    as _i944;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_detail_repository_impl.dart'
    as _i441;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_repository_impl.dart'
    as _i104;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_detail_repository.dart'
    as _i47;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_repository.dart'
    as _i86;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/task_cubit.dart'
    as _i564;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_cubit.dart'
    as _i110;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_detail_cubit.dart'
    as _i185;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i646.DefaultDioInterceptor>(
        () => _i646.DefaultDioInterceptor());
    gh.factory<_i857.GameLocalStorageService>(
        () => _i857.GameLocalStorageService());
    gh.factory<_i1013.FetchFeaturedUseCase>(
        () => _i1013.FetchFeaturedUseCase());
    gh.factory<_i857.FeaturedBloc>(() => _i857.FeaturedBloc());
    gh.factory<_i11.FeaturedFilterCubit>(() => _i11.FeaturedFilterCubit());
    gh.factory<_i592.FilterCubit>(() => _i592.FilterCubit());
    gh.factory<_i278.GamesDataSource>(() => _i278.GamesDataSource());
    gh.factory<_i846.FetchGamesUseCase>(() => _i846.FetchGamesUseCase());
    gh.factory<_i868.GamesBloc>(() => _i868.GamesBloc());
    gh.factory<_i750.GameDetailRemoteDatasource>(
        () => _i750.GameDetailRemoteDatasource());
    gh.factory<_i187.GameScreenshotsDatasource>(
        () => _i187.GameScreenshotsDatasource());
    gh.factory<_i238.GameDetailCubit>(() => _i238.GameDetailCubit());
    gh.factory<_i488.GameScreenshotCubit>(() => _i488.GameScreenshotCubit());
    gh.factory<_i944.GameLocalDatasource>(() => _i944.GameLocalDatasource());
    gh.factory<_i564.TaskCubit>(() => _i564.TaskCubit());
    gh.factory<_i110.TrackerCubit>(() => _i110.TrackerCubit());
    gh.factory<_i185.TrackerDetailCubit>(() => _i185.TrackerDetailCubit());
    gh.singleton<_i267.DioService>(() => _i267.DioService());
    gh.singleton<_i3.SharedPreference>(() => _i3.SharedPreference());
    gh.singleton<_i1017.ScrollNotifier>(() => _i1017.ScrollNotifier());
    gh.factory<_i534.GameDetailRepository>(
        () => _i400.GameDetailRepositoryImpl());
    gh.factory<_i1005.GamesRepository>(() => _i424.GamesRepositoryImpl());
    gh.factory<_i47.TrackerDetailRepository>(
        () => _i441.TrackerDetailRepositoryImpl());
    gh.factory<_i634.GameScreenshotsRepository>(
        () => _i991.GameScreenshotsRepositoryImpl());
    gh.factory<_i86.TrackerRepository>(() => _i104.TrackerRepositoryImpl());
    gh.factory<_i787.FeaturedRepository>(() => _i870.FeaturedRepositoryImpl());
    return this;
  }
}
