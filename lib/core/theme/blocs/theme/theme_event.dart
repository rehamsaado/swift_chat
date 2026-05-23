import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class InitializeTheme extends ThemeEvent {}
class ToggleTheme extends ThemeEvent {}
class SetLightTheme extends ThemeEvent {}
class SetDarkTheme extends ThemeEvent {}
class SetSystemTheme extends ThemeEvent {}

// حدث داخلي خاص لتحديث الحالة عند تغير ThemeManager
class ThemeStateChanged extends ThemeEvent {} 