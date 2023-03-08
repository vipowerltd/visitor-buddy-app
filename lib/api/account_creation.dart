import 'dart:convert';
import 'dart:developer';

import 'env.dart';
import 'package:http/http.dart';

getStudent() async {
  String url = '${Env.URL_PREFIX}/getStudent.php';
  var res = await get(Uri.parse(url), headers: {'Accept':'application/json'});
  var responseBody = json.decode(res.body);
  return responseBody;
}

addStudent(var student) async {
  String url = '${Env.URL_PREFIX}/addStudent.php';
  var response = await post(Uri.parse(url), headers: {
    'content-type': 'application/json', 'accept': 'application/json'
  },body: jsonEncode(student.toJson()));
  log(response.body);
}

deleteStudent(String student_id) async {
  String url = '${Env.URL_PREFIX}/deleteStudent.php';
  var response = await post(Uri.parse(url), headers: {
    'content-type': 'application/json', 'accept': 'application/json'
  },body: jsonEncode(<String, dynamic>{
    "student_id": student_id,
  }));
  log(response.body);
}

editStudent(var student) async {
  String url = '${Env.URL_PREFIX}/editStudent.php';
  var response = await post(Uri.parse(url), headers: {
    'content-type': 'application/json', 'accept': 'application/json'
  },body: jsonEncode(student.toJson()));
  log(response.body);
}