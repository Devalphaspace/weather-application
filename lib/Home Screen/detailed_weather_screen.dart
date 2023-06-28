import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Models/weather_api_model.dart';

class DetailedWeatherScreen extends StatefulWidget {
  final WeatherAPIModel weatherAPIModel;
  final String placeName;
  const DetailedWeatherScreen({
    super.key,
    required this.weatherAPIModel,
    required this.placeName,
  });

  @override
  State<DetailedWeatherScreen> createState() => _DetailedWeatherScreenState();
}

class _DetailedWeatherScreenState extends State<DetailedWeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  Get.back();
                });
              },
              icon: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
            expandedHeight: Get.height * 0.2,
            collapsedHeight: 80,
            centerTitle: false,
            pinned: true,
            title: Text(
              widget.placeName.toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: widget.weatherAPIModel.current!.weather![0].id
                          .toString()[0] ==
                      '2'
                  ? Image.asset(
                      'assets/images/thunderstorm.jpeg',
                      fit: BoxFit.cover,
                    )
                  : widget.weatherAPIModel.current!.weather![0].id.toString()[0] ==
                          '3'
                      ? Image.asset(
                          'assets/images/rainy.jpg',
                          fit: BoxFit.cover,
                        )
                      : widget.weatherAPIModel.current!.weather![0].id.toString()[0] ==
                              '5'
                          ? Image.asset(
                              'assets/images/rainy.jpg',
                              fit: BoxFit.cover,
                            )
                          : widget.weatherAPIModel.current!.weather![0].id
                                      .toString()[0] ==
                                  '2'
                              ? Image.asset(
                                  'assets/images/winter2.jpg',
                                  fit: BoxFit.cover,
                                )
                              : widget.weatherAPIModel.current!.weather![0].id ==
                                      701
                                  ? Image.asset(
                                      'assets/images/mist.jpeg',
                                      fit: BoxFit.cover,
                                    )
                                  : widget.weatherAPIModel.current!.weather![0].id! >
                                              700 &&
                                          widget.weatherAPIModel.current!
                                                  .weather![0].id! <
                                              762
                                      ? Image.asset(
                                          'assets/images/mist.jpeg',
                                          fit: BoxFit.cover,
                                        )
                                      : widget.weatherAPIModel.current!
                                                  .weather![0].id ==
                                              762
                                          ? Image.asset(
                                              'assets/images/volcanic_ash.jpeg',
                                              fit: BoxFit.cover,
                                            )
                                          : widget.weatherAPIModel.current!.weather![0].id == 771
                                              ? Image.asset(
                                                  'assets/images/thunderstorm.jpeg',
                                                  fit: BoxFit.cover,
                                                )
                                              : widget.weatherAPIModel.current!.weather![0].id == 781
                                                  ? Image.asset(
                                                      'assets/images/tornado.jpeg',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : widget.weatherAPIModel.current!.weather![0].id == 800
                                                      ? Image.asset(
                                                          'assets/images/clear_sky.jpeg',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : widget.weatherAPIModel.current!.weather![0].id! > 800 && widget.weatherAPIModel.current!.weather![0].id! < 805
                                                          ? Image.asset(
                                                              'assets/images/cloudy_sky.jpeg',
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              'assets/images/summer2.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather now',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GridView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    children: [
                      WeatherNowComponents(
                        iconData: Icons.thermostat_rounded,
                        fieldName: 'Feels like',
                        fieldValue:
                            '${widget.weatherAPIModel.current!.feelsLike}°C',
                      ),
                      WeatherNowComponents(
                        iconData: Icons.wind_power_rounded,
                        fieldName: 'Wind',
                        fieldValue:
                            '${widget.weatherAPIModel.current!.windSpeed} km/h',
                      ),
                      WeatherNowComponents(
                        iconData: Icons.umbrella_rounded,
                        fieldName: 'Precipitation',
                        fieldValue:
                            '${widget.weatherAPIModel.minutely![0].precipitation}%',
                      ),
                      WeatherNowComponents(
                        iconData: Icons.water_drop_rounded,
                        fieldName: 'Humidity',
                        fieldValue:
                            '${widget.weatherAPIModel.current!.humidity}%',
                      ),
                      WeatherNowComponents(
                        iconData: Icons.compress_rounded,
                        fieldName: 'Pressure',
                        fieldValue:
                            '${widget.weatherAPIModel.current!.pressure}hPa',
                      ),
                      WeatherNowComponents(
                        iconData: Icons.visibility_rounded,
                        fieldName: 'Visibility',
                        fieldValue:
                            '${widget.weatherAPIModel.current!.visibility! / 1000}KM',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Prediction',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.weatherAPIModel.daily!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color:
                              index == 0 ? Colors.grey.shade200 : Colors.white,
                          border: Border.all(
                            color: index == 0
                                ? Colors.white
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: Get.width * 0.275,
                              child: Text(
                                DateFormat('EEEE')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                            widget.weatherAPIModel.daily![index]
                                                    .dt! *
                                                1000,
                                            isUtc: true)
                                        .toLocal())
                                    .toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: Get.width * 0.275,
                              child: Text(
                                '${widget.weatherAPIModel.daily![index].temp!.day!.round()}°C',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: Get.width * 0.275,
                              child: Text(
                                '${widget.weatherAPIModel.daily![index].weather![0].main}',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherNowComponents extends StatelessWidget {
  final IconData iconData;
  final String fieldName;
  final String fieldValue;
  const WeatherNowComponents({
    super.key,
    required this.iconData,
    required this.fieldName,
    required this.fieldValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16)),
          child: Icon(
            iconData,
            color: Colors.black,
            size: 36,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              fieldName,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fieldValue,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
