import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/custom_shimmer_loader.dart';
import 'package:fyp_edtech/widgets/pdf_viewer.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  String keyword = '';

  List<Content> contentList = [];

  late final Debouncer<String> debouncer;

  bool init = true;
  int _page = 1;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _search({
    String? keyword,
  }) async {
    try {
      PaginatedData<Content>? response = await Content.search(
        page: _page,
        keyword: keyword,
      );
      List<Content>? content = response?.data;
      if (content!.isEmpty) {
        _refreshController.loadNoData();
      } else {
        setState(() {
          _page++;
          contentList.addAll(content);
          _refreshController.loadComplete();
        });
      }
    } catch (error) {
      //
    }
  }

  Future<void> _refresh() async {
    setState(() {
      contentList.clear();
      _textEditingController.clear();
      _page = 1;
    });
    await _search();
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  void initState() {
    debouncer = Debouncer<String>(
      Duration(milliseconds: 750),
      onChanged: (value) async {
        setState(() {
          _page = 1;
          contentList.clear();
        });
        await _search(
          keyword: value,
        ).then((_) {
          setState(() {
            init = false;
          });
        });
      },
      initialValue: '',
    );
    _textEditingController.addListener(() => debouncer.value = _textEditingController.text);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _search().then((_) {
        setState(() {
          init = false;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
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
            onChanged: (value) => setState(() {
              init = true;
              keyword = value;
            }),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: TextStyle(
              color: AppColors.primary,
            ),
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
          child: ScrollConfiguration(
            behavior: MaterialScrollBehavior(),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _refresh,
              onLoading: () {
                _search(keyword: keyword);
              },
              controller: _refreshController,
              child: init || _refreshController.headerStatus == RefreshStatus.refreshing
                  ? CustomShimmmerLoader()
                  : MasonryGridView.extent(
                      maxCrossAxisExtent: Globals.screenWidth! * 0.5,
                      itemCount: contentList.length,
                      itemBuilder: (context, index) {
                        Content? content = contentList[index];
                        return Box(
                          margin: EdgeInsets.all(5),
                          child: SizedBox(
                            width: Globals.screenWidth! * 0.42,
                            height: init ? 250 : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GenericButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => content.type == ContentType.notes
                                          ? CustomPDFViewer(
                                              id: content.id,
                                              points: content.points,
                                            )
                                          : ExercisePage(
                                              id: content.id,
                                              points: content.points,
                                              questions: content.exerciseDetails ?? [],
                                              mode: ExerciseViewMode.regular,
                                            ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      content.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      content.description,
                                      style: TextStyle(
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        )
      ],
    );
  }
}
