import 'package:flutter/material.dart';

double bussiness_select_tab_height = 6;
Color bussiness_select_tab_colors = Colors.deepPurpleAccent;

const app_theam = MaterialColor(app_color, <int, Color>{
  50: Color(0xFFffffff),
  100: Color(0xFFf9d2e4),
  200: Color(0xFFf4a4c8),
  300: Color(0xFFee77ad),
  400: Color(0xFFe94991),
  500: Color(app_color),
  600: Color(0xFFb6165e),
  700: Color(0xFF881147),
  800: Color(0xFF5b0b2f),
  900: Color(0xFF2d0618),
});
const app_color = 0xFFe4287c;
const Color app_colorSecondary = Color(0xfffae5ef);

const billpay_div_line_color = Color(0xffefeeef);
const home_service_tab_bg = Color(0xfff6f5f6);

const gradint_start_color = Color(0xff0B45B0);
const gradient_end_color = Color(0xffA8198F);
const dashboard_news_color = Color(0xffF8E8EF);

Gradient app_gradient = LinearGradient(
  // Define the colors for the gradient. At least two are required.
  colors: [gradint_start_color, gradient_end_color],
  // Define where the gradient starts and ends (Alignment values range from -1.0 to 1.0).
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  // begin: Alignment.centerLeft,
  // end: Alignment.centerRight,
  // stops: [0.45, 1.0],
);

Gradient home_bottom_text_gradient = LinearGradient(
  // Define the colors for the gradient. At least two are required.
  colors: [Colors.grey, Colors.grey],
  // Define where the gradient starts and ends (Alignment values range from -1.0 to 1.0).
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  // begin: Alignment.centerLeft,
  // end: Alignment.centerRight,
  // stops: [0.45, 1.0],
);

const gray_color = billpay_div_line_color;

Gradient gradient_btn_lift = LinearGradient(
  colors: [gradint_start_color, Color(0xff6B2B9B)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

Gradient gradient_btn_lift_disabled = LinearGradient(
  colors: [Colors.grey, Colors.grey],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

Gradient gradient_btn_rigth = LinearGradient(
  colors: [Color(0xff6B2B9B), gradient_end_color],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

var isLiveMode = false;
