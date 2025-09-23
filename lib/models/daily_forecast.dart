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

  // Updated factory constructor for weatherapi.com
  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    // The main data is now nested inside a 'day' object
    final dayData = json['day'] as Map<String, dynamic>;
    final conditionData = dayData['condition'] as Map<String, dynamic>;

    return DailyForecast(
      // 'date_epoch' provides the timestamp
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['date_epoch'] as int) * 1000),
      // 'avgtemp_c' is the average temperature
      temp: (dayData['avgtemp_c'] as num).toDouble(),
      // 'avghumidity' is the average humidity
      humidity: (dayData['avghumidity'] as num).toInt(),
      // 'text' inside 'condition' is the description
      weatherDescription: conditionData['text'] as String,
      // 'icon' inside 'condition' is the icon path
      weatherIconCode: conditionData['icon'] as String,
    );
  }
}
