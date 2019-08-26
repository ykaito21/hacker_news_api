import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocks/stories_provider.dart';
import 'dart:async';
import 'loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;
  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/${item.id}');
            },
            title: Text(item.title),
            subtitle: Text('${item.score} points by ${item.by}'),
            trailing: Column(
              children: <Widget>[
                Icon(
                  Icons.comment,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  '${item.descendants}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
