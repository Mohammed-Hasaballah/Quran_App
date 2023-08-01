import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List items;
  final List surahs;
  @override
  String get searchFieldLabel => '... أدخل الآية';
  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: mainTextColor,
        fontSize: 20.0,
        fontFamily: 'kitab',
      );

  CustomSearchDelegate({required this.items, required this.surahs});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: mainTextColor,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: mainTextColor,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List filteredData = [];
    if (query.isNotEmpty) {
      filteredData = items
          .where((element) =>
              element['aya_text_emlaey'].toString().contains(query.trim()))
          .toList();

      return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/', arguments: [
                filteredData[index]['page'],
                filteredData[index]['id']
              ]);
            },
            title: Text(
              filteredData[index]['aya_text'],
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Hafs'),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              filteredData[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Column(
              children: [
                const Text('الصفحة'),
                Text(
                  filteredData[index]['page'].toString(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          );
        },
        itemCount: filteredData.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      );
    } else {
      return const Column(
        children: [],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filteredData = [];
    if (query.isNotEmpty) {
      filteredData = items
          .where((element) =>
              element['aya_text_emlaey'].toString().contains(query.trim()))
          .toList();

      return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home', arguments: [
                filteredData[index]['page'],
                filteredData[index]['id']
              ]);
            },
            title: Text(
              filteredData[index]['aya_text'],
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Hafs'),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              filteredData[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Column(
              children: [
                const Text(
                  'الصفحة',
                ),
                Text(
                  filteredData[index]['page'].toString(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          );
        },
        itemCount: filteredData.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      );
    } else {
      return const Column(
        children: [],
      );
    }
  }
}
