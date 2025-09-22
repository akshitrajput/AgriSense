class DailyForecast {
  final DateTime dateTime;
  final double temp;
  final int humidity;
  final String weatherDescription;
  final String weatherIconCode;

  DailyForecast({
    required this.dateTime,
    required this.temp,
    required this.humidity,
    required this.weatherDescription,
    required this.weatherIconCode,
  });

  // A factory constructor to create a DailyForecast from JSON
  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (json['temp']['day'] as num).toDouble(),
      humidity: json['humidity'] as int,
      weatherDescription: json['weather'][0]['description'] as String,
      weatherIconCode: json['weather'][0]['icon'] as String,
    );
  }
}

