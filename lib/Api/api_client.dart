import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localkart/unit/showing.dart';

import 'config.dart';

import 'dart:convert' as convert;

class ApiClient {
  late BuildContext context;

  ApiClient(BuildContext contexts) {
    context = contexts;
    HttpOverrides.global = MyHttpOverrides();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {}
  }

  Future<Response> httpGet(String url) async {
    print("Get Method url - " + url);

    Response res = await get(
      Uri.parse(url),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    ).timeout(const Duration(seconds: 10));

    print(" resonces - " + res.body.toString());

    try {
      if (res.statusCode == 200) {
        return res;
      } else {
        throw "Unable to retrieve posts.";
      }
    } on TimeoutException catch (e) {
      // Triggers if the entire data transfer takes longer than 10 seconds
      print('Request timed out: $e');
      throw 'The server took too long to respond. Please try again.';

    }catch (e) {
      print(" Method url $url  error - $e");
      throw "Unable to retrieve posts.";
    }
  }

  Future<Response> httpPost(Map<String, Object> input, String url) async {
    print("Post url - " + url + " parms " + input.toString());
    Response res = await post(
      Uri.parse(url),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    ).timeout( Duration(seconds: 10)); // Limits entire request duration


    print("Response code  ${res.statusCode} body - ${res.body}");

    try {
      if (res.statusCode == 200) {
        return res;
      } else {
        throw "Unable to retrieve posts.";
      }
    } on TimeoutException catch (e) {
      // Triggers if the entire data transfer takes longer than 10 seconds
      print('Request timed out: $e');
      throw 'The server took too long to respond. Please try again.';

    }catch (e) {
      print(" Method url $url and  inputs $input error - $e ");
      throw "Unable to retrieve posts.";
    }
  }
}

class ApiClientLocalKart {
  String Tag = "Old ";

  Future<Response> httpGet(String url) async {
    print("Get Method url - " + url);

    Response res = await get(
      Uri.parse(url),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    print(" $Tag Resonces - " + res.body.toString());
    // var responseBody = jsonDecode(res.body);
    try {
      if (res.statusCode == 200) {
        return res;
      } else {
        throw " $Tag Unable to retrieve posts.";
      }
    } catch (e) {
      print(" Method url $url  error - $e");
      throw "Unable to retrieve posts.";
    }
  }

  Future<Response> httpPost(Map<String, Object> input, String url) async {
    print("$Tag Post url - " + url + " parms " + input.toString());
    Response res = await post(
      Uri.parse(url),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    ).timeout(const Duration(seconds: 10));

    print("$Tag Response code  ${res.statusCode} body - ${res.body}");

    try {
      if (res.statusCode == 200) {
        return res;
      } else {
        throw "$Tag Unable to retrieve posts.";
      }
    } catch (e) {
      print("$Tag Method url $url and  inputs $input error - $e ");
      throw "Unable to retrieve posts.";
    }
  }
}
