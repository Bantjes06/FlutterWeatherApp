import 'package:intl/intl.dart';

class ForecastModel {
  List<Forecast> forecasts;

  ForecastModel({required this.forecasts});

  factory ForecastModel.fromMap(Map<String, dynamic> json) {
    var list = json['list'] as List;
    List<Forecast> forecastList =
        list.map((item) => Forecast.fromMap(item)).toList();
    return ForecastModel(forecasts: forecastList);
  }

  // This function will return a list of daily average forecasts.
  List<Forecast> getDailyForecasts() {
    Map<String, List<Forecast>> groupedForecasts = {};

    for (var forecast in forecasts) {
      DateTime dateObject = DateTime.parse(forecast.dateTime);
      String date = DateFormat('yyyy-MM-dd').format(dateObject);

      if (groupedForecasts[date] == null) {
        groupedForecasts[date] = [];
      }

      groupedForecasts[date]!.add(forecast);
    }

    List<Forecast> dailyForecasts = [];

    groupedForecasts.forEach((date, forecastList) {
      double avgTemp = 0;
      String main = '';
      String description = '';

      for (var forecast in forecastList) {
        avgTemp += forecast.temp;
      }

      avgTemp = avgTemp / forecastList.length;

      // Assuming you want the main and description from the first forecast of the day.
      main = forecastList[0].main;
      description = forecastList[0].description;

      dailyForecasts.add(Forecast(
        dateTime: date,
        temp: avgTemp,
        main: main,
        description: description,
      ));
    });
    print('Daily Forecasts: $dailyForecasts');
    return dailyForecasts;
  }
}

class Forecast {
  final String dateTime;
  final double temp;
  final String main;
  final String description;

  Forecast({
    required this.dateTime,
    required this.temp,
    required this.main,
    required this.description,
  });

  factory Forecast.fromMap(Map<String, dynamic> json) {
    return Forecast(
      dateTime: json['dt_txt'] as String,
      temp: json['main']['temp'] as double,
      main: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
    );
  }
}
