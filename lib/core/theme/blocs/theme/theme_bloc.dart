
import 'package:bloc/bloc.dart';

import '../../constants/theme_manager.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeManager _themeManager = ThemeManager();

  ThemeBloc() : super(ThemeInitial()) {
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetLightTheme>(_onSetLightTheme);
    on<SetDarkTheme>(_onSetDarkTheme);
    on<SetSystemTheme>(_onSetSystemTheme);
    on<ThemeStateChanged>(_onThemeStateChanged);
    _themeManager.addListener(_onThemeManagerChanged);
  }

  Future<void> _onInitializeTheme(
    InitializeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeLoading());
    try {
      await _themeManager.initialize();
      emit(ThemeLoaded(
        themeMode: _themeManager.themeMode,
        isDarkMode: _themeManager.isDarkMode,
        currentTheme: _themeManager.getCurrentTheme(),
      ));
    } catch (e) {
      emit(ThemeError('Failed to initialize theme: $e'));
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.toggleTheme();
      // تحديث الحالة مباشرة بعد تغيير الثيم
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        emit(currentState.copyWith(
          themeMode: _themeManager.themeMode,
          isDarkMode: _themeManager.isDarkMode,
          currentTheme: _themeManager.getCurrentTheme(),
        ));
      }
    } catch (e) {
      emit(ThemeError('Failed to toggle theme: $e'));
    }
  }

  Future<void> _onSetLightTheme(
    SetLightTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.setLightTheme();
      // تحديث الحالة مباشرة بعد تغيير الثيم
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        emit(currentState.copyWith(
          themeMode: _themeManager.themeMode,
          isDarkMode: _themeManager.isDarkMode,
          currentTheme: _themeManager.getCurrentTheme(),
        ));
      }
    } catch (e) {
      emit(ThemeError('Failed to set light theme: $e'));
    }
  }

  Future<void> _onSetDarkTheme(
    SetDarkTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.setDarkTheme();
      // تحديث الحالة مباشرة بعد تغيير الثيم
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        emit(currentState.copyWith(
          themeMode: _themeManager.themeMode,
          isDarkMode: _themeManager.isDarkMode,
          currentTheme: _themeManager.getCurrentTheme(),
        ));
      }
    } catch (e) {
      emit(ThemeError('Failed to set dark theme: $e'));
    }
  }

  Future<void> _onSetSystemTheme(
    SetSystemTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.setSystemTheme();
      // تحديث الحالة مباشرة بعد تغيير الثيم
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        emit(currentState.copyWith(
          themeMode: _themeManager.themeMode,
          isDarkMode: _themeManager.isDarkMode,
          currentTheme: _themeManager.getCurrentTheme(),
        ));
      }
    } catch (e) {
      emit(ThemeError('Failed to set system theme: $e'));
    }
  }

  void _onThemeManagerChanged() {
    // عند تغيير ThemeManager نطلق حدثاً ليتم التعامل معه داخل الـ Bloc بشكل آمن
    if (!isClosed) {
      add(ThemeStateChanged());
    }
  }

  Future<void> _onThemeStateChanged(
    ThemeStateChanged event,
    Emitter<ThemeState> emit,
  ) async {
    // تحديث الحالة عند طلب تغيير الحالة
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      emit(currentState.copyWith(
        themeMode: _themeManager.themeMode,
        isDarkMode: _themeManager.isDarkMode,
        currentTheme: _themeManager.getCurrentTheme(),
      ));
    }
  }
} 