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
    as _i22;
import 'package:gaming_library_assessment_flutter/features/featured/data/repository/featured_repository_impl.dart'
    as _i7;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart'
    as _i6;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart'
    as _i5;
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart'
    as _i8;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart'
    as _i10;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart'
    as _i14;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_detail_repository_impl.dart'
    as _i12;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repository/game_screenshots_repository_impl.dart'
    as _i16;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart'
    as _i11;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart'
    as _i15;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart'
    as _i9;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart'
    as _i13;
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart'
    as _i18;
import 'package:gaming_library_assessment_flutter/features/games/data/repository/games_repository_impl.dart'
    as _i20;
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart'
    as _i19;
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart'
    as _i17;
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart'
    as _i21;
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
    gh.factory<_i8.FilterCubit>(() => _i8.FilterCubit());
    gh.factory<_i9.GameDetailCubit>(() => _i9.GameDetailCubit());
    gh.factory<_i10.GameDetailDatasource>(() => _i10.GameDetailDatasource());
    gh.factory<_i11.GameDetailRepository>(
        () => _i12.GameDetailRepositoryImpl());
    gh.factory<_i13.GameScreenshotCubit>(() => _i13.GameScreenshotCubit());
    gh.factory<_i14.GameScreenshotsDatasource>(
        () => _i14.GameScreenshotsDatasource());
    gh.factory<_i15.GameScreenshotsRepository>(
        () => _i16.GameScreenshotsRepositoryImpl());
    gh.factory<_i17.GamesBloc>(() => _i17.GamesBloc());
    gh.factory<_i18.GamesDataSource>(() => _i18.GamesDataSource());
    gh.factory<_i19.GamesRepository>(() => _i20.GamesRepositoryImpl());
    gh.singleton<_i21.ScrollNotifier>(_i21.ScrollNotifier());
    gh.singleton<_i22.SharedPreference>(_i22.SharedPreference());
    return this;
  }
}
