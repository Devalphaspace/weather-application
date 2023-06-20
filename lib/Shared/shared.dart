import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Constant/constant.dart';
import 'package:weather_app/Controller/state_controller.dart';

class WeatherLoadingWidget extends StatefulWidget {
  const WeatherLoadingWidget({super.key});

  @override
  State<WeatherLoadingWidget> createState() => _WeatherLoadingWidgetState();
}

class _WeatherLoadingWidgetState extends State<WeatherLoadingWidget> {
  var rng = Random();
  int randNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < 10; i++) {
      randNum = rng.nextInt(10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: LottieBuilder.asset(
                  'assets/json/76622-weather.json',
                  repeat: true,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Text(
                '"${weatherQuotes[randNum]}"',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String textFieldLabel;
  final TextEditingController cityController;
  const CustomTextField({
    required this.icon,
    required this.textFieldLabel,
    required this.cityController,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
      ),
      controller: widget.cityController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.white,
          ),
        ),
        labelText: widget.textFieldLabel,
        labelStyle: GoogleFonts.roboto(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LocationPopUp extends StatefulWidget {
  const LocationPopUp({super.key});

  @override
  State<LocationPopUp> createState() => _LocationPopUpState();
}

class _LocationPopUpState extends State<LocationPopUp> {
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StateController controller = Get.put(StateController());
    return GetBuilder<StateController>(builder: (stateController) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
            ),
            child: Container(
              height: Get.height * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.4),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 1.5,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextField(
                      cityController: cityController,
                      icon: Icons.location_on_rounded,
                      textFieldLabel: 'Enter your city',
                    ),
                    const SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Get.back();
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
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              stateController.updateCity(cityController.text);
                              Get.back();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0164FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(Get.width * 0.325, 50)),
                          child: const Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
