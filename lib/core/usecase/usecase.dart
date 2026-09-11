import 'package:equatable/equatable.dart';

// Abstract contract for asynchronous Future use cases
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

// Abstract contract for reactive Stream use cases
abstract class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

// Reusable parameter object when no arguments are required
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
