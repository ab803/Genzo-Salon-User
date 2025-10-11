import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Booking/ViewModel/service__cubit.dart';
import 'package:userbarber/Feature/Booking/ViewModel/service__state.dart';
import 'package:userbarber/core/Models/Service.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/serviceList.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final flutterLocalization = FlutterLocalization.instance;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor:
        isDark ? AppColors.darkBackground : AppColors.lightBackground,
        centerTitle: true,
        title: Text(
          "services".getString(context), // ✅ localized
          style: AppTextStyles.heading(
              isDark ? AppColors.darkText : AppColors.primaryNavy),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? AppColors.darkText : AppColors.lightText),
          onPressed: () {
            context.go("/booking");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () {
              context.read<ServiceCubit>().loadServices();
            },
          ),
        ],
      ),
      body: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentyellow,
                ));
          } else if (state is ServiceLoaded) {
            final List<Service> services = state.services;
            if (services.isEmpty) {
              return Center(
                  child: Text("noServices".getString(context))); // ✅ localized
            }

            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      service.name,
                      style: AppTextStyles.subheading(
                          isDark ? AppColors.darkText : AppColors.primaryNavy),
                    ),
                    subtitle: Text(
                      "${service.price.toStringAsFixed(2)} ${"currency".getString(context)}", // ✅ localized currency
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // ✅ Add service to global list
                        if (!globalServiceCartItems
                            .any((s) => s.id == service.id)) {
                          globalServiceCartItems.add(service);
                          Fluttertoast.showToast(
                            msg:
                            "${service.name} ${"added".getString(context)}", // ✅ localized toast
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            backgroundColor: AppColors.accentyellow,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg:
                            "${service.name} ${"alreadyAdded".getString(context)}", // ✅ localized toast
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            backgroundColor: AppColors.accentyellow,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      icon: const Icon(Icons.add, color: AppColors.accentyellow),
                    ),
                  ),
                );
              },
            );
          } else if (state is ServiceError) {
            return Center(child: Text(state.message));
          }

          return Center(
              child: Text("pressToLoad".getString(context))); // ✅ localized
        },
      ),
    );
  }
}
