import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:developer' as dev;

import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  String url;
  String reference;

  WebPage(this.url, this.reference);
  @override
  WebViewExampleState createState() =>
      WebViewExampleState(this.url, this.reference);
}

class WebViewExampleState extends State<WebPage> {
  String murl;
  String reference;

  WebViewExampleState(this.murl, this.reference);
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebViewPlugin.onUrlChanged.listen((String url) {
    //   print("This is url: " + url);
    //   try {
    //     if (url != murl) {
    //       Order(url);
    //     }
    //   } catch (e) {
    //     print(e.toString());
    //   }
    // });
  }

  cancel_order() async {
    Prefs.load();
    String token = Prefs.getString('token');

    String url =
        ApiCon.baseurl() + '/orders/cancelunpaid?ref=' + widget.reference;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };

    final response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == '201' || response.statusCode == '200') {
      print(response.statusCode);
    }
  }

  checkUrlRes(String url) async {
    //https://paypage.sandbox.ngenius-payments.com/?code=56000e9c278ad09d
    // bool checkurl = url.contains('https://paypage.ngenius-payments.com/?outletId=');
    bool checkurl =
        url.contains('https://paypage.sandbox.ngenius-payments.com/?outletId=');

    print(checkurl);
    // if (checkurl == true) {
    bool suc = url.contains('SUCCESS');
    //if (suc == true) {
    var divurl = url.split('=');
    print(divurl[2].trim());
    String codena = divurl[2].trim();
    String mycode = codena.replaceAll('&paymentRef', '');
    print(mycode);

    // Navigator.pop(context, mycode);

    // }

    // Map<String, String> headers = {"Content-Type": "application/json; charset=utf-8"};
    // final response = await http.get(url,headers: headers);
    // var jsondata = json.decode(response.body);
    //
    // //print(jsondata.toString());
    // if(response.statusCode == 200){
    //   if(jsondata.toString() == '{backToCart: true}') {
    //     Navigator.of(context).pop();
    //     //Navigator.pop(context, url);
    //     //print(json.decode(response.body)['savedCard']['maskedPan']);
    //   }else {
    //     //print(jsondata['savedCard']);
    //     if(json.decode(response.body)['savedCard']['cardToken'] != '' || json.decode(response.body)['savedCard']['cardToken'] != null) {
    //       if (json.decode(response.body)['state'] != 'FAILED' ||
    //           json.decode(response.body)['state'] != null ||
    //           json.decode(response.body)['state'] != '') {
    //         //Navigator.of(context).pop();
    //         print(json.decode(response.body)['state']);
    //         Navigator.pop(context, url);
    //       }
    //     }
    //
    //
    //   }
    // }
  }

  Order(String url) async {
    Prefs.load();
    String token = Prefs.getString('token');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      String mystate =
          json.decode(response.body)['_embedded']['payment'][0]['state'];

      if (url.contains('cancelUnpaid')) {
        Navigator.pop(context, 'cancel');
      } else {
        if (mystate.toLowerCase() == ('AUTHORISED').toLowerCase()) {
          Navigator.pop(context, 'AUTHORISED');
        } else {
          Navigator.pop(context, 'failed');
        }
      }
    } catch (x) {
      //Navigator.pop(context, 'failed');
    }

    // try {
    //   if (url.contains('cancelUnpaid')) {
    //     Navigator.pop(context, 'cancel');
    //   } else {
    //     final response = await http.post(url, headers: headers);
    //     dev.log("STATUS J: " + response.body);

    //     String mystate =
    //         json.decode(response.body)['_embedded']['payment'][0]['state'];
    //     dev.log("STATUS J" + mystate);
    //     if (mystate.toLowerCase() == ('AUTHORISED').toLowerCase()) {
    //       Navigator.pop(context, 'AUTHORISED');
    //     } else if (mystate.toLowerCase() == ('FAILED').toLowerCase()) {
    //       Navigator.pop(context, 'failed');
    //     } else if (mystate.toLowerCase() == ('REVERSE').toLowerCase()) {
    //       Navigator.pop(context, 'failed');
    //     } else {
    //       Navigator.pop(context, 'failed');
    //     }
    //   }
    // } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          backgroundColor: Color(0xFF2b2b61),
          title: new Text(
            "Payment",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          //     actions: [
          //       Padding(
          //   padding: EdgeInsets.only(right: 20.0),
          //   child: GestureDetector(
          //     onTap: () {
          //       Order();
          //     },
          //     child: Icon(
          //       Icons.search,
          //       size: 26.0,
          //     ),
          //   )
          // ),
          //     ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              cancel_order();
              Navigator.pop(context, 'cancel');
            },
          ),
        ),
      body: WebView(
        initialUrl: murl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
          child: const Center(
              child: Text(
                'Loading......',
                style: TextStyle(color: Colors.black),
              ),
            );
        },
         navigationDelegate: (action) {
        // if (action.url.contains('google.com')) {
        //   // Won't redirect url
        //   print('Trying to open google');
        //   Navigator.pop(context); 
        //   return NavigationDecision.prevent; 
        // } else if (action.url.contains('youtube.com')) {
        // // Allow opening url
        //   print('Trying to open Youtube');
        //   return NavigationDecision.navigate; 
        // } else {
        //   return NavigationDecision.navigate; 
        // }
        print("This is url: " + action.url);
         try {
          if (action.url != murl) {
            Order(action.url);
          }
        } catch (e) {
          print(e.toString());
        }
    
        return NavigationDecision.navigate; 
      },
        // appBar: new AppBar(
        //   backgroundColor: Color(0xFF2b2b61),
        //   title: new Text(
        //     "Payment",
        //     style: TextStyle(fontSize: 20, color: Colors.white),
        //   ),
        //   //     actions: [
        //   //       Padding(
        //   //   padding: EdgeInsets.only(right: 20.0),
        //   //   child: GestureDetector(
        //   //     onTap: () {
        //   //       Order();
        //   //     },
        //   //     child: Icon(
        //   //       Icons.search,
        //   //       size: 26.0,
        //   //     ),
        //   //   )
        //   // ),
        //   //     ],
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       cancel_order();
        //       Navigator.pop(context, 'cancel');
        //     },
        //   ),
        // ),
        // initialChild: Container(
        //   color: Colors.white,
        //   child: const Center(
        //     child: Text('Waiting.....'),
        //   ),
        // ),
      ),
    );
  }
}
