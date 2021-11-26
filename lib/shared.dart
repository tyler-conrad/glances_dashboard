import 'dart:convert' as c;

import 'package:http/http.dart' as http;

List<dynamic> decodeJsonListFromResp({required http.Response resp}) {
  return c.jsonDecode(
    c.utf8.decode(
      resp.bodyBytes,
    ),
  );
}

Map<String, dynamic> decodeJsonMapFromResp({required http.Response resp}) {
  return c.jsonDecode(
    c.utf8.decode(
      resp.bodyBytes,
    ),
  );
}
