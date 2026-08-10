import 'package:equatable/equatable.dart';

// When backend is integrated, consider wrapping Result in Either<Failure, Result>
// using fpdart for proper functional error handling.
abstract interface class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

abstract interface class SyncUseCase<Result, Params> {
  Result call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
