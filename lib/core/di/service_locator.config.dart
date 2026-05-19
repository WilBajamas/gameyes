// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.dart'
    as _i1015;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart'
    as _i190;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart'
    as _i424;
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart'
    as _i646;
import 'package:gaming_library_assessment_flutter/core/services/api/network_module.dart'
    as _i401;
import 'package:gaming_library_assessment_flutter/core/services/api/twitch_auth_interceptor.dart'
    as _i641;
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart'
    as _i857;
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart'
    as _i3;
import 'package:gaming_library_assessment_flutter/features/featured/data/repositories/featured_repository_impl.dart'
    as _i840;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart'
    as _i985;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/fetch_featured_use_case.dart'
    as _i783;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/featured_bloc.dart'
    as _i298;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubits/featured_filter_cubit.dart'
    as _i53;
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart'
    as _i305;
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_cubit.dart'
    as _i669;
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_state.dart'
    as _i113;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart'
    as _i750;
import 'package:gaming_library_assessment_flutter/features/game_detail/data/repositories/game_detail_repository_impl.dart'
    as _i366;
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_detail_repository.dart'
    as _i223;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubits/game_detail_cubit.dart'
    as _i32;
import 'package:gaming_library_assessment_flutter/features/game_detail/services/game_detail_service.dart'
    as _i54;
import 'package:gaming_library_assessment_flutter/features/games/data/datasources/games_datasource.dart'
    as _i621;
import 'package:gaming_library_assessment_flutter/features/games/data/repositories/games_repository_impl.dart'
    as _i891;
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart'
    as _i461;
import 'package:gaming_library_assessment_flutter/features/games/domain/use_cases/fetch_games_use_case.dart'
    as _i14;
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_bloc.dart'
    as _i591;
import 'package:gaming_library_assessment_flutter/features/games/services/games_service.dart'
    as _i549;
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart'
    as _i1017;
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart'
    as _i944;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_detail_repository_impl.dart'
    as _i441;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_repository_impl.dart'
    as _i104;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_detail_repository.dart'
    as _i980;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_repository.dart'
    as _i443;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/task_cubit.dart'
    as _i633;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_cubit.dart'
    as _i970;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_detail_cubit.dart'
    as _i43;
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
    final networkModule = _$NetworkModule();
    gh.factory<_i646.DefaultDioInterceptor>(
        () => _i646.DefaultDioInterceptor());
    gh.factory<_i857.GameLocalStorageService>(
        () => _i857.GameLocalStorageService());
    gh.singleton<_i1015.AppRouter>(() => _i1015.AppRouter());
    gh.singleton<_i641.TwitchAuthInterceptor>(
        () => _i641.TwitchAuthInterceptor());
    gh.singleton<_i3.SharedPreference>(() => _i3.SharedPreference());
    gh.singleton<_i1017.ScrollNotifier>(() => _i1017.ScrollNotifier());
    gh.singleton<_i361.Dio>(
        () => networkModule.getDioInstance(gh<_i641.TwitchAuthInterceptor>()));
    gh.singleton<_i549.GamesServices>(
        () => networkModule.getRetrofitService(gh<_i361.Dio>()));
    gh.singleton<_i54.GameDetailService>(
        () => networkModule.getGameDetailService(gh<_i361.Dio>()));
    gh.factoryParam<_i53.FeaturedFilterCubit, Set<_i305.GamePlatform>, dynamic>(
        (
      initialPlatforms,
      _,
    ) =>
            _i53.FeaturedFilterCubit(initialPlatforms: initialPlatforms));
    gh.factory<_i750.GameDetailRemoteDatasource>(
        () => _i750.GameDetailRemoteDatasource(gh<_i54.GameDetailService>()));
    gh.factoryParam<_i669.FilterCubit, _i113.FilterState, dynamic>((
      initialState,
      _,
    ) =>
        _i669.FilterCubit(initialState: initialState));
    gh.factory<_i944.GameLocalDatasource>(
        () => _i944.GameLocalDatasource(gh<_i857.GameLocalStorageService>()));
    gh.factory<_i621.GamesDataSource>(
        () => _i621.GamesDataSource(gh<_i549.GamesServices>()));
    gh.factory<_i223.GameDetailRepository>(() => _i366.GameDetailRepositoryImpl(
          gh<_i750.GameDetailRemoteDatasource>(),
          gh<_i944.GameLocalDatasource>(),
        ));
    gh.factory<_i461.GamesRepository>(
        () => _i891.GamesRepositoryImpl(gh<_i621.GamesDataSource>()));
    gh.factoryParam<_i32.GameDetailCubit, int, dynamic>((
      id,
      _,
    ) =>
        _i32.GameDetailCubit(
          id: id,
          gameDetailRepository: gh<_i223.GameDetailRepository>(),
        ));
    gh.factory<_i980.TrackerDetailRepository>(() =>
        _i441.TrackerDetailRepositoryImpl(gh<_i944.GameLocalDatasource>()));
    gh.factory<_i443.TrackerRepository>(
        () => _i104.TrackerRepositoryImpl(gh<_i944.GameLocalDatasource>()));
    gh.factory<_i985.FeaturedRepository>(
        () => _i840.FeaturedRepositoryImpl(gh<_i621.GamesDataSource>()));
    gh.factoryParam<_i633.TaskCubit, _i424.TrackerTaskEntity?, dynamic>((
      task,
      _,
    ) =>
        _i633.TaskCubit(
          task: task,
          trackerDetailRepository: gh<_i980.TrackerDetailRepository>(),
        ));
    gh.factoryParam<_i43.TrackerDetailCubit, _i190.TrackerSavedGameEntity,
        dynamic>((
      game,
      _,
    ) =>
        _i43.TrackerDetailCubit(
          game: game,
          trackerDetailRepository: gh<_i980.TrackerDetailRepository>(),
        ));
    gh.factory<_i783.FetchFeaturedUseCase>(
        () => _i783.FetchFeaturedUseCase(gh<_i985.FeaturedRepository>()));
    gh.factory<_i970.TrackerCubit>(
        () => _i970.TrackerCubit(gh<_i443.TrackerRepository>()));
    gh.factory<_i14.FetchGamesUseCase>(
        () => _i14.FetchGamesUseCase(gh<_i461.GamesRepository>()));
    gh.factory<_i298.FeaturedBloc>(
        () => _i298.FeaturedBloc(gh<_i783.FetchFeaturedUseCase>()));
    gh.factory<_i591.GamesBloc>(
        () => _i591.GamesBloc(gh<_i14.FetchGamesUseCase>()));
    return this;
  }
}

class _$NetworkModule extends _i401.NetworkModule {}
