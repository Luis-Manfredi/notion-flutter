import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notion_test/models/failure_model.dart';
import 'package:notion_test/models/item_model.dart';

class BudgetRepository {
  static const String baseUrl = 'https://api.notion.com/v1/databases'; 
  final http.Client _client;

  BudgetRepository({ http.Client? client }) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  // Create
  Future createItem (String nombre, String categoria, double precio, DateTime fecha) async {
    const url = 'https://api.notion.com/v1/pages/';
    final Map<String, dynamic> data = {
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
        'Categorías': {
          'type': 'select',
          'select': {
            'name': categoria
          }
        },
        'Fecha': {
          'type': 'date',
          'date': {
            'start': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'
          }
        }
      }
    }; 
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data)
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
      } else {
        throw const Failure(message: 'Algo ha salido mal');  
      }
    } catch (_) {
      print(_);
      throw const Failure(message: 'Algo ha salido mal');
    }
  }

  // Read
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

  // Update
  Future updateItem (String id, String nombre, double precio, String categoria) async {
    final url = 'https://api.notion.com/v1/pages/$id';
    final Map<String, dynamic> data = {
      'properties': {
        'Precio': {
          'number': precio
        },
        'Categorías': {
          'select': {
            'name': categoria
          }
        },
        'Nombre': {
          'title': [
            {
              'text': {
                'content': nombre
              }
            }
          ]
        }
      }
    };
    try {
      final response = await _client.patch(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data)
      );
      print(response.statusCode);
    } catch (_) {
      throw const Failure(message: 'Algo ha salido mal');
    }
  }

  // Delete
  Future deleteItem (String id) async {
    final url = 'https://api.notion.com/v1/blocks/$id';
    try {
      final response = await _client.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
        }
      );

      print(response.statusCode);
    } catch (_) {
      throw const Failure(message: 'Algo ha salido mal');
    }
  }
}