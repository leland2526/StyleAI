import 'package:dio/dio.dart';
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

  /// 获取当前天气
  Future<WeatherData?> getCurrentWeather() async {
    // 返回缓存数据
    if (_isCacheValid) {
      return _cachedWeather;
    }

    // MVP版本使用默认天气
    // TODO: 后续版本添加位置服务或用户手动选择城市
    return _getDefaultWeather();
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