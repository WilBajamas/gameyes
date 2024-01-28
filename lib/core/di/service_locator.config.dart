// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart'
    as _i4;
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart'
    as _i5;
import 'package:gaming_library_assessment_flutter/features/featured/data/datasources/games_datasource.dart'
    as _i8;
import 'package:gaming_library_assessment_flutter/features/featured/data/repository/featured_repository_impl.dart'
    as _i7;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart'
    as _i6;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart'
    as _i3;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/latest_releases_cubit.dart'
    as _i10;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/most_anticipated_cubit.dart'
    as _i11;
import 'package:gaming_library_assessment_flutter/features/home/presentation/cubit/home_cubit.dart'
    as _i9;
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
    gh.factory<_i3.BestMetacriticCubit>(() => _i3.BestMetacriticCubit());
    gh.factory<_i4.DefaultDioInterceptor>(() => _i4.DefaultDioInterceptor());
    gh.factory<_i5.DioService>(() => _i5.DioService());
    gh.factory<_i6.FeaturedRepository>(() => _i7.FeaturedRepositoryImpl());
    gh.factory<_i8.GamesDataSource>(() => _i8.GamesDataSource());
    gh.factory<_i9.HomeCubit>(() => _i9.HomeCubit());
    gh.factory<_i10.LatestReleasesCubit>(() => _i10.LatestReleasesCubit());
    gh.factory<_i11.MostAnticipatedCubit>(() => _i11.MostAnticipatedCubit());
    return this;
  }
}
