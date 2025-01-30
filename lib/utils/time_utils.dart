// lib/src/utils/time_utils.dart

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// Enum representing supported timezones.
enum Timezone {
  local,
  utcMinus3,
}

/// Enum representing the type of time format.
enum TimeFormat {
  date,
  time,
}

/// Returns the default launch date based on the current UTC time.
/// If current UTC time is before 14:00, returns today's date.
/// Otherwise, returns tomorrow's date.
DateTime getDefaultLaunchDate() {
  final nowUtc = DateTime.now().toUtc();
  if (nowUtc.hour < 14) {
    return DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
  } else {
    return nowUtc.add(Duration(days: 1));
  }
}

/// Returns the default launch time, which is the current UTC time rounded down to the nearest hour.
DateTime getDefaultLaunchTime() {
  final nowUtc = DateTime.now().toUtc();
  return DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day, nowUtc.hour);
}

/// Converts the given UTC time to the device's local timezone.
/// If the local timezone cannot be detected, defaults to UTC-3.
DateTime convertToLocalTime(DateTime utcTime) {
  try {
    return utcTime.toLocal();
  } catch (e) {
    // Fallback to UTC-3
    return utcTime.subtract(Duration(hours: 3));
  }
}

/// Formats the given DateTime object into a string with format YYYY-MM-DD.
String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

/// Formats the given DateTime object into a string with format HH:mm:ss.
String formatTime(DateTime time) {
  final DateFormat formatter = DateFormat('HH:mm:ss');
  return formatter.format(time);
}

/// Rounds the given time down to the nearest hour.
/// Example: 16:37:45 becomes 16:00:00.
DateTime roundTimeToNearestHour(DateTime time) {
  return DateTime(time.year, time.month, time.day, time.hour);
}

/// Retrieves the current local time as a formatted string.
/// If the local timezone cannot be detected, defaults to UTC-3.
String getCurrentLocalTimeString() {
  DateTime now;
  try {
    now = DateTime.now();
  } catch (e) {
    now = DateTime.now().toUtc().subtract(Duration(hours: 3));
  }
  return formatTime(now);
}

/// Retrieves the current UTC time as a formatted string.
String getCurrentUtcTimeString() {
  final nowUtc = DateTime.now().toUtc();
  return formatTime(nowUtc);
}
