// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class SurahsScreen extends StatefulWidget {
  List<dynamic> surahs;
  List<dynamic> ayasFromJson;
  PageController pageViewController;

  SurahsScreen(
      {Key? key,
      required this.surahs,
      required this.ayasFromJson,
      required this.pageViewController})
      : super(key: key);

  @override
  State<SurahsScreen> createState() => _SurahsScreenState();
}

class _SurahsScreenState extends State<SurahsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfffdf7e9),
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: const Color(0xfffdf7e9),
          title: const Text(
            'أسماء السور',
            style: TextStyle(color: Color(0xff8c5824), fontFamily: 'kitab'),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff8c5824),
              )),
        ),
        body: ListView.separated(
            itemCount: widget.surahs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    int initialPage = 0;
                    initialPage = widget.ayasFromJson.firstWhere((ayaData) =>
                        ayaData['sura_name_ar'] ==
                        widget.surahs[index])['page'];

                    widget.pageViewController.jumpToPage(initialPage - 1);
                  },
                  title: Text(
                    widget.surahs[index],
                    style: const TextStyle(
                        color: Color(0xff8c5824), fontFamily: 'kitab'),
                  ),
                )),
      ),
    );
  }
}
