import 'package:flutter/material.dart';
import 'package:flutter_mobile_ads_sample/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile ads Demo',
      home: ListScreen(dataList),
    );
  }
}

class ListScreen extends StatefulWidget {
  final List<DataItem> items;

  const ListScreen(this.items);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Mobile Ads SDK Demo'),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => ItemRow(widget.items[index])),
    );
  }
}

class ItemRow extends StatelessWidget {
  final DataItem item;

  const ItemRow(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.text),
    );
  }
}
