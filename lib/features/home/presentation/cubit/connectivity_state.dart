part of 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState {}

class ConnectInitialState extends ConnectivityState {}

class ConnectLoadingState extends ConnectivityState {}

class ConnectTrueState extends ConnectivityState {}

class ConnectFalseState extends ConnectivityState {}
