import 'package:flutter/material.dart';

class IconHelper {
  // Mapping of String names to actual Flutter Icons
  static const Map<String, IconData> _iconMap = {
    'solar_power': Icons.solar_power,
    'solar_power_rounded': Icons.solar_power_rounded,
    'battery_charging_full': Icons.battery_charging_full,
    'battery_charging_full_rounded': Icons.battery_charging_full_rounded,
    'power': Icons.power,
    'power_rounded': Icons.power_rounded,
    'wind_power': Icons.wind_power,
    'wind_power_rounded': Icons.wind_power_rounded,
    'cable': Icons.cable,
    'cable_rounded': Icons.cable_rounded,
    'ev_station': Icons.ev_station,
    'ev_station_rounded': Icons.ev_station_rounded,
    'bolt': Icons.bolt,
    'bolt_rounded': Icons.bolt_rounded,
    'error': Icons.error,
  };

  /// Returns an IconData based on the string name. Defaults to [Icons.error] if not found.
  static IconData getIcon(String? iconName) {
    if (iconName == null) return Icons.category;
    return _iconMap[iconName] ?? Icons.category;
  }

  /// Converts a hex string like "#FF0000" or "FF0000" to a Color object.
  static Color getColorFromHex(String? hexColor, {Color fallback = Colors.grey}) {
    if (hexColor == null || hexColor.isEmpty) return fallback;
    
    String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add opacity if missing
    }
    
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return fallback;
    }
  }
}
