import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/services/weather_data.dart';

class ForecastWidget extends StatefulWidget {
  final bool isCurrentCity;
  final String cityName;

  const ForecastWidget({
    Key? key,
    required this.isCurrentCity,
    required this.cityName,
  }) : super(key: key);

  @override
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  Future<ForecastModel>? futureForecastData;

  @override
  void initState() {
    super.initState();
    futureForecastData = getForecastData();
  }

  @override
  void didUpdateWidget(covariant ForecastWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cityName != widget.cityName || 
        oldWidget.isCurrentCity != widget.isCurrentCity) {
      setState(() {
        futureForecastData = getForecastData();
      });
    }
  }

  Future<ForecastModel> getForecastData() async {
    return await CallForecastToApi()
        .callWeatherAPi(widget.isCurrentCity, widget.cityName);
  }

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) {
      return "";
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ForecastModel>(
      future: futureForecastData,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final ForecastModel forecastData = snapshot.data!;
          final dailyForecasts = forecastData.getDailyForecasts();
          return ListView.builder(
            itemCount: dailyForecasts.length,
            itemBuilder: (context, index) {
              final dayForecast = dailyForecasts[index];
              return ListTile(
                title: Text(
                  dayForecast.dateTime,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  capitalizeFirstLetter(dayForecast.description),
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  "${dayForecast.temp.toStringAsFixed(1)}°C",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

