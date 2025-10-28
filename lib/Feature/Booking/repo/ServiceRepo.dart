
import 'package:userbarber/core/Models/Service.dart';
import 'package:userbarber/core/Services/FireStoreForServices.dart';

class ServiceRepo {
  final FireStoreForService _firestoreService;

  ServiceRepo(this._firestoreService);

  /// ✅ Get all services
  Future<List<Service>> getServices() {
    return _firestoreService.getServices();
  }
}
