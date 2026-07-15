import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PinAuthStatus {
  success,
  invalid,
  locked,
  notConfigured,
}

class PinAuthResult {
  final PinAuthStatus status;
  final int? remainingSeconds;

  const PinAuthResult(this.status, {this.remainingSeconds});

  bool get isSuccess => status == PinAuthStatus.success;
}

class AuthService {
  static const _pinKeyLegacy = 'user_pin';
  static const _pinHashKey = 'user_pin_hash';
  static const _pinSaltKey = 'user_pin_salt';
  static const _failedAttemptsKey = 'user_pin_failed_attempts';
  static const _lockedUntilEpochMsKey = 'user_pin_locked_until_ms';

  static const int _maxFailedAttempts = 5;
  static const Duration _lockDuration = Duration(minutes: 5);

  String _generateSalt() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(24, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    return sha256.convert(bytes).toString();
  }

  int _remainingLockSeconds(int lockedUntilEpochMs) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final remainingMs = lockedUntilEpochMs - nowMs;
    if (remainingMs <= 0) return 0;
    return (remainingMs / 1000).ceil();
  }

  Future<void> _clearLockState(SharedPreferences prefs) async {
    await prefs.remove(_failedAttemptsKey);
    await prefs.remove(_lockedUntilEpochMsKey);
  }

  Future<PinAuthResult?> _checkLockState(SharedPreferences prefs) async {
    final lockedUntil = prefs.getInt(_lockedUntilEpochMsKey);
    if (lockedUntil == null) return null;

    final remaining = _remainingLockSeconds(lockedUntil);
    if (remaining <= 0) {
      await _clearLockState(prefs);
      return null;
    }

    return PinAuthResult(PinAuthStatus.locked, remainingSeconds: remaining);
  }

  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pinHashKey) || prefs.containsKey(_pinKeyLegacy);
  }

  Future<void> createPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);

    await prefs.setString(_pinSaltKey, salt);
    await prefs.setString(_pinHashKey, hash);
    await prefs.remove(_pinKeyLegacy);
    await _clearLockState(prefs);
  }

  Future<bool> verifyPin(String pin) async {
    final result = await verifyPinWithStatus(pin);
    return result.isSuccess;
  }

  Future<PinAuthResult> verifyPinWithStatus(String pin) async {
    final prefs = await SharedPreferences.getInstance();

    final lockState = await _checkLockState(prefs);
    if (lockState != null) {
      return lockState;
    }

    final storedHash = prefs.getString(_pinHashKey);
    final storedSalt = prefs.getString(_pinSaltKey);
    final legacyPin = prefs.getString(_pinKeyLegacy);

    if (storedHash == null && legacyPin == null) {
      return const PinAuthResult(PinAuthStatus.notConfigured);
    }

    bool isValid = false;
    if (storedHash != null && storedSalt != null) {
      isValid = _hashPin(pin, storedSalt) == storedHash;
    } else if (legacyPin != null) {
      isValid = legacyPin == pin;
      if (isValid) {
        await createPin(pin);
      }
    }

    if (isValid) {
      await _clearLockState(prefs);
      return const PinAuthResult(PinAuthStatus.success);
    }

    final attempts = (prefs.getInt(_failedAttemptsKey) ?? 0) + 1;
    if (attempts >= _maxFailedAttempts) {
      final lockedUntil =
          DateTime.now().add(_lockDuration).millisecondsSinceEpoch;
      await prefs.setInt(_lockedUntilEpochMsKey, lockedUntil);
      await prefs.remove(_failedAttemptsKey);
      return PinAuthResult(
        PinAuthStatus.locked,
        remainingSeconds: _remainingLockSeconds(lockedUntil),
      );
    }

    await prefs.setInt(_failedAttemptsKey, attempts);
    return const PinAuthResult(PinAuthStatus.invalid);
  }

  Future<void> deletePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKeyLegacy);
    await prefs.remove(_pinHashKey);
    await prefs.remove(_pinSaltKey);
    await _clearLockState(prefs);
  }
}
