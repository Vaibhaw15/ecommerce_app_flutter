import 'package:ecommerce_app/data/models/order/order_model.dart';

import '../../../data/models/product/product_model.dart';

abstract class OrderState {
  final List<OrderModel> orders;
  OrderState(this.orders);
}

class OrderInitialState extends OrderState {
  OrderInitialState() : super([]);
}

class OrderLoadingState extends OrderState {
  OrderLoadingState(List<OrderModel> orders) : super(orders);
}

class OrderLoadedState extends OrderState {
  OrderLoadedState(List<OrderModel> orders) : super(orders);
}

class OrderErrorState extends OrderState {
  final String message;
  OrderErrorState(List<OrderModel> orders, this.message) : super(orders);
}
