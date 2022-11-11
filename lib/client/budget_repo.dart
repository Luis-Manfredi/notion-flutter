import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:notion_test/models/failure_model.dart';
import 'package:notion_test/models/item_model.dart';

class BudgetRepository {
  static const String baseUrl = 'https://api.notion.com/v1/databases'; 
  final http.Client _client;

  BudgetRepository({ http.Client? client }) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future <List<Item>> getItems () async {
    try {
      final url = '$baseUrl/${dotenv.env['NOTION_DATABASE_ID']}/query/';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          HttpHeaders.accessControlAllowOriginHeader: '*'
        }
      );

      // print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List listItems = data['results'];
        final mapToItem = listItems.map((e) => Item.fromMap(e)).toList()..sort((a, b) => b.date.compareTo(a.date));
        return mapToItem;
      } else {
        throw const Failure(message: 'Algo ha salido mal');
      }
    } 
    catch (_) {
      // print(_);
      throw const Failure(message: 'Algo ha salido mal');
    }
  }

  Future createItem (String nombre, String categoria, double precio, DateTime fecha) async {
    const url = 'https://api.notion.com/v1/pages/';
    final response = await _client.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2022-06-28',
      },
      body: {
        'parent': {
          'type': 'database_id',
          'database_id': '${dotenv.env['NOTION_DATABASE_ID']}'
        },
        'properties': {
          'Nombre': {
            'title': [
              {
                'text': {
                  'content': nombre
                }
              }
            ]
          },
          'Precio': {
            'type': 'number',
            'number': precio
          },
          'Fecha': {
            'type': 'date',
            'date': {
              'start': DateFormat.yMd().format(fecha)
            }
          }
        }
      }
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      print('API Connected');
    }
  }
}