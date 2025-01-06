import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/appbar.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: 'Bookmarks'),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 10,
        itemBuilder: (context, index) => Box(
          margin: EdgeInsets.all(5),
          child: GenericButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => PDFViewer(
              //       pdfPath: 'assets/sample.pdf',
              //     ),
              //   ),
              // );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.text,
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
    );
  }
}
