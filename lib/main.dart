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
  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies()');
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          size: AdSize.banner,
          adUnitId: adState.bannerAdUnitId,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Mobile Ads SDK Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) => ItemRow(widget.items[index])),
          ),
          if (banner == null)
            SizedBox(
              height: 50,
            )
          else
            Container(
                height: 50,
                child: AdWidget(
                  ad: banner,
                ))
        ],
      ),
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
