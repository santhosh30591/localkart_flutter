import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/event/event_ticket_count_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsProvider with ChangeNotifier {
  List eventsList = [];

  List<Ticket>? ticket = [];

  Future checkTicketAvailability(int eventId) async {
    String url = '$subBase/eventticketavailablity?eventid=$eventId';
    var response = await ApiClientLocalKart().httpGet(url);
    var responseBody = jsonDecode(response.body);
    if (responseBody['errorCode'] == 0) {
      return response;
    } else {
      return null;
    }
  }

  Future confeecalculation(var data) async {
    var response = await http.post(
      Uri.parse('$subBase/confeecalculation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return json.decode(response.body);
  }

  Future<void> getEventListing(state, city, filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getString("lat") ?? "";
    var longtitudue = prefs.getString("long") ?? "";
    print(
      '$eventListing?state=$state&city=$city&filter=$filter&latitude=$latitude&longitude=$longtitudue',
    );

    var response = await http.get(
      Uri.parse(
        '$eventListing?state=$state&city=$city&filter=$filter&latitude=$latitude&longitude=$longtitudue',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var responseBody = jsonDecode(response.body);
    eventsList = [];
    if (responseBody["result"] != null) {
      for (int i = 0; i < responseBody["result"].length; i++) {
        eventsList.add({
          "eventName": responseBody["result"][i]["eventname"],
          "location": responseBody["result"][i]["district"],
          "date": responseBody["result"][i]["date"],
          "bannerImage": responseBody["result"][i]["image"],
          "eventId": responseBody["result"][i]["eventId"],
          "eventAllow": responseBody["result"][i]["booking_allow"],
          "allowMessage": responseBody["result"][i]["closed_message"],
        });
      }
    }
    notifyListeners();
  }

  Future getEventhtmlStyle() async {
    var response = await http.get(
      Uri.parse('$eventstyles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['errorCode'] == 0) {
      return responseBody;
    } else {
      return null;
    }
  }

  Future getEventDetails(eventId) async {
    String url = '$eventDetail?id=$eventId';
    var response = await ApiClientLocalKart().httpGet(url);
    var responseBody = jsonDecode(response.body);

    return responseBody;
  }

  Future getTicketDetails(var ticketId) async {
    var response = await http.get(
      Uri.parse('$subBase/eventbookingdetails?id=$ticketId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return json.decode(response.body);
  }

  Future getEventSummary(int id) async {
    print('$subBase/eventsummary?eventid=$id');
    var response = await http.get(
      Uri.parse('$subBase/eventsummary?eventid=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return json.decode(response.body);
  }

  Future getBookingsList() async {
    var loginProfile = await DBHelper().getLoginAllDB();
    var data = jsonDecode(loginProfile);
    var userId = data["result"]['Id'];
    var response = await http.get(
      Uri.parse('$subBase/mybookings?userid=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return json.decode(response.body);
  }

  Future checkEventBooking(var eventId, var bookingId) async {
    var loginProfile = await DBHelper().getLoginAllDB();
    var data = jsonDecode(loginProfile);
    var userId = data["result"]['Id'];

    var response = await http.get(
      Uri.parse(
        '$subBase/checkeventbooking?userId=$userId&eventId=$eventId&bookingId=$bookingId',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return json.decode(response.body);
  }

  Future admitUser(var randId, int scanUserId, bool isScanUser) async {
    print(scanUserId);
    var loginProfile = await DBHelper().getLoginAllDB();
    var data = jsonDecode(loginProfile);
    var userId = data["result"]['Id'];
    var url = Uri.parse('$subBase/admitevent');
    var request = http.MultipartRequest('POST', url);

    request.fields['UserId'] = userId.toString();
    request.fields['RandId'] = randId.toString();
    request.fields['scanUserId'] = scanUserId.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = responseData;

      return json.decode(jsonResponse);
    }
  }

  Future getEvents(userId) async {
    var response = await http.get(
      Uri.parse('$businessEventList?userindexid=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['errorCode'] == 0) {
      var listing = [];
      for (int i = 0; i < responseBody['result'].length; i++) {
        listing.add(responseBody['result'][i]);
      }
      return listing;
    } else {
      return null;
    }
  }
}
