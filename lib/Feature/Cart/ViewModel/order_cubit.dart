import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Cart/orderRepo/orderRepo.dart';
import 'package:userbarber/core/Models/OrderModel.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  int _orderCounter = 0;

  OrderCubit(this._orderRepository) : super(OrderInitial());

  // load orders by userId
  Future<void> loadOrders(String userId) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrdersByUserId(userId);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  // add order (assign userId here as well)
  Future<void> addOrder(OrderModel order, String userId) async {
    if (order.items.isEmpty) {
      emit(OrderError("You must take an order first"));
      return;
    }
    emit(OrderLoading());
    try {
      _orderCounter++;
      final newOrder = order.copyWith(
        orderNumber: _orderCounter,
        // 🔑 make sure OrderModel has userId field
      );
      await _orderRepository.addOrder(newOrder);
      emit(OrderSuccess("Order ${newOrder.orderNumber} created successfully"));
      await loadOrders(userId); // reload only this user's orders
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrder(OrderModel order, String userId) async {
    emit(OrderLoading());
    try {
      await _orderRepository.updateOrder(order);
      emit(OrderSuccess("Order updated successfully"));
      await loadOrders(userId);
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(
    String orderID,
    String status,
    String userId,
  ) async {
    try {
      await _orderRepository.updateOrderStatus(orderID, status);
      emit(OrderStatusUpdated());
      await loadOrders(userId);
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId, String userId) async {
    emit(OrderLoading());
    try {
      await _orderRepository.deleteOrder(orderId);
      emit(OrderSuccess("Order deleted successfully"));
      await loadOrders(userId);
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
