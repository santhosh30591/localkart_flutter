

class SubHistory {
  String id = "";
  String date = "";
  var expery_date;
  var pack;
  var validity;
  var amount;
  var status;
  var details;
  var directory_total_day;
  var directory_reminning_day;
  var directory_shown_day;

  var post_daily_total;
  var post_daily_available;
  var post_daily_used;
  var post_daily_expried;

  var post_weekly_total;
  var post_weekly_available;
  var post_weekly_used;
  var post_weekly_expried;

  var post_fest_total;
  var post_fest_available;
  var post_fest_used;
  var post_fest_expried;

  var google_maps;
  var push_notification;
  var acc_option;
  var per_post;

  @override
  String toString() {
    return '{"id": "$id","date": "$date","expery_date": "$expery_date","pack": "$pack","validity": "$validity","amount": "$amount","status": "$status","details": "$details","directory_total_day": "$directory_total_day","directory_reminning_day": "$directory_reminning_day","directory_shown_day": "$directory_shown_day","post_daily_total": "$post_daily_total","post_daily_available": "$post_daily_available","post_daily_used": "$post_daily_used","post_daily_expried": "$post_daily_expried","post_weekly_total": "$post_weekly_total","post_weekly_available": "$post_weekly_available","post_weekly_used": "$post_weekly_used","post_weekly_expried": "$post_weekly_expried","post_fest_total": "$post_fest_total","post_fest_available": "$post_fest_available","post_fest_used": "$post_fest_used","post_fest_expried": "$post_fest_expried","google_maps": "$google_maps","push_notification": "$push_notification","acc_option": "$acc_option","per_post": "$per_post"}';
  }
}
