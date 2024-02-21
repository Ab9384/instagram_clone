import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/screens/home/home_page.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController? homePageTabController;

  @override
  void initState() {
    homePageTabController =
        TabController(initialIndex: 0, length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<AppData>(context).userModel!;
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                    homePageTabController!.animateTo(0);
                  });
                },
                child: ExtendedImage.asset(
                  currentIndex == 0
                      ? 'assets/icons/home_filled.png'
                      : 'assets/icons/home_outlined.png',
                  height: 24,
                  width: 24,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 1;
                    homePageTabController!.animateTo(1);
                  });
                },
                child: ExtendedImage.asset(
                  currentIndex == 1
                      ? 'assets/icons/search_filled.png'
                      : 'assets/icons/search_outlined.png',
                  height: 24,
                  width: 24,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                    tabController!.animateTo(0);
                  });
                },
                child: ExtendedImage.asset(
                  'assets/icons/add_outlined.png',
                  height: 24,
                  width: 24,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 3;
                    homePageTabController!.animateTo(2);
                  });
                },
                child: ExtendedImage.asset(
                  currentIndex == 3
                      ? 'assets/icons/reel_filled.png'
                      : 'assets/icons/reel_outlined.png',
                  height: 24,
                  width: 24,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 4;
                    homePageTabController!.animateTo(3);
                  });
                },
                child: ExtendedImage.network(
                  userModel.profilePhoto ??
                      (userModel.gender!.toLowerCase() == 'male'
                          ? maleAvatar
                          : femaleAvatar),
                  height: 26,
                  width: 26,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: homePageTabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            Center(child: Text('Search')),
            Center(child: Text('Reels')),
            Center(child: Text('Profile')),
          ],
        ));
  }
}
