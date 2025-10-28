import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Booking/Booking%20detials.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__cubit.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__state.dart';
import 'package:userbarber/Feature/Booking/Widgets/BookingCard.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class BookingHistoryView extends StatefulWidget {
  const BookingHistoryView({super.key});

  @override
  State<BookingHistoryView> createState() => _BookingHistoryViewState();
}

class _BookingHistoryViewState extends State<BookingHistoryView> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<BookingCubit>().loadBookings(userId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "bookingHistory".getString(context),
          style: AppTextStyles.heading(
            isDark ? AppColors.darkText : AppColors.primaryNavy,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.accentyellow : AppColors.primaryNavy,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.accentyellow : AppColors.primaryNavy,
            ),
            onPressed: () {
              context.read<BookingCubit>().loadBookings(userId);
            },
          ),
        ],
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          } else if (state is BookingLoaded) {
            final bookings = state.booking;
            if (bookings.isEmpty) {
              return Center(
                child: Text(
                  "noBookings".getString(context),
                  style: AppTextStyles.body(
                    isDark ? AppColors.darkSecondaryText : AppColors.lightText,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingDetailsView(booking: booking),
                      ),
                    );
                  },
                  child: BookingCard(booking: booking),
                );
              },
            );
          } else if (state is BookingError) {
            return Center(
              child: Text(
                "error ${state.message}".getString(context),
                style: AppTextStyles.body(Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
