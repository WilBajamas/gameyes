// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart'
    as _i3;
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart'
    as _i4;
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart'
    as _i17;
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart'
    as _i27;
import 'package:gaming_library_assessment_flutter/features/featured/data/repository/featured_repository_impl.dart'
    as _i8;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart'
    as _i7;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_case/fetch_featured_use_case.dart'
    as _i9;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart'
    as _i5;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/featured_filter_cubit.dart'
    as _i6;
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart'
    as _i11;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart'
    as _i13;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart'
    as _i19;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_detail_repository_impl.dart'
    as _i15;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_screenshots_repository_impl.dart'
    as _i21;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart'
    as _i14;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart'
    as _i20;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart'
    as _i12;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart'
    as _i18;
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart'
    as _i23;
import 'package:gaming_library_assessment_flutter/features/games/data/repository/games_repository_impl.dart'
    as _i25;
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart'
    as _i24;
import 'package:gaming_library_assessment_flutter/features/games/domain/use_case/fetch_games_use_case.dart'
    as _i10;
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart'
    as _i22;
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart'
    as _i26;
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart'
    as _i16;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_detail_repository_impl.dart'
    as _i31;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_repository_impl.dart'
    as _i33;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_detail_repository.dart'
    as _i30;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_repository.dart'
    as _i32;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_cubit.dart'
    as _i28;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_detail_cubit.dart'
    as _i29;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.DefaultDioInterceptor>(() => _i3.DefaultDioInterceptor());
    gh.singleton<_i4.DioService>(() => _i4.DioService());
    gh.factory<_i5.FeaturedBloc>(() => _i5.FeaturedBloc());
    gh.factory<_i6.FeaturedFilterCubit>(() => _i6.FeaturedFilterCubit());
    gh.factory<_i7.FeaturedRepository>(() => _i8.FeaturedRepositoryImpl());
    gh.factory<_i9.FetchFeaturedUseCase>(() => _i9.FetchFeaturedUseCase());
    gh.factory<_i10.FetchGamesUseCase>(() => _i10.FetchGamesUseCase());
    gh.factory<_i11.FilterCubit>(() => _i11.FilterCubit());
    gh.factory<_i12.GameDetailCubit>(() => _i12.GameDetailCubit());
    gh.factory<_i13.GameDetailRemoteDatasource>(
        () => _i13.GameDetailRemoteDatasource());
    gh.factory<_i14.GameDetailRepository>(
        () => _i15.GameDetailRepositoryImpl());
    gh.factory<_i16.GameLocalDatasource>(() => _i16.GameLocalDatasource());
    gh.factory<_i17.GameLocalStorageService>(
        () => _i17.GameLocalStorageService());
    gh.factory<_i18.GameScreenshotCubit>(() => _i18.GameScreenshotCubit());
    gh.factory<_i19.GameScreenshotsDatasource>(
        () => _i19.GameScreenshotsDatasource());
    gh.factory<_i20.GameScreenshotsRepository>(
        () => _i21.GameScreenshotsRepositoryImpl());
    gh.factory<_i22.GamesBloc>(() => _i22.GamesBloc());
    gh.factory<_i23.GamesDataSource>(() => _i23.GamesDataSource());
    gh.factory<_i24.GamesRepository>(() => _i25.GamesRepositoryImpl());
    gh.singleton<_i26.ScrollNotifier>(() => _i26.ScrollNotifier());
    gh.singleton<_i27.SharedPreference>(() => _i27.SharedPreference());
    gh.factory<_i28.TrackerCubit>(() => _i28.TrackerCubit());
    gh.factory<_i29.TrackerDetailCubit>(() => _i29.TrackerDetailCubit());
    gh.factory<_i30.TrackerDetailRepository>(
        () => _i31.TrackerDetailRepositoryImpl());
    gh.factory<_i32.TrackerRepository>(() => _i33.TrackerRepositoryImpl());
    return this;
  }
}
