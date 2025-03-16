abstract class UseCase<Output, Input> {
  Future<Output> call(Input input);
}

abstract class UseCaseStream<Output, Input> {
  Stream<Output> call(Input input);
}