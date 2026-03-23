import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../data/models/weather/weather_data.dart';

class WeatherService {
  final Dio _dio;
  final String? _apiKey;
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherData? _cachedWeather;
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(minutes: 30);

  WeatherService({Dio? dio, String? apiKey})
      : _dio = dio ?? Dio(),
        _apiKey = apiKey ?? const String.fromEnvironment('OPENWEATHER_API_KEY');

  bool get _isCacheValid =>
      _cachedWeather != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheValidDuration;

  /// 获取当前位置天气
  Future<WeatherData?> getCurrentWeather() async {
    // 返回缓存数据
    if (_isCacheValid) {
      return _cachedWeather;
    }

    try {
      // 获取位置
      final position = await _getCurrentPosition();
      if (position == null) {
        return _getDefaultWeather();
      }

      // 获取天气数据
      final weather = await _fetchWeather(position.latitude, position.longitude);
      _cachedWeather = weather;
      _lastFetchTime = DateTime.now();
      return weather;
    } catch (e) {
      return _getDefaultWeather();
    }
  }

  /// 获取位置
  Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// 调用API获取天气
  Future<WeatherData> _fetchWeather(double lat, double lon) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return _getDefaultWeather();
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
          'lang': 'zh_cn',
        },
      );

      return WeatherData.fromOpenWeather(response.data);
    } catch (e) {
      return _getDefaultWeather();
    }
  }

  /// 默认天气（无网络时使用）
  WeatherData _getDefaultWeather() {
    return WeatherData(
      location: '北京',
      temp: 22,
      tempMin: 18,
      tempMax: 26,
      condition: '晴',
      conditionCode: '01d',
      humidity: 50,
      windSpeed: 3.0,
      timestamp: DateTime.now(),
    );
  }

  /// 清除缓存
  void clearCache() {
    _cachedWeather = null;
    _lastFetchTime = null;
  }
}
