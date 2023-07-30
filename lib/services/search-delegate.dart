import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List items;
  final List surahs;

  CustomSearchDelegate({required this.items, required this.surahs});

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: const Icon(Icons.arrow_back),
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
              print(filteredData[index]['page']);
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
}
