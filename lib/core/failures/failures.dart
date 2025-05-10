abstract class Failure {
  final String title;
  final String message;

  const Failure(this.title, this.message);

  List<Object> get props => [title, message];

  @override
  String toString() => 'Failure(title: $title, message: $message)';
}

class NoFailure extends Failure {
  NoFailure([super.title = '', super.message = '']);
}

class ServerFailure extends Failure {
  const ServerFailure(String title, String message) : super(title, message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String title, required String message})
      : super(title, message);
}

class CommonFailure extends Failure {
  const CommonFailure(String title, String message) : super(title, message);
}

class InternetFailure extends Failure {
  const InternetFailure(String title, String message) : super(title, message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String title, String message)
      : super(title, message);
}
