import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/dependency_injection.dart';
import '../../logic/cubit/orders_cubit.dart';
import 'add_order_page.dart';

class AddOrderWrapperPage extends StatelessWidget {
  const AddOrderWrapperPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: Scaffold(
        body: AddOrderPage(onBack: onBack),
      ),
    );
  }
}

