import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3)).then((val) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
          child: TextField(
            cursorColor: AppColors.primary,
            controller: _textEditingController,
            focusNode: inputFocusNode,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.unselected,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.primary,
                ),
              ),
              hintText: 'Explore...',
              hintStyle: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: GenericButton(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Symbols.close,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {
                  _textEditingController.clear();
                },
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
            ),
          ),
        ),
        Expanded(
          child: MasonryGridView.builder(
            physics: _isLoading ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) => Box(
              margin: EdgeInsets.all(5),
              child: SizedBox(
                width: Globals.screenWidth! * 0.42,
                height: _isLoading ? 250 : Random().nextInt(250) + 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitlePlaceholder(
                                height: 24,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              ContentPlaceholder(
                                lines: 3,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index.isEven ? 'Exercise' : 'Article',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
