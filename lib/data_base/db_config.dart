import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  String _login_help = "login";
  String _dashboad_slide = "dashboad_slide";
  String _dashboad_help_shopping = "dashboad_shopping";
  String _dashboad_help_services = "dashboad_services";

  String _latLocation = "lat";
  String _longLocation = "long";

  Future<String> getLoginDB(String inputs) async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (inputs.length == 0) {
        return outputs = await prefs.getString(_login_help) ?? "";
      } else {
        outputs = await prefs.getString('login') ?? "";
        print("Login details - " + outputs);
        var datas = json.decode(outputs);
        var res = datas['$inputs'];
        return res.toString();
      }
    } catch (e) {
      print("get Login error - " + e.toString());
      return outputs;
    }
  }

  Future<String> getLoginAllDB() async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      outputs = await prefs.getString('login') ?? "";
      return outputs.toString();
    } catch (e) {
      print("get Login error - " + e.toString());
      return outputs;
    }
  }

  Future<bool> isLoginDB() async {
    var login = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var outputs = await prefs.getString('login') ?? "";
      if (outputs.length > 0) {
        login = true;
      }
    } catch (e) {
      login = false;
    }
    return login;
  }

  Future<String> getLoginSubDB(String inputs) async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (inputs.length == 0) {
        return outputs = await prefs.getString(_login_help) ?? "";
      } else {
        outputs = await prefs.getString('login') ?? "";
        var datas = json.decode(outputs);
        var res = datas['result']['$inputs'].toString();
        return res.toString();
      }
    } catch (e) {
      print("get Login error - " + e.toString());
      return outputs;
    }
  }

  saveDashboardShoppingDB(String input) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dashboad_help_shopping, input);
      return true;
    } catch (e) {
      print("save _dashboad_help_shopping error - " + e.toString());
      return false;
    }
  }

  Future<String> getDashboardShoppingDB() async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      outputs = await prefs.getString(_dashboad_help_shopping) ?? "";
      return outputs;
    } catch (e) {
      print("get _dashboad_help_shopping error - " + e.toString());
      return outputs;
    }
  }

  saveDashboardSlide(String input) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dashboad_slide, input);
      return true;
    } catch (e) {
      print("save _dashboad_help_shopping error - " + e.toString());
      return false;
    }
  }

  Future<String> getDashboardSlide() async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      outputs = await prefs.getString(_dashboad_slide) ?? "";
      return outputs;
    } catch (e) {
      print("get _dashboad_slide error - " + e.toString());
      return outputs;
    }
  }

  saveDashServicesDB(String input) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dashboad_help_services, input);
      return true;
    } catch (e) {
      print("save _dashboad_help_shopping error - " + e.toString());
      return false;
    }
  }

  Future<String> getDashboardServicesDB() async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      outputs = await prefs.getString(_dashboad_help_services) ?? "";
      return outputs;
    } catch (e) {
      print("get _dashboad_help_services error - " + e.toString());
      return outputs;
    }
  }

  Future<bool> saveLoginDB(String inputs) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_login_help, inputs);
      return true;
    } catch (e) {
      print("login save error - " + e.toString());
      return false;
    }
  }

  Future<String> getUserId() async {
    String userId = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var outputs = await prefs.getString('login') ?? "5";
      var datas = json.decode(outputs);
      userId = datas['result']['Id'].toString();
    } catch (e) {
      print("get Login error - " + e.toString());
    }
    return userId;
  }

  Future<bool> saveLocationDetailsDB(double late, double long) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_latLocation, late.toString());
      await prefs.setString(_longLocation, long.toString());
      print("save loc - " + late.toString());
      return true;
    } catch (e) {
      print("login save error - " + e.toString());
      return false;
    }
  }

  Future<String> getLocationDetailsDB(bool latLong) async {
    String outputs = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (latLong) {
        outputs = await prefs.getString(_latLocation) ?? "12.7409";
      } else {
        outputs = await prefs.getString(_longLocation) ?? "77.8253";
      }

      return outputs.toString();
    } catch (e) {
      print("get Login error - " + e.toString());
      return 0.0.toString();
    }
  }

  Future<bool> logOutDB() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_login_help);
      await prefs.remove(_dashboad_help_shopping);
      await prefs.remove(_dashboad_help_services);
      return true;
    } catch (e) {
      print("logout error - " + e.toString());
      return false;
    }
  }
}
