import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesBloc({required this.getCategoriesUseCase}) : super(CategoriesInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      final response = await getCategoriesUseCase(const GetCategoriesParams());
      emit(CategoriesLoaded(response.items));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
