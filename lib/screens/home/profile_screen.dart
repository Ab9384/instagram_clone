import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/functions/navigator_function.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/screens/profile/share_profile.dart';
import 'package:instagram_clone/utils/app_colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? profileTabController;

  @override
  void initState() {
    profileTabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    UserModel userModel = provider.userModel!;
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
            SliverAppBar(
              floating: true,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                children: [
                  const Icon(CupertinoIcons.lock, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    userModel.username!,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icons/add_outlined.png',
                      height: 25,
                      width: 25,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.line_horizontal_3_decrease,
                        size: 25)),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(userModel.profilePhoto!),
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.cover)),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        width: 1.5),
                                    color: AppColors.instagramDarkPrimary),
                                child: const Icon(
                                  Icons.add,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    userModel.posts!.length.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                  Text(
                                    'posts',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    userModel.followers!.length.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                  Text(
                                    'followers',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    userModel.following!.length.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                  Text(
                                    'following',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.fullName!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                        const SizedBox(height: 5),
                        if (userModel.bio != null && userModel.bio!.isNotEmpty)
                          Text(
                            userModel.bio!,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color),
                          ),
                        const SizedBox(height: 5),
                        if (userModel.website != null &&
                            userModel.website!.isNotEmpty)
                          Text(
                            userModel.website!,
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.instagramDarkPrimary),
                          ),

                        // edit / share profile button
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 0, bottom: 0),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  NavigatorFunctions.navigateTo(
                                      context, const ShareProfileScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 0, bottom: 0),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Share Profile',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.person_add,
                                  size: 20,
                                  color: Colors.white,
                                ))
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TabBar(
                    key: const PageStorageKey('profileTabBar'),
                    indicatorSize: TabBarIndicatorSize.tab,
                    automaticIndicatorColorAdjustment: true,
                    indicatorWeight: 3,
                    isScrollable: false,
                    labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                    unselectedLabelColor: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.5),
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(
                        icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
                      ),
                      Tab(
                        icon: Icon(CupertinoIcons.profile_circled),
                      ),
                    ],
                    controller: profileTabController!),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.width,
                child: TabBarView(
                  controller: profileTabController,
                  children: [
                    // posts
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1),
                      itemCount: provider.postList.length,
                      itemBuilder: (context, index) {
                        return ExtendedImage.network(
                          provider.postList[index].images[0],
                          fit: BoxFit.cover,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else if (state.extendedImageLoadState ==
                                LoadState.failed) {
                              return const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              return null;
                            }
                          },
                        );
                      },
                    ),
                    // saved
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ExtendedImage.network(
                          provider.postList.reversed.toList()[index].images[0],
                          fit: BoxFit.cover,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else if (state.extendedImageLoadState ==
                                LoadState.failed) {
                              return const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              return null;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
