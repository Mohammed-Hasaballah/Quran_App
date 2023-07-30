import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quran_application/screens/surahs_screen.dart';
import 'package:quran_application/services/search-delegate.dart';
import 'package:quran_application/services/json_helper.dart';
import 'package:quran_application/services/tafseer_service.dart';

import '../constants/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageViewController = PageController();

  List _ayasFromJson = [];
  int selectedAyah = -1;

  bool selectNewAyah = false;

  void readJson() async {
    dynamic data = await JsonHelper().readJson();
    setState(() {
      _ayasFromJson = data;
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    Set surahsSet = <dynamic>{};
    List surahs = [];

    if (args != null && selectNewAyah == false) {
      int navigateToPage = 0;
      navigateToPage = args[0];
      selectedAyah = args[1];
      if (pageViewController.hasClients) {
        pageViewController.jumpToPage(navigateToPage - 1);
      }
    }

    if (_ayasFromJson.isNotEmpty) {
      for (var suraObject in _ayasFromJson) {
        surahsSet.add(suraObject['sura_name_ar']);
      }

      for (var element in surahsSet) {
        surahs.add(element);
      }
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: RadialGradient(
                        colors: [Color(0xfffdf7e9), Color(0xfff5dca2)])),
                height: 200,
                child: Center(
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset('images/quran-icon.png'))),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurahsScreen(
                                ayasFromJson: _ayasFromJson,
                                surahs: surahs,
                                pageViewController: pageViewController,
                              )));
                },
                title: Text(
                  '  أسماء السور',
                  style: TextStyle(
                    fontFamily: 'kitab',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
              ),
              const Divider(
                thickness: 0.8,
                color: Color.fromARGB(255, 6, 37, 63),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: const Color(0xfffdf7e9),
          title: customSearchBar,
          iconTheme: IconThemeData(color: mainTextColor),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      items: _ayasFromJson, surahs: surahs),
                );
              },
              icon: customIcon,
            ),
          ],
        ),
        backgroundColor: const Color(0xfffdf7e9),
        body: PageView.builder(
          itemCount: quranPages,
          controller: pageViewController,
          itemBuilder: (BuildContext context, int index) {
            if (_ayasFromJson.isNotEmpty) {
              List<TextSpan> ayahsByPage = [];
              String surahName = '';
              int jozzNum = 0;
              bool isBasmalahShown = false;

              for (Map ayahData in _ayasFromJson) {
                if (ayahData['page'] == index + 1) {
                  if (ayahData['aya_no'] == 1 &&
                      ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                      ayahData['sura_name_ar'] != 'التوبَة') {
                    isBasmalahShown = true;
                  }

                  ayahsByPage.addAll([
                    if (isBasmalahShown) ...[
                      const TextSpan(
                        text: "\n\n‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏\n\n",
                        style: TextStyle(
                            fontFamily: 'Hafs',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 2,
                            backgroundColor: Colors.black12),
                      )
                    ],
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          setState(() {
                            selectNewAyah = true;
                            selectedAyah = ayahData['id'];
                          });
                          dynamic tafseer = await TafseerService().getTafseer(
                              surahNum: ayahData['sura_no'].toString(),
                              ayahNum: ayahData['aya_no'].toString());
                          if (mounted) {
                            showModalBottomSheet<void>(
                              clipBehavior: Clip.hardEdge,
                              isScrollControlled: true,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              )),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    height: 270,
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Text(
                                                ayahData['aya_text'],
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontFamily: 'Hafs',
                                                    fontSize: 18),
                                              ),
                                            ),
                                            tafseer != null
                                                ? Text(
                                                    tafseer['text'],
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      text: '${ayahData['aya_text'].toString()} ',
                      style: TextStyle(
                          backgroundColor: selectedAyah == ayahData['id']
                              ? Colors.black12
                              : null,
                          fontFamily: 'Hafs',
                          fontSize: 19),
                    ),
                  ]);
                  isBasmalahShown = false;
                  surahName = ayahData['sura_name_ar'];
                  jozzNum = ayahData['jozz'];
                }
              }

              return SafeArea(
                child: Container(
                  decoration: index % 2 == 0
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                              Color(0x27000000),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent
                            ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight))
                      : const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                              Color(0x27000000),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent
                            ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height -
                                Scaffold.of(context).appBarMaxHeight! -
                                30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الجزء $jozzNum',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: mainTextColor,
                                        fontFamily: 'Kitab',
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    surahName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: mainTextColor,
                                        fontFamily: 'Kitab',
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxHeight: 500),
                              child: AutoSizeText.rich(
                                minFontSize: 8,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: ayahsByPage),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      pageViewController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    child: Text(
                                      'الصفحة السابقة',
                                      style: TextStyle(color: mainTextColor),
                                    )),
                                Text(
                                  '${index + 1}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: 'Kitab', fontSize: 18),
                                ),
                                TextButton(
                                    onPressed: () {
                                      pageViewController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    child: Text(
                                      'الصفحة التالية',
                                      style: TextStyle(color: mainTextColor),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff915a13),
              ));
            }
          },
        ),
      ),
    );
  }
}
