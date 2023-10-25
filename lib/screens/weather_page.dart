import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'dart:developer';
import 'package:weather_app/services/weather_data.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: '');

  Future<WeatherModel>? _myData;

@override
void initState() {
  super.initState();
  _myData = getData(true, "");
}

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) {
      return "";
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _myData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
//If data has errors
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occured',
                  style: const TextStyle(fontSize: 18),
                ),
              );
//If data has no error
            } else if (snapshot.hasData) {
              final data = snapshot.data as WeatherModel;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color.fromARGB(255, 61, 61, 63),
                          Color.fromARGB(255, 56, 56, 61),
                          Color.fromARGB(255, 67, 67, 77),
                          Color.fromARGB(255, 122, 121, 120),
                          Color.fromARGB(255, 158, 157, 157)
                        ],
                        tileMode: TileMode.mirror)),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      AnimSearchBar(
                        rtl: true,
                        width: 400,
                        textController: textController,
                        onSuffixTap: () {
                          if (textController.text.isEmpty) {
                            log('No city entered');
                          } else {
                            setState(() {
                              _myData = getData(false, textController.text);
                            });
                            FocusScope.of(context).unfocus();
                          }
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _myData = getData(false, value);
                            });
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                Text(
                                  data.city,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              capitalizeFirstLetter(data.desc),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              '${data.temp}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return const Center(
            child: Text('Server timeout'),
          );
        },
      ),
    );
  }
}
