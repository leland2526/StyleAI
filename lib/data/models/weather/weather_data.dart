class WeatherData {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String conditionCode;
  final int humidity;
  final double windSpeed;
  final DateTime timestamp;

  WeatherData({
    required this.location,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.conditionCode,
    required this.humidity,
    required this.windSpeed,
    required this.timestamp,
  });

  factory WeatherData.fromOpenWeather(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;

    return WeatherData(
      location: json['name'] as String? ?? '未知',
      temp: (main['temp'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      condition: weather['description'] as String,
      conditionCode: weather['icon'] as String,
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      timestamp: DateTime.now(),
    );
  }

  String get temperatureDisplay => '${temp.round()}°C';
  String get conditionDisplay => _getConditionEmoji();

  String _getConditionEmoji() {
    switch (conditionCode) {
      case '01d':
        return '☀️';
      case '01n':
        return '🌙';
      case '02d':
      case '02n':
        return '⛅';
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return '☁️';
      case '09d':
      case '09n':
        return '🌧️';
      case '10d':
      case '10n':
        return '🌦️';
      case '11d':
      case '11n':
        return '⛈️';
      case '13d':
      case '13n':
        return '❄️';
      case '50d':
      case '50n':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'temp': temp,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'condition': condition,
      'conditionCode': conditionCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['location'] as String,
      temp: (json['temp'] as num).toDouble(),
      tempMin: (json['tempMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      condition: json['condition'] as String,
      conditionCode: json['conditionCode'] as String,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
