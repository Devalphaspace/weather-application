import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Controller/state_controller.dart';
import 'package:weather_app/Home%20Screen/detailed_weather_screen.dart';
import 'package:weather_app/Shared/shared.dart';

import '../Models/weather_api_model.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  late Future<WeatherAPIModel> weatherAPIModel;
  String? currentAddress;
  Position? _currentPosition;
  bool locationEnabled = true;
  int locationPopUpShownTime = 0;
  Map<String, dynamic> weatherAPIMap = {};
  bool nextScreen = false;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    locationEnabled = serviceEnabled;
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location services are disabled. Please enable the services',
          ),
        ),
      );
      locationEnabled = false;
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
          ),
        );
        locationEnabled = false;
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied. Please enable it from the settings.'),
        ),
      );
      locationEnabled = false;
      return false;
    }
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    locationEnabled = true;
    return true;
  }

  Future<void> _getCurrentLocation() async {
    final hasPemission = await _handleLocationPermission();
    locationEnabled = hasPemission;
    if (!hasPemission) return;
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      log('Error from _getCurrentLocation: $e');
    });
    locationEnabled = await Geolocator.isLocationServiceEnabled();
  }

  Future<WeatherAPIModel> getWeatherDetails() async {
    String apiURL;
    apiURL = _currentPosition != null
        ? 'https://api.openweathermap.org/data/2.5/onecall?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&units=metric&appid=9e8c4f7652c78eafdd1fe21de5f5c30d'
        : StateController().enteredCity != 'None'
            ? 'https://api.openweathermap.org/data/2.5/onecall?q=${StateController().enteredCity}&units=metric&appid=9e8c4f7652c78eafdd1fe21de5f5c30d'
            : 'https://api.openweathermap.org/data/2.5/onecall?q=Bengaluru&units=metric&appid=9e8c4f7652c78eafdd1fe21de5f5c30d';
    final response = await http.get(Uri.parse(apiURL));

    var data = jsonDecode(response.body.toString());

    String apiURL2;
    apiURL2 = _currentPosition != null
        ? 'https://api.openweathermap.org/data/2.5/weather?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&units=metric&appid=9e8c4f7652c78eafdd1fe21de5f5c30d'
        : StateController().enteredCity != 'None'
            ? 'https://api.openweathermap.org/data/2.5/weather?q=${StateController().enteredCity}&appid=9e8c4f7652c78eafdd1fe21de5f5c30d&units=metric'
            : 'https://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=9e8c4f7652c78eafdd1fe21de5f5c30d&units=metric';
    final response2 = await http.get(Uri.parse(apiURL2));

    Map<String, dynamic> data2 =
        jsonDecode(response2.body.toString()) as Map<String, dynamic>;


    weatherAPIMap = data2;

    return WeatherAPIModel.fromJson(data);
  }

  // Future<void> getWeatherLocationDetails() async {
  //   String apiURL;
  //   apiURL = _currentPosition != null
  //       ? 'https://api.openweathermap.org/data/2.5/weather?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&units=metric&appid=9e8c4f7652c78eafdd1fe21de5f5c30d'
  //       : StateController().enteredCity != 'None'
  //           ? 'https://api.openweathermap.org/data/2.5/weather?q=${StateController().enteredCity}&appid=9e8c4f7652c78eafdd1fe21de5f5c30d&units=metric'
  //           : 'https://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=9e8c4f7652c78eafdd1fe21de5f5c30d&units=metric';
  //   final response = await http.get(Uri.parse(apiURL));

  //   Map<String, dynamic> data =
  //       jsonDecode(response.body.toString()) as Map<String, dynamic>;

  //   log(data.toString());

  //   weatherAPIMap = data;
  // }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    weatherAPIModel = getWeatherDetails();
    // getWeatherLocationDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      ElevatedButton(
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LocationPopUp();
                });
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0164FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: Size(Get.width * 0.325, 50),
        ),
        child: const Text(
          'Enable Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<WeatherAPIModel>(
            future: getWeatherDetails(),
            builder: (BuildContext context,
                AsyncSnapshot<WeatherAPIModel> weatherSnapshot) {
              if (weatherSnapshot.hasData && weatherAPIMap.isNotEmpty) {
                return _currentPosition != null
                    ? Container(
                        height: Get.height,
                        width: Get.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: weatherSnapshot.data!.current!.weather![0].id
                                        .toString()[0] ==
                                    '2'
                                ? const AssetImage(
                                    'assets/images/thunderstorm.jpeg')
                                : weatherSnapshot.data!.current!.weather![0].id
                                            .toString()[0] ==
                                        '3'
                                    ? const AssetImage(
                                        'assets/images/rainy.jpg')
                                    : weatherSnapshot.data!.current!.weather![0].id
                                                .toString()[0] ==
                                            '5'
                                        ? const AssetImage(
                                            'assets/images/rainy.jpg')
                                        : weatherSnapshot.data!.current!.weather![0].id
                                                    .toString()[0] ==
                                                '2'
                                            ? const AssetImage(
                                                'assets/images/winter2.jpg')
                                            : weatherSnapshot.data!.current!
                                                        .weather![0].id ==
                                                    701
                                                ? const AssetImage(
                                                    'assets/images/mist.jpeg')
                                                : weatherSnapshot.data!.current!.weather![0].id! > 700 &&
                                                        weatherSnapshot
                                                                .data!
                                                                .current!
                                                                .weather![0]
                                                                .id! <
                                                            762
                                                    ? const AssetImage('assets/images/mist.jpeg')
                                                    : weatherSnapshot.data!.current!.weather![0].id == 762
                                                        ? const AssetImage('assets/images/volcanic_ash.jpeg')
                                                        : weatherSnapshot.data!.current!.weather![0].id == 771
                                                            ? const AssetImage('assets/images/thunderstorm.jpeg')
                                                            : weatherSnapshot.data!.current!.weather![0].id == 781
                                                                ? const AssetImage('assets/images/tornado.jpeg')
                                                                : weatherSnapshot.data!.current!.weather![0].id == 800
                                                                    ? const AssetImage('assets/images/clear_sky.jpeg')
                                                                    : weatherSnapshot.data!.current!.weather![0].id! > 800 && weatherSnapshot.data!.current!.weather![0].id! < 805
                                                                        ? const AssetImage('assets/images/cloudy_sky.jpeg')
                                                                        : const AssetImage('assets/images/summer2.jpg'),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        padding: Platform.isAndroid
                            ? const EdgeInsets.all(16)
                            : const EdgeInsets.symmetric(horizontal: 16),
                        child: SafeArea(
                          child: nextScreen == false
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.7,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${weatherAPIMap['name']}'
                                                    .toUpperCase(),
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${weatherSnapshot.data!.current!.temp!.round()}°'
                                                    .toUpperCase(),
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 144,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _getCurrentLocation();
                                                  });
                                                },
                                                icon: const RotatedBox(
                                                  quarterTurns: 5,
                                                  child: Icon(
                                                    Icons.replay_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                '${weatherSnapshot.data!.current!.weather![0].description}',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Get.to(
                                                () => DetailedWeatherScreen(
                                                  weatherAPIModel:
                                                      weatherSnapshot.data!,
                                                  placeName:
                                                      weatherAPIMap['name'],
                                                ),
                                              );
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            foregroundColor: Colors.blue,
                                            backgroundColor: Colors.black38,
                                          ),
                                          child: Text(
                                            'More details',
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 3,
                                              sigmaY: 3,
                                            ),
                                            child: Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0.4),
                                                      Colors.black
                                                          .withOpacity(0.4),
                                                    ],
                                                    begin: AlignmentDirectional
                                                        .topStart,
                                                    end: AlignmentDirectional
                                                        .bottomEnd),
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 24),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${weatherSnapshot.data!.current!.temp}°C',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Temperature',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${weatherSnapshot.data!.current!.feelsLike}°C',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Feels Like',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${weatherSnapshot.data!.current!.windSpeed}m/s',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Wind Speed',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 18),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.0),
                                                    child: Divider(
                                                      color: Colors.white,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 18),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${weatherSnapshot.data!.current!.humidity}%',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Humidity',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${weatherSnapshot.data!.current!.visibility! / 1000}KM',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Visibility',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${weatherSnapshot.data!.current!.pressure}hPa',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Pressure',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 3,
                                        sigmaY: 3,
                                      ),
                                      child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.4),
                                              ],
                                              begin:
                                                  AlignmentDirectional.topStart,
                                              end: AlignmentDirectional
                                                  .bottomEnd),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          border: Border.all(
                                            width: 1.5,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          itemCount: weatherSnapshot
                                              .data!.daily!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  Text(
                                                      'Date: ${DateTime.fromMicrosecondsSinceEpoch(weatherSnapshot.data!.daily![index].dt!)}')
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      )
                    : const WeatherLoadingWidget();
              } else if (weatherSnapshot.hasError) {
                return Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/summer2.jpg'),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  child: Text('${weatherSnapshot.error}'),
                );
              }
              return const WeatherLoadingWidget();
            }),
      ),
    );
  }
}
