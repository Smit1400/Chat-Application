import 'dart:async';

class SignInBloc {
  StreamController<bool> _controller = StreamController<bool>();
  Stream<bool> get streamData => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void setStreamData(bool data) => _controller.add(data);
}
