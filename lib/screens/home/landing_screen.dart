import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/provider/settings.dart';
import 'package:instagram_clone/screens/home/home_page.dart';
import 'package:instagram_clone/screens/home/reel_screen.dart';
import 'package:instagram_clone/screens/home/explore_page.dart';
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
          height: 55,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setCurrentHomeScreenIndex(currentIndex);
                    homePageTabController!
                        .animateTo(0, curve: Curves.easeInOut);
                  },
                  child: Stack(
                    children: [
                      ExtendedImage.asset(
                        'assets/icons/home_outlined.png',
                        height: 24,
                        width: 24,
                        color: currentIndex != 0
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Colors.transparent,
                      ),
                      ExtendedImage.asset(
                        'assets/icons/home_filled.png',
                        height: 24,
                        width: 24,
                        color: currentIndex == 0
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                    homePageTabController!.animateTo(1);
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setCurrentHomeScreenIndex(currentIndex);
                  },
                  child: Stack(
                    children: [
                      ExtendedImage.asset(
                        'assets/icons/search_outlined.png',
                        height: 24,
                        width: 24,
                        color: currentIndex != 1
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Colors.transparent,
                      ),
                      ExtendedImage.asset(
                        'assets/icons/search_filled.png',
                        height: 24,
                        width: 24,
                        color: currentIndex == 1
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 2;
                      tabController!.animateTo(0);
                    });
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setCurrentHomeScreenIndex(currentIndex);
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
                    });
                    homePageTabController!.animateTo(2);
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setCurrentHomeScreenIndex(currentIndex);
                  },
                  child: Stack(
                    children: [
                      ExtendedImage.asset(
                        'assets/icons/reel_outlined.png',
                        height: 24,
                        width: 24,
                        color: currentIndex != 3
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Colors.transparent,
                      ),
                      ExtendedImage.asset(
                        'assets/icons/reel_filled.png',
                        height: 24,
                        width: 24,
                        color: currentIndex == 3
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 4;
                    });
                    homePageTabController!.animateTo(3);
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setCurrentHomeScreenIndex(currentIndex);
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
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: TabBarView(
            controller: homePageTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              ExplorePage(),
              ReelScreen(),
              Center(child: Text('Profile')),
            ],
          ),
        ));
  }
}
