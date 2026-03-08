import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String comIpAddress = "192.168.1.1";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$comIpAddress:5050/api/';
    }

    if (kIsWeb) {
      return 'http://localhost:5050/api/';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050/api/';
    }

    if (Platform.isIOS) {
      return 'http://localhost:5050/api/';
    }

    return 'http://localhost:5050/api/';
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // User Endpoints
  static const String userRegister = 'auth/register';
  static const String userLogin = 'auth/login';
  static const String userProfile = 'auth/profile';
  static const String userLogout = 'auth/logout';

  // Booking Endpoints
  static const String createBooking = 'bookings';
  static const String userBookings = 'bookings/user';
  static const String bookingById = 'bookings/'; // Append ID
  static const String updateBookingStatus = 'bookings/'; // Append ID/status
  static const String deleteBooking = 'bookings/'; // Append ID

  // Movie Endpoints
  static const String movies = 'movies';
  static const String movieById = 'movies/'; // Append ID

  // Showtime Endpoints
  static const String showtimes = 'showtimes';
  static const String showtimeById = 'showtimes/'; // Append ID
  static const String checkAvailability = 'showtimes/';

  static get myTickets => null;

  static get getBookedSeats => null;

  static get bookTicket => null; // Append ID/check-availability
}
