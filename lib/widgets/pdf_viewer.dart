import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:material_symbols_icons/symbols.dart';

class PDFViewer extends StatefulWidget {
  final String pdfAssetPath;
  final String title;
  const PDFViewer({super.key, required this.pdfAssetPath, required this.title});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PDFViewController? _pdfViewController;
  int? _currentPage;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isIdling ? Globals.screenHeight! * 0.13 : 0, 0),
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
                  _currentPage == (_total ?? -1) - 1 ? Symbols.check : Symbols.close,
                  color: AppColors.secondary,
                  size: 18,
                ),
                text: Text(
                  _currentPage == (_total ?? -1) - 1 ? 'Finish' : 'Exit',
                  style: TextStyle(color: AppColors.secondary),
                ),
                onPressed: () {
                  if (_currentPage == (_total ?? -1) - 1) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CompletedPage(
                          type: CompletedType.article,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
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
            PDF(
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageFling: true,
              fitPolicy: FitPolicy.BOTH,
              onPageChanged: (int? current, int? total) {
                setState(() {
                  _total = total;
                  _currentPage = current;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) async {
                _pdfViewController = pdfViewController;
                _currentPage = await pdfViewController.getCurrentPage();
              },
              onRender: (pages) => setState(() {}),
            ).fromAsset(
              widget.pdfAssetPath,
              errorWidget: (dynamic error) => Center(child: Text(error.toString())),
            ),
            GestureDetector(
              onTap: () {
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
              },
            ),
            if (_currentPage != null && _total != null)
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                height: 2,
                width: MediaQuery.of(context).size.width * ((_currentPage! + 1) / _total!),
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
                        if ((_currentPage ?? 0) > 0 && _pdfViewController != null) {
                          _pdfViewController!.setPage(_currentPage! - 1);
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
                        if (_pdfViewController != null) {
                          _pdfViewController!.setPage((_currentPage ?? 0) + 1);
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
    );
  }
}
