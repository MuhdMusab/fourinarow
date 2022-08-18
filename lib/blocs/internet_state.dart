part of 'internet_cubit.dart';


enum ConnectionType {
  WIFI,
  MOBILE,
}

@immutable
abstract class InternetState {

}

class InternetLoading extends InternetState {

}

class InternetConnected extends InternetState {
  ConnectionType connectionType;

  InternetConnected({
    required this.connectionType,
  });
}

class InternetDisconnected extends InternetState {

}
