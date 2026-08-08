import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/scan_error_page.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TicketScannerPage extends StatefulWidget {
  static const routeName = '/scanner';

  int eventId;
  int scanUserId;
  String eventName;

  TicketScannerPage({
    this.scanUserId = 0,
    required this.eventId,
    required this.eventName,
    Key? key,
  }) : super(key: key);

  @override
  State<TicketScannerPage> createState() => _TicketScannerPageState();
}

class _TicketScannerPageState extends State<TicketScannerPage> {
  Barcode? result;

  // QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  bool isQRCodeVisible = false;
  bool listen = true;

  void _onScan(String bookingId) async {
    var userId = await DBHelper().getLoginSubDB("Id");
    var res = await ApiClientLocalKart().httpGet(
      '$subBase/checkeventbooking?userId=$userId&eventId=${widget.eventId}&bookingId=$bookingId',
    );

    var response = json.decode(res.body.toString());

    Future<void> navigateToPage(String routeName, dynamic arguments) async {
      await Navigator.pushNamed(context, routeName, arguments: arguments);
      setState(() {
        isQRCodeVisible = false;
        listen = true;
      });
      // controller?.resumeCamera(); // Resume the camera when returning
    }

    if (response['errorCode'] == 0) {
      //   navigateToPage(
      //     AdmitPageScreen.routeName,
      //     AdmitPageArguments(response['result'], widget.scanUserId),
      //   );
    } else {
      navigateToPage(ErrorPageScreen.routeName, ErrorPageArguments(response));
    }
  }

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Scan",
      context,
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              color: app_colorSecondary,
              width: MediaQuery.of(context).size.width,

              child: Center(
                child: Html(
                  data: '${widget.eventName ?? ""}',
                  style: {
                    "body": Style(
                      color: app_theam,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
              ),
            ),

            Expanded(
              // width: screenWidth,
              // height: screenHeight - 240,
              child: _buildQrView(context),
            ),

            Center(
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Point the QR Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 50,

          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 1),
                    // width: screenWidth / 2,
                    decoration: BoxDecoration(gradient: gradient_btn_lift),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(' Back', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => DefaultTextDialog(
                        onSubmit: (bookingId) {
                          _onScan(bookingId);
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(gradient: gradient_btn_rigth),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Enter Manually',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  String qr_code = "";

  Widget _buildQrView(BuildContext context) {
    return MobileScanner(
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          debugPrint(
            'Found code: ${barcode.rawValue}',
          ); // Handle the scanned data

          if (barcode.rawValue.toString() == qr_code) {
            ShowToastdur(context, "Already Scan");
          } else {
            qr_code = barcode.rawValue.toString();
            _onScan(qr_code);
          }
        }
      },
    );

    // return QRView(
    //   key: qrKey,
    //   onQRViewCreated: _onQRViewCreated,
    //   overlay: QrScannerOverlayShape(
    //     borderColor: isQRCodeVisible
    //         ? Color.fromARGB(255, 6, 175, 12)
    //         : Color.fromARGB(255, 243, 230, 229),
    //     borderRadius: 10,
    //     borderLength: 30,
    //     borderWidth: 10,
    //     cutOutSize: scanArea,
    //   ),
    //   onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    // );
  }
}

class DefaultTextDialog extends StatefulWidget {
  final Function(String) onSubmit;

  DefaultTextDialog({required this.onSubmit});

  @override
  _DefaultTextDialogState createState() => _DefaultTextDialogState();
}

class _DefaultTextDialogState extends State<DefaultTextDialog> {
  final String _defaultText = "LKEBKID";
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _defaultText);
    _focusNode = FocusNode();
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    final currentText = _controller.text;
    final selection = _controller.selection;

    // If the current text does not start with the default text, restore it
    if (!currentText.startsWith(_defaultText)) {
      _controller.value = TextEditingValue(
        text: _defaultText,
        selection: TextSelection.collapsed(offset: _defaultText.length),
      );
    } else if (selection.start < _defaultText.length) {
      // If the cursor is within the default text, move it to the end of the default text
      _controller.value = TextEditingValue(
        text: currentText,
        selection: TextSelection.collapsed(offset: _defaultText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Booking ID', style: TextStyle(color: app_theam)),
      content: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(labelText: 'Enter Booking ID'),
        onTap: () {
          // Move the cursor to the end of the default text if it is within the default text
          if (_controller.selection.start < _defaultText.length) {
            _controller.selection = TextSelection.collapsed(
              offset: _defaultText.length,
            );
          }
        },
        onChanged: (text) {
          // Prevent modification to the default text
          if (!text.startsWith(_defaultText)) {
            _controller.value = TextEditingValue(
              text: _defaultText + text.replaceFirst(_defaultText, ''),
              selection: TextSelection.collapsed(offset: _defaultText.length),
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Call the onSubmit callback with the entered text
            final enteredText = _controller.text.substring(_defaultText.length);
            widget.onSubmit(enteredText);
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
