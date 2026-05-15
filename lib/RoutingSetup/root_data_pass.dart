class RootDataPassing {
  String title = "";
  String url = "";
  String sub_title = "";
  String services_id = "";
  String sub_services_id = "";
  String state_id = "";
  String dist_id = "";
}

class CreatePostMode {
  var id;
  var titile;
  var desc;
  var images;
}

class DashboardSlid {
  var Image = "";
  var actionType = "";
  var dataLink = "";

  DashboardSlid(
      {required this.Image, required this.actionType, required this.dataLink});
}
class EventSlid {
  var Image = "";
  var actionType = "";
  var dataLink = "";

  EventSlid(
      {required this.Image, required this.actionType, required this.dataLink});
}