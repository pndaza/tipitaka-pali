import 'dart:async';

class SlidableBarController {
  /// the initial bar state when it's build for the first time
  final bool initialStatus;

  SlidableBarController({this.initialStatus = false}) : currentStatus = initialStatus;

  /// return the current state for the bar
  /// open [true], close [false]
  bool currentStatus;

  /// stream for bar state changes
  Stream<bool> get statusStream => _barStatus.stream;

  StreamController<bool> _barStatus = StreamController<bool>.broadcast();

  /// to hide the bar
  hide() {
    currentStatus = false;
    _barStatus.add(currentStatus);
  }

  /// to show the bar
  show() {
    currentStatus = true;
    _barStatus.add(currentStatus);
  }

  /// if the bar was closed this method will open it
  /// if the bar was opened this method will closed it
  reverseStatus() {
    currentStatus = !currentStatus;
    _barStatus.add(currentStatus);
  }

  /// this should be called when the widget is disposed to close the stream
  /// it is called by default
  dispose() {
    _barStatus.close();
  }
}
