import 'package:userbarber/core/Models/OrderModel.dart';



abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  OrderLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderSuccess extends OrderState {
  final String message;
  OrderSuccess(this.message);
}
class OrderStatusUpdated extends OrderState {}