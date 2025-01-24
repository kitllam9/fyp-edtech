import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomPDFViewer extends StatefulWidget {
  final int id;
  final int points;
  const CustomPDFViewer({
    super.key,
    required this.id,
    required this.points,
  });

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  final PageController _pdfViewController = PageController();
  int _currentPage = 1;
  int? _total;
  PDFDocument? doc;
  final User user = GetIt.instance.get<User>();

  @override
  void initState() {
    context.loaderOverlay.show();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      doc = await PDFDocument.fromURL('http://${dotenv.get('API_DEV')}/api/content/get-pdf/${widget.id}');
      // doc = await PDFDocument.fromURL('https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=1f2ee3831eebfc97bfafd514ca2abb7e2c5c86bb');
      _total = doc?.count;
      setState(() {});
      if (mounted) context.loaderOverlay.hide();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        generalDialog(
          icon: Symbols.help,
          title: 'Are you sure?',
          msg: 'Do you really want to exit? All your unsaved progress will be lost.',
          onConfirmed: () => Navigator.of(context).popUntil(
            (route) => route.isFirst || route.settings.name == '/bookmark',
          ),
        );
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: Globals.screenHeight! * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconTextButton(
                width: Globals.screenWidth! * 0.3,
                height: 35,
                backgroundColor: AppColors.primary,
                icon: Icon(
                  _currentPage == (_total ?? -1) ? Symbols.check : Symbols.close,
                  color: AppColors.secondary,
                  size: 18,
                ),
                text: Text(
                  _currentPage == (_total ?? -1) ? 'Finish' : 'Exit',
                  style: TextStyle(color: AppColors.secondary),
                ),
                onPressed: () async {
                  if (_currentPage == (_total ?? -1)) {
                    await user.checkBadges(points: widget.points).then((map) {
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CompletedPage(
                            contentId: widget.id,
                            type: CompletedType.notes,
                            targets: List<int>.from(map!['targets']),
                            currentPoints: map['current_points'],
                            targetPoints: map['target_points'],
                          ),
                        ),
                      );
                    });
                  } else {
                    generalDialog(
                      icon: Symbols.help,
                      title: 'Are you sure?',
                      msg: 'Do you really want to exit? All your unsaved progress will be lost.',
                      onConfirmed: () => Navigator.of(context).popUntil(
                        (route) => route.isFirst || route.settings.name == '/bookmark',
                      ),
                    );
                  }
                },
              ),
              IconTextButton(
                width: Globals.screenWidth! * 0.3,
                height: 35,
                backgroundColor: AppColors.primary,
                icon: Icon(
                  Symbols.bookmark_add,
                  color: AppColors.secondary,
                  size: 18,
                ),
                text: Text(
                  'Bookmark',
                  style: TextStyle(color: AppColors.secondary),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (doc != null)
                PDFViewer(
                  document: doc!,
                  controller: _pdfViewController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value + 1;
                    });
                  },
                  showIndicator: false,
                  showPicker: false,
                  backgroundColor: AppColors.scaffold,
                  navigationBuilder: (context, pageNumber, totalPages, jumpToPage, animateToPage) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: AppColors.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.first_page,
                                  ),
                                  disabledColor: AppColors.unselected,
                                  color: AppColors.secondary,
                                  onPressed: pageNumber == 1
                                      ? null
                                      : () {
                                          jumpToPage(page: 0);
                                        },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                  ),
                                  disabledColor: AppColors.unselected,
                                  color: AppColors.secondary,
                                  onPressed: pageNumber == 1
                                      ? null
                                      : () {
                                          int page = pageNumber! - 2;
                                          // print(page);
                                          if (0 > page) {
                                            page = 1;
                                          }
                                          animateToPage(page: page);
                                        },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                  ),
                                  disabledColor: AppColors.unselected,
                                  color: AppColors.secondary,
                                  onPressed: pageNumber == doc!.count
                                      ? null
                                      : () {
                                          int page = pageNumber!;
                                          if (doc!.count < page) {
                                            page = doc!.count;
                                          }
                                          animateToPage(page: page);
                                        },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.last_page,
                                  ),
                                  disabledColor: AppColors.unselected,
                                  color: AppColors.secondary,
                                  onPressed: pageNumber == doc!.count
                                      ? null
                                      : () {
                                          jumpToPage(page: doc!.count);
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              if (_total != null)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  height: 4,
                  width: Globals.screenWidth! * (_currentPage / _total!),
                  decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
