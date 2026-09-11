import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_jewellery_usecase.dart';
import 'jewellery_event.dart';
import 'jewellery_state.dart';

class JewelleryBloc extends Bloc<JewelleryEvent, JewelleryState> {
  final GetJewelleryUseCase getJewelleryUseCase;

  JewelleryBloc({required this.getJewelleryUseCase}) : super(JewelleryInitial()) {
    on<LoadJewelleryEvent>(_onLoadJewellery);
  }

  Future<void> _onLoadJewellery(
    LoadJewelleryEvent event,
    Emitter<JewelleryState> emit,
  ) async {
    emit(JewelleryLoading());
    try {
      final items = await getJewelleryUseCase(GetJewelleryParams(
        category: event.category,
        search: event.search,
      ));
      emit(JewelleryLoaded(
        items,
        selectedCategory: event.category,
        search: event.search,
      ));
    } catch (e) {
      emit(JewelleryError(e.toString()));
    }
  }
}
