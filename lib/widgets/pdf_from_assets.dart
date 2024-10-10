import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fyp_edtech/widgets/appbar.dart';

class PDFViewerFromAsset extends StatelessWidget {
  final String pdfAssetPath;
  final String title;
  final Completer<PDFViewController> _pdfViewController = Completer<PDFViewController>();
  final StreamController<String> _pageCountController = StreamController<String>();
  PDFViewerFromAsset({super.key, required this.pdfAssetPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: title),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: false,
        fitPolicy: FitPolicy.BOTH,
        onPageChanged: (int? current, int? total) => _pageCountController.add('${current! + 1} - $total'),
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromAsset(
        pdfAssetPath,
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
