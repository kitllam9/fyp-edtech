import 'dart:io';

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomPDFViewer extends StatefulWidget {
  final File? file;
  const CustomPDFViewer({
    super.key,
    this.file,
  });

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  final PageController _pdfViewController = PageController();
  int _currentPage = 1;
  int? _total;
  PDFDocument? doc;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      doc = await PDFDocument.fromFile(widget.file!);
      _total = doc?.count;
      setState(() {});
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
                onPressed: () {
                  if (_currentPage == (_total ?? -1)) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CompletedPage(
                          type: CompletedType.article,
                        ),
                      ),
                    );
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
                      _currentPage = value;
                    });
                  },
                  showIndicator: false,
                  showPicker: false,
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
                                    color: AppColors.secondary,
                                  ),
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
                                    color: AppColors.secondary,
                                  ),
                                  onPressed: pageNumber == 1
                                      ? null
                                      : () {
                                          int page = pageNumber! - 2;
                                          if (1 > page) {
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
                                    color: AppColors.secondary,
                                  ),
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
                                    color: AppColors.secondary,
                                  ),
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
                  height: 2,
                  width: Globals.screenWidth! * ((_currentPage + 1) / _total!),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
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
