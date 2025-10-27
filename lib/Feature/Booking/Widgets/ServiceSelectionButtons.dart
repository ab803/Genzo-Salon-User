import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Booking/Widgets/serviceButton.dart';
import 'package:userbarber/core/Utilities/serviceList.dart';

class ServiceSelectionButtons extends StatelessWidget {
  final double totalPrice;
  const ServiceSelectionButtons({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ServiceSelectButton(
          title: 'Select Services',
          onPressed: () => context.go("/services"),
        ),
        const SizedBox(height: 10),
        ServiceSelectButton(
          title: "Selected: ${globalServiceCartItems.length} | Total: ${totalPrice.toStringAsFixed(2)} EGP",
          onPressed: () => context.go("/selected"),
        ),
      ],
    );
  }
}
