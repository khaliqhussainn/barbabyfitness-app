import 'package:equatable/equatable.dart';

// When backend is integrated, consider wrapping Type in Either<Failure, Type>
// using fpdart for proper functional error handling.
abstract interface class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract interface class SyncUseCase<Type, Params> {
  Type call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
