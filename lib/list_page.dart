import 'package:flutter/cupertino.dart';
import 'package:news_app/widgets/platform_widget.dart';

import 'article.dart';
import 'article_detail_page.dart';
import 'package:flutter/material.dart';

class NewsListPage extends StatefulWidget {
  static const routeName = '/article_list';

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  int bottomIndex = 0;

  Widget _buildList(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString("assets/articles.json"),
      builder: (context, snapshot) {
        final List<Article> articles = parseArticles(snapshot.data);
        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return _buildArticleItem(context, articles[index]);
          },
        );
      },
    );
  }

  Widget _buildArticleItem(BuildContext context, Article article) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Hero(
        tag: article.urlToImage,
        child: Image.network(
          article.urlToImage,
          width: 100,
        ),
      ),
      title: Text(article.title),
      subtitle: Text(article.author),
      onTap: () {
        Navigator.pushNamed(context, ArticleDetailPage.routeName,
            arguments: article);
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("News App"),
        ),
        child: _buildList(context));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
      ),
      body: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }
}
