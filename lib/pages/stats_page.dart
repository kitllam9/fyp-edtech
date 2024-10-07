import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/box.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.unselected,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            tabs: [
              Tab(
                text: 'Leaderboard',
              ),
              Tab(
                text: 'Stats',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) => Box(
                    margin: EdgeInsets.all(5),
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => Box(
                    margin: EdgeInsets.all(5),
                    child: SizedBox(
                      height: 300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
