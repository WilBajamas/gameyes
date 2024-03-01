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
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart'
    as _i23;
import 'package:gaming_library_assessment_flutter/features/featured/data/repository/featured_repository_impl.dart'
    as _i7;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart'
    as _i6;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_case/fetch_featured_use_case.dart'
    as _i8;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart'
    as _i5;
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart'
    as _i9;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart'
    as _i11;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart'
    as _i15;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_detail_repository_impl.dart'
    as _i13;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_screenshots_repository_impl.dart'
    as _i17;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart'
    as _i12;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart'
    as _i16;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart'
    as _i10;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart'
    as _i14;
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart'
    as _i19;
import 'package:gaming_library_assessment_flutter/features/games/data/repository/games_repository_impl.dart'
    as _i21;
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart'
    as _i20;
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart'
    as _i18;
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart'
    as _i22;
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
    gh.singleton<_i4.DioService>(_i4.DioService());
    gh.factory<_i5.FeaturedBloc>(() => _i5.FeaturedBloc());
    gh.factory<_i6.FeaturedRepository>(() => _i7.FeaturedRepositoryImpl());
    gh.factory<_i8.FetchFeaturedUseCase>(() => _i8.FetchFeaturedUseCase());
    gh.factory<_i9.FilterCubit>(() => _i9.FilterCubit());
    gh.factory<_i10.GameDetailCubit>(() => _i10.GameDetailCubit());
    gh.factory<_i11.GameDetailDatasource>(() => _i11.GameDetailDatasource());
    gh.factory<_i12.GameDetailRepository>(
        () => _i13.GameDetailRepositoryImpl());
    gh.factory<_i14.GameScreenshotCubit>(() => _i14.GameScreenshotCubit());
    gh.factory<_i15.GameScreenshotsDatasource>(
        () => _i15.GameScreenshotsDatasource());
    gh.factory<_i16.GameScreenshotsRepository>(
        () => _i17.GameScreenshotsRepositoryImpl());
    gh.factory<_i18.GamesBloc>(() => _i18.GamesBloc());
    gh.factory<_i19.GamesDataSource>(() => _i19.GamesDataSource());
    gh.factory<_i20.GamesRepository>(() => _i21.GamesRepositoryImpl());
    gh.singleton<_i22.ScrollNotifier>(_i22.ScrollNotifier());
    gh.singleton<_i23.SharedPreference>(_i23.SharedPreference());
    return this;
  }
}
