  import 'dart:convert';
  import 'package:http/http.dart' as http;

  Future<Map<String, dynamic>> getPageAndParse() async {
    try {
      var url =
          Uri.parse('https://api.nexaflow.xyz/api/page/PAGE_ID');

      url = url.replace(
        queryParameters: {'websiteId': 'WEBSITE_ID'},
      );

      final response = await http.get(
        url,
        headers: {
          'x-api-key': 'API_KEY',
        },
      );

      final responseJSON = json.decode(response.body);
      final result = <String, dynamic>{};

      for (var block in responseJSON['blocks']) {
        if (block['nested'] != null) {
          continue;
        }

        if (block['blockType'] == 'group') {
          result[block['blockName']] =
              (block['blockData'] as Map<String, dynamic>)
                  .values
                  .fold<Map<String, dynamic>>({}, (acc, nested) {
            return {...acc, ...nested['blockData']};
          });
        } else if (block['blockType'] == 'array') {
          final arr = (block['blockData'] as List).map((nestedObj) {
            return (nestedObj as Map<String, dynamic>)
                .values
                .fold<Map<String, dynamic>>({}, (acc, obj) {
              var blockData = obj['blockData'];
              if (blockData is String) {
                var nested = responseJSON['blocks']
                    .firstWhere((block) => block['id'] == blockData);
                var blockName = obj['fieldName'];

                if (nested['blockData'] is List) {
                  nested = (nested['blockData'] as List).map((nestedObj) {
                    return (nestedObj as Map<String, dynamic>)
                        .values
                        .fold<Map<String, dynamic>>({}, (acc, nested) {
                      return {...acc, ...nested['blockData']};
                    });
                  }).toList();
                  blockData = {blockName: nested};
                }

                if (nested['blockData'] is Map<String, dynamic>) {
                  nested = (nested['blockData'] as Map<String, dynamic>)
                      .values
                      .fold<Map<String, dynamic>>(
                    {},
                    (acc, nested) {
                      return {...acc, ...nested['blockData']};
                    },
                  );
                  blockData = {blockName: nested};
                }
              }
              return {...acc, ...blockData};
            });
          }).toList();
          result[block['blockName']] = arr;
          return arr.first;
        } else {
          result[block['blockName']] = block['blockData'][block['blockName']];
        }
      }

      return result;
    } catch (e) {
      print(e);
      return {};
    }
  }

  void main() {
    getPageAndParse().then((cmsParsedData) {
      final cmsPageTest = cmsParsedData;
      final cmsTest = cmsParsedData['test'];

      // Your code goes here

      
    }).catchError((e) {
      print(e);
    });
  }
  