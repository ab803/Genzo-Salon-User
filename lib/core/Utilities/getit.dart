import 'package:get_it/get_it.dart';
import 'package:userbarber/Feature/Booking/repo/ServiceRepo.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/orderRepo/orderRepo.dart';
import 'package:userbarber/Feature/Home/offersRepo.dart';

import 'package:userbarber/core/Services/AuthService.dart';
import 'package:userbarber/core/Services/FireStoreForOffers.dart';
import 'package:userbarber/core/Services/FireStoreForServices.dart';
import 'package:userbarber/core/Services/Firestore.dart';
import 'package:userbarber/core/Services/FirestoreForOrders.dart';
import 'package:userbarber/core/Services/FreStoreForBooking.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Auth
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Firestore services
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  // Firestore for Orders
  getIt.registerLazySingleton<FireStoreForOrdersService>(
    () => FireStoreForOrdersService(),
  );

  // Firestore for booking
  getIt.registerLazySingleton<FirestoreForBooking>(() => FirestoreForBooking());

  // Order repository
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepository(firestore: getIt<FireStoreForOrdersService>()),
  );

  getIt.registerLazySingleton<FireStoreForService>(() => FireStoreForService());
  getIt.registerLazySingleton<ServiceRepo>(
    () => ServiceRepo(getIt<FireStoreForService>()),
  );
  // Cubits
  getIt.registerFactory<OrderCubit>(() => OrderCubit(getIt<OrderRepository>()));

  getIt.registerFactory<FireStoreForOffers>(() => FireStoreForOffers());

  getIt.registerFactory<OffersRepo>(() => OffersRepo());

  // getIt.registerFactory<SearchRepository>(()=>SearchRepository());
}
