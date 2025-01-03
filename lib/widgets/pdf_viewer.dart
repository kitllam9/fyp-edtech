import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class PDFViewer extends StatefulWidget {
  final String pdfPath;
  const PDFViewer({super.key, required this.pdfPath});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  final PdfViewerController _pdfViewController = PdfViewerController();
  int _currentPage = 1;
  int? _total;
  bool _isIdling = false;
  Timer? idleTimer;

  @override
  void initState() {
    idleTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isIdling = true;
        });
      }
    });
    super.initState();
  }

  void resetIdling() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isIdling = false;
      setState(() {
        idleTimer?.cancel();
        idleTimer = Timer(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isIdling = true;
            });
          }
        });
      });
    });
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
        floatingActionButton: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isIdling ? Globals.screenHeight! * 0.15 : 0, 0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: Globals.screenHeight! * 0.06),
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
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SfPdfViewerTheme(
                data: SfPdfViewerThemeData(
                  backgroundColor: AppColors.scaffold,
                  progressBarColor: AppColors.primary,
                ),
                child: SfPdfViewer.network(
                  widget.pdfPath,
                  controller: _pdfViewController,
                  scrollDirection: PdfScrollDirection.horizontal,
                  canShowScrollHead: false,
                  pageLayoutMode: PdfPageLayoutMode.single,
                  onDocumentLoaded: (details) {
                    setState(() {
                      _total = details.document.pages.count;
                    });
                  },
                  onPageChanged: (details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });
                  },
                  onTap: (details) => resetIdling(),
                ),
              ),
              if (_total != null)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  height: 2,
                  width: Globals.screenWidth! * (_currentPage / _total!),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              AnimatedOpacity(
                opacity: _isIdling ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withAlpha(5),
                          overlayColor: AppColors.primary,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          if (_currentPage > 1 && !_isIdling) {
                            _pdfViewController.previousPage();
                            resetIdling();
                          }
                        },
                        child: Icon(
                          Symbols.arrow_back_ios_new,
                          color: AppColors.secondary,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withAlpha(5),
                          overlayColor: AppColors.primary,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          if (_currentPage < (_total ?? -1) && !_isIdling) {
                            _pdfViewController.nextPage();
                            resetIdling();
                          }
                        },
                        child: Icon(
                          Symbols.arrow_forward_ios,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
