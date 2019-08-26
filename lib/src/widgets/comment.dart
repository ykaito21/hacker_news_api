import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'loading_container.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;
  Comment({
    this.itemId,
    this.itemMap,
    this.depth,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        final item = snapshot.data;
        final children = <Widget>[
          Card(
            child: ListTile(
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: 16.0 + (16.0 * depth),
              ),
              title: item.text.isEmpty
                  ? Text('Comment Deleted')
                  : Html(
                      data: item.text,
                      onLinkTap: (url) async {
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
              subtitle: item.by.isEmpty ? Text('No Author') : Text(item.by),
            ),
          ),
        ];
        snapshot.data.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });
        return Column(
          children: children,
        );
      },
    );
  }
}
