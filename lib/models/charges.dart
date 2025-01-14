import 'package:flutter/material.dart';

class Charges {
  final bool isDeliveryChargesEnabled;
  final double? deliveryCharges;
  final String? startDateStr;
  final String? endDateStr;
  final int? startTimeMinutes;
  final int? endTimeMinutes;

  // Getters with null safety and error handling
  DateTime? get startDate {
    try {
      return startDateStr != null ? DateTime.parse(startDateStr!) : null;
    } catch (e) {
      print('Error parsing startDate: $e');
      return null;
    }
  }

  DateTime? get endDate {
    try {
      return endDateStr != null ? DateTime.parse(endDateStr!) : null;
    } catch (e) {
      print('Error parsing endDate: $e');
      return null;
    }
  }

  TimeOfDay? get startTime => startTimeMinutes != null
      ? minutesToTimeOfDay(startTimeMinutes!)
      : null;

  TimeOfDay? get endTime => endTimeMinutes != null
      ? minutesToTimeOfDay(endTimeMinutes!)
      : null;

  Charges({
    required this.isDeliveryChargesEnabled,
    this.deliveryCharges,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  })  : startDateStr = startDate?.toIso8601String(),
        endDateStr = endDate?.toIso8601String(),
        startTimeMinutes =
            startTime != null ? timeOfDayToMinutes(startTime) : null,
        endTimeMinutes = endTime != null ? timeOfDayToMinutes(endTime) : null;

  factory Charges.fromMap(Map<String, dynamic> map) {
  double? parseDeliveryCharges(dynamic value) {
    try {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    } catch (e) {
      print('Error parsing delivery charges: $e');
      return null;
    }
  }

  DateTime? parseDateTime(dynamic value) {
    try {
      if (value == null) return null;
      if (value is String) return DateTime.parse(value);
      return null;
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }

  TimeOfDay? parseTimeOfDay(dynamic value) {
    try {
      if (value == null) return null;
      if (value is int) return minutesToTimeOfDay(value);
      if (value is String) {
        final intMinutes = int.tryParse(value);
        return intMinutes != null ? minutesToTimeOfDay(intMinutes) : null;
      }
      return null;
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }

  return Charges(
    isDeliveryChargesEnabled: map['isDeliveryChargesEnabled'] ?? false,
    deliveryCharges: parseDeliveryCharges(map['deliveryCharges']),
    startDate: parseDateTime(map['startDate']),
    endDate: parseDateTime(map['endDate']),
    startTime: parseTimeOfDay(map['startTime']),
    endTime: parseTimeOfDay(map['endTime']),
  );
}


  static int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  static TimeOfDay minutesToTimeOfDay(int minutes) {
    return TimeOfDay(
      hour: minutes ~/ 60,
      minute: minutes % 60,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDeliveryChargesEnabled': isDeliveryChargesEnabled,
      'deliveryCharges': deliveryCharges,
      'startDateStr': startDateStr,
      'endDateStr': endDateStr,
      'startTimeMinutes': startTimeMinutes,
      'endTimeMinutes': endTimeMinutes,
    };
  }

  // Helper method to validate time range
  bool isValidTimeRange() {
    if (startTime == null || endTime == null) return true;
    final startMinutes = timeOfDayToMinutes(startTime!);
    final endMinutes = timeOfDayToMinutes(endTime!);
    return endMinutes > startMinutes;
  }

  // Helper method to validate date range
  bool isValidDateRange() {
    if (startDate == null || endDate == null) return true;
    return endDate!.isAfter(startDate!);
  }
}
