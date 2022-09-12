import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:budget_tracker/item_model.dart';
import 'package:budget_tracker/failure_model.dart';

class BudgetRepository{
  final http.Client _client;
  static const String _baseUrl = 'https://api.notion.com/v1/';
  BudgetRepository({http.Client? client}) : _client = client ?? http.Client();

  void dispose(){
    _client.close();
  }
  Future<List<Item>>getItem() async {
    try{
    final url =
        '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
    final response = await _client.post(
        Uri.parse(url),
        headers:{
          HttpHeaders.authorizationHeader:
             'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version':'2022-06-28',
        }
      );
    print(url);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String,dynamic>;
      print("code ran here");
      return(data['results'] as List).map((e) => Item.fromMap(e)).toList()
        ..sort((a,b) => b.date.compareTo(a.date));
    } else {
      throw const Failure(message: 'Something went wrong!35');
    }
    } catch(_){
      throw const Failure(message: 'Something went wrong!38');
    }
  }
}