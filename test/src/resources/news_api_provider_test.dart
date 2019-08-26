import 'package:api_practice/src/resources/news_api_provider.dart';
import 'package:test_api/test_api.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds returns a list of ids', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    expect(ids, [1, 2, 3]);
  });

  test('FetchItem returns a item model', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItme(999);

    expect(item.id, 123);
  });
}
