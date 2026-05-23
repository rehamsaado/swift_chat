import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}
class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  final bool isDarkMode;
  final ThemeData currentTheme;

  const ThemeLoaded({
    required this.themeMode,
    required this.isDarkMode,
    required this.currentTheme,
  });

  @override
  List<Object?> get props => [themeMode, isDarkMode, currentTheme];

  ThemeLoaded copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
    ThemeData? currentTheme,
  }) {
    return ThemeLoaded(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}

class ThemeError extends ThemeState {
  final String message;
  const ThemeError(this.message);
  @override
  List<Object?> get props => [message];
} 