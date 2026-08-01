import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/directory_more_deails.dart';
import 'package:localkart/pages/Dashboard/manage_business/Subscription/subscription.dart';
import 'package:localkart/pages/Dashboard/manage_business/Subscription/subscription_history.dart';
import 'package:localkart/pages/Dashboard/manage_business/Subscription/subscription_plan_list.dart';
import 'package:localkart/pages/Dashboard/manage_business/UpdateDetails/business_basic_update.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/ads_history.dart';
import 'package:localkart/pages/Dashboard/manage_business/business.dart';
import 'package:localkart/pages/Dashboard/dashboard.dart';
import 'package:localkart/pages/Dashboard/manage_business/business_basic_register.dart';
import 'package:localkart/pages/Dashboard/manage_business/customer_leads.dart';
import 'package:localkart/pages/Dashboard/manage_business/digital_vcard.dart';
import 'package:localkart/pages/Dashboard/manage_business/posts/create_post.dart';
import 'package:localkart/pages/Dashboard/manage_business/posts/job_post.dart';
import 'package:localkart/pages/Dashboard/manage_business/suscribers_list.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/eventsList.dart';
import 'package:localkart/pages/Dashboard/menu/Notification/notification.dart';
import 'package:localkart/pages/Dashboard/menu/my_rewards_page.dart';
import 'package:localkart/pages/Dashboard/menu/tens_invoice/invoice_list.dart';
import 'package:localkart/pages/Dashboard/menu/feedback.dart';
import 'package:localkart/pages/Dashboard/menu/mybookingspage.dart';
import 'package:localkart/pages/Dashboard/menu/profile.dart';
import 'package:localkart/pages/Dashboard/menu/refer.dart';
import 'package:localkart/pages/Dashboard/menu/ticketDetailsPage.dart';
import 'package:localkart/pages/Dashboard/searching.dart';
import 'package:localkart/pages/Dashboard/services_details_tab_view.dart';
import 'package:localkart/pages/Dashboard/shop_service_list.dart';
import 'package:localkart/pages/autho/login.dart';
import 'package:localkart/pages/autho/register.dart';
import 'package:localkart/pages/autho/splash.dart';
import 'package:localkart/pages/billpayment/bill_fatch_info_enter.dart';
import 'package:localkart/pages/billpayment/fatch_balance.dart';
import 'package:localkart/pages/billpayment/operater_list.dart';
import 'package:localkart/pages/billpayment/trans_details.dart';
import 'package:localkart/pages/billpayment/trans_history.dart';
import 'package:localkart/pages/billpayment/web_view_payment.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:flutter/material.dart';
import 'package:localkart/RoutingSetup/undefined-view.dart';
import 'package:localkart/pages/events/bookNow.dart';
import 'package:localkart/pages/web_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final arg = settings.arguments;

  switch (settings.name) {
    // case root_home:
    //   return MaterialPageRoute(builder: (context) => HomePage());
    case root_dashboard:
      return MaterialPageRoute(builder: (context) => DashboardPage());
    case root_splash:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case root_profile_nav:
      return MaterialPageRoute(builder: (context) => Profile());
    case root_login:
      return MaterialPageRoute(builder: (context) => Login());
    case root_register:
      return MaterialPageRoute(builder: (context) => Register());
    //
    case root_business:
      return MaterialPageRoute(builder: (context) => Business());
    //
    case root_business_basic:
      return MaterialPageRoute(builder: (context) => RegisterBusiness());
    //
    case root_business_basic_update:
      return MaterialPageRoute(builder: (context) => UpdateBusiness());
    //
    case root_business_job:
      return MaterialPageRoute(builder: (context) => JobPost());

    case root_business_create_post:
      return MaterialPageRoute(builder: (context) => CreatePosts());

    // case root_help_support:
    //   return MaterialPageRoute(builder: (context) => HelpSupport());
    //
    case root_business_digital_Vcard:
      return MaterialPageRoute(builder: (context) => DigitalVcardDetails());
    //
    case root_business_ads:
      return MaterialPageRoute(builder: (context) => AdsHostory());
    //
    case root_business_subScription:
      return MaterialPageRoute(builder: (context) => SubscriptionPlans());
    case root_business_subscribers_list:
      return MaterialPageRoute(builder: (context) => SubscribersListPage());
    //
    case business_subscriptin_history:
      return MaterialPageRoute(builder: (context) => SubscriptionHistorys());
    case business_lead:
      return MaterialPageRoute(
        builder: (context) => CustomerLeardsPage(datas: arg),
      );

    case business_digital_subscriptin_list:
      return MaterialPageRoute(builder: (context) => SubscriptionPlansList());
    //
    case root_notification_list:
      return MaterialPageRoute(builder: (context) => NotificationDetailsList());

    case root_trans_list:
      return MaterialPageRoute(builder: (context) => TransInvoiceList());

    // case root_trans_list:
    //   return MaterialPageRoute(builder: (context) => TransInvoiceList());

    //
    case root_my_bookings:
      return MaterialPageRoute(builder: (context) => MybookingsPage());
    case root_my_rewards:
      return MaterialPageRoute(builder: (context) => MyRewardsPage());

    //
    case view_my_bookings:
      return MaterialPageRoute(
        builder: (context) => TicketDetailsScreen(datas: arg),
      );
    //
    case root_feedback:
      return MaterialPageRoute(builder: (context) => FeedBack());

    case root_search:
      return MaterialPageRoute(builder: (context) => ServicesSerching());
    //
    case root_services_more_details:
      return MaterialPageRoute(
        builder: (context) => ServicesMoreDetails(setviceDetails: arg),
      );
    //
    //
    case root_ticketNxt:
      return MaterialPageRoute(builder: (context) => ManageEventsListing());
    //
    case root_services_list:
      return MaterialPageRoute(builder: (context) => ServicesList(datas: arg));
    case root_referal:
      return MaterialPageRoute(builder: (context) => ReferalDetails());
    //
    case root_services_details:
      return MaterialPageRoute(
        builder: (context) => ServicesDetails(roots: arg),
      );

    case root_web_view_nav:
      return MaterialPageRoute(builder: (context) => WebViewLoad(roots: arg));

    case root_billpay_opertor_list:
      return MaterialPageRoute(
        builder: (context) => BillPayOperateList(datas: arg),
      );
    case root_enter_card_details:
      return MaterialPageRoute(
        builder: (context) => BillFatchInfoEnterCard(datas: arg),
      );
    case root_fetch_balance:
      return MaterialPageRoute(
        builder: (context) => FetchBalanceDetails(datas: arg),
      );

    case root_webview_payment:
      return MaterialPageRoute(
        builder: (context) => WebViewPaymentGateway(datas: arg),
      );
    // case root_bookNow:
    //   return MaterialPageRoute(builder: (context) => BookNowPage(eventId: arg));

    case root_view_billbay_status:
      return MaterialPageRoute(
        builder: (context) => TransStatusDetails(datas: arg),
      );
    case root_billbay_history:
      return MaterialPageRoute(builder: (context) => TransHistory());

    default:
      return MaterialPageRoute(builder: (context) => UndefinedView(name: ""));
  }
}
