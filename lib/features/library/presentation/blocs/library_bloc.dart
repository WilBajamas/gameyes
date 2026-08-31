import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/const.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/fetch_library_counts_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/fetch_library_page_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/get_library_preferences_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/save_library_sort_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/save_library_view_mode_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/presentation/blocs/library_state.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'library_event.dart';

// Typing waits until it stops; a chip or sort tap is deliberate and runs at
// once. Merging the two back together keeps one handler, so the newest query
// always supersedes the one before it.
EventTransformer<LibraryQueryChanged> _latestQuery() {
  return (events, mapper) {
    final searches = events
        .where((event) => event is LibrarySearchTermChanged)
        .debounce(LibraryConstants.searchDebounce);
    final rest = events.where((event) => event is! LibrarySearchTermChanged);

    return restartable<LibraryQueryChanged>()(rest.merge(searches), mapper);
  };
}

@injectable
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc(
    this._fetchLibraryPageUseCase,
    this._fetchLibraryCountsUseCase,
    this._getLibraryPreferencesUseCase,
    this._saveLibraryViewModeUseCase,
    this._saveLibrarySortUseCase,
  ) : super(const LibraryState()) {
    on<LibraryQueryChanged>(_onQueryChanged, transformer: _latestQuery());
    on<LibraryViewModeSelected>(_onViewModeSelected);
    on<LibraryNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
  }

  final FetchLibraryPageUseCase _fetchLibraryPageUseCase;
  final FetchLibraryCountsUseCase _fetchLibraryCountsUseCase;
  final GetLibraryPreferencesUseCase _getLibraryPreferencesUseCase;
  final SaveLibraryViewModeUseCase _saveLibraryViewModeUseCase;
  final SaveLibrarySortUseCase _saveLibrarySortUseCase;

  // Goes up every time the query changes. A page that comes back under an
  // older number was asked for on behalf of a list nobody is looking at now.
  int _queryGeneration = 0;

  Future<void> _onQueryChanged(
    LibraryQueryChanged event,
    Emitter<LibraryState> emit,
  ) async {
    _queryGeneration++;

    final preferences = event is LibraryStarted
        ? _getLibraryPreferencesUseCase()
        : null;

    final activeStatus = event is LibraryStatusSelected
        ? event.status
        : state.activeStatus;
    final sort = switch (event) {
      LibrarySortSelected(:final sort) => sort,
      _ => preferences?.sort ?? state.sort,
    };
    final searchTerm = event is LibrarySearchTermChanged
        ? event.term.trim()
        : state.searchTerm;

    // The stored view mode and sort land in the same emit as the first
    // loading state, so nothing ever paints in the wrong view. The entries
    // already on screen are left alone so a search never blanks the list.
    emit(
      state.copyWith(
        activeStatus: activeStatus,
        sort: sort,
        viewMode: preferences?.viewMode ?? state.viewMode,
        searchTerm: searchTerm,
        status: LibraryLoadStatus.loading,
        nextPageStatus: LibraryNextPageStatus.initial,
        hasReachedEnd: false,
        error: null,
        nextPageError: null,
      ),
    );

    if (event is LibrarySortSelected) {
      _saveLibrarySortUseCase(sort).ignore();
    }

    // Both calls are started before either is awaited so they run side by
    // side; awaiting the page first would leave the counts queued behind it.
    final pageCall = _fetchLibraryPageUseCase(
      status: activeStatus,
      sort: sort,
      limit: LibraryConstants.pageSize,
      offset: 0,
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
    );
    // Whole-status figures never change with the filter, so they are read
    // once per visit rather than on every chip tap.
    final countsCall = state.counts == null
        ? _fetchLibraryCountsUseCase()
        : null;

    final pageResult = await pageCall;
    final countsResult = countsCall == null ? null : await countsCall;

    final counts = switch (countsResult) {
      Success(value: final value) => value,
      _ => state.counts,
    };

    emit(switch (pageResult) {
      Success(value: final page) => state.copyWith(
        status: page.entries.isEmpty
            ? LibraryLoadStatus.empty
            : LibraryLoadStatus.success,
        entries: page.entries,
        matchedCount: page.matchedCount,
        hasReachedEnd: page.entries.length >= page.matchedCount,
        counts: counts,
      ),
      Failure(error: final error) => state.copyWith(
        status: LibraryLoadStatus.failed,
        error: error,
        counts: counts,
      ),
    });
  }

  void _onViewModeSelected(
    LibraryViewModeSelected event,
    Emitter<LibraryState> emit,
  ) {
    if (event.viewMode == state.viewMode) return;

    emit(state.copyWith(viewMode: event.viewMode));

    // Fire-and-forget: a slow or failing write must not delay the toggle.
    _saveLibraryViewModeUseCase(event.viewMode).ignore();
  }

  Future<void> _onNextPageRequested(
    LibraryNextPageRequested event,
    Emitter<LibraryState> emit,
  ) async {
    if (state.hasReachedEnd || state.status != LibraryLoadStatus.success) {
      return;
    }

    final generation = _queryGeneration;

    emit(state.copyWith(nextPageStatus: LibraryNextPageStatus.loading));

    final result = await _fetchLibraryPageUseCase(
      status: state.activeStatus,
      sort: state.sort,
      limit: LibraryConstants.pageSize,
      offset: state.entries.length,
      searchTerm: state.searchTerm.isEmpty ? null : state.searchTerm,
    );

    // The filter, sort or search changed while this page was on its way, so
    // these rows would be appended under the wrong heading. Drop them; the
    // query that replaced it has already reset the next-page state.
    if (generation != _queryGeneration) return;

    emit(switch (result) {
      Success(value: final page) => state.copyWith(
        nextPageStatus: LibraryNextPageStatus.initial,
        entries: List.of(state.entries)..addAll(page.entries),
        matchedCount: page.matchedCount,
        hasReachedEnd:
            state.entries.length + page.entries.length >= page.matchedCount,
      ),
      Failure(error: final error) => state.copyWith(
        nextPageStatus: LibraryNextPageStatus.failed,
        nextPageError: error,
      ),
    });
  }
}
