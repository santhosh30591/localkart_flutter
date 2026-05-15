import 'dart:io';

import 'package:localkart/theams_colors.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

var isUat = true;

var BaseURL = "localkart.app";

var subBase = !isLiveMode
    ? "https://www.$BaseURL/portal/uatapi"
    : "https://www.$BaseURL/portal/api";

var urlLogin = "$subBase/login";
var urlServiceCategories = "$subBase/servicecategories";
var urlShoppingCategories = "$subBase/shopcategories";
var urlSubCategorys = "$subBase/";
var urlState = "$subBase/state";
var urlDistrict = "$subBase/district";
var urlSendotpnew = "$subBase/sendotpnew";
var urlRegister = "$subBase/signup";
var urlDashSlide = "$subBase/homeslider";
var urlSubSlide = "$subBase/categoryslider";
var urlProfile = "$subBase/getprofiledetails";
var urlProfileUpdate = "$subBase/updateprofile";
var urlDevicesDetails = "$subBase/updatedeviceid";
var urlAppversion = "$subBase/appversion";

var shoprating = "$subBase/shoprating";
var servicerating = "$subBase/servicerating";

var shopviewcount = "$subBase/shopviewcount";

//Ticket_Nxt
var checkRegister = "$subBase/checkorgregister";
var bookingSlider = "$subBase/mybookings";
var paysuccess = "$subBase/paysuccess";
var sumcart = "$subBase/sumcart";
var bookingconfirm = "$subBase/bookingconfirm";
var paysuccessfree = "$subBase/paysuccessfree";
var subscriber_info = "$subBase/subscriber_info";
var customer_leads = "$subBase/customer_leads";
var eventListing = "$subBase/customereventlist";
var eventDetail = "$subBase/eventdetails";
var eventstyles = "$subBase/html_styles";
var urlAdsHistoryDelete = "$subBase/deletepost";
var urlDirectoryMore = "$subBase/directorymoredetails";
var businessEventList = "$subBase/bussinesseventlist";
var eventBookingLists = "$subBase/eventbookinglist";
var scanAgentEventList = "$subBase/scan_eventlist";
var ScaneventBookingLists = "$subBase/scan_bookedlist";
var urlEventSlide = "$subBase/homeslider";
var urlEventReferralVerify = "$subBase/verifyreferral";
var urlBusiness_create = "$subBase/business_create";
var popUpAds = "$subBase/popupads";
var closePopUp = "$subBase/popupclose";

var usershoprating = '$subBase/usershoprating';
var userservicerating = '$subBase/userservicerating';
var customereventlist = '/portal/api/customereventlist';

var posthistoryviewcount = '$subBase/posthistoryviewcount';
var serviceviewcount = "$subBase/serviceviewcount";
var urlServiceTypes = "$subBase/";
// var shopviewcount = "$subBase/shopviewcount";
var urlReportsShop = "$subBase/savereports";

var urlFeedBack = "$subBase/savefeedback";
var urlViewReferral = "$subBase/viewreferral";

var urlPaymentHistory = "$subBase/paymenthistory";
var urlAdsHistory = "$subBase/posthistory";
var urlGetReports = "$subBase/getrepost";
var urlSubscriptionList = "$subBase/subscription";
var urlPaymenthistorydetails = "$subBase/paymenthistorydetails";
var urlSubViewplandetails = "$subBase/viewplandetails";
var urlgetPrice = "$subBase/getpricing";
var urlPaymentsuccess = "$subBase/paymentsuccess";
var urlApplyCode = "$subBase/applycode";
var urlNotification = "$subBase/notificationlist";
var urlTransInvoice = "$subBase/transaction_reports";
var urlTransInvoiceDetails = "$subBase/transaction_report_details";

// questions

var urlBusinesssave = "$subBase/businesssave";
var urlUploadimage = "$subBase/uploadimage";
var urlCreateoffers = "$subBase/createoffers";
var urlViewoffer = "$subBase/viewoffer";
var urlEditbusiness = "$subBase/editbusiness";
var urlCreaterepostoffers = "$subBase/createrepostoffers";
var urlBuynow = "$subBase/buynow";
var urlPaysuccess = "$subBase/paysuccess";
var urlListarray = "$subBase/listarray";

var urlJobValidation = "$subBase/jobpostvalidation";

var urlCreatejoboffers = "$subBase/createjoboffers";
var urlCreatejobpost = "$subBase/createjobpost";
var urlPostvalidation = "$subBase/postvalidation";
var urlCreatepost = "$subBase/createpost";
var urlViewdeals = "$subBase/viewdeals";
var urlSendpush = "$subBase/sendpush";
var urlAmountcalculation = "$subBase/amountcalculation";

var urlDeletebusinessbanner = "$subBase/deletebusinessbanner";
var urlBusinessupdate = "$subBase/businessupdate";
var urlGetmegasales = "$subBase/getmegasales";

var urlCreatemegasalespost = "$subBase/createmegasalespost";
var urlCreatemegasalesoffers = "$subBase/createmegasalesoffers";

var urlViewmegasalespostdetails = "$subBase/viewmegasalespostdetails";
var urlViewmegasalesdeals = "$subBase/viewmegasalesdeals";
var shopservicedetailcount = '$subBase/shopservicedetailcount';

var urlSignupTerms = "https://localkart.app/terms-and-conditions-customers.php";
var urlBusinessTerms =
    "https://localkart.app/terms-and-conditions-business-owners.php";

var urlBusinessSupport = "https://localkart.app/help-support.php";
var urlFranchise = "https://localkart.app/portal/franchise/index";

var BillPaymentBaseURL = !isLiveMode
    ? "https://billpaynxt.in/portal/uatapi/"
    : "https://billpaynxt.in/portal/billapi/";

var urlBillpayList = "https://billpaynxt.in/portal/api/ps_home_categories";
var url_fetch_operators = BillPaymentBaseURL + "fetch_operators";
var url_fetch_billinfo = BillPaymentBaseURL + "fetch_billinfo";
var url_bill_status = BillPaymentBaseURL + "bill_status";
var url_transaction_details = BillPaymentBaseURL + "transaction_details";

var url_dashboard = subBase + "/dashboard";
var url_Updatedeviceid = subBase + "/updatedeviceid";
var url_scan_booking_list = subBase + "/scan_bookedlist";
