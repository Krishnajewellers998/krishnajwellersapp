import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_jewellery_usecase.dart';
import 'jewellery_event.dart';
import 'jewellery_state.dart';

class JewelleryBloc extends Bloc<JewelleryEvent, JewelleryState> {
  final GetJewelleryUseCase getJewelleryUseCase;

  JewelleryBloc({required this.getJewelleryUseCase}) : super(JewelleryInitial()) {
    on<LoadJewelleryEvent>(_onLoadJewellery);
    on<LoadMoreJewelleryEvent>(_onLoadMoreJewellery);
  }

  Future<void> _onLoadJewellery(
    LoadJewelleryEvent event,
    Emitter<JewelleryState> emit,
  ) async {
    emit(JewelleryLoading());
    try {
      final response = await getJewelleryUseCase(GetJewelleryParams(
        category: event.category,
        search: event.search,
        page: 1,
        limit: 10,
      ));
      emit(JewelleryLoaded(
        items: response.items,
        selectedCategory: event.category,
        search: event.search,
        hasReachedMax: response.hasReachedMax,
        page: 1,
      ));
    } catch (e) {
      emit(JewelleryError(e.toString()));
    }
  }

  Future<void> _onLoadMoreJewellery(
    LoadMoreJewelleryEvent event,
    Emitter<JewelleryState> emit,
  ) async {
    final currentState = state;
    if (currentState is JewelleryLoaded && !currentState.hasReachedMax) {
      try {
        final nextPage = currentState.page + 1;
        final response = await getJewelleryUseCase(GetJewelleryParams(
          category: currentState.selectedCategory,
          search: currentState.search,
          page: nextPage,
          limit: 10,
        ));
        
        emit(response.items.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : currentState.copyWith(
                items: currentState.items + response.items,
                hasReachedMax: response.hasReachedMax,
                page: nextPage,
              ));
      } catch (e) {
        // Optional: Handle pagination error gracefully without breaking UI
      }
    }
  }
}
