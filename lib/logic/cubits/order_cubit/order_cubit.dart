import 'dart:async';

import 'package:ecommerce_app/data/models/order/order_model.dart';
import 'package:ecommerce_app/data/repositories/order_repository.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:ecommerce_app/logic/cubits/order_cubit/order_state.dart';
import 'package:ecommerce_app/logic/services/calculation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart/cart_item_model.dart';
import '../user_cubit/user_cubit.dart';
import '../user_cubit/user_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final UserCubit _userCubit;
  final CartCubit carCubit;
  StreamSubscription? _userSubscription;
  OrderCubit(this._userCubit, this.carCubit) : super(OrderInitialState()) {
    //initial Value
    _handleUserState(_userCubit.state);

    //listening to user cubit (for future updates
    _userSubscription = _userCubit.stream.listen(_handleUserState);
  }

  void _handleUserState(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (userState is UserLoggedOutState) {
      emit(OrderInitialState());
    }
  }

  final _oredrRepository = OrderRepository();
  void _initialize(String userId) async {
    emit(OrderLoadingState(state.orders));
    try {
      final orders = await _oredrRepository.fetchOrdersForUser(userId);
      emit(OrderLoadedState(orders));
    } catch (ex) {
      emit(OrderErrorState(state.orders, ex.toString()));
    }
  }

  Future<OrderModel?> createOrder(
      {required List<CartItemModel> items,
      required String paymentMethod}) async {
    emit(OrderLoadingState(state.orders));
    try {
      if (_userCubit.state is! UserLoggedInState) {
        return null;
      }
      OrderModel newOrder = OrderModel(
        items: items,
        totalAmount: Calculations.carTotal(items),
        status: (paymentMethod == "pay-on-delivery")
            ? "order-placed"
            : "payment-pending",
        user: (_userCubit.state as UserLoggedInState).userModel,
      );
      final order = await _oredrRepository.createOrder(newOrder);
      List<OrderModel> orders = [order, ...state.orders];
      emit(OrderLoadedState(orders));
      //clear the cart

      carCubit.clearCart();

      // if (order.status == "payment-pending") {
      //   return null;
      // }
      return order;
    } catch (ex) {
      emit(OrderErrorState(state.orders, ex.toString()));
      return null;
    }
  }

  Future<bool> updateOrder(
    OrderModel orderModel, {
    String? paymentId,
    String? signature,
  }) async {
    try {
      OrderModel updatedOrder = await _oredrRepository.updateOrder(orderModel,
          paymentId: paymentId, signature: signature);
      int index = state.orders.indexOf(updatedOrder);
      if (index == -1) {
        return false;
      }
      List<OrderModel> newList = state.orders;
      newList[index] = updatedOrder;

      emit(OrderLoadedState(newList));
      return true;
    } catch (ex) {
      emit(OrderErrorState(state.orders, ex.toString()));
      return false;
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _userSubscription?.cancel();
    return super.close();
  }
}

// Order(Backend)---order_id---> Fronted(order_id:payment)
