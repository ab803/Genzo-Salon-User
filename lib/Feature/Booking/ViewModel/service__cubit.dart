import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Booking/ViewModel/service__state.dart';
import 'package:userbarber/Feature/Booking/repo/ServiceRepo.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepo _serviceRepo;

  ServiceCubit(this._serviceRepo) : super(ServiceInitial());

  /// ✅ Load all services
  Future<void> loadServices() async {
    emit(ServiceLoading());
    try {
      final services = await _serviceRepo
          .getServices(); // returns List<ServiceModel>
      emit(ServiceLoaded(services)); // ✅ now matches state
    } catch (e) {
      emit(ServiceError("Failed to load services: $e"));
    }
  }
}
