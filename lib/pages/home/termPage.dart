import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/login/signup.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class termPage extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class termsSign extends StatefulWidget {
  String fname, lname, email, uname, pwd, cpwd;
  bool checkedValuex;

  termsSign(this.fname, this.lname, this.email, this.uname, this.pwd, this.cpwd,
      this.checkedValuex);

  @override
  WebViewExampleState1 createState() => WebViewExampleState1();
}

class WebViewExampleState extends State<termPage> {
  String murl =
      'https://drinklink.ae/oathygow/2020/12/Terms-of-Service-DrinkLink.pdf';
  // final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebViewPlugin.onUrlChanged.listen((String url) {});
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text(
          "Terms of Service",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: FutureBuilder<Uint8List>(
        future: _fetchPdfContent(murl),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              initialPageFormat:
                  PdfPageFormat(100 * PdfPageFormat.mm, 120 * PdfPageFormat.mm),
              build: (format) => snapshot.data,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
Future<Uint8List> _fetchPdfContent(final String url) async {
    try {
      final Response<List<int>> response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

class WebViewExampleState1 extends State<termsSign> {
  String murl =
      'https://drinklink.ae/oathygow/2020/12/Terms-of-Service-DrinkLink.pdf';
  // final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebViewPlugin.onUrlChanged.listen((String url) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text(
          "Terms of Service",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUp(
                      widget.fname,
                      widget.lname,
                      widget.email,
                      widget.uname,
                      widget.pwd,
                      widget.cpwd,
                      widget.checkedValuex)),
            );
          },
        ),
      ),
      body: FutureBuilder<Uint8List>(
        future: _fetchPdfContent(murl),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              initialPageFormat:
                  PdfPageFormat(100 * PdfPageFormat.mm, 120 * PdfPageFormat.mm),
              build: (format) => snapshot.data,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
