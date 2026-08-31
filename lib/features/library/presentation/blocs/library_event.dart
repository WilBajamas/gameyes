part of 'library_bloc.dart';

sealed class LibraryEvent extends Equatable {
  const LibraryEvent();
}

/// Anything that resets pagination and refetches the first page.
sealed class LibraryQueryChanged extends LibraryEvent {
  const LibraryQueryChanged();
}

final class LibraryStarted extends LibraryQueryChanged {
  const LibraryStarted();

  @override
  List<Object?> get props => [];
}

final class LibraryStatusSelected extends LibraryQueryChanged {
  const LibraryStatusSelected(this.status);

  final LibraryStatus? status;

  @override
  List<Object?> get props => [status];
}

final class LibrarySortSelected extends LibraryQueryChanged {
  const LibrarySortSelected(this.sort);

  final LibrarySort sort;

  @override
  List<Object?> get props => [sort];
}

final class LibrarySearchTermChanged extends LibraryQueryChanged {
  const LibrarySearchTermChanged(this.term);

  final String term;

  @override
  List<Object?> get props => [term];
}

final class LibraryRetried extends LibraryQueryChanged {
  const LibraryRetried();

  @override
  List<Object?> get props => [];
}

final class LibraryViewModeSelected extends LibraryEvent {
  const LibraryViewModeSelected(this.viewMode);

  final LibraryViewMode viewMode;

  @override
  List<Object?> get props => [viewMode];
}

final class LibraryNextPageRequested extends LibraryEvent {
  const LibraryNextPageRequested();

  @override
  List<Object?> get props => [];
}
