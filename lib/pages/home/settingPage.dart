import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/savecard.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:driklink/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driklink/pages/home/menupage.dart';
import 'package:uuid/uuid.dart';
import 'package:email_validator/email_validator.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:otp/otp.dart';

class setPage extends StatefulWidget {
  @override
  _setPageState createState() => _setPageState();
}

class _setPageState extends State<setPage> {
  bool sound = true;
  bool ring = true;
  bool checkedValue = false;
  String uName = '';
  TextEditingController billname = new TextEditingController();
  TextEditingController billlast = new TextEditingController();
  TextEditingController billadd = new TextEditingController();
  TextEditingController billemail = new TextEditingController();
  bool isActive = true;

  TextEditingController otp = new TextEditingController();
  bool isVerified = false;

  List<CardDetails> myCardList = [];
  Future myCardFuture;

  int tipid = 0;
  String idCard = '0';
  String discountID = '';
  String discountPerc = '';
  int lengtofsub = 0;
  String iconid = '';
  bool saveCard = false;
  var uuid = Uuid();
  String token = '';

  String maskedPan = '';
  String expiry = '';
  String cardholderName = '';
  String scheme = '';
  String cardToken = '';
  String cardnamex = '';
  String cardidx = '';
  Color contColor = Colors.green;
  String otpcode = OTP.generateTOTPCodeString(
      'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
      interval: 60);

  @override
  void initState() {
    super.initState();
    getDetails();
    myCardList = [];
    myCardFuture = getCard();
  }

  deleteusercardsingle(String cardtoken) async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, _, __) {
          return Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              width: 150,
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: new SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    String su = Prefs.getString('token');
    String un = Prefs.getString('uname') ?? '';
    print('Dele Card');
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + su,
      'Content-Type': 'application/json'
    };

    String url = ApiCon.baseurl() +
        '/users/currentUser/deletecard?cardtoken=' +
        cardtoken;

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      print(response.statusCode);
      Navigator.pop(context);
      _showDialog_deletecard_single('My Card', 'Successfully deleted.');
      cardidx = '';
      cardnamex = '';
      checkedValue = false;
      Prefs.setString('bcardname' + uName, cardnamex);
      Prefs.setString('bcardid' + uName, cardidx);
      Prefs.setBool('bsendBill' + uName + '', checkedValue);
    } else {
      Navigator.pop(context);
      _showDialog_deletecard_single('My Card', 'Failed to delete card.');
    }

    myCardFuture = getCard();
  }

  deleteuser() async {
    String su = Prefs.getString('token');
    String un = Prefs.getString('uname') ?? '';
    print('Dele Card');
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + su,
      'Content-Type': 'application/json'
    };

    String url = ApiCon.baseurl() + '/users/currentUser/savedcards';

    final response = await http.delete(Uri.parse(url), headers: headers);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      getCard();
    }
  }

  Future<List<CardDetails>> getCard() async {
    setState(() {
      myCardList = [];
    });
    String mytoken = Prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + mytoken
    };
    try {
      final response = await http.get(
          Uri.parse(ApiCon.baseurl() + '/users/currentUser/savedCards'),
          headers: headers);
      var jsondata = json.decode(response.body);
      print(response.body);

      for (var u in jsondata) {
        var mask = u['maskedPan'];
        var fullname = mask.split('******');
        String latmask = "******" + fullname[1].trim().toString();

        CardDetails tmc = new CardDetails(
            u['id'].toString(),
            u['maskedPan'],
            u['expiry'],
            u['cardholderName'],
            u['scheme'],
            u['cardToken'],
            false,
            latmask);

        setState(() {
          myCardList.add(tmc);
        });
      }
    } catch (e) {}
    return myCardList;
  }

  getDetails() {
    setState(() {
      Prefs.load();

      uName = Prefs.getString('uname') ?? '';
      billname.text = Prefs.getString('bfName' + uName) ?? '';
      billlast.text = Prefs.getString('blMame' + uName) ?? '';

      billadd.text = Prefs.getString('billAdd' + uName) ?? '';
      billemail.text = Prefs.getString('billEmail' + uName) ?? '';
      sound = Prefs.getBool('sound' + uName) ?? '';

      ring = Prefs.getBool('alert' + uName) ?? '';

      checkedValue = Prefs.getBool('bsendBill' + uName) ?? '';
      cardidx = Prefs.getString('bcardid' + uName) ?? '';
      cardnamex = Prefs.getString('bcardname' + uName) ?? '';
      String vemail = Prefs.getString('verifiedemail' + uName) ?? '';
      if (vemail == billemail.text.trim()) {
        isVerified = Prefs.getBool('isVerified' + uName) ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2b61),
      appBar: new AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFF2b2b61),
        title: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                "SETTINGS",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 20),
              child: Text(
                "Customize DrinkLink",
                style: TextStyle(fontSize: 12, color: Colors.deepOrange),
              ),
            ),
          ],
        ),
        shape: Border(bottom: BorderSide(color: Colors.deepOrange, width: 2)),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Cards',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
              showCardDetails(),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (isActive) {
                    _showDialog('ADD CREDIT CARD',
                        "1 AED will be authorized and then released in order to validate your credit card. Do you want to continue?");
                    setState(() {
                      isActive = false;
                    });
                  }
                  print(isActive);
                },
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.white, // red as border color
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "ADD NEW CARD",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Default Message Sound',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
              Text(
                'Default Message Sound for each order status change',
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(.8)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black45.withOpacity(.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sound = true;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: sound == true
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "ON",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sound = false;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: sound == false
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "OFF",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Default Ring for Order Ready',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black45.withOpacity(.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ring = true;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ring == true
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "ON",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ring = false;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ring == false
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "OFF",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Column(
                  children: [
                    TextField(
                      controller: billemail,
                      style: TextStyle(color: Colors.white),
                      decoration: new InputDecoration(
                        hintText: "Send bill to email",
                        hintStyle: TextStyle(color: Colors.white54),
                        labelStyle: new TextStyle(color: Colors.white),
                        labelText: 'Send bill to email',
                      ),
                      onChanged: (text) {
                        setState(() {
                          String vemail =
                              Prefs.getString('verifiedemail' + uName) ?? '';
                          if (vemail == text.trim()) {
                            isVerified =
                                Prefs.getBool('isVerified' + uName) ?? false;
                          } else {
                            isVerified = false;
                          }
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isVerified == true)
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    ' VERIFIED',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            )
                          else
                            GestureDetector(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_rounded,
                                    color: Colors.deepOrange,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    ' SEND VERIFICATION EMAIL',
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  if (isVerified != true) {
                                    var email = billemail.text.trim();
                                    final bool isValid =
                                        EmailValidator.validate(email);
                                    print(isValid);
                                    if (isValid == false) {
                                      _messageDialog('DrinkLink',
                                          'Enter valid email address.', '');
                                      return;
                                    }
                                    sendOTP();
                                  }
                                });
                              },
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  //padding: EdgeInsets.fromLTRB(0, 10, 15, 5),
                  child: CheckboxListTile(
                checkColor: Colors.white,
                title: Text("Use name on card for billing",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                    cardnamex = '';
                    cardidx = '';
                    print(cardnamex);
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              )),
              Visibility(
                visible: checkedValue == true ? false : true,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextFormField(
                    controller: billname,
                    style: TextStyle(color: Colors.white),
                    decoration: new InputDecoration(
                      hintText: "First name on bill",
                      hintStyle: TextStyle(color: Colors.white54),
                      labelStyle: new TextStyle(color: Colors.white),
                      labelText: 'First name on bill',
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: checkedValue == true ? false : true,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextField(
                    onChanged: (val) {
                      print(val);
                    },
                    controller: billlast,
                    style: TextStyle(color: Colors.white),
                    decoration: new InputDecoration(
                      hintText: "Last name on bill",
                      hintStyle: TextStyle(color: Colors.white54),
                      labelStyle: new TextStyle(color: Colors.white),
                      labelText: 'Last name on bill',
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: TextField(
                  controller: billadd,
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    hintText: "Address, City, Country",
                    hintStyle: TextStyle(color: Colors.white54),
                    labelStyle: new TextStyle(color: Colors.white),
                    labelText:
                        'Billing to: Address, City, Country(separated with: ,)',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          style: flatButtonStyle,
                          onPressed: () async {
                            if (checkedValue) {
                              if (cardidx.isEmpty) {
                                _messageDialog('Select Card',
                                    'Please choose your default card.', '');
                                return;
                              }
                            }
                            var email = billemail.text.trim();
                            final bool isValid = EmailValidator.validate(email);
                            print(isValid);
                            if (isValid == false) {
                              _messageDialog('DrinkLink',
                                  'Enter valid email address.', '');
                              return;
                            }
                            if (isVerified == false) {
                              _messageDialog('DrinkLink',
                                  'Email address is not verified.', '');
                              return;
                            }

                            updateChanges();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   'assets/images/applelogo.png',
                              //   height: 30.0,
                              //   width: 30.0,
                              // ),
                              //SizedBox(width: 10,),
                              Text(
                                'APPLY SETTINGS',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendOTP() async {
    _loadPreview();
    print(otpcode);
    // String username = 'leepe@drinklinkph.com';
    // String password = 'P@ssw0rd';
    String username = 'leepeapp1@gmail.com';
    String password = 'ioafduzyrulejpqj';
    String bemail = billemail.text.trim();

    final smtpServer =
        SmtpServer('smtp.gmail.com', username: username, password: password);

    final message = Message()
      ..from = Address(username, bemail)
      ..recipients.add(bemail)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'DrinkLink@support : ${DateTime.now()}'
      // ..text = messageController.text;
      ..html = "<h5>Hi " +
          bemail +
          " ,</h5>\n<p> We received your request for a single-use OTP to use with your DrinkLink account." +
          "</p>"
              "\n"
              "<p> Your single-use OTP is:" +
          otpcode +
          "</p>"
              "\n"
              "<p>If you didn't request this OTP, you can safely ignore this email. Someone else might have typed your email address by mistake</p>"
              "\n"
              "<p>Thanks,</p>"
              "DrinkLinkTeamSupport";

    var connection = PersistentConnection(smtpServer);

    // Send the first message
    try {
      final rsult = await connection.send(message);
      if (rsult.toString().contains('Message successfully sent')) {
        await connection.close();
        Navigator.of(context).pop();
        _messageDialog(
            'Verify Your Email Address',
            'We have sent an email to ' +
                bemail +
                ' to verify your email address. The OTP will expire in 5m.',
            'otp');
      } else {
        await connection.close();
        Navigator.of(context).pop();
        _messageDialog(
            'Verify Your Email Address', 'Failed to send request!', '');
      }
    } catch (error) {
      await connection.close();
      Navigator.of(context).pop();
      _messageDialog(
          'Verify Your Email Address', 'Failed to send request!', '');
    }

    // close the connection
  }

  _loadPreview() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, _, __) {
          return Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              width: 150,
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: new SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  updateChanges() async {
    Prefs.load();
    uName = Prefs.getString('uname') ?? '';

    String bname = billname.text.trimLeft();
    String blast = billlast.text.trimLeft();
    String badd = billadd.text;
    String bemail = billemail.text.trim();
    bool bsendBill = checkedValue;
    Prefs.setString('bfName' + uName, bname);
    Prefs.setString('blMame' + uName, blast);
    Prefs.setString('billName' + uName, bname + " " + blast);
    Prefs.setString('billAdd' + uName, badd);
    Prefs.setString('billEmail' + uName, bemail);
    Prefs.setBool('bsendBill' + uName + '', bsendBill);
    Prefs.setString('bcardname' + uName, cardnamex);
    Prefs.setString('bcardid' + uName, cardidx);

    setState(() {
      Prefs.setBool('sound' + uName, sound);
      Prefs.setBool('alert' + uName, ring);
    });

    FirebaseMessaging.instance.requestPermission(
      alert: ring,
      sound: sound,
    );
  }

  _showDialog_deletecard_single(String title, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            // FlatButton(
            //   child: Text(
            //     'Cancel',
            //     style: TextStyle(color: Colors.white, fontSize: 18),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context, rootNavigator: true).pop();
            //   },
            // ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  _showDialog_Deletecard(String title, String message, String Token) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                deleteusercardsingle(Token);
              },
            ),
          ],
        ),
      ),
    );
  }

  _showDialog1(String title, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              style: flatButtonStyle,
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _messageDialog(String title, String message, String action) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                switch (action) {
                  case 'otp':
                    Navigator.of(context, rootNavigator: true).pop();
                    _confirmOTP();
                    break;
                  default:
                    Navigator.of(context, rootNavigator: true).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _confirmOTP() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 20,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            'Verify Your Email Address',
            style: TextStyle(color: Colors.deepOrange, fontSize: 18),
          ),
          content: Container(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Check your email for the OTP.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  controller: otp,
                  style: TextStyle(color: Colors.deepOrange),
                  decoration: new InputDecoration(
                    hintText: "Enter OTP",
                    hintStyle: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                otp.text = '';
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                'Verify',
                style: TextStyle(color: Colors.deepOrange, fontSize: 14),
              ),
              onPressed: () async {
                setState(() {
                  if (otpcode == otp.text) {
                    uName = Prefs.getString('uname') ?? '';
                    Prefs.setString(
                        'verifiedemail' + uName, billemail.text.trim());
                    Prefs.setBool('isVerified' + uName, true);
                    isVerified = true;
                    otp.text = '';
                    Navigator.of(context, rootNavigator: true).pop();
                  } else {
                    otp.text = '';
                    _otperrordialog();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _otperrordialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            'Verify Your Email Address',
            style: TextStyle(color: Colors.deepOrange, fontSize: 18),
          ),
          content: Container(
            height: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Invalid OTP!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(String title, String message) async {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, _, __) {
          return Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              width: 150,
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: new SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
            ),
          );
        }));

    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    String linkpayment = '';
    String reference = '';
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token
      };
      String url = ApiCon.baseurl() + '/users/currentUser/savedCards';
      final response = await http.post(Uri.parse(url), headers: headers);
      print(json.decode(response.body));
      await Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      if (response.statusCode == 200) {
        linkpayment = json.decode(response.body)['paymentLink'];
        reference = json.decode(response.body)['orderReference'];
        confirmDialog(title, message, linkpayment, reference);
      }
      setState(() {
        isActive = true;
        print(isActive);
      });
    } catch (e) {
      setState(() {
        isActive = true;
        print(isActive);
      });
      _showDialog1('DrinkLink', 'Please login first.');
    }
  }

  confirmDialog(
      String title, String message, String linkpayment, String reference) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              style: flatButtonStyle,
              child: Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              style: flatButtonStyle,
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                // Navigator.of(context, rootNavigator: true).pop();
                // Navigator.of(context).push(
                //     new PageRouteBuilder(
                //         opaque: false,
                //         barrierDismissible:false,
                //         pageBuilder: (BuildContext context, _, __) {
                //           return Center(
                //             child: Container(
                //               padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                //               width: 150,
                //               height: 150,
                //               color: Colors.transparent,
                //               child: Center(
                //                 child: new SizedBox(
                //                   height: 50.0,
                //                   width: 50.0,
                //                   child: new CircularProgressIndicator(
                //                     value: null,
                //                     strokeWidth: 7.0,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           );
                //         }
                //     )
                // );
                // await Future.delayed(const Duration(seconds: 1), (){
                //   Navigator.of(context).pop();
                // });

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SaveCardWeb(linkpayment.toString(), reference)),
                );

                if (result == 'Added') {
                  _showDialog1('DrinkLink', 'New card saved.');
                } else {
                  print(result);
                  _showDialog1('DrinkLink', 'Failed to save card.');
                }
                myCardFuture = getCard();
              },
            ),
          ],
        ),
      ),
    );
  }

  showCardDetails() {
    return Container(
      height: 60 * myCardList.length.toDouble(),
      child: FutureBuilder(
          future: myCardFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              // try {
              //   cardnamex = snapshot.data[0].cardholderName;
              //   cardidx = snapshot.data[0].cardid;
              // } catch (e) {
              //   cardnamex = '';
              //   cardidx = '';
              // }

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  snapshot.data[index].scheme,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index].cardholderName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      snapshot.data[index].showmask +
                                          "  " +
                                          snapshot.data[index].expiry,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    if (checkedValue) {
                                      cardnamex =
                                          snapshot.data[index].cardholderName;
                                      cardidx = snapshot.data[index].cardid;
                                      myCardList = [];
                                      myCardFuture = getCard();
                                    }
                                  });
                                },
                              ),

                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  cardnamex =
                                      snapshot.data[index].cardholderName;
                                  cardidx = snapshot.data[index].cardid;
                                  _showDialog_Deletecard(
                                      'Delete card',
                                      'Are you sure you want to delete this card?',
                                      snapshot.data[index].cardToken);
                                }, //Delete card
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (checkedValue == true)
                                Visibility(
                                  visible:
                                      cardidx == snapshot.data[index].cardid
                                          ? true
                                          : false,
                                  child: GestureDetector(
                                    child: Container(
                                      // padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        cardnamex =
                                            snapshot.data[index].cardholderName;
                                        cardidx = snapshot.data[index].cardid;
                                        myCardList = [];
                                        myCardFuture = getCard();
                                      });
                                      // _showDialog_Deletecard(
                                      //     'Delete card',
                                      //     'Are you sure you want to delete this card?',
                                      //     snapshot.data[index].cardToken);
                                    }, //Delete card
                                  ),
                                )

                              // Container(
                              //   padding: EdgeInsets.fromLTRB(63, 0, 0, 0),
                              //   child: FlatButton(
                              //     onPressed: () {},
                              //     child: Icon(
                              //       Icons.close,
                              //       color: Colors.white,
                              //     ),
                              //     height: 48,
                              //   ),
                              // )
                            ],
                          )),
                    );
                  });
            }
          }),
    );
  }
}
