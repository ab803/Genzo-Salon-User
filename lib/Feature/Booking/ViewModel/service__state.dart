import 'package:equatable/equatable.dart';
import 'package:userbarber/core/Models/Service.dart';


// 🔹 Base class
abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

// 🔹 Initial State
class ServiceInitial extends ServiceState {}

// 🔹 Loading State
class ServiceLoading extends ServiceState {}

// 🔹 Loaded State
class ServiceLoaded extends ServiceState {
  final List<Service> services;

  const ServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

// 🔹 Error State
class ServiceError extends ServiceState {
  final String message;

  const ServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
