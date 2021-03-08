import 'package:flutter/material.dart';
import 'package:flutter_mobile_ads_sample/ad_state.dart';
import 'package:flutter_mobile_ads_sample/data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    ),
  );
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
  List<Object> itemList;

  @override
  void initState() {
    super.initState();
    itemList = List.from(widget.items);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies()');
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        for (int i = 5; i <= itemList.length; i += 5) {
          itemList.insert(
            i,
            BannerAd(
              size: AdSize.banner,
              adUnitId: adState.bannerAdUnitId,
              request: AdRequest(),
              listener: adState.adListener,
            )..load(),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Mobile Ads SDK Demo'),
      ),
      body: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            if (itemList[index] is DataItem) {
              return ItemRow(itemList[index] as DataItem);
            } else {
              return Container(
                height: 50,
                color: Colors.black,
                child: AdWidget(ad: itemList[index] as BannerAd),
              );
            }
          }),
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
