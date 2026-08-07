// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart'
    as _i627;
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.dart'
    as _i1015;
import 'package:gaming_library_assessment_flutter/config/route/guards/auth_guard.dart'
    as _i964;
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart'
    as _i748;
import 'package:gaming_library_assessment_flutter/config/route/session_navigator.dart'
    as _i569;
import 'package:gaming_library_assessment_flutter/core/di/igdb_proxy_module.dart'
    as _i819;
import 'package:gaming_library_assessment_flutter/core/di/storage_module.dart'
    as _i472;
import 'package:gaming_library_assessment_flutter/core/di/supabase_module.dart'
    as _i871;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart'
    as _i190;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart'
    as _i424;
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart'
    as _i646;
import 'package:gaming_library_assessment_flutter/core/services/sentry/crash_report_user.dart'
    as _i554;
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart'
    as _i857;
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_connection_checker.dart'
    as _i656;
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart'
    as _i498;
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_ping.dart'
    as _i124;
import 'package:gaming_library_assessment_flutter/features/auth/data/datasources/auth_datasource.dart'
    as _i445;
import 'package:gaming_library_assessment_flutter/features/auth/data/repositories/auth_repository_impl.dart'
    as _i202;
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart'
    as _i615;
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart'
    as _i595;
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_in_use_case.dart'
    as _i403;
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_out_use_case.dart'
    as _i1024;
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_in_cubit.dart'
    as _i347;
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_cubit.dart'
    as _i410;
import 'package:gaming_library_assessment_flutter/features/featured/data/datasources/featured_local_datasource.dart'
    as _i554;
import 'package:gaming_library_assessment_flutter/features/featured/data/repositories/featured_repository_impl.dart'
    as _i840;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart'
    as _i985;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_countdown_game_use_case.dart'
    as _i781;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_critics_choice_use_case.dart'
    as _i971;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_genre_preferences_use_case.dart'
    as _i804;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_library_snapshot_use_case.dart'
    as _i851;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_out_this_week_use_case.dart'
    as _i526;
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/save_genre_preferences_use_case.dart'
    as _i151;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/countdown_releases_cubit.dart'
    as _i208;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/critics_grid_cubit.dart'
    as _i187;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/library_stats_cubit.dart'
    as _i426;
import 'package:gaming_library_assessment_flutter/features/featured/services/featured_api_service.dart'
    as _i524;
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
import 'package:gaming_library_assessment_flutter/features/game_detail/services/game_detail_api_service.dart'
    as _i40;
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
import 'package:gaming_library_assessment_flutter/features/games/services/games_api_service.dart'
    as _i706;
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart'
    as _i1017;
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_cubit.dart'
    as _i403;
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart'
    as _i944;
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/tracker_preferences_datasource.dart'
    as _i629;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_detail_repository_impl.dart'
    as _i441;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_repository_impl.dart'
    as _i104;
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_sort_repository_impl.dart'
    as _i856;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_detail_repository.dart'
    as _i980;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_repository.dart'
    as _i443;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_sort_repository.dart'
    as _i922;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/get_tracker_sort_use_case.dart'
    as _i671;
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/save_tracker_sort_use_case.dart'
    as _i422;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/task_cubit.dart'
    as _i633;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_cubit.dart'
    as _i970;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_detail_cubit.dart'
    as _i43;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final supabaseModule = _$SupabaseModule();
    final igdbProxyModule = _$IgdbProxyModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i454.SupabaseClient>(
      () => supabaseModule.supabaseClient,
      preResolve: true,
    );
    gh.factory<_i646.DefaultDioInterceptor>(
      () => _i646.DefaultDioInterceptor(),
    );
    gh.singleton<_i748.PendingRouteStore>(() => _i748.PendingRouteStore());
    gh.singleton<_i857.GameLocalStorageService>(
      () => _i857.GameLocalStorageService(),
    );
    gh.singleton<_i1017.ScrollNotifier>(() => _i1017.ScrollNotifier());
    gh.singleton<_i498.SupabaseIgdbProxyService>(
      () =>
          igdbProxyModule.supabaseIgdbProxyService(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i403.WelcomeCubit>(
      () => _i403.WelcomeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i629.TrackerPreferencesDatasource>(
      () => _i629.TrackerPreferencesDatasource(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i922.TrackerSortRepository>(
      () => _i856.TrackerSortRepositoryImpl(
        gh<_i629.TrackerPreferencesDatasource>(),
      ),
    );
    gh.factory<_i554.FeaturedLocalDatasource>(
      () => _i554.FeaturedLocalDatasource(
        gh<_i857.GameLocalStorageService>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i524.FeaturedApiService>(
      () => _i524.FeaturedApiService(gh<_i498.SupabaseIgdbProxyService>()),
    );
    gh.factory<_i40.GameDetailApiService>(
      () => _i40.GameDetailApiService(gh<_i498.SupabaseIgdbProxyService>()),
    );
    gh.factory<_i706.GamesApiService>(
      () => _i706.GamesApiService(gh<_i498.SupabaseIgdbProxyService>()),
    );
    gh.factory<_i750.GameDetailRemoteDatasource>(
      () => _i750.GameDetailRemoteDatasource(gh<_i40.GameDetailApiService>()),
    );
    gh.factory<_i621.GamesDataSource>(
      () => _i621.GamesDataSource(gh<_i706.GamesApiService>()),
    );
    gh.factory<_i124.SupabasePing>(
      () => _i124.SupabasePing(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i445.AuthDatasource>(
      () => _i445.AuthDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.factoryParam<_i669.FilterCubit, _i113.FilterState, dynamic>(
      (initialState, _) => _i669.FilterCubit(initialState: initialState),
    );
    gh.factory<_i615.AuthRepository>(
      () => _i202.AuthRepositoryImpl(gh<_i445.AuthDatasource>()),
    );
    gh.factory<_i944.GameLocalDatasource>(
      () => _i944.GameLocalDatasource(gh<_i857.GameLocalStorageService>()),
    );
    gh.factory<_i656.SupabaseConnectionChecker>(
      () => _i656.SupabaseConnectionChecker(gh<_i124.SupabasePing>()),
    );
    gh.factory<_i671.GetTrackerSortUseCase>(
      () => _i671.GetTrackerSortUseCase(gh<_i922.TrackerSortRepository>()),
    );
    gh.factory<_i422.SaveTrackerSortUseCase>(
      () => _i422.SaveTrackerSortUseCase(gh<_i922.TrackerSortRepository>()),
    );
    gh.factory<_i223.GameDetailRepository>(
      () => _i366.GameDetailRepositoryImpl(
        gh<_i750.GameDetailRemoteDatasource>(),
        gh<_i944.GameLocalDatasource>(),
      ),
    );
    gh.factory<_i985.FeaturedRepository>(
      () => _i840.FeaturedRepositoryImpl(
        gh<_i554.FeaturedLocalDatasource>(),
        gh<_i524.FeaturedApiService>(),
      ),
    );
    gh.factory<_i781.GetCountdownGameUseCase>(
      () => _i781.GetCountdownGameUseCase(gh<_i985.FeaturedRepository>()),
    );
    gh.factory<_i971.GetCriticsChoiceUseCase>(
      () => _i971.GetCriticsChoiceUseCase(gh<_i985.FeaturedRepository>()),
    );
    gh.factory<_i804.GetGenrePreferencesUseCase>(
      () => _i804.GetGenrePreferencesUseCase(gh<_i985.FeaturedRepository>()),
    );
    gh.factory<_i851.GetLibrarySnapshotUseCase>(
      () => _i851.GetLibrarySnapshotUseCase(gh<_i985.FeaturedRepository>()),
    );
    gh.factory<_i526.GetOutThisWeekUseCase>(
      () => _i526.GetOutThisWeekUseCase(gh<_i985.FeaturedRepository>()),
    );
    gh.factory<_i151.SaveGenrePreferencesUseCase>(
      () => _i151.SaveGenrePreferencesUseCase(gh<_i985.FeaturedRepository>()),
    );
    gh.factory<_i461.GamesRepository>(
      () => _i891.GamesRepositoryImpl(gh<_i621.GamesDataSource>()),
    );
    gh.factory<_i595.ObserveAuthStatusUseCase>(
      () => _i595.ObserveAuthStatusUseCase(gh<_i615.AuthRepository>()),
    );
    gh.factory<_i403.SignInUseCase>(
      () => _i403.SignInUseCase(gh<_i615.AuthRepository>()),
    );
    gh.factory<_i1024.SignOutUseCase>(
      () => _i1024.SignOutUseCase(gh<_i615.AuthRepository>()),
    );
    gh.factory<_i426.LibraryStatsCubit>(
      () => _i426.LibraryStatsCubit(
        gh<_i851.GetLibrarySnapshotUseCase>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i410.SignOutCubit>(
      () => _i410.SignOutCubit(gh<_i1024.SignOutUseCase>()),
    );
    gh.factoryParam<_i32.GameDetailCubit, int, dynamic>(
      (id, _) => _i32.GameDetailCubit(
        id: id,
        gameDetailRepository: gh<_i223.GameDetailRepository>(),
      ),
    );
    gh.factory<_i980.TrackerDetailRepository>(
      () => _i441.TrackerDetailRepositoryImpl(gh<_i944.GameLocalDatasource>()),
    );
    gh.factory<_i443.TrackerRepository>(
      () => _i104.TrackerRepositoryImpl(gh<_i944.GameLocalDatasource>()),
    );
    gh.factory<_i187.CriticsGridCubit>(
      () => _i187.CriticsGridCubit(
        gh<_i804.GetGenrePreferencesUseCase>(),
        gh<_i971.GetCriticsChoiceUseCase>(),
        gh<_i151.SaveGenrePreferencesUseCase>(),
      ),
    );
    gh.factory<_i208.CountdownReleasesCubit>(
      () => _i208.CountdownReleasesCubit(
        gh<_i781.GetCountdownGameUseCase>(),
        gh<_i526.GetOutThisWeekUseCase>(),
      ),
    );
    gh.singleton<_i627.AuthStatusListener>(
      () => _i627.AuthStatusListener(gh<_i595.ObserveAuthStatusUseCase>()),
    );
    gh.singleton<_i554.CrashReportUser>(
      () => _i554.CrashReportUser(gh<_i595.ObserveAuthStatusUseCase>()),
    );
    gh.factoryParam<_i633.TaskCubit, _i424.TrackerTaskEntity?, dynamic>(
      (task, _) => _i633.TaskCubit(
        task: task,
        trackerDetailRepository: gh<_i980.TrackerDetailRepository>(),
      ),
    );
    gh.factoryParam<
      _i43.TrackerDetailCubit,
      _i190.TrackerSavedGameEntity,
      dynamic
    >(
      (game, _) => _i43.TrackerDetailCubit(
        game: game,
        trackerDetailRepository: gh<_i980.TrackerDetailRepository>(),
      ),
    );
    gh.factory<_i347.SignInCubit>(
      () => _i347.SignInCubit(gh<_i403.SignInUseCase>()),
    );
    gh.factory<_i14.FetchGamesUseCase>(
      () => _i14.FetchGamesUseCase(gh<_i461.GamesRepository>()),
    );
    gh.factory<_i970.TrackerCubit>(
      () => _i970.TrackerCubit(
        gh<_i443.TrackerRepository>(),
        gh<_i422.SaveTrackerSortUseCase>(),
        gh<_i671.GetTrackerSortUseCase>(),
      ),
    );
    gh.factory<_i591.GamesBloc>(
      () => _i591.GamesBloc(gh<_i14.FetchGamesUseCase>()),
    );
    gh.singleton<_i964.AuthGuard>(
      () => _i964.AuthGuard(
        gh<_i627.AuthStatusListener>(),
        gh<_i460.SharedPreferences>(),
        gh<_i748.PendingRouteStore>(),
      ),
    );
    gh.singleton<_i1015.AppRouter>(
      () => _i1015.AppRouter(gh<_i964.AuthGuard>()),
    );
    gh.singleton<_i569.SessionNavigator>(
      () => _i569.SessionNavigator(
        gh<_i627.AuthStatusListener>(),
        gh<_i748.PendingRouteStore>(),
        gh<_i1015.AppRouter>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i472.StorageModule {}

class _$SupabaseModule extends _i871.SupabaseModule {}

class _$IgdbProxyModule extends _i819.IgdbProxyModule {}
