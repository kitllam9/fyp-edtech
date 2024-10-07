import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:material_symbols_icons/symbols.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

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
              suffixIcon: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Icon(
                  Symbols.close,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  _textEditingController.clear();
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: MasonryGridView.builder(
            itemCount: 10,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) => Box(
              margin: EdgeInsets.all(5),
              child: SizedBox(
                width: Globals.screenWidth! * 0.42,
                height: Random().nextInt(250) + 100,
              ),
            ),
          ),
        )
      ],
    );
  }
}
