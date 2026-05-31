import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/feature/auth/controller/login/login_cubit.dart';
import 'package:shoply/feature/auth/controller/register/register_cubit.dart';
import 'package:shoply/feature/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shoply/feature/auth/view/register_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shoply/core/storage_helper/app_shared_preference_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const String routeName = "OnboardingScreen";

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingData> onboardingList = dataOnboarding();
  int index = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! image onboarding
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  itemBuilder: (context, index) => CustomAnimatedWidget(
                    delay: index,
                    index: index,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        onboardingList[index].image,
                        width: 343,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  itemCount: onboardingList.length,
                ),
              ),
              SizedBox(height: 35),
              //! indicator onboarding
              SmoothPageIndicator(
                controller: controller,
                count: onboardingList.length,
                axisDirection: Axis.horizontal,
                effect: ExpandingDotsEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  dotColor: Color(0xffAFAFAF),
                  activeDotColor: Color(0xff212121),
                ),
              ),
              //! title onboarding and description onboarding
              SizedBox(height: 50),
              CustomAnimatedWidget(
                delay: (index + 1) * 100,
                index: index,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        onboardingList[index].title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff24252C),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        onboardingList[index].description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6E6A7C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
              //! button next onboarding
              MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: () {
                  if (index < onboardingList.length - 1) {
                    controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  } else {
                    SharedPreferencesHelper.saveData(key: 'onboarding_seen', value: true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RegisterCubit(),
                          child: RegisterScreen(),
                        ),
                      ),
                    );
                  }
                },
                color: Color(0xff212121),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  index < onboardingList.length - 1 ? "Next" : "Get Started",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// data class
class OnboardingData {
  final String title;
  final String description;
  final String image;
  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

// data onboarding
List<OnboardingData> dataOnboarding() {
  return [
    OnboardingData(
      title: 'Discover Trends',
      description: 'Now we are here to provide variety of the best fashion',
      image: 'assets/image/onboarding-1-screen.png',
    ),
    OnboardingData(
      title: 'Latest out fit',
      description: 'Express your self through the art of the fashionism',
      image: 'assets/image/onboarding-2-screen.png',
    ),
  ];
}

class CustomAnimatedWidget extends StatelessWidget {
  const CustomAnimatedWidget({
    super.key,
    required this.index,
    required this.delay,
    required this.child,
  });
  final int index;
  final int delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (index == 1) {
      return FadeInDown(
        delay: Duration(milliseconds: delay),
        child: child,
      );
    }
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: child,
    );
  }
}
