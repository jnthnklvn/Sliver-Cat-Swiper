import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:silver_app_bar/src/cats/cats_module.dart';
import 'package:silver_app_bar/src/models/cat_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';

import 'cats_bloc.dart';

class CatsPage extends StatelessWidget {
  final _catsPerReq = 5;

  @override
  Widget build(BuildContext context) {
    final _bloc = CatsModule.to.getBloc<CatsBloc>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 250,
              floating: false,
              pinned: true,
              flexibleSpace: flexibleSpaceBar(_bloc),
            ),
          ];
        },
        body: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            titleText('The Cat API'),
            linkCopyable('https://thecatapi.com', context),
            titleText('Slidy with BLoC Pattern'),
            linkCopyable('https://github.com/Flutterando/slidy', context),
            titleText('Flutter Swiper'),
            linkCopyable('https://pub.dev/packages/flutter_swiper', context),
          ],
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  GestureDetector linkCopyable(String url, BuildContext context) {
    return GestureDetector(
      child: Text(
        url,
        style: TextStyle(
            color: Color(0xff0068b5), decoration: TextDecoration.underline),
      ),
      onLongPress: () {
        Toast.show("Link copiado para o clipboard", context,
            gravity: Toast.CENTER);
        Clipboard.setData(
          ClipboardData(text: url),
        );
      },
      onTap: () {
        FlutterWebBrowser.openWebPage(
          url: url,
          androidToolbarColor: Colors.black,
        );
      },
    );
  }

  FlexibleSpaceBar flexibleSpaceBar(CatsBloc _bloc) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: Container(
        decoration: ShapeDecoration(
          color: Colors.black38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Text(
          "THE CAT API",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      background: streamBuilder(_bloc),
    );
  }

  StreamBuilder<List<CatModel>> streamBuilder(CatsBloc _bloc) {
    return StreamBuilder(
      stream: _bloc.outCats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _bloc.getCats(_catsPerReq);
          return circularProgressIndicator();
        } else
          return swiper(snapshot, _bloc);
      },
    );
  }

  Widget swiper(AsyncSnapshot snapshot, CatsBloc bloc) {
    return Container(
      color: Colors.black,
      child: Swiper(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < snapshot.data.length) {
            return netWorkImage(snapshot, index);
          } else {
            bloc.getCats(_catsPerReq);
            return circularProgressIndicator();
          }
        },
        viewportFraction: 0.8,
      ),
    );
  }

  Image netWorkImage(AsyncSnapshot snapshot, int index) {
    return Image.network(
      snapshot.data[index].url,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }

  Widget circularProgressIndicator() {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
