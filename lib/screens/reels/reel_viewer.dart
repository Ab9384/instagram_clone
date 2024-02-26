import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/screens/home/reel_screen.dart';
import 'package:provider/provider.dart';

class ReelViewScreen extends StatefulWidget {
  final ReelModel reelModel;
  const ReelViewScreen({super.key, required this.reelModel});

  @override
  State<ReelViewScreen> createState() => _ReelViewScreenState();
}

class _ReelViewScreenState extends State<ReelViewScreen> {
  List<ReelModel> reels = [];

  @override
  void initState() {
    setState(() {
      reels = getReelList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 50,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Reels',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Swiper(
          itemCount: reels.length,
          axisDirection: AxisDirection.up,
          loop: false,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            // print('reel index: $index');
            return ReelWidget(reel: reels[index]);
          },
        ),
      ),
    );
  }

  List<ReelModel> getReelList() {
    List<ReelModel> reelList = [];
    reelList.add(widget.reelModel);

    List<ReelModel> reelListG =
        Provider.of<AppData>(context, listen: false).reelsList;
    reelListG.remove(widget.reelModel);
    reelList.shuffle();
    reelList.addAll(reelListG);

    return reelList;
  }
}
