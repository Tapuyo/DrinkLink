import 'dart:ffi';
import 'dart:math';

import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/orderPage.dart';
import 'package:driklink/pages/home/orderdetails.dart';
import 'package:driklink/pages/home/settingPage.dart';
import 'package:driklink/pages/home/termPage.dart';
import 'package:driklink/pages/home/webpage.dart';
import 'package:driklink/pages/login/help.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:driklink/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanoid/nanoid.dart';

//import 'package:nanoid/non_secure.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:driklink/provider/payment_provider.dart';
import 'package:collection/equality.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:driklink/auth_provider.dart';
import 'package:provider/provider.dart';

import 'dart:core';
import 'package:email_validator/email_validator.dart';

class MenuPage extends StatefulWidget {
  String id, title, desc;

  MenuPage(this.id, this.title, this.desc);

  @override
  _MenuPageState createState() =>
      _MenuPageState(this.id, this.title, this.desc);
}

class _MenuPageState extends State<MenuPage> {
  int tipid = 0;
  String idCard = '0';
  String discountID = '';
  String discountPerc = '';
  int lengtofsub = 0;
  String iconid = '';
  bool saveCard = false;
  var uuid = Uuid();
  String token = '';
  String uName = '';

  String stoken;
  int orderlenght = 0;
  String choosetb = "Choose Table";
  double fee = 0;
  List jorder = [];
  String selectedmenu = '';
  String selectedmenu1 = '';
  int subbodybool = 0;
  String id, title, desc;

  _MenuPageState(this.id, this.title, this.desc);

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future subMenu;
  Future myStore;
  Future myTempCart;
  Future myCartFuture;
  Future myCardFuture;
  List<CardDetails> myCardList = [];
  List<TempOrder> temporder = [];
  List<Store> myList = [];
  List<SubMenu> myMenu = [];
  List<Drinks> myDrinks = [];
  List<chossenMixerMultiple> newChsmx;
  List<chossenMixerMultipleRemoved> newChsmxRemoved;
  List<chossenMixerMultipleQty> chmqty;
  List<String> userChecked = [];

  List<Table> mytable = [];
  List<Discount> mydicount = [];
  PanelController _pc = new PanelController();
  bool _pcb = false;
  int order1 = 0;
  int order2 = 0;
  String ord1 = '00';
  String ord2 = '00';
  bool btnaddcolor = false;
  String ord3 = '00';
  bool pickdine = true;
  bool checkedValue = false;
  bool checkedValue_dsettings = false;
  String sub = '';
  String dri = '';
  String drisub = '';
  double finaltotwithdiscount = 0;
  double finaltot = 0;
  int dtofdy = 0;
  String wk = '';
  bool isWorkingDay = false;
  double vip = 0;
  double timecol = 0;
  bool vipcharge = false;
  double mdicount = 0;
  double discountitempercentage = 0;
  double mtip = 0;
  double discount = 0;
  double tip = 0;
  double charge = 0;
  int selectedIndex = 0;
  String cname = '';
  TextEditingController billname = new TextEditingController();
  TextEditingController billadd = new TextEditingController();
  TextEditingController billemail = new TextEditingController();
  bool addICe;

  String maskedPan = '';
  String expiry = '';
  String cardholderName = '';
  String scheme = '';
  String cardToken = '';
  Color contColor = Colors.green;

  bool isloading;
  int totalqty = 0;
  double chrx = 0;

  bool isbname = true;
  bool isbaddress = true;
  bool isemail = true;
  bool isedit = false;
  counteraddord1(String addminus) {
    if (addminus == 'add') {
      setState(() {
        order1 = order1 + 1;
        if (order1 < 10) {
          ord1 = '0' + order1.toString();
        } else {
          ord1 = order1.toString();
        }
      });
    } else {
      setState(() {
        order1 = order1 - 1;
        if (order1 < 0) {
          order1 = 0;
          ord1 = '00';
        } else {
          if (order1 < 10) {
            ord1 = '0' + order1.toString();
          } else {
            ord1 = order1.toString();
          }
        }
      });
    }
    if (order1 > 0 || order2 > 0) {
      setState(() {
        btnaddcolor = true;
      });
    } else {
      setState(() {
        btnaddcolor = false;
      });
    }
  }

  counteraddord2(String addminus) {
    if (addminus == 'add') {
      //setState(() {
      order2 = order2 + 1;
      if (order2 < 10) {
        ord2 = '0' + order2.toString();
      } else {
        ord2 = order2.toString();
      }
      //});
    } else {
      //setState(() {
      order2 = order2 - 1;
      if (order2 < 0) {
        order2 = 0;
        ord2 = '00';
      } else {
        if (order2 < 10 || order2 > 0) {
          ord2 = '0' + order2.toString();
        } else {
          ord2 = order1.toString();
        }
      }
      //});
    }
    if (order2 > 0) {
      //setState(() {
      btnaddcolor = true;
      //});
    } else {
      //setState(() {
      btnaddcolor = false;
      //});
    }
  }

  _resetorder() {
    myDrinks.clear();
    myTempCart = getDrinks();
    orderlenght = 0;
    myOrder.clear();
    temporder.clear();
    finaltot = 0;
    myCartFuture = getOrder();
    chrx = 0;
    newChsmx = [];
    newChsmxRemoved = [];
    userChecked = [];
  }

  getToke() {
    try {
      Prefs.load();
      token = Prefs.getString('token');
      uName = Prefs.getString('uname') ?? '';
    } catch (e) {
      token = '';
    }
  }

  savebill(
      String unamex,
      String fname,
      String lname,
      String address,
      String email,
      String idCardx,
      bool savebill,
      bool sdefaultSettings) async {
    Prefs.load();
    Prefs.setString('sfName' + unamex, fname.replaceAll(' ', ''));
    Prefs.setString('slMame' + unamex, lname.replaceAll(' ', ''));
    Prefs.setString('sillName' + unamex, fname + " " + lname);
    Prefs.setString('sillAdd' + unamex, address);
    Prefs.setString('sillEmail' + unamex, email.replaceAll(' ', ''));
    Prefs.setString('sidCard' + unamex + '', idCardx.replaceAll(' ', ''));
    Prefs.setBool('ssavebill' + unamex + '', savebill);
    Prefs.setBool('sdefaultSettings' + unamex + '', checkedValue_dsettings);
  }

  loadBill() async {
    Prefs.load();
    uName = Prefs.getString('uname') ?? '';
    String unamex = '';
    switch (uName) {
      case '':
        {
          unamex = 'Guest Mode';
        }
        break;
      case ' ':
        {
          unamex = '';
        }
        break;
      case 'Guest Mode':
        {
          unamex = 'Guest Mode';
        }
        break;
      case 'None':
        {
          unamex = 'None';
        }
        break;
      default:
        {
          unamex = uName;
        }
        break;
    }

    bool savebill = Prefs.getBool('ssavebill' + unamex + '') ?? false;
    if (savebill == true) {
      checkedValue = savebill;
      bool usename = Prefs.getBool('ssendBill' + unamex + '') ?? false;

      String fname = Prefs.getString('sfName' + unamex) ?? '';
      String lname = Prefs.getString('slMame' + unamex) ?? '';
      billname.text = fname + ' ' + lname;

      billadd.text = Prefs.getString('sillAdd' + unamex) ?? '';
      String email = Prefs.getString('sillEmail' + unamex) ?? '';
      billemail.text = email.trim().replaceAll(' ', '');

      idCard = Prefs.getString('sidCard' + unamex) ?? '';
      maskedPan = Prefs.getString('smaskedPan' + unamex) ?? '';
      expiry = Prefs.getString('sexpiry' + unamex) ?? '';
      cardholderName = Prefs.getString('scardholderName' + unamex) ?? '';
      scheme = Prefs.getString('sscheme' + unamex) ?? '';
      cardToken = Prefs.getString('scardToken' + unamex) ?? '';
      bool ds = Prefs.getBool('sdefaultSettings' + unamex + '') ?? false;
      checkedValue_dsettings = ds;
      if (ds == true) {
        isbname = false;
        isbaddress = false;
        isemail = false;
      } else {
        isbname = true;
        isbaddress = true;
        isemail = true;
      }
    }
  }

  saveTempopraryDetails() async {
    Prefs.load();
    uName = Prefs.getString('uname') ?? '';
    String unamex = '';
    switch (uName) {
      case '':
        {
          unamex = '';
        }
        break;
      case ' ':
        {
          unamex = '';
        }
        break;
      case 'guest':
        {
          unamex = 'guest';
        }
        break;
      case 'None':
        {
          unamex = 'None';
        }
        break;
      default:
        {
          unamex = uName;
        }
        break;
    }

    String billnamex = billname.text;
    String billaddx = billadd.text;
    String billemailx = billemail.text;

    Prefs.setString('temp_name' + unamex, billnamex);
    Prefs.setString('temp_address' + unamex, billaddx);
    Prefs.setString('temp_email' + unamex, billemailx);
    Prefs.setBool('temp_semail' + unamex, checkedValue);
  }

  getTempopraryDetails() async {
    Prefs.load();
    uName = Prefs.getString('uname') ?? '';
    String unamex = '';
    switch (uName) {
      case '':
        {
          unamex = '';
        }
        break;
      case ' ':
        {
          unamex = '';
        }
        break;
      case 'guest':
        {
          unamex = 'guest';
        }
        break;
      case 'None':
        {
          unamex = 'None';
        }
        break;
      default:
        {
          unamex = uName;
        }
        break;
    }
    String name = Prefs.getString('temp_name' + unamex) ?? '';
    String address = Prefs.getString('temp_address' + unamex) ?? '';
    String email = Prefs.getString('temp_email' + unamex) ?? '';
    bool semail = Prefs.getBool('temp_semail' + unamex) ?? false;

    billname.text = name;
    billadd.text = address;
    billemail.text = email;
    checkedValue = semail;
  }

  getDefaultSettings() async {
    Prefs.load();
    uName = Prefs.getString('uname') ?? '';
    String unamex = '';
    switch (uName) {
      case '':
        {
          unamex = '';
        }
        break;
      case ' ':
        {
          unamex = '';
        }
        break;
      case 'guest':
        {
          unamex = 'guest';
        }
        break;
      case 'None':
        {
          unamex = 'None';
        }
        break;
      default:
        {
          unamex = uName;
        }
        break;
    }

    bool isDefaultSettings = checkedValue_dsettings;
    if (isDefaultSettings == true) {
      checkedValue = false;
      isbname = true;
      isbaddress = true;
      isemail = true;
      // idCard = '';
      bool usename = Prefs.getBool('bsendBill' + unamex + '') ?? false;
      if (usename == true) {
        String cardname = Prefs.getString('bcardname' + unamex) ?? '';
        if (cardname.isNotEmpty) {
          isbname = true;
          billname.text = cardname;
        }
      } else {
        isbname = true;
        String fname = Prefs.getString('bfName' + unamex) ?? '';
        String lname = Prefs.getString('blMame' + unamex) ?? '';
        String name = fname + ' ' + lname;
        billname.text = name.trimLeft();
      }

      billadd.text = Prefs.getString('billAdd' + unamex) ?? '';
      String email = Prefs.getString('billEmail' + unamex) ?? '';
      billemail.text = email.trim().replaceAll(' ', '');
    } else {
      isbname = true;
      isbaddress = true;
      isemail = true;
    }
  }

  savebillcard(String unamex, String sidCard, String smaskedPan, String sexpiry,
      String scardholderName, String sscheme, String scardToken) async {
    Prefs.load();
    Prefs.setString('sidCard' + unamex + '', sidCard.replaceAll(' ', ''));
    Prefs.setString('smaskedPan' + unamex, smaskedPan);
    Prefs.setString('sexpiry' + unamex + '', sexpiry.replaceAll(' ', ''));
    Prefs.setString('scardholderName' + unamex, scardholderName);
    Prefs.setString('sscheme' + unamex + '', sscheme);
    Prefs.setString('scardToken' + unamex, scardToken.replaceAll(' ', ''));
  }

  @override
  void initState() {
    super.initState();
    loadBill();
    getToke();
    myList = [];
    myCartFuture = getOrder();
    callcompute();

    myStore = getStore();
    orderlenght = 0;
    //getStore();
    getDayofweek();
    getVipcharge();
    myCardList = [];
    myCardFuture = getCard();

    getTable();
    mytable = [];
    newChsmx = [];
    newChsmxRemoved = [];
    userChecked = [];
  }

  Future<List<CardDetails>> getCard() async {
    try {
      String mytoken = Prefs.getString('token');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + mytoken
      };
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

        myCardList.add(tmc);
      }
      return myCardList;
    } catch (e) {
      return null;
    }
  }

  getVipcharge() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);
    var jsondata = json.decode(response.body);

    vip = double.parse(jsondata['vipOrderCharge'].toString());
    timecol = double.parse(jsondata['timeToCollect'].toString());
    if (jsondata['isServiceChargeEnabled'].toString() == 'true') {
      charge = jsondata['serviceChargePercentage'];
    } else {
      charge = 0;
    }
  }

  getDayofweek() {
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    print(dateFormat);
    if (dateFormat == 'Monday') {
      dtofdy = 1;
    } else if (dateFormat == 'Tuesday') {
      dtofdy = 2;
    } else if (dateFormat == 'Wednesday') {
      dtofdy = 3;
    } else if (dateFormat == 'Thursday') {
      dtofdy = 4;
    } else if (dateFormat == 'Friday') {
      dtofdy = 5;
    } else if (dateFormat == 'Saturday') {
      dtofdy = 6;
    } else if (dateFormat == 'Sunday') {
      dtofdy = 0;
    } else {
      dtofdy = 0;
    }
    getSched();
  }

  getSched() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);
    var jsondata = json.decode(response.body)['workHours'];

    for (var u in jsondata) {
      if (u['dayOfWeek'] == dtofdy) {
        String st = '2020-07-20T' + u['startTime'];
        String et = '2020-07-20T' + u['endTime'];
        String nst = DateFormat.jm().format(DateTime.parse(st));
        String net = DateFormat.jm().format(DateTime.parse(et));
        setState(() {
          wk = "Working hours " + nst + " - " + net;
          isWorkingDay = u['isWorkingDay'];
        });
      }
    }
  }

  _rounddata(double num) {
    double temp = num;
    String spliter = temp.toString();

    var splitag = spliter.split(".");
    var splitag1 = splitag[0];
    var splitag2 = splitag[1];

    try {
      var secs1 = splitag2.substring(0, 1);
      var secs2 = splitag2.substring(1, 2);
      var secs3 = splitag2.substring(2, 3);
      print(secs3);

      if (double.parse(secs3) <= 5) {
        String compl = splitag1 + "." + secs1 + secs2;

        num = double.parse(compl);
        num = double.parse(num.toStringAsFixed(2));
      } else {
        num = double.parse((temp).toStringAsFixed(2));
      }
    } catch (e) {
      num = double.parse((temp).toStringAsFixed(2));
    }
    return num;
  }

  Future<List<Table>> getTable() async {
    mytable.clear();
    print(id.toString());
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);
    //print(response.body.toString());
    var jsondata = json.decode(response.body)['tables'];
    for (var u in jsondata) {
      String tableid, tablename;
      tableid = u['id'].toString();
      tablename = u['name'].toString();
      Table tb = Table(tableid, tablename);

      mytable.add(tb);
    }

    print('Table list: ' + mytable.length.toString());
    return mytable;
  }

  Future<List<Discount>> getDiscount() async {
    mydicount.clear();
    print(id.toString());
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);
    //print(response.body.toString());
    Discount tb = Discount("", "No Discount", 0);

    mydicount.add(tb);
    var jsondata = json.decode(response.body)['discounts'];
    for (var u in jsondata) {
      String id, name;
      double percentage = 0;
      id = u['id'].toString();
      name = u['name'].toString();
      percentage = u['percentage'];

      Discount tb = Discount(id, name, percentage);

      mydicount.add(tb);
    }

    print('Table list: ' + mydicount.length.toString());
    return mydicount;
  }

  Future<List<Store>> getStore() async {
    print(id.toString());
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);
    //print(response.body.toString());
    var jsondata = json.decode(response.body)['menu'];
    for (var u in jsondata) {
      String id, name, des, image, cat;

      print(u['subCategories'].toString());
      id = u['id'].toString();
      cat = u['facilityId'].toString();
      name = u['name'];
      if (u['subCategories'].toString() == '[]') {
        des = 'Menu';
      } else {
        des = 'Sub';
      }
      image = u['iconId'].toString();
      Store store = Store(id, name, des, image, u['facilityId'].toString());

      myList.add(store);
    }

    return myList;
  }

  Future<List<SubMenu>> getSub() async {
    myMenu = [];
    print('call');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);

    var jsondata = json.decode(response.body)['menu'];

    for (var i = 0; i < jsondata.length - 1; i++) {
      if (jsondata[i]['id'].toString() == sub) {
        print(jsondata[i]['name'].toString() + '|' + sub);
        var jsondata1 = json.decode(response.body)['menu'][i]['subCategories'];
        for (var u in jsondata1) {
          print(u['name']);
          SubMenu store = SubMenu(u['id'].toString(), u['name'].toString(),
              u['iconId'].toString(), u['facilityId'].toString());

          myMenu.add(store);
        }
      }
    }

    setState(() {
      lengtofsub = myMenu.length * 80;
    });
    return myMenu;
  }

  @override
  Widget build(BuildContext context) {
    String _token = context.read<AuthProvider>().token;
    String token = Prefs.getString('token');
    uName = Prefs.getString('uname') ?? '';
    if (_token.isNotEmpty) {
      stoken = _token;
    } else {
      stoken = token;
    }
    if (uName.isEmpty) {
      uName = 'Guest Mode';
    } else {
      uName = uName;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bkgdefault.png"),
                fit: BoxFit.cover)),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                if (subbodybool == 1) {
                  setState(() {
                    subbodybool = 0;
                  });
                } else if (subbodybool == 2) {
                  setState(() {
                    subbodybool = 1;
                  });
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
            // actions: [
            //   IconButton(
            //     icon: Icon(Icons.menu, size: 35, color: Colors.white,),
            //     onPressed: () {
            //       _scaffoldKey.currentState.openEndDrawer();
            //     },
            //   )
            // ],
          ),
          endDrawer: Drawer(
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
                color: Colors.black,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (_scaffoldKey.currentState.isEndDrawerOpen) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.home,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Home",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_scaffoldKey.currentState.isEndDrawerOpen) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => orderPage()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.wine_bar_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "My Orders",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_scaffoldKey.currentState.isEndDrawerOpen) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => setPage()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.settings,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Settings v1.0.122",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_scaffoldKey.currentState.isEndDrawerOpen) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => termPage()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesome.angle_double_up,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Terms of Service",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_scaffoldKey.currentState.isEndDrawerOpen) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                        //Navigator.of(context).popAndPushNamed('/home');
                        if (stoken == '' || stoken == null || stoken.isEmpty) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        } else {
                          _showDialogout(
                              "Drinklink", "Are you sure you want to log out?");
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              MaterialCommunityIcons.human,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              stoken == '' || stoken == null || stoken.isEmpty
                                  ? "Sign In / Register"
                                  : "Sign Out (" + uName + ")",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_scaffoldKey.currentState.isEndDrawerOpen) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          _scaffoldKey.currentState.openEndDrawer();
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => help()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              MaterialCommunityIcons.help_circle_outline,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            new Expanded(
                              flex: 1,
                              child: new SingleChildScrollView(
                                scrollDirection: Axis.horizontal, //.horizontal
                                child: new Text(
                                  'Help Centre',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(0, 0, 10, 50),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Visibility(
                    //           visible: orderList.length > 0 ? true:false,
                    //           child: Text('Most recent orders', style: TextStyle(color: Colors.white),)),
                    //       mybodyRec(),
                    //       SizedBox(height: 20,)
                    //     ],
                    //   ),
                    // )
                  ],
                )),
          ),
          backgroundColor: Colors.transparent,
          body: myorig(),
        ),
      ),
    );
  }

  myorig() {
    if (subbodybool == 2) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  desc != null ? desc : '',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 16,
                  ),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  title != null ? title : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: isWorkingDay,
                    child: Container(
                        child: Text(
                      wk != null ? wk : '',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                      color: isWorkingDay == true ? Colors.green : Colors.red,
                      child: Text(
                        isWorkingDay == true ? 'online' : 'offline',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.deepOrange,
              thickness: 2,
            ),
            Expanded(
              child: payment(),
            )
          ],
        ),
      );
    } else {
      return SlidingUpPanel(
        color: Colors.transparent,
        controller: _pc,
        maxHeight: MediaQuery.of(context).size.height - 200,
        body: Stack(
          children: [
            Container(
              height: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        desc != null ? desc : '',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        title != null ? title : '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: isWorkingDay,
                          child: Container(
                              child: Text(
                            wk != null ? wk : '',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        Spacer(),
                        Container(
                            padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                            color: isWorkingDay == true
                                ? Colors.green
                                : Colors.red,
                            child: Text(
                              isWorkingDay == true ? 'online' : 'offline',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.deepOrange,
                    thickness: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                        child: mybody(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        panel: Visibility(
          visible: subbodybool == 2 ? false : true,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  //Call change color
                  blickFunct();
                  if (_pc.isPanelOpen == false) {
                    _pc.open();
                    setState(() {
                      _pcb = true;
                    });
                  } else {
                    _pc.close();
                    setState(() {
                      _pcb = false;
                    });
                  }
                },
                child: Container(
                    height: 97,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0),
                      ),
                      gradient: new LinearGradient(
                          colors: [
                            const Color(0xFFeb5834),
                            const Color(0xFFf08b43),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                          if (_pc.isPanelOpen == false) {
                            _pc.open();
                            setState(() {
                              _pcb = true;
                            });
                          } else {
                            _pc.close();
                            setState(() {
                              _pcb = false;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (_pc.isPanelOpen == false) {
                                    _pc.open();
                                    setState(() {
                                      _pcb = true;
                                    });
                                  } else {
                                    _pc.close();
                                    setState(() {
                                      _pcb = false;
                                    });
                                  }
                                },
                                child: Icon(
                                  _pcb == false
                                      ? FontAwesome.angle_double_up
                                      : FontAwesome.angle_double_down,
                                  color: Colors.white,
                                  size: 45,
                                )),
                            Text(
                              'VIEW ORDER',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              finaltot.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' AED',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Container(
                color: Color(0xFF2b2b61).withOpacity(1),
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: myOrder.length > 0 ? false : true,
                          child: SizedBox(
                            height: 67,
                          ),
                        ),
                        Visibility(
                          visible: myOrder.length > 0 ? true : false,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  myDrinks.clear();
                                  myTempCart = getDrinks();
                                  orderlenght = 0;
                                  myOrder.clear();
                                  temporder.clear();
                                  finaltot = 0;
                                  myCartFuture = getOrder();
                                  chrx = 0;
                                  newChsmx = [];
                                  newChsmxRemoved = [];
                                  userChecked = [];
                                });
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white,
                                      //                   <--- border color
                                      width: 2.0,
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Center(
                                      child: Text(
                                    'RESET ORDER',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ))),
                            ),
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          height: MediaQuery.of(context).size.height - 470,
                          //color: Colors.white,

                          child: mycart(),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: GestureDetector(
                            onTap: () {
                              if (myOrder.length > 0) {
                                setState(() {
                                  Prefs.load();
                                  Prefs.setInt('Quant', myOrder.length);
                                  Prefs.setDouble('Price', finaltot);
                                  double percentagefee = 0;
                                  finaltotwithdiscount = 0;
                                  double sc = 0;
                                  double _tip = 0;

                                  if (mtip != 0) {
                                    // String a = mtip.replaceAll(' AED', '');

                                    _tip = mtip;
                                    // print(mtip + 'Tip here!');

                                    if (tipid == 1) {
                                      _tip = finaltot * 0.05;
                                    } else if (tipid == 2) {
                                      _tip = finaltot * 0.10;
                                    } else if (tipid == 3) {
                                      _tip = finaltot * 0.15;
                                    } else if (tipid == 4) {
                                      _tip = finaltot * 0.20;
                                    } else if (tipid == 5) {
                                      _tip = 5;
                                    } else if (tipid == 6) {
                                      _tip = 10;
                                    } else if (tipid == 7) {
                                      _tip = 15;
                                    } else if (tipid == 8) {
                                      _tip = 20;
                                    } else {
                                      _tip = _tip;
                                    }

                                    // _tip = parse mtip;
                                  } else {
                                    _tip = _tip;
                                  }
                                  mtip = _tip;
                                  // sc = (fee / 100) * finaltot;
                                  //  if (vipcharge == true) {
                                  //     chrx = chrx + vip;
                                  //   }
                                  // if (_tip == 0 || _tip == 0.0) {
                                  //   mtip = '';
                                  // } else {
                                  //   mtip = _tip.toStringAsFixed(3) + ' AED';
                                  // }
                                  // print(mtip);

                                  if (discountID.isEmpty) {
                                    // tip = _tip;
                                    // mtip = "";

                                    double ch = charge / 100;

                                    // double a = _tip + finaltot;
                                    double a, c;
                                    if (vipcharge == true) {
                                      a = finaltot + _tip + vip;
                                      c = vip;
                                    } else {
                                      a = finaltot + _tip;
                                      c = 0;
                                    }
                                    double b = a * ch;
                                    // percentagefee = (fee / 100) * finaltot;
                                    // double roundDouble(
                                    //     double value, int places) {
                                    //   double mod = pow(10.0, places);
                                    //   return ((value * mod).round().toDouble() /
                                    //       mod);
                                    // }

                                    // chrx = roundDouble(b, 2);
                                    chrx = b;

                                    print(b.round().toStringAsFixed(2));
                                    // print('Service Charge!');
                                    // print(chrx.toStringAsFixed(2) +
                                    //     'Service Charge!');

                                    // percentagefee = chrx;
                                    finaltotwithdiscount = a + chrx;
                                    // finaltotwithdiscount = double.parse(
                                    //     finaltotwithdiscount
                                    //         .toStringAsFixed(5));
                                  } else {
                                    // mtip = tip.toStringAsFixed(2) + ' AED';

                                    // mtip = "";
                                    percentagefee =
                                        (discountitempercentage / 100) *
                                            finaltot;

                                    double ch = charge / 100;

                                    double a, c;
                                    if (vipcharge == true) {
                                      a = _tip + finaltot + vip - percentagefee;
                                      c = vip;
                                    } else {
                                      a = _tip + finaltot - percentagefee;
                                      c = 0;
                                    }
                                    double b = a * ch;
                                    // double roundDouble(
                                    //     double value, int places) {
                                    //   double mod = pow(10.0, places);
                                    //   return ((value * mod).round().toDouble() /
                                    //       mod);
                                    // }

                                    // chrx = roundDouble(b, 2);
                                    chrx = b;

                                    mdicount = percentagefee;
                                    finaltotwithdiscount = finaltot +
                                        _tip +
                                        chrx +
                                        c -
                                        percentagefee;
                                    // finaltotwithdiscount = double.parse(
                                    //     finaltotwithdiscount
                                    //         .toStringAsFixed(3));
                                  }

                                  print('Percentage fee:' +
                                      fee.toString() +
                                      ' - ' +
                                      percentagefee.toString() +
                                      ' - ' +
                                      finaltot.toString());
                                  subbodybool = 2;
                                  _pcb = false;
                                  _pc.close();
                                });
                              }
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: myOrder.length > 0
                                      ? contColor
                                      : Colors.grey,
                                  border: Border.all(
                                    color: Colors.white,
                                    //                   <--- border color
                                    width: 2.0,
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  children: [
                                    Text(
                                      'PROCEED TO PAYMENT',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      '(Time to collect order: ' +
                                          timecol.toStringAsFixed(0) +
                                          ' mins)',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  blickFunct() async {
    for (var i = 0; i < 50; i++) {
      await Future.delayed(Duration(milliseconds: 400));
      setState(() {
        if (i.isEven) {
          contColor = Colors.greenAccent;
        } else {
          contColor = Colors.green;
        }
      });
    }
  }

  Widget getCartMixWidgets(List<MixerOrd> strings, int ind) {
    int select;
    List<Widget> list = new List<Widget>();

    for (var i = 0; i < strings.length; i++) {
      list.add(Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: GestureDetector(
          onTap: () {},
          child: strings[i].name.toString() != ''
              ? new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white54.withOpacity(.5)),
                  ), //
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Row(
                    children: [
                      Text(
                        strings[i].name.toString() != null
                            ? strings[i].name.toString()
                            : '',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ));
    }
    return new Row(children: list);
  }

  //cart
  mycart() {
    return Container(
      color: Color(0xFF2b2b61).withOpacity(.5),
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
          future: myCartFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              color: Colors.transparent,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          snapshot.data[index].Name != null
                                              ? snapshot.data[index].Name
                                              : '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                color: Colors.deepOrange,
                                                letterSpacing: .5,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index].aIce != false
                                                ? 'With Ice /'
                                                : '',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: .5,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].Price != null
                                                ? snapshot.data[index].Price
                                                : '',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: .5,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                            ' AED',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: .5,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          int drinkId = Prefs.getInt('drinkId');
                                          if (myOrder[index].Quant > 1) {
                                            setState(() {
                                              myOrder[index].Quant =
                                                  myOrder[index].Quant - 1;
                                            });
                                          } else {
                                            setState(() {
                                              myOrder.removeAt(index);
                                            });
                                          }

                                          callcompute();
                                        },
                                        child: Container(
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              '-',
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.deepOrange),
                                            ))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 60,
                                          child: Center(
                                              //snapshot.data[index].Quant.toString()
                                              child: Text(
                                            myOrder[index].Quant.toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          int drinkId = Prefs.getInt('drinkId');
                                          setState(() {
                                            myOrder[index].Quant =
                                                myOrder[index].Quant + 1;
                                          });
                                          // counteraddord2('add');
                                          // bool exists = myOrder.any((myOrder) => myOrder.CatId == snapshot.data[index].CatId);
                                          // if(exists == false){
                                          //   Order tmp = Order(snapshot.data[index].drinkId,snapshot.data[index].CatId, snapshot.data[index].Name, myOrder[index].Quant,snapshot.data[index].Price);
                                          //   myOrder.add(tmp);
                                          // }else{
                                          //
                                          //   for(var i = 0; i < myOrder.length; i++){
                                          //     if(myOrder[i].CatId == snapshot.data[index].CatId){
                                          //       print(myOrder[i].Name);
                                          //       int tq = myOrder[i].Quant;
                                          //       print(tq);
                                          //       int newtq = tq + 1;
                                          //       myOrder.removeAt(i);
                                          //       Order tmp = Order(snapshot.data[index].drinkId,snapshot.data[index].CatId, snapshot.data[index].Name, newtq,snapshot.data[index].Price);
                                          //       myOrder.add(tmp);
                                          //     }
                                          //   }
                                          // }
                                          //
                                          // for(var i = 0; i < temporder.length; i++){
                                          //   print(myOrder[i].CatId);
                                          //   print(myOrder[i].Name);
                                          //   print(myOrder[i].Quant);
                                          // }
                                          callcompute();
                                        },
                                        child: Container(
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              '+',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.deepOrange),
                                            ))),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                            //visible: snapshot.data[index].mixer == null ? false:true,
                            child: snapshot.data[index].mxir != null
                                ? Container(
                                    // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          getCartMixWidgets(
                                              snapshot.data[index].mxir, index),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ]))
                                : null,
                          ),
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }

  mybody() {
    if (subbodybool == 1) {
      return Container(
        color: Color(0xFF2b2b61).withOpacity(.5),
        //height: MediaQuery.of(context).size.height - 200,
        //child: mylistt(),
        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedmenu = '';
                  subbodybool = 0;
                });
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white10,
                            ),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              'Menu',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Text(
                              '> ' + selectedmenu,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.white,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                        color: Colors.transparent,
                        width: 50,
                        height: 50,
                        //'assets/images/menu' + image.toString() + '.png'
                        child: Image.asset(
                            'assets/images/menu' + iconid + '.png')),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        selectedmenu1,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (orderlenght > 0) {
                        setState(() {
                          ord3 = ord1;
                          order1 = 0;
                          order2 = 0;
                          ord1 = '00';
                          ord2 = '00';
                          btnaddcolor = false;

                          myCartFuture = getOrder();
                          callcompute();

                          newChsmx = [];
                          newChsmxRemoved = [];
                          userChecked = [];
                        });
                      }
                    },
                    child: Container(
                        //width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              orderlenght > 0 ? Colors.green : Colors.white10,
                          border: Border.all(
                            color: Colors
                                .white, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Center(
                            child: Text(
                          'ADD',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Container(
              // padding: EdgeInsets.fromLTRB(0,0,0,150),
              child: mylistt(),
            )
          ],
        ),
      );
    } else if (subbodybool == 2) {
      return Container(
        child: payment(),
      );
    } else {
      return Container(
        color: Color(0xFF2b2b61).withOpacity(.5),
        height: MediaQuery.of(context).size.height - 250,
        child: FutureBuilder(
            future: myStore,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return subbody(
                          snapshot.data[index].id,
                          snapshot.data[index].ImageUrl,
                          snapshot.data[index].Name,
                          snapshot.data[index].Description,
                          snapshot.data[index].cat);
                    });
              }
            }),
      );
    }
  }

  String selectedindex = '';

  subbody(String id, image, name, cat, fac) {
    if (cat == 'Sub') {
      return GestureDetector(
          onTap: () {
            setState(() {
              selectedindex = id;
            });
          },
          child: ExpansionTile(
            key: Key(id.toString()),
            initiallyExpanded: selectedindex == id ? true : false,
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onExpansionChanged: (value) {
              print("Expand: " + id.toString());
              setState(() {
                iconid = image.toString();

                print(id);
                sub = id;
                myMenu = [];
                subMenu = getSub();
                dri = id;
                myDrinks = [];
                newChsmx = [];
                myTempCart = getDrinks();
              });
            },
            title: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        color: Colors.transparent,
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          'assets/images/menu' + image.toString() + '.png',
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            //height: 60,
                            width: MediaQuery.of(context).size.width / 1.8,
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              name != null ? name : '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.left,
                            )),
                      ],
                    )
                  ],
                )),
            children: [
              Container(
                color: Color(0xFF2b2b61).withOpacity(.5),
                height: double.parse(lengtofsub.toString()),
                child: FutureBuilder(
                    future: subMenu,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    iconid =
                                        snapshot.data[index].image.toString();
                                    Prefs.load();
                                    Prefs.setInt(
                                        'Facility',
                                        int.parse(
                                            snapshot.data[index].facility));
                                    int fac = Prefs.getInt('Facility');
                                    print('MyFac ' +
                                        snapshot.data[index].facility
                                            .toString());
                                    selectedmenu = name;
                                    selectedmenu1 = snapshot.data[index].name;
                                    subbodybool = 1;
                                    dri = id;
                                    drisub = snapshot.data[index].id;
                                    myDrinks = [];
                                    newChsmx = [];
                                    myTempCart = getDrinks();
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(55, 0, 22, 10),
                                    color: Colors.transparent,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            color: Colors.transparent,
                                            width: 50,
                                            height: 50,
                                            child: Image.asset(
                                              'assets/images/menu' +
                                                  snapshot.data[index].image
                                                      .toString() +
                                                  '.png',
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                //height: 60,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.8,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 5),
                                                child: Text(
                                                  snapshot.data[index].name !=
                                                          null
                                                      ? snapshot
                                                          .data[index].name
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                )),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 60,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.white,
                                                ))),
                                          ],
                                        ),
                                      ],
                                    )),
                              );
                            });
                      }
                    }),
              )
            ],
          ));
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            iconid = image.toString();
            print('MyFac ' + fac.toString());
            Prefs.load();
            Prefs.setInt('Facility', int.parse(fac));
            int faci = Prefs.getInt('Facility');
            print('MyFac ' + faci.toString());
            selectedmenu = name;
            selectedmenu1 = name;
            subbodybool = 1;
            dri = id;
            myDrinks = [];
            newChsmx = [];
            myTempCart = getDrinks();
          });
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(25, 0, 22, 10),
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: Colors.transparent,
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/images/menu' + image.toString() + '.png',
                    )),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.8,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          name != null ? name : '',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 60,
                        child: Center(
                            child: Icon(Icons.arrow_forward_ios,
                                size: 15, color: Colors.white))),
                  ],
                ),
              ],
            )),
      );
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white54.withOpacity(.5)),
    );
  }

  Widget getTextWidgets(List<Mixer> strings, int ind) {
    int select;
    List<Widget> list = new List<Widget>();
    String indId = '';
    String chid = '';
    String chname = '';
    String chprice = '';
    int myindex = 0;
    int chmid;
    String mname;
    String mj;
    bool _isnone = false;
    String none = '';
    bool iCancel = false;
    double qty = 0;
    String Ids = '';
    userChecked = [];
    if (newChsmx == null) {
      newChsmx = [];
    }

    if (newChsmxRemoved == null) {
      newChsmxRemoved = [];
    }
    print(newChsmx);
    for (var jom = 0; jom < newChsmx.length; jom++) {
      userChecked.add(newChsmx[jom].cname);
    }

    iCancel = true;

    print(userChecked);
    if (strings.length <= 0) {
      list.add(Container());
    } else {
      for (var i = 0; i < strings.length; i++) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: GestureDetector(
            onTap: () {
              print('ajkshdkajhsdkj');
              if (myMenu != null || myMenu != [])
                //print(strings[i].id.toString());
                // for (var x = 0; x < strings[i].mx.length; x++) {
                //   // print(strings[i].mx[x].name.toString());
                //   // print(strings[i].mx[x].price.toString());

                // }
                myDrinks[ind].mid = strings[i].name;
              if (strings[i].name == 'None') {
                none = 'None';
              }
              // var res = userChecked.sublist(userChecked.indexOf(''));
              // print(res);
              showModalBottomSheet<void>(
                isDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context,
                      StateSetter modsetState /*You can rename this!*/) {
                    return SingleChildScrollView(
                      child: Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(32, 20, 32, 0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (strings[i].ismSelect != 'true') {
                                          if (myDrinks[ind]
                                              .ChMixer
                                              .isNotEmpty) {
                                            myDrinks[ind].mid = '';
                                            setState(() {
                                              myDrinks[ind].mid = myDrinks[ind]
                                                  .ChMixer[ind]
                                                  .cname;
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            myDrinks[ind].mid = '';
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          if (iCancel == false) {
                                            print(chmqty);
                                            newChsmx.clear();
                                            userChecked.clear();
                                            newChsmx.clear();
                                            List<chossenMixer> newChs =
                                                myDrinks[ind].ChMixer;
                                            print(newChs);
                                            // newChs.clear();

                                            for (var i = 0;
                                                i < newChsmx.length;
                                                i++) {
                                              newChs.removeWhere((element) =>
                                                  element.cname ==
                                                  newChsmx[i].cname);
                                              chossenMixer chs = chossenMixer(
                                                  Ids,
                                                  newChsmx[i].cmid,
                                                  newChsmx[i].cname,
                                                  newChsmx[i].cprice);
                                              if (chs.cmid.isNotEmpty) {
                                                newChs.add(chs);
                                              }
                                            }
                                            if (chmqty == null) {
                                              chmqty = [];
                                            }

                                            for (var a = 0;
                                                a < chmqty.length;
                                                a++) {
                                              chossenMixerMultiple chsa =
                                                  chossenMixerMultiple(
                                                      chmqty[a].indId,
                                                      chmqty[a].cmid,
                                                      chmqty[a].cname,
                                                      chmqty[a].cprice);
                                              // chossenMixer chs = chossenMixer(
                                              //     indId, chid, chname, chprice);
                                              if (chsa.cmid.isNotEmpty) {
                                                newChsmx.add(chsa);
                                              }
                                            }
                                            print(newChsmx);

                                            for (var b = 0;
                                                b < newChsmx.length;
                                                b++) {
                                              chossenMixer cm = chossenMixer(
                                                  newChsmx[b].indId,
                                                  newChsmx[b].cmid,
                                                  newChsmx[b].cname,
                                                  newChsmx[b].cprice);
                                              if (cm.cmid.isNotEmpty) {
                                                setState(() {
                                                  newChs.add(cm);
                                                });
                                              }
                                            }
                                            print(newChs);
                                            for (var bx = 0;
                                                bx < newChs.length;
                                                bx++) {
                                              if (newChs[bx].cname.isNotEmpty) {
                                                setState(() {
                                                  chossenMixerMultiple chsa =
                                                      chossenMixerMultiple(
                                                          newChs[bx].indId,
                                                          newChs[bx].cmid,
                                                          newChs[bx].cname,
                                                          newChs[bx].cprice);
                                                  userChecked
                                                      .add(newChs[bx].cname);
                                                  newChsmx.add(chsa);
                                                });
                                              }
                                            }
                                            print(userChecked);
                                            // chossenMixer chs = chossenMixer(
                                            //     Ids,
                                            //     newChsmx[i].cmid,
                                            //     newChsmx[i].cname,
                                            //     newChsmx[i].cprice);
                                            // if (chs.cmid.isNotEmpty) {
                                            //   chs.add(chs);
                                            // }
                                            iCancel = true;
                                          }

                                          // indId = '';
                                          // chid = '';
                                          // chname = 'None';
                                          // chprice = '0';
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Visibility(
                                    //   visible: strings[i].ismSelect == 'true',
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       setState(() {
                                    //         modsetState(() {
                                    //           close = false;
                                    //           isedit = true;
                                    //           userChecked = [];
                                    //           newChsmx = [];
                                    //         });
                                    //       });
                                    //     },
                                    //     child: SizedBox(
                                    //       width: 100,
                                    //       child: Row(
                                    //         children: [
                                    //           Text(
                                    //             "Edit",
                                    //             style: TextStyle(
                                    //                 color: Colors.deepOrange,
                                    //                 fontSize: 16),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (mname != null) {
                                            if (myDrinks[ind]
                                                .ChMixer
                                                .isNotEmpty) {
                                              myDrinks[ind].ChMixer.removeWhere(
                                                  (element) =>
                                                      element.cname == mname);
                                            }

                                            Navigator.pop(context);

                                            if (_isnone == true) {
                                              List<chossenMixer> newChs =
                                                  myDrinks[ind].ChMixer;
                                              print(newChs);
                                              chossenMixer chs = chossenMixer(
                                                  indId, chid, chname, chprice);
                                              if (chs.cmid.isNotEmpty) {
                                                newChs.add(chs);
                                              }
                                              // print(chs.cmid.toString());
                                              // mj = chs.cmid.toString();
                                              // print(mj + "mjjjj");
                                              // print(chs.cname.toString());
                                              // print(chs.cprice.toString());
                                              myDrinks[ind].ChMixer = newChs;

                                              print(strings[i].mx.length);

                                              // print(
                                              //     chs.cname + 'Drinks Here!!');
                                              double mixertotal = 0;
                                              for (var i = 0;
                                                  i < newChs.length;
                                                  i++) {
                                                double cprice = double.parse(
                                                    newChs[i].cprice);
                                                setState(() {
                                                  mixertotal += cprice;
                                                });
                                              }

                                              double tot = double.parse(
                                                      myDrinks[ind].origPrice) +
                                                  mixertotal;
                                              myDrinks[ind].price =
                                                  tot.toStringAsFixed(2);
                                              strings[i].name = chname;
                                            } else {
                                              List<chossenMixer> newChs =
                                                  myDrinks[ind].ChMixer;
                                              print(newChs);
                                              chossenMixer chs = chossenMixer(
                                                  indId, chid, chname, chprice);
                                              if (chs.cmid.isNotEmpty) {
                                                newChs.add(chs);
                                              }
                                              // print(chs.cmid.toString());
                                              // mj = chs.cmid.toString();
                                              // print(mj + "mjjjj");
                                              // print(chs.cname.toString());
                                              // print(chs.cprice.toString());
                                              myDrinks[ind].ChMixer = newChs;

                                              print(strings[i].mx.length);

                                              // print(
                                              //     chs.cname + 'Drinks Here!!');
                                              double mixertotal = 0;
                                              for (var i = 0;
                                                  i < newChs.length;
                                                  i++) {
                                                double cprice = double.parse(
                                                    newChs[i].cprice);
                                                setState(() {
                                                  mixertotal += cprice;
                                                });
                                              }

                                              double tot = double.parse(
                                                      myDrinks[ind].origPrice) +
                                                  mixertotal;
                                              myDrinks[ind].price =
                                                  tot.toStringAsFixed(2);
                                              strings[i].name = chname;
                                            }
                                          } else {
                                            if (strings[i].ismSelect ==
                                                'true') {
                                              print(newChsmx);
                                              if (iCancel == false) {
                                                List<chossenMixer> newChs =
                                                    myDrinks[ind].ChMixer;
                                                // newChs = [];
                                                print(newChs);
                                                if (newChsmxRemoved.length >
                                                    0) {
                                                  for (var ia = 0;
                                                      ia <
                                                          newChsmxRemoved
                                                              .length;
                                                      ia++) {
                                                    newChsmx.removeWhere(
                                                        (element) =>
                                                            element.cname ==
                                                            newChsmxRemoved[ia]
                                                                .cname);
                                                    newChs.removeWhere(
                                                        (element) =>
                                                            element.cname ==
                                                            newChsmxRemoved[ia]
                                                                .cname);
                                                  }
                                                }
                                                // bool isContain = false;
                                                // for (var ib = 0;
                                                //     ib < newChsmx.length;
                                                //     ib++) {
                                                //   for (var ic = 0;
                                                //       ic < newChs.length;
                                                //       ic++) {
                                                //     if (newChsmx[ib].cname ==
                                                //         newChs[ic].cname) {
                                                //       isContain = true;
                                                //       break;
                                                //     }
                                                //   }
                                                // }

                                                // if (isContain == false) {
                                                // newChsmx.remove(newChsmxRemoved);
                                                print(newChsmx);
                                                // newChsmx.removeWhere(
                                                //     (element) =>
                                                //         element.indId ==
                                                //         strings[i]
                                                //             .id
                                                //             .toString());

                                                for (var i = 0;
                                                    i < newChsmx.length;
                                                    i++) {
                                                  newChs.removeWhere(
                                                      (element) =>
                                                          element.cname ==
                                                          newChsmx[i].cname);
                                                  chossenMixer chs =
                                                      chossenMixer(
                                                          Ids,
                                                          newChsmx[i].cmid,
                                                          newChsmx[i].cname,
                                                          newChsmx[i].cprice);
                                                  if (chs.cmid.isNotEmpty) {
                                                    newChs.add(chs);
                                                  }
                                                }
                                                // }

                                                myDrinks[ind].ChMixer = newChs;

                                                print(strings[i].mx.length);

                                                double mixertotal = 0;
                                                for (var i = 0;
                                                    i < newChs.length;
                                                    i++) {
                                                  double cprice = double.parse(
                                                      newChs[i].cprice);
                                                  setState(() {
                                                    mixertotal += cprice;
                                                  });
                                                }

                                                double tot = double.parse(
                                                        myDrinks[ind]
                                                            .origPrice) +
                                                    mixertotal;
                                                myDrinks[ind].price =
                                                    tot.toStringAsFixed(2);
                                                // qty = double.parse(
                                                //     newChs.length.toString());
                                                var indx =
                                                    strings[i].id.toString();
                                                chmqty = [];

                                                for (var i = 0;
                                                    i < newChsmx.length;
                                                    i++) {
                                                  if (indx ==
                                                      newChsmx[i].indId) {
                                                    chossenMixerMultipleQty
                                                        chqty =
                                                        chossenMixerMultipleQty(
                                                            newChsmx[i].indId,
                                                            newChsmx[i].cmid,
                                                            newChsmx[i].cname,
                                                            newChsmx[i].cprice);
                                                    chmqty.add(chqty);
                                                  }
                                                }

                                                qty = double.parse(
                                                    chmqty.length.toString());

                                                if (qty <= 0) {
                                                  strings[i].name = 'None';
                                                } else {
                                                  strings[i].name =
                                                      qty.toStringAsFixed(0) +
                                                          'x Add Ons';
                                                }
                                              }

                                              print(userChecked);
                                              newChsmxRemoved = [];
                                              iCancel = false;
                                              // chmqty = [];

                                              // if (qty != 0) {
                                              //   qty = 0;
                                              // }
                                            }

                                            Navigator.pop(context);
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              // Container(
                              //   padding: EdgeInsets.fromLTRB(
                              //       20, 20, 20, 5),
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       print('none');
                              //       modsetState(() {
                              //         strings[i].name = '';
                              //         select = null;
                              //       });
                              //
                              //       myDrinks[ind].mid = '';
                              //       myDrinks[ind].mprice = '';
                              //       setState(() {
                              //         myDrinks[ind].price = myDrinks[ind].origPrice;
                              //         myDrinks = [];
                              //         myTempCart = getDrinks();
                              //       });
                              //     },
                              //     child: Container(
                              //         padding: EdgeInsets.fromLTRB(
                              //             10, 0, 10, 0),
                              //         child: Row(
                              //           children: [
                              //             Icon(Icons.circle,
                              //               color: select == null
                              //                   ? Colors.deepOrange
                              //                   : Colors.black
                              //                   .withOpacity(.5),),
                              //             SizedBox(width: 10,),
                              //             Text("Cancel",
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 12),),
                              //             Spacer(),
                              //             Text("0 AED",
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 16),),
                              //           ],
                              //         )
                              //     ),
                              //   ),
                              // ),
                              //body
                              if (strings[i].ismSelect != 'true')
                                (Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  height: 35,
                                  child: ListView.builder(
                                      padding: EdgeInsets.all(10.0),
                                      shrinkWrap: false,
                                      itemCount: 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 20),
                                            child: Row(children: [
                                              Icon(
                                                Icons.circle,
                                                color: myDrinks[ind].mid == none
                                                    ? Colors.deepOrange[700]
                                                    : Colors.black
                                                        .withOpacity(.5),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    'None',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              modsetState(() {
                                                _isnone = true;
                                                none = 'None';
                                                myDrinks[ind].mid = 'None';

                                                chid = '';
                                                chname = 'None';
                                                chprice = '0';

                                                myindex = index;
                                                print(myindex);
                                                print(index);
                                                print(chid);

                                                myDrinks[ind].mid = 'None';
                                                myDrinks[ind].mprice = '0';
                                                mname = strings[i].name;
                                              });
                                            });
                                          },
                                        );
                                      }),
                                )),
                              if (strings[i].mx.length <= 0)
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Center(
                                      child: Text('No mixers available')),
                                )
                              else
                                (Container(
                                  color: Colors.white,
                                  height: 400,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(10.0),
                                    shrinkWrap: false,
                                    itemCount: strings[i].mx.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // if (userChecked.contains(
                                      //         strings[i].mx[index].name) ==
                                      //     true) {
                                      //   qty += 1;
                                      // }

                                      if (strings[i].ismSelect == 'true') {
                                        return Theme(
                                          data: ThemeData(
                                            checkboxTheme: CheckboxThemeData(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            unselectedWidgetColor:
                                                Colors.black54,
                                            backgroundColor: Colors.black54,
                                          ),
                                          child: CheckboxListTile(
                                            shape: CircleBorder(),
                                            tileColor: Colors.black54,
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      strings[i].mx[index].name,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  strings[i]
                                                          .mx[index]
                                                          .price
                                                          .toString() +
                                                      " AED",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: userChecked.contains(
                                                strings[i].mx[index].name),
                                            onChanged: (val) {
                                              modsetState(() {
                                                // if (isedit == true) {
                                                iCancel = false;
                                                if (val == true) {
                                                  setState(() {
                                                    // if (newChsmx.length > 0) {
                                                    //   newChsmx = [];
                                                    // }
                                                    userChecked.add(strings[i]
                                                        .mx[index]
                                                        .name);

                                                    indId = strings[i]
                                                        .id
                                                        .toString();
                                                    chid =
                                                        strings[i].mx[index].id;
                                                    chname = strings[i]
                                                        .mx[index]
                                                        .name;
                                                    chprice = strings[i]
                                                        .mx[index]
                                                        .price;
                                                    qty += 1;
                                                    chossenMixerMultiple chs =
                                                        chossenMixerMultiple(
                                                            indId,
                                                            chid,
                                                            chname,
                                                            chprice);
                                                    if (chs.cmid.isNotEmpty) {
                                                      var isContain = newChsmx
                                                          .contains(chs);
                                                      if (isContain == false) {
                                                        newChsmx.add(chs);
                                                      }
                                                    }
                                                    print(newChsmx);
                                                  });
                                                } else {
                                                  setState(() {
                                                    userChecked.remove(
                                                        strings[i]
                                                            .mx[index]
                                                            .name);
                                                    indId = strings[i]
                                                        .id
                                                        .toString();
                                                    chid =
                                                        strings[i].mx[index].id;
                                                    chname = strings[i]
                                                        .mx[index]
                                                        .name;
                                                    chprice = strings[i]
                                                        .mx[index]
                                                        .price;
                                                    if (qty > 0) {
                                                      qty = qty - 1;
                                                    }

                                                    chossenMixerMultipleRemoved
                                                        chs =
                                                        chossenMixerMultipleRemoved(
                                                            indId,
                                                            chid,
                                                            chname,
                                                            chprice);
                                                    if (chs.cmid.isNotEmpty) {
                                                      var isContain =
                                                          newChsmxRemoved
                                                              .contains(chs);
                                                      if (isContain == false) {
                                                        newChsmxRemoved
                                                            .add(chs);
                                                      }
                                                    }
                                                    List<chossenMixer> newChs =
                                                        myDrinks[ind].ChMixer;
                                                    if (newChsmxRemoved.length >
                                                        0) {
                                                      for (var ia = 0;
                                                          ia <
                                                              newChsmxRemoved
                                                                  .length;
                                                          ia++) {
                                                        newChsmx.removeWhere(
                                                            (element) =>
                                                                element.cname ==
                                                                newChsmxRemoved[
                                                                        ia]
                                                                    .cname);
                                                        newChs.removeWhere(
                                                            (element) =>
                                                                element.cname ==
                                                                newChsmxRemoved[
                                                                        ia]
                                                                    .cname);
                                                      }
                                                    }
                                                    print(newChsmx);
                                                  });
                                                }
                                                // }
                                              });
                                            },
                                            activeColor: Colors.deepOrange,
                                            checkColor: Colors.deepOrange,
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            var a = myDrinks[ind].mid;
                                            var b = strings[i].mx[index].name;
                                            setState(() {
                                              if (a != b) {
                                                print(a + '' + b);
                                                indId =
                                                    strings[i].id.toString();
                                                chid = strings[i].mx[index].id;
                                                chname =
                                                    strings[i].mx[index].name;
                                                chprice =
                                                    strings[i].mx[index].price;

                                                myindex = index;
                                                print(myindex);
                                                print(index);
                                                print(chid);

                                                myDrinks[ind].mid =
                                                    strings[i].mx[index].name;
                                                myDrinks[ind].mprice =
                                                    strings[i].mx[index].price;
                                                mname = strings[i].name;
                                              }
                                            });

                                            modsetState(() {
                                              if (a != b) {
                                                if (strings[i].name ==
                                                    strings[i].mx[index].name) {
                                                  strings[i].name =
                                                      strings[i].mx[index].name;
                                                } else {
                                                  strings[i].name =
                                                      strings[i].name;
                                                }

                                                myDrinks[ind].mid =
                                                    strings[i].mx[index].name;
                                                myDrinks[ind].mprice =
                                                    strings[i].mx[index].price;
                                                select = myindex;
                                                int Row = index;
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 0, 20, 20),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: myDrinks[ind].mid ==
                                                            strings[i]
                                                                .mx[index]
                                                                .name
                                                        ? Colors.deepOrange[700]
                                                        : Colors.black
                                                            .withOpacity(.5),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        strings[i]
                                                                    .mx[index]
                                                                    .name
                                                                    .toString() !=
                                                                null
                                                            ? strings[i]
                                                                .mx[index]
                                                                .name
                                                                .toString()
                                                            : '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    strings[i]
                                                            .mx[index]
                                                            .price
                                                            .toString() +
                                                        " AED",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              )),
                                        );
                                      }
                                    },
                                  ),
                                ))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              );
            },
            child: new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white54.withOpacity(.5)),
              ), //
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.white54,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    strings[i].name.toString() != null
                        ? strings[i].name.toString()
                        : '',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }
    return new Row(children: list);
  }

  //my list
  mylistt() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Color(0xFF2b2b61).withOpacity(.5),
      height: MediaQuery.of(context).size.height - 450,
      child: FutureBuilder(
          future: myTempCart,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 150),
                  //physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              color: Colors.transparent,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          snapshot.data[index].name != null
                                              ? snapshot.data[index].name
                                              : '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                color: Colors.deepOrange,
                                                letterSpacing: .5,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text(
                                            snapshot.data[index].desciption !=
                                                    'null'
                                                ? snapshot
                                                    .data[index].desciption
                                                : '',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: .5,
                                                  fontSize: 12),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              snapshot.data[index].price !=
                                                      'null'
                                                  ? snapshot.data[index].price
                                                  : '',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: .5,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Text(
                                              ' AED',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: .5,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 2, 0, 2),
                                          child: snapshot.data[index].allowIce
                                              ? Row(
                                                  children: [
                                                    Visibility(
                                                        visible: snapshot
                                                            .data[index]
                                                            .allowIce,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (snapshot
                                                                        .data[
                                                                            index]
                                                                        .addIce ==
                                                                    false) {
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .addIce = true;
                                                                  addICe = true;
                                                                } else {
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .addIce = false;
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          2,
                                                                          0,
                                                                          5,
                                                                          0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: snapshot
                                                                              .data[
                                                                                  index]
                                                                              .addIce ==
                                                                          false
                                                                      ? Colors
                                                                          .transparent
                                                                      : Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              .2)),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/images/ic_ice_cubes.png')),
                                                                  Text(
                                                                    snapshot.data[index].addIce ==
                                                                            false
                                                                        ? "Add ice"
                                                                        : "ice",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                ],
                                                              ),
                                                            ))),
                                                  ],
                                                )
                                              : null),
                                      SizedBox(
                                        height: snapshot.data[index].imagePath
                                                    .toString()
                                                    .isNotEmpty ==
                                                true
                                            ? 10
                                            : 0,
                                      ),
                                      Container(
                                        child: snapshot.data[index].imagePath
                                                    .toString()
                                                    .isNotEmpty ==
                                                true
                                            ? GestureDetector(
                                                onTap: () {
                                                  Alert(
                                                    context: context,
                                                    title: "Image",
                                                    content: Container(
                                                      child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: 200,
                                                          height: 200,
                                                          child: Image.network(
                                                              ApiCon.baseurl() +
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .imagePath)),
                                                    ),
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop(),
                                                        color:
                                                            Colors.deepOrange,
                                                      )
                                                    ],
                                                  ).show();
                                                },
                                                child: Icon(
                                                  Icons.photo,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (myDrinks[index].Quant > 0) {
                                              myDrinks[index].Quant =
                                                  myDrinks[index].Quant - 1;
                                            }
                                            if (orderlenght > 0) {
                                              orderlenght = orderlenght - 1;
                                            }
                                          });
                                          if (orderlenght > 0) {
                                            setState(() {
                                              btnaddcolor = true;
                                            });
                                          } else {
                                            setState(() {
                                              btnaddcolor = false;
                                            });
                                          }
                                          // counteraddord2('minus');
                                          // bool exists = temporder.any((temporder) => temporder.CatId == snapshot.data[index].id);
                                          // if(exists == false){
                                          //   TempOrder tmp = TempOrder(snapshot.data[index].drinkid,snapshot.data[index].id, snapshot.data[index].name, int.parse(ord2),snapshot.data[index].price);
                                          //   temporder.add(tmp);
                                          // }else{
                                          //   for(var i = 0; i < temporder.length; i++){
                                          //     if(temporder[i].CatId == snapshot.data[index].id){
                                          //       print(temporder[i].Name);
                                          //       int tq = temporder[i].Quant;
                                          //       print(tq);
                                          //       int newtq = tq - 1;
                                          //       temporder.removeAt(i);
                                          //       TempOrder tmp = TempOrder(snapshot.data[index].drinkid,snapshot.data[index].id, snapshot.data[index].name, newtq,snapshot.data[index].price);
                                          //       temporder.add(tmp);
                                          //     }
                                          //   }
                                          // }
                                          //
                                          // for(var i = 0; i < temporder.length; i++){
                                          //   print(temporder[i].CatId);
                                          //   print(temporder[i].Name);
                                          //   print(temporder[i].Quant);
                                          // }
                                        },
                                        child: Container(
                                            child: Center(
                                                child: Text('−',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .deepOrange)))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: Center(
                                              child: Text(
                                        snapshot.data[index].Quant.toString(),
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ))),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            Prefs.setInt(
                                                'drinkCatId',
                                                int.parse(snapshot
                                                    .data[index].drinkCategoryId
                                                    .toString()));
                                            Prefs.setInt(
                                                'drinkId',
                                                int.parse(snapshot
                                                    .data[index].id
                                                    .toString()));
                                            myDrinks[index].Quant =
                                                myDrinks[index].Quant + 1;
                                            orderlenght = orderlenght + 1;
                                          });
                                          for (var i = 0;
                                              i < myDrinks.length;
                                              i++) {
                                            print(myDrinks[i].id.toString() +
                                                " | " +
                                                myDrinks[i]
                                                    .drinkCategoryId
                                                    .toString() +
                                                " | " +
                                                myDrinks[i].name.toString() +
                                                " | " +
                                                myDrinks[i].Quant.toString() +
                                                " | " +
                                                myDrinks[i].price.toString());
                                          }
                                          if (orderlenght > 0) {
                                            setState(() {
                                              btnaddcolor = true;
                                            });
                                          } else {
                                            setState(() {
                                              btnaddcolor = false;
                                            });
                                          }
                                          // counteraddord2('add');
                                          // bool exists = temporder.any((temporder) => temporder.CatId == snapshot.data[index].id);
                                          //
                                          // if(exists == false){
                                          //   TempOrder tmp = TempOrder(snapshot.data[index].drinkid,snapshot.data[index].id, snapshot.data[index].name, int.parse(ord2),snapshot.data[index].price);
                                          //   temporder.add(tmp);
                                          // }else{
                                          //   for(var i = 0; i < temporder.length; i++){
                                          //     if(temporder[i].CatId == snapshot.data[index].id){
                                          //       print(temporder[i].Name);
                                          //       int tq = temporder[i].Quant;
                                          //       print(tq);
                                          //       int newtq = tq + 1;
                                          //       temporder.removeAt(i);
                                          //       TempOrder tmp = TempOrder(snapshot.data[index].drinkid,snapshot.data[index].id, snapshot.data[index].name, newtq,snapshot.data[index].price);
                                          //       temporder.add(tmp);
                                          //     }
                                          //   }
                                          // }

                                          // for(var i = 0; i < temporder.length; i++){
                                          //   print(temporder[i].CatId);
                                          //   print(temporder[i].Name);
                                          //   print(temporder[i].Quant);
                                          // }
                                        },
                                        child: Container(
                                            child: Center(
                                                child: Text(
                                          '+',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange),
                                        ))),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          //visible: snapshot.data[index].mixer == null ? false:true,
                          child: snapshot.data[index].mixer.isEmpty
                              ? Container()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    height: snapshot.data[index].mixer.isEmpty
                                        ? 0
                                        : 40,
                                    child: ListView(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Container(
                                              // color: Colors.green,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: getTextWidgets(
                                                  snapshot.data[index].mixer,
                                                  index)),
                                        ]),
                                  )),
                        ),
                        SizedBox(
                          height: snapshot.data[index].mixer.isEmpty ? 0 : 10,
                        )
                      ],
                    );
                  });
            }
          }),
    );
  }

  Future<List<Drinks>> getDrinks() async {
    myDrinks = [];
    print('drinks');
    print(dri);
    print(drisub);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(Uri.parse(url), headers: headers);

    var jsondata = json.decode(response.body)['menu'];

    String feeable =
        json.decode(response.body)['isServiceChargeEnabled'].toString();
    if (feeable == 'true') {
      fee = double.parse(
          json.decode(response.body)['serviceChargePercentage'].toString());
    } else {
      fee = 0;
    }

    for (var i = 0; i < jsondata.length - 1; i++) {
      if (jsondata[i]['id'].toString() == dri) {
        print(jsondata[i]['name'].toString() + '|' + dri);
        if (jsondata[i]['subCategories'].toString() == '[]') {
          var jsondata1 = json.decode(response.body)['menu'][i]['drinks'];
          int mi = 0;
          for (var u in jsondata1) {
            print(u['name']);
            List<Mixer> mix = [];
            int mci = 0;
            var jsondata2 = await json.decode(response.body)['menu'][i]
                ['drinks'][mi]['mixerCategories'];
            for (var m in jsondata2) {
              List<MixerCat> mixCat = [];
              try {
                var jsondata3 = await json.decode(response.body)['menu'][i]
                    ['drinks'][mi]['mixerCategories'][mci]['mixers'];
                for (var mc in jsondata3) {
                  MixerCat mymixCat = MixerCat(mc['id'].toString(),
                      mc['name'].toString(), mc['price'].toString());
                  setState(() {
                    mixCat.add(mymixCat);
                  });
                }
              } catch (e) {
                print("empty mixer");
              }
              Mixer mymix = Mixer(m['id'], m['name'],
                  m['isMultipleSelectionAlowed'].toString(), mixCat);
              setState(() {
                mix.add(mymix);
              });
              mci++;
            }
//s['allowIce']
            Drinks store = Drinks(
                jsondata[i]['id'].toString(),
                u['id'].toString(),
                u['name'].toString(),
                u['description'].toString(),
                u['price'].toString(),
                0,
                u['drinkCategoryId'].toString(),
                mix,
                '',
                '',
                u['price'].toString(),
                [],
                u['imagePath'],
                u['allowIce'],
                false);

            setState(() {
              myDrinks.add(store);
            });
            mi++;
          }
        } else {
          var jsondata1 =
              json.decode(response.body)['menu'][i]['subCategories'];
          for (var v = 0; v < jsondata1.length - 1; v++) {
            if (jsondata1[i]['id'].toString() == drisub) {
              print(jsondata1[i]['id'].toString() + '|' + drisub);
              var jsondata2 = json.decode(response.body)['menu'][i]
                  ['subCategories'][v]['drinks'];
              int mi = 0;
              for (var s in jsondata2) {
                //if(s['drinkCategoryId'] == drisub) {
                print(s['name']);

                List<Mixer> mix = [];
                int mci = 0;
                var jsondata2 = await json.decode(response.body)['menu'][i]
                    ['subCategories'][v]['drinks'][0]['mixerCategories'];
                for (var m in jsondata2) {
                  print(m['name']);
                  List<MixerCat> mixCat = [];

                  try {
                    var jsondata3 = await json.decode(response.body)['menu'][i]
                            ['subCategories'][v]['drinks'][mi]
                        ['mixerCategories'][mci]['mixers'];

                    for (var mc in jsondata3) {
                      print(mc['name'].toString());
                      MixerCat mymixCat = MixerCat(mc['id'].toString(),
                          mc['name'].toString(), mc['price'].toString());
                      setState(() {
                        mixCat.add(mymixCat);
                      });
                    }
                  } catch (e) {
                    print('empty mixer');
                  }

                  Mixer mymix = Mixer(m['id'], m['name'],
                      m['isMultipleSelectionAlowed'].toString(), mixCat);
                  setState(() {
                    mix.add(mymix);
                  });
                  mci++;
                }

                Drinks store = Drinks(
                    s['drinkCategoryId'].toString(),
                    s['id'].toString(),
                    s['name'].toString(),
                    s['description'].toString(),
                    s['price'].toString(),
                    0,
                    s['drinkCategoryId'].toString(),
                    mix,
                    '',
                    '',
                    s['price'].toString(),
                    [],
                    s['imagePath'],
                    s['allowIce'],
                    false);

                setState(() {
                  myDrinks.add(store);
                });
                //}
                mi++;
              }
            }
          }
        }
      }
    }
    print('My drinks: ' + myDrinks.length.toString());
    return myDrinks;
  }

  Widget showDiscount() {
    return Container(
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: Column(
          children: [
            Container(
              height: 300.0,
              child: FutureBuilder(
                  future: getDiscount(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  //
                                  //Prefs.setString('discountId', snapshot.data[index].discountid);
                                  discountID = snapshot.data[index].discountid;
                                  discountitempercentage =
                                      snapshot.data[index].discountpercentage;

                                  double totdiscount = ((finaltot *
                                          double.parse(snapshot
                                              .data[index].discountpercentage
                                              .toString())) /
                                      100);

                                  mdicount = totdiscount;
                                  discount = double.parse(snapshot
                                      .data[index].discountpercentage
                                      .toString());
                                  print(discount);

                                  if (discount > 0) {
                                    double totwithdiscount =
                                        finaltot - totdiscount;
                                    double tmptot;
                                    if (vipcharge == true) {
                                      tmptot = totwithdiscount + mtip + vip;
                                    } else {
                                      tmptot = totwithdiscount + mtip;
                                    }
                                    double chr = tmptot * (charge / 100);

                                    // double roundDouble(
                                    //     double value, int places) {
                                    //   double mod = pow(10.0, places);
                                    //   return ((value * mod).round().toDouble() /
                                    //       mod);
                                    // }

                                    // chrx = roundDouble(chr, 2);
                                    chrx = chr;
                                    double temp = tmptot + chrx;
                                    // String spliter = temp.toString();
                                    // var splitag = spliter.split(".");
                                    // var splitag1 = splitag[0];
                                    // var splitag2 = splitag[1];

                                    finaltotwithdiscount = temp;

                                    // try {
                                    //   var secs1 = splitag2.substring(0, 1);
                                    //   var secs2 = splitag2.substring(1, 2);
                                    //   var secs3 = splitag2.substring(2, 3);
                                    //   print(secs3);

                                    //   if (double.parse(secs3) <= 5) {
                                    //     String compl =
                                    //         splitag1 + "." + secs1 + secs2;

                                    //     finaltotwithdiscount =
                                    //         double.parse(compl);
                                    //     finaltotwithdiscount = double.parse(
                                    //         finaltotwithdiscount
                                    //             .toStringAsFixed(2));
                                    //   } else {
                                    //     finaltotwithdiscount = double.parse(
                                    //         (temp).toStringAsFixed(2));
                                    //   }
                                    // } catch (e) {
                                    //   finaltotwithdiscount = double.parse(
                                    //       (temp).toStringAsFixed(2));
                                    // }

                                    Alert(
                                      context: context,
                                      title: "DISCOUNT CARD",
                                      content: Text(
                                        'You will not receive your order unless you present a valid discount card.',
                                        textAlign: TextAlign.center,
                                      ),
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            Navigator.pop(context);
                                          },
                                          color: Colors.deepOrange,
                                        )
                                      ],
                                    ).show();
                                  } else {
                                    double totwithdiscount = finaltot;
                                    double tmptot;
                                    if (vipcharge == true) {
                                      tmptot = totwithdiscount + mtip + vip;
                                    } else {
                                      tmptot = totwithdiscount + mtip;
                                    }
                                    double chr = tmptot * (charge / 100);
                                    // double roundDouble(
                                    //     double value, int places) {
                                    //   double mod = pow(10.0, places);
                                    //   return ((value * mod).round().toDouble() /
                                    //       mod);
                                    // }

                                    // chrx = roundDouble(chr, 2);
                                    chrx = chr;
                                    double temp = tmptot + chrx;
                                    finaltotwithdiscount = temp;
                                    // double.parse(temp.toStringAsFixed(2));
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Container(
                                  child: Card(
                                color: Colors.black45.withOpacity(.5),
                                child: Container(
                                    height: 40,
                                    width: 300,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 2, 10, 2),
                                      child: Row(
                                        children: [
                                          Text(
                                            snapshot.data[index].discountname,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          Spacer(),
                                          Text(
                                            snapshot.data[index]
                                                    .discountpercentage
                                                    .toString() +
                                                '%',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )),
                              )),
                            );
                          });
                    }
                  }),
            ),
          ],
        ));
  }

  Widget showTable() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Container(
        child: FutureBuilder(
            future: getTable(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                if (snapshot.data.length <= 0) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text('No tables available.'),
                  );
                }
                return ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            choosetb = snapshot.data[index].tablename;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                            child: Card(
                          color: Colors.black45.withOpacity(.5),
                          child: Container(
                            //height: 40,
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            width: 300,
                            child: Center(
                                child: Text(
                              snapshot.data[index].tablename,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                          ),
                        )),
                      );
                    });
              }
            }),
      ),
    );
  }

  payment() {
    return Container(
      color: Color(0xFF2b2b61).withOpacity(.7),
      height: 10000,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
              //color: Colors.white.withOpacity(.2),
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Text(
                'PAYMENT',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          Divider(
            color: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Row(
                          children: [
                            Text(
                              "Order (" + totalqty.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              totalqty > 1 ? " items):" : " item):",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Spacer(),
                            Text(finaltot.toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              ' AED',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        )),
                    Divider(
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {
                        Alert(
                          closeIcon: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 1,
                          ),
                          context: context,
                          title: "Discount",
                          content: showDiscount(),
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              color: Color(0xFF2b2b61).withOpacity(.7),
                            ),
                          ],
                        ).show();
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Text('Discount'),
                        //         content: showDiscount(),
                        //       );
                        //     });
                      },
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Row(
                            children: [
                              Text(
                                'Discount',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Visibility(
                                  visible: discount <= 0 ? false : true,
                                  child: Text(
                                    roundtoEven(mdicount, 3).toStringAsFixed(2),
                                    // mdicount.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              Visibility(
                                  visible: discount <= 0 ? false : true,
                                  child: Text(
                                    ' AED',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                            ],
                          )),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {
                        double mytip = 0;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, mState) {
                                return AlertDialog(
                                  title: Text("Tip"),
                                  content: Container(
                                    height: 450.0,
                                    width: 300.0,
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 0? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  mtip = 0;
                                                  tip = 0;
                                                  double ch = charge / 100;
                                                  //finaltotwithdiscount = finaltotwithdiscount;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                });
                                                mState(() {
                                                  tipid = 0;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 0
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "No tip",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 1? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tip = (finaltot * .05);
                                                  //finaltotwithdiscount = finaltotwithdiscount;
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;

                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = tip;
                                                });
                                                mState(() {
                                                  tipid = 1;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 1
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "5%",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 2? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 2;
                                                  tip = (finaltot * .10);
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = tip;
                                                });
                                                mState(() {
                                                  tipid = 2;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 2
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "10%",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 3? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 3;
                                                  tip = (finaltot * .15);
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = tip;
                                                });
                                                mState(() {
                                                  tipid = 3;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 3
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "15%",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 4? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 4;
                                                  tip = (finaltot * .20);
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = tip;
                                                });
                                                mState(() {
                                                  tipid = 4;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 4
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "20%",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 5? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 5;
                                                  tip = 5;
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = 5;
                                                });
                                                mState(() {
                                                  tipid = 5;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 5
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "5 AED",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 6? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 6;
                                                  tip = 10;
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;

                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = 10;
                                                });
                                                mState(() {
                                                  tipid = 6;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 6
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "10 AED",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 7? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 7;
                                                  tip = 15;
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // chrx = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = 15;
                                                });
                                                mState(() {
                                                  tipid = 7;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 7
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "15 AED",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Divider(),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: tipid == 6? Colors.deepOrange:Colors.transparent,)
                                          // ),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tipid = 8;
                                                  tip = 20;
                                                  double ch = charge / 100;
                                                  if (discount > 0) {
                                                    double discountwithtot =
                                                        finaltot *
                                                            (discount / 100);
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip +
                                                          vip;
                                                    } else {
                                                      temp = (finaltot -
                                                              discountwithtot) +
                                                          tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  } else {
                                                    double temp;
                                                    if (vipcharge == true) {
                                                      temp =
                                                          finaltot + tip + vip;
                                                    } else {
                                                      temp = finaltot + tip;
                                                    }
                                                    double chr = temp * ch;
                                                    // double roundDouble(
                                                    //     double value,
                                                    //     int places) {
                                                    //   double mod =
                                                    //       pow(10.0, places);
                                                    //   return ((value * mod)
                                                    //           .round()
                                                    //           .toDouble() /
                                                    //       mod);
                                                    // }

                                                    // chrx = roundDouble(chr, 2);
                                                    chrx = chr;
                                                    finaltotwithdiscount =
                                                        chrx + temp;
                                                    // finaltotwithdiscount =
                                                    //     double.parse(
                                                    //         finaltotwithdiscount
                                                    //             .toStringAsFixed(
                                                    //                 2));
                                                  }
                                                  mtip = 20;
                                                });
                                                mState(() {
                                                  tipid = 8;
                                                });
                                              },
                                              child: Container(
                                                width: 300.0,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: tipid == 8
                                                          ? Colors.deepOrange
                                                          : Colors.black
                                                              .withOpacity(.5),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "20 AED",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Full TIP amount goes to the staff!',
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    // InkWell(
                                    //   onTap: () {
                                    //     Navigator.pop(context);
                                    //   },
                                    //   child: new Container(
                                    //     width: 130.0,
                                    //     height: 50.0,
                                    //     decoration: new BoxDecoration(
                                    //       color: Color(0xFF2b2b61).withOpacity(.7),
                                    //       border: new Border.all(color: Colors.white, width: 2.0),
                                    //       borderRadius: new BorderRadius.circular(10.0),
                                    //     ),
                                    //     child: new Center(child: new Text('Cancel', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                                    //   ),
                                    // ),
                                    // Spacer(),

                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: new Container(
                                        width: 300,
                                        height: 50.0,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: new BoxDecoration(
                                          color: Colors.deepOrange,
                                          border: new Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: new Center(
                                          child: new Text(
                                            'Save',
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Row(
                            children: [
                              Text(
                                'Tip',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 154,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Visibility(
                                  visible: mtip == 0 ? false : true,
                                  child: Text(
                                    roundtoEven(mtip, 3).toStringAsFixed(2),
                                    // mtip.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              Visibility(
                                  visible: mtip == 0 ? false : true,
                                  child: Text(
                                    ' AED',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                            ],
                          )),
                    ),
                    Visibility(
                      visible: vip > 0 ? true : false,
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (vipcharge == true) {
                                      //finaltotwithdiscount = finaltotwithdiscount - vip;
                                      double ch = charge / 100;
                                      if (discount > 0) {
                                        double discountwithtot =
                                            finaltot * (discount / 100);
                                        double temp =
                                            (finaltot - discountwithtot) + tip;
                                        double chr = temp * ch;
                                        // double roundDouble(
                                        //     double value, int places) {
                                        //   double mod = pow(10.0, places);
                                        //   return ((value * mod)
                                        //           .round()
                                        //           .toDouble() /
                                        //       mod);
                                        // }

                                        // chrx = roundDouble(chr, 2);
                                        chrx = chr;
                                        finaltotwithdiscount = chrx + temp;
                                        // finaltotwithdiscount = double.parse(
                                        //     finaltotwithdiscount
                                        //         .toStringAsFixed(3));
                                      } else {
                                        double temp = finaltot + tip;
                                        double chr = temp * ch;
                                        // double roundDouble(
                                        //     double value, int places) {
                                        //   double mod = pow(10.0, places);
                                        //   return ((value * mod)
                                        //           .round()
                                        //           .toDouble() /
                                        //       mod);
                                        // }

                                        // chrx = roundDouble(chr, 2);
                                        chrx = chr;
                                        finaltotwithdiscount = chrx + temp;
                                        // finaltotwithdiscount = double.parse(
                                        //     finaltotwithdiscount
                                        //         .toStringAsFixed(3));
                                      }
                                      vipcharge = false;
                                    } else {
                                      //finaltotwithdiscount = finaltotwithdiscount + vip;
                                      double ch = charge / 100;
                                      if (discount > 0) {
                                        double discountwithtot =
                                            finaltot * (discount / 100);
                                        double temp =
                                            (finaltot - discountwithtot) +
                                                tip +
                                                vip;
                                        double chr = temp * ch;
                                        // double roundDouble(
                                        //     double value, int places) {
                                        //   double mod = pow(10.0, places);
                                        //   return ((value * mod)
                                        //           .round()
                                        //           .toDouble() /
                                        //       mod);
                                        // }

                                        // chrx = roundDouble(chr, 2);
                                        chrx = chr;
                                        finaltotwithdiscount = chrx + temp;
                                        // finaltotwithdiscount = double.parse(
                                        //     finaltotwithdiscount
                                        //         .toStringAsFixed(3));
                                      } else {
                                        double temp = finaltot + tip + vip;
                                        double chr = temp * ch;
                                        // double roundDouble(
                                        //     double value, int places) {
                                        //   double mod = pow(10.0, places);
                                        //   return ((value * mod)
                                        //           .round()
                                        //           .toDouble() /
                                        //       mod);
                                        // }

                                        // chrx = roundDouble(chr, 2);
                                        chrx = chr;
                                        finaltotwithdiscount = chrx + temp;
                                        // finaltotwithdiscount = double.parse(
                                        //     finaltotwithdiscount
                                        //         .toStringAsFixed(3));
                                      }
                                      vipcharge = true;
                                    }
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: vipcharge == true
                                        ? Colors.white.withOpacity(.5)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: vipcharge == false
                                          ? Colors.white
                                          : Colors.transparent,
                                      //                   <--- border color
                                      width: 1.0,
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  child: Center(
                                      child: Text(
                                    'VIP Charge ' + vip.toString() + '0 AED',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                                ),
                              ),
                              Spacer(),
                              Visibility(
                                  visible: vipcharge == true ? true : false,
                                  child: Text(
                                    vip.toString() + '0',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 14),
                                  )),
                              Visibility(
                                  visible: vipcharge == true ? true : false,
                                  child: Text(
                                    ' AED',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                  )),
                            ],
                          )),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Row(
                          children: [
                            Text(
                              'Service charge:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              // ((fee / 100) * finaltot).toStringAsFixed(2),
                              roundDouble(chrx, 2).toString(),
                              // (chrx).toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' AED',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        )),
                    Divider(
                      color: Colors.white,
                    ),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Row(
                          children: [
                            Text(
                              'TOTAL:',
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 20),
                            ),
                            Spacer(),
                            Text(
                              roundDouble(finaltotwithdiscount, 2).toString(),
                              // finaltotwithdiscount.toStringAsFixed(3),
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' AED',
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 18),
                            ),
                          ],
                        )),
                    //
                    Container(
                        color: Colors.white.withOpacity(.2),
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF2b2b61),
                            //color: Colors.white
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pickdine = true;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: pickdine == true
                                          ? Colors.white.withOpacity(.2)
                                          : Color(0xFF2b2b61).withOpacity(.7),
                                    ),
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'PICK UP',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pickdine = false;
                                  });
                                  Alert(
                                    closeIcon: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 1,
                                    ),
                                    context: context,
                                    title: "Table list",
                                    content: showTable(),
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                        color:
                                            Color(0xFF2b2b61).withOpacity(.7),
                                      ),
                                    ],
                                  ).show();
                                  // Alert(
                                  //   context: context,
                                  //   title: "Table list",
                                  //   content: showTable(),
                                  //   buttons: [
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Cancel",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 20),
                                  //       ),
                                  //       onPressed: () => Navigator.of(context,
                                  //               rootNavigator: true)
                                  //           .pop(),
                                  //       color:
                                  //           Color(0xFF2b2b61).withOpacity(.7),
                                  //     ),
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Save",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 20),
                                  //       ),
                                  //       onPressed: () => Navigator.of(context,
                                  //               rootNavigator: true)
                                  //           .pop(),
                                  //       color: Colors.deepOrange,
                                  //     )
                                  //   ],
                                  // ).show();
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return AlertDialog(
                                  //         title: Text('Table list'),
                                  //         content: showTable(),
                                  //       );
                                  //     });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: pickdine == false
                                          ? Colors.white.withOpacity(.2)
                                          : Color(0xFF2b2b61).withOpacity(.7),
                                    ),
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'DINE IN',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )),
                              ),
                            ],
                          ),
                        )),

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Visibility(
                        visible: pickdine == false ? true : false,
                        child: Container(
                            color: Colors.white.withOpacity(.2),
                            //height: 70,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Ask server for your table number',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          wordSpacing: 5),
                                    )),
                                //Spacer(),
                                Expanded(
                                  flex: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      Alert(
                                        closeIcon: Icon(
                                          Icons.circle,
                                          color: Colors.white,
                                          size: 1,
                                        ),
                                        context: context,
                                        title: "Table list",
                                        content: showTable(),
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () => Navigator.of(
                                                    context,
                                                    rootNavigator: true)
                                                .pop(),
                                            color: Color(0xFF2b2b61)
                                                .withOpacity(.7),
                                          ),
                                        ],
                                      ).show();
                                      // Alert(
                                      //   context: context,
                                      //   title: "Table list",
                                      //   content: showTable(),
                                      //   buttons: [
                                      //     DialogButton(
                                      //       child: Text(
                                      //         "Cancel",
                                      //         style: TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 20),
                                      //       ),
                                      //       onPressed: () => Navigator.of(
                                      //               context,
                                      //               rootNavigator: true)
                                      //           .pop(),
                                      //       color: Color(0xFF2b2b61)
                                      //           .withOpacity(.7),
                                      //     ),
                                      //     DialogButton(
                                      //       child: Text(
                                      //         "Save",
                                      //         style: TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 20),
                                      //       ),
                                      //       onPressed: () => Navigator.of(
                                      //               context,
                                      //               rootNavigator: true)
                                      //           .pop(),
                                      //       color: Colors.deepOrange,
                                      //     )
                                      //   ],
                                      // ).show();
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return AlertDialog(
                                      //         title: Text('Table list'),
                                      //         content: showTable(),
                                      //       );
                                      //     });
                                    },
                                    child: Text(
                                      choosetb,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                      onTap: () {
                                        Alert(
                                          closeIcon: Icon(
                                            Icons.circle,
                                            color: Colors.white,
                                            size: 1,
                                          ),
                                          context: context,
                                          title: "Table list",
                                          content: showTable(),
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () => Navigator.of(
                                                      context,
                                                      rootNavigator: true)
                                                  .pop(),
                                              color: Color(0xFF2b2b61)
                                                  .withOpacity(.7),
                                            ),
                                          ],
                                        ).show();
                                        // Alert(
                                        //   context: context,
                                        //   title: "Table List",
                                        //   content: showTable(),
                                        //   buttons: [
                                        //     DialogButton(
                                        //       child: Text(
                                        //         "Cancel",
                                        //         style: TextStyle(
                                        //             color: Colors.white,
                                        //             fontSize: 20),
                                        //       ),
                                        //       onPressed: () => Navigator.of(
                                        //               context,
                                        //               rootNavigator: true)
                                        //           .pop(),
                                        //       color: Color(0xFF2b2b61)
                                        //           .withOpacity(.7),
                                        //     ),
                                        //     DialogButton(
                                        //       child: Text(
                                        //         "Save",
                                        //         style: TextStyle(
                                        //             color: Colors.white,
                                        //             fontSize: 20),
                                        //       ),
                                        //       onPressed: () => Navigator.of(
                                        //               context,
                                        //               rootNavigator: true)
                                        //           .pop(),
                                        //       color: Colors.deepOrange,
                                        //     )
                                        //   ],
                                        // ).show();
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            )),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: myCardList.length > 0 ? true : false,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                          child: Text(
                            'Select card or Enter card below.',
                            style: TextStyle(
                                color: Colors.deepOrange, fontSize: 16),
                          ),
                        )),
                    Visibility(
                      visible: myCardList.length > 0 ? true : false,
                      child: Container(
                        //padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: showCardDetails(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Container(
                        //padding: EdgeInsets.fromLTRB(0, 10, 15, 5),
                        child: CheckboxListTile(
                      checkColor: Colors.white,
                      title: Text("Use default billing details",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      value: checkedValue_dsettings,
                      onChanged: (dsettings) {
                        setState(() {
                          checkedValue_dsettings = dsettings;

                          if (checkedValue_dsettings == true) {
                            saveTempopraryDetails();
                          } else {
                            getTempopraryDetails();
                          }
                          getDefaultSettings();
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    )),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: TextField(
                        enabled: isbname,
                        controller: billname,
                        style: TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          hintText: "Billing name: First name, Last name",
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: new TextStyle(color: Colors.white),
                          labelText: 'Billing name: First name, Last name',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: TextField(
                        enabled: isbaddress,
                        controller: billadd,
                        style: TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          hintText: "Billing to: Address, City, Country",
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: new TextStyle(color: Colors.white),
                          labelText:
                              'Billing to: Address, City, Country(separated with: ,)',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: TextField(
                        enabled: isemail,
                        controller: billemail,
                        style: TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          hintText: "Send bill to email",
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: new TextStyle(color: Colors.white),
                          labelText: 'Send bill to email',
                          // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        //padding: EdgeInsets.fromLTRB(0, 10, 15, 5),
                        child: CheckboxListTile(
                      checkColor: Colors.white,
                      title: Text("Save billing details",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  //samplecheck();

                                  // if (billadd.text != '' ||
                                  //     billadd.text.isNotEmpty) {
                                  //   _validate = true;
                                  // } else {
                                  //   _validate = false;
                                  // }

                                  // if (billname.text != '' ||
                                  //     billname.text.isNotEmpty) {
                                  //   _validate = true;
                                  // } else {
                                  //   _validate = false;
                                  // }

                                  // if (billemail.text != '' ||
                                  //     billemail.text.isNotEmpty) {
                                  //   _validate = true;
                                  // } else {
                                  //   _validate = false;
                                  // }
                                  String unamex = '';
                                  switch (uName) {
                                    case '':
                                      {
                                        unamex = 'Guest Mode';
                                      }
                                      break;
                                    case ' ':
                                      {
                                        unamex = ' ';
                                      }
                                      break;
                                    case 'None':
                                      {
                                        unamex = 'None';
                                      }
                                      break;
                                    case 'Guest Mode':
                                      {
                                        unamex = 'Guest Mode';
                                      }
                                      break;
                                    default:
                                      {
                                        unamex = uName;
                                      }
                                  }

                                  bool _validate1;
                                  bool _validate2;
                                  bool _validate3;
                                  bool _validate4;
                                  bool _validate5;
                                  bool _validate6;
                                  bool _validate7;
                                  String ename = billname.text.trimLeft();
                                  print("This is the name:" + ename);
                                  int charLength = ename.length;
                                  var fullname = ename.split(' ');
                                  if (fullname.length == 1) {
                                    _showDialog(
                                        'DrinkLink', 'Please input full name.');
                                    return;
                                  }
                                  String firsname = '';
                                  String lastname = '';
                                  if (pickdine == false) {
                                    if (choosetb == "Choose Table") {
                                      _showDialog(
                                          'DrinkLink', 'Please choose table.');
                                      return;
                                    }
                                  }

                                  try {
                                    firsname = fullname[0];
                                    lastname = fullname[1];

                                    _validate4 = Prefs.getBoolValtext(firsname);
                                    _validate5 = Prefs.getBoolValtext(lastname);
                                    _validate1 =
                                        Prefs.getBoolValtext(billadd.text);
                                    _validate2 =
                                        Prefs.getBoolValtext(billname.text);
                                    _validate3 =
                                        Prefs.getBoolValtext(billemail.text);

                                    if (_validate4 == false ||
                                        _validate5 == false) {
                                      _showDialog('DrinkLink',
                                          'Please input full name.');
                                      return;
                                    } else if (_validate4 == false &&
                                        _validate5 == false) {
                                      _showDialog('DrinkLink',
                                          'Please input full name.');
                                      return;
                                    } else if (charLength == 1) {
                                      _showDialog('DrinkLink',
                                          'Please input full name.');
                                      return;
                                    } else if (_validate5 == false) {
                                      _showDialog('DrinkLink',
                                          'Please input Lastname.');
                                      return;
                                    } else if (_validate1 == false) {
                                      _showDialog('DrinkLink',
                                          'Please input billing address.');
                                      return;
                                    } else if (_validate3 == false) {
                                      String email =
                                          billemail.text.replaceAll(' ', '');
                                      final bool isValid =
                                          EmailValidator.validate(email);
                                      print(isValid);
                                      if (isValid == false) {
                                        _showDialog('DrinkLink',
                                            'Enter valid email address');
                                        return;
                                      }
                                      return;
                                    } else if (_validate3 == true) {
                                      String email =
                                          billemail.text.replaceAll(' ', '');
                                      final bool isValid =
                                          EmailValidator.validate(email);
                                      print(isValid);
                                      if (isValid == false) {
                                        _showDialog('DrinkLink',
                                            'Enter valid email address');
                                        return;
                                      }
                                    } else {
                                      _validate4 = _validate4;
                                      _validate5 = _validate5;
                                    }

                                    if (_validate1 == true &&
                                        _validate2 == true &&
                                        _validate3 == true &&
                                        _validate4 == true &&
                                        _validate5 == true) {
                                      setState(() {
                                        // isloading = true;
                                        if (checkedValue == true) {
                                          savebill(
                                              unamex,
                                              firsname,
                                              lastname,
                                              billadd.text,
                                              billemail.text,
                                              idCard,
                                              checkedValue,
                                              checkedValue_dsettings);

                                          savebillcard(
                                              unamex,
                                              idCard,
                                              maskedPan,
                                              expiry,
                                              cardholderName,
                                              scheme,
                                              cardToken);
                                        } else {
                                          savebill(unamex, '', '', '', '', '',
                                              false, false);
                                          savebillcard(
                                              unamex, '', '', '', '', '', '');
                                        }
                                        tokenChecker();
                                      });
                                    }
                                  } catch (e) {
                                    if (firsname.isEmpty) {
                                      _showDialog('DrinkLink',
                                          'Please input full name.');
                                      return;
                                    }
                                    if (lastname.isEmpty) {
                                      _showDialog('DrinkLink',
                                          'Please input full name.');
                                      return;
                                    }
                                    _showDialog('DrinkLink',
                                        'Please input billing details.');
                                  }
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
                                      'PAY NOW',
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
          ),
        ],
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
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CheckboxListTile(
                                      title: Text(
                                        snapshot.data[index].scheme,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      value:
                                          idCard == snapshot.data[index].cardid
                                              ? true
                                              : false,
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (idCard ==
                                              snapshot.data[index].cardid) {
                                            idCard = '';
                                            maskedPan = '';
                                            expiry = '';
                                            cardholderName = '';
                                            scheme = '';
                                            cardToken = '';
                                          } else {
                                            idCard =
                                                snapshot.data[index].cardid;
                                            maskedPan =
                                                snapshot.data[index].maskedPan;
                                            expiry =
                                                snapshot.data[index].expiry;
                                            cardholderName = snapshot
                                                .data[index].cardholderName;
                                            scheme =
                                                snapshot.data[index].scheme;
                                            cardToken =
                                                snapshot.data[index].cardToken;
                                          }
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity
                                          .leading, //  <-- leading Checkbox
                                    ),
                                    // Checkbox(
                                    //     value: snapshot.data[index].select,
                                    //     activeColor: Colors.deepOrange,
                                    //     onChanged:(bool newValue){
                                    //       setState(() {
                                    //         if( snapshot.data[index].select == false ){
                                    //           snapshot.data[index].select = true;
                                    //         }else{
                                    //           snapshot.data[index].select = false;
                                    //         }
                                    //
                                    //       });
                                    //       Text(snapshot.data[index].scheme,style: TextStyle(color: Colors.white),);
                                    //     }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
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
                              )
                            ],
                          )),
                    );
                  });
            }
          }),
    );
  }

  samplecheck() {
    String url =
        'https://paypage.ngenius-payments.com/?outletId=c5d48ba0-f539-42b1-8ea4-346f5ea8493b&orderRef=18aa8912-e777-46de-88b9-bbb13c523c95&paymentRef=78f1eb4f-956a-4d9c-86ad-dbab5b7d6f65&state=AUTHORISED&3ds_status=SUCCESS&authResponse_success=true&authResponse_authorizationCode=413977';
    var divurl = url.split('=');
    //print(divurl[0].trim());
    //print(divurl[1].trim());
    print(divurl[2].trim());
    String codena = divurl[2].trim();
    String mycode = codena.replaceAll('&paymentRef', '');
    print(mycode);
    //print(divurl[3].trim());
    //print(divurl[4].trim());
    //print(divurl[5].trim());
  }

  tokenChecker() async {
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

    Prefs.load();

    String tk = Prefs.getString('token');

    if (tk == null || tk == '') {
      SignUpPay();
    } else {
      String uname = Prefs.getString('uname') ?? '';
      OrderNow(uname);
      // isloading = false;
      //getPaymentLink();

    }
  }

  SignUpPay() async {
    String su = uuid.v1();
    String nname = su.replaceAll(new RegExp(r'[^\w\s]+'), '');
    String em = nname + "@gmail.com";
    print(nname);
    String pss = "Asd12345678!";
    String uname = nname;
    print('Singup');
    Prefs.load();
    Prefs.setString('email', em);
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map map = {
      'data': {
        "email": em,
        "passwordConfirmed": pss,
        "password": pss,
        "userName": uname
      },
    };
    var body = json.encode(map['data']);
    print(body);
    String url = ApiCon.baseurl() + '/auth/users';
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    //var jsondata = json.decode(response.headers);
    print(response.body.toString());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      logintoPay(uname, pss);
    }
  }

  logintoPay(String uname, pass) async {
    //   String nname = uname.replaceAll(new RegExp(r'[^\w\s]+'),'');

    print('login');
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map map = {
      'data': {
        "userName": uname,
        "password": pass,
      },
    };
    var body = json.encode(map['data']);
    String url = ApiCon.baseurl() + '/auth/Token';
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String token = json.decode(response.body)['token'];
      print(token);
      setState(() {
        Prefs.setString('token', token);
      });
      // setNotif(token, uname);
      OrderNow(uname);
      //getPaymentLink();
    }
  }

  setNotif(String su, email) async {
    print(email);
    Prefs.load();
    String ntoken = Prefs.getString('notifToken');
    print("my token: " + ntoken);
    String myt = "'" + ntoken + "'";
    final bod = jsonEncode({'token': ntoken, 'clientAppPlatform': 'ios'});
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + su,
      'Content-Type': 'application/json',
      'api-version': '1.1'
    };
    String url = ApiCon.baseurl() + '/auth/users/currentUser/notificationToken';

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: bod);
    print(response.body);
  }

  OrderNow(String uname) async {
    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    String em = billemail.text.trimLeft();
    String ename = billname.text.trimLeft();
    String eaddress = billadd.text.trimLeft();
    var fullname = ename.split(' ');
    String firsname = '';
    String lastname = '';
    try {
      firsname = fullname[0];
      lastname = fullname[1];
    } catch (e) {
      // _showDialog('DrinkLink', 'Please input full name.');
    }

    print(token);
    int facility = Prefs.getInt('Facility');
    double price = Prefs.getDouble('Price');

    String drinksorderall = '';

    List<PayDrinks> myPydr = [];

    for (var i = 0; i < myOrder.length; i++) {
      PayOrder ord = PayOrder(myOrder[i].drinkId.toString(),
          myOrder[i].CatId.toString(), myOrder[i].origPrice.toString());
      List<PayMixer> mymixer = [];
      PayMixer ord1;
      List strings = [];
      for (var jo = 0; jo < myOrder[i].mxir.length; jo++) {
        if (myOrder[i].mxir[jo].id.toString() != '') {
          ord1 = PayMixer(myOrder[i].mxir[jo].id.toString(),
              myOrder[i].mxir[jo].price.toString());
          mymixer.add(ord1);
          strings.add(ord1);
          for (var j = 0; j < myOrder[i].mxir.length; j++) {
            print(myOrder[i].mxir[j].id.toString());
          }
        } else {
          ord1 = null;
        }
      }
      print(strings);
      double price = double.parse(myOrder[i].Quant.toString()) *
          double.parse(myOrder[i].Price.toString());
      PayDrinks pydr = PayDrinks(myOrder[i].Quant.toString(),
          price.toStringAsFixed(2), myOrder[i].aIce, ord, mymixer);

      String jsonUser = jsonEncode(pydr);

      drinksorderall = drinksorderall + jsonUser.toString() + ',';
      myPydr.add(pydr);
    }

    //print(drinksorderall);
    var tagsJson = jsonEncode(myPydr);
    //print(tagsJson.toString());
    // var fjs = json.decode(tagsJson.toString());
    var fjs = json.decode(tagsJson.toString());
    print(fjs.toString());
    String totalPrice = '0';

    //var ftd = finaltotwithdiscount.toStringAsFixed(2);
    //double percentagefee = (fee/100) * finaltot;

    //finaltotwithdiscount = finaltot + percentagefee;

    //totalPrice = roundDouble(finaltotwithdiscount, 3).toStringAsFixed(2);
    print(finaltotwithdiscount);
    totalPrice = calCulateDecimatPlace(finaltotwithdiscount).toString();
    // totalPrice = finaltotwithdiscount.toStringAsFixed(2);
    //totalPrice = '1.08';
    print(totalPrice);
    print('Total price:' + totalPrice);
    double finalcharge = charge / 100;

    double vpc = 0;
    if (vipcharge == true) {
      vpc = vip;
    } else {
      vpc = 0;
    }

    print(cardToken);
    print(fjs);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    Map<String, String> items = {"items": drinksorderall.toString()};
    Map map;
    if (cardToken == '') {
      map = {
        "billingAddress": {
          "address": eaddress,
          "city": "Fr",
          "countryCode": "Fr",
          "email": em,
          "firstName": firsname,
          "lastName": lastname,
          "id": 0
        },
        "discountId": discountID,
        "facilityId": facility,
        "finalPrice": totalPrice,
        "isVip": vipcharge,
        "items": fjs,
        "originalPrice": price,
        "saveCardInfo": checkedValue,
        "serviceCharge": finalcharge,
        "tip": mtip,
        "vipCharge": vpc,
      };
    } else {
      map = {
        "billingAddress": {
          "address": eaddress,
          "city": "Fr",
          "countryCode": "Fr",
          "email": em,
          "firstName": firsname,
          "lastName": lastname,
          "id": 0
        },
        "discountId": discountID,
        "facilityId": facility,
        "finalPrice": totalPrice,
        "isVip": vipcharge,
        "items": fjs,
        "originalPrice": price,
        "saveCardInfo": checkedValue,
        "serviceCharge": finalcharge,
        "tip": mtip,
        "vipCharge": vpc,

        "savedCard": {
          "cardToken": cardToken,
          "cardholderName": cardholderName,
          "expiry": expiry,
          "maskedPan": maskedPan,
          "scheme": scheme
        }

        //'discount': discount
      };
    }

    var body = json.encode(map);
    print(body.toString());
    String url = ApiCon.baseurl() + '/orders';
    String _cm = '';
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    //var jsondata = json.decode(response.headers);
    //print(response.body.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('success');
      print(response.body.toString());
      getPaymentLink(
          json.decode(response.body)['id'].toString(),
          json.decode(response.body)['paymentLink'].toString(),
          json.decode(response.body)['orderReference'].toString(),
          json.decode(response.body)['paymentOrderCode'].toString(),
          uname);
    } else {
      print('error');
      print(response.statusCode.toString());
      print(response.body.toString());
      if (response.body.toString().isEmpty) {
        _cm = '[' +
            response.statusCode.toString() +
            '] ' +
            'Please contact Administrator!';
      } else if (response.body
          .toString()
          .contains("Not accepting orders at the moment")) {
        _cm = "Not accepting orders at the moment.";
      } else {
        _cm = response.body.toString();
      }
      _showDialog('DrinkLink', _cm);
      Navigator.pop(context);
      return false;
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.00, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double roundtoEven(double value, int places) {
    double mod = pow(10.00, places) / places;
    return ((value * mod).round().toDouble() / mod);
  }

  _showDialog(String title, String message) {
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
                'Close',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  _showDialogout(String title, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 25),
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
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                context.read<AuthProvider>().setToken('');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                setState(() {
                  setState(() {
                    Prefs.load();
                    Prefs.setString('token', '');
                    Prefs.setString('uname', '');
                    Prefs.setString('bfNamenone', '');
                    Prefs.setString('blMamenone', '');
                    Prefs.setString('billNamenone', '');
                    Prefs.setString('billAddnone', '');
                    Prefs.setString('billEmailnone', '');
                  });
                });
              },
            ),
            TextButton(
              style: flatButtonStyle,
              child: Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  getPaymentLink(String orderID, String url, String reference,
      String paymentCode, String uname) async {
    Prefs.load();
    double price = Prefs.getDouble('Price');
    String maskedPan = Prefs.getString('maskedPan');
    String expiry = Prefs.getString('expiry');
    String cardholderName = Prefs.getString('cardholderName');
    String scheme = Prefs.getString('scheme');
    String cardToken = Prefs.getString('cardToken');
    var idn = nanoid();
    //String tranid = idn.replaceAll(new RegExp(r'[^\w\s]_+'),'');
    print(url);

    // String totalPrice = '0';
    //
    // if(vipcharge == true){
    //   finaltotwithdiscount = finaltotwithdiscount - vip;
    // }
    //
    //
    // if(charge > 0){
    //
    //
    //   double ad = (charge / 100) * double.parse(finaltotwithdiscount.toString());
    //
    //
    //   finaltotwithdiscount = finaltotwithdiscount + ad;
    //   totalPrice = finaltotwithdiscount.toStringAsFixed(2);
    // }else{
    //
    //   totalPrice = finaltotwithdiscount.toStringAsFixed(2);
    // }
    //
    //
    // Navigator.of(context).push(
    //     new PageRouteBuilder(
    //         opaque: false,
    //         barrierDismissible:true,
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
    // Map<String, String> headers = {"Content-Type": "application/json; charset=utf-8"};
    // Map map = {
    //   'data': {
    //     "amount": double.parse(totalPrice),
    //     "currencyCode": "AED",
    //     "transactionNo": code,
    //     "maskedPan": maskedPan,
    //     "expiry": expiry,
    //     "cardholderName": cardholderName,
    //     "scheme": scheme,
    //     "cardToken": cardToken
    //   },
    // };
    // var body = json.encode(map['data']);
    // String url = 'http://dlpp.somee.com/api/payment';
    // final response = await http.post(url,headers: headers, body: body);
    // var jsondata = json.decode(response.body)['mainUrl'];
    // print("This is the reponse: "+ jsondata.toString());

    // String linkpayment = 'https://paypage.ngenius-payments.com/?code=' + code;
    // String linkpayment = ApiCon.paymenturl() + '/?code=' + code;

    String linkpayment = url;
    //if(response.statusCode == 200){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => WebPage(jsondata.toString())),
    // );
    Navigator.pop(context);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebPage(linkpayment.toString(), reference)),
    );

    try {
      if (result.toString().toLowerCase() == ('AUTHORISED').toLowerCase() ||
          result.toString().toLowerCase() == ('REVERSED').toLowerCase()) {
        if (checkedValue == true) {
          Prefs.load();
          Prefs.setString('billName', billname.text);
          Prefs.setString('billAdd', billadd.text);
          Prefs.setString('billEmail', billemail.text);
          Prefs.setBool('billcheck', checkedValue);
        }

        setState(() {
          myDrinks.clear();
          myTempCart = getDrinks();
          orderlenght = 0;
          myOrder.clear();
          temporder.clear();
          finaltot = 0;
          myCartFuture = getOrder();
          chrx = 0;
        });
        setNotif(token, uname);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetails(orderID, reference)),
        );
      } else if (result.toString().toLowerCase() == ('cancel').toLowerCase()) {
        _showDialog('DrinkLink', 'Cancelled payment!');
      } else {
        _showDialog('DrinkLink', 'Failed payment!');
      }
    } catch (x) {
      _showDialog('DrinkLink', 'Failed payment!');
    }

    // if (result.toString().toLowerCase() == ('AUTHORISED').toLowerCase()) {
    //   print(result + 'result here');
    //   if (checkedValue == true) {
    //     Prefs.load();
    //     Prefs.setString('billName', billname.text);
    //     Prefs.setString('billAdd', billadd.text);
    //     Prefs.setString('billEmail', billemail.text);
    //     Prefs.setBool('billcheck', checkedValue);
    //   }

    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => OrderDetails('')),
    //   );
    // } else if ((result).toString().toLowerCase() ==
    //     ('REVERSED').toLowerCase()) {
    //   print(result + 'result here');
    //   if (checkedValue == true) {
    //     Prefs.load();
    //     Prefs.setString('billName', billname.text);
    //     Prefs.setString('billAdd', billadd.text);
    //     Prefs.setString('billEmail', billemail.text);
    //     Prefs.setBool('billcheck', checkedValue);
    //   }

    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => OrderDetails('')),
    //   );
    // } else if ((result).toString().toLowerCase() ==
    //     ('CANCELLED').toLowerCase()) {
    //   print(result + 'payment mode');
    //   _showDialog('DrinkLink', 'Failed payment!');
    // } else if ((result).toString().toLowerCase() == ('FAILED').toLowerCase()) {
    //   print(result + 'payment mode');
    //   _showDialog('DrinkLink', 'Failed payment!');
    // } else {
    //   print((result).toString().toLowerCase() + 'payment mode');
    //   _showDialog('DrinkLink', 'Failed payment!');
    // }
    //}
  }

  checkUrlRes(String code) async {
    await Prefs.load();
    String billn = billname.text;
    String billa = billadd.text;
    String bille = billemail.text;
    String myurl = 'https://dlpp.somee.com/api/orders/?ref=' + code;
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8"
    };
    final response = await http.get(Uri.parse(myurl), headers: headers);
    var jsondata = json.decode(response.body);

    print(jsondata.toString());
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderDetails('', '')),
      );
    } else {
      Navigator.of(context).pop();
      Alert(
        title: "Something went wrong!",
        content: showDiscount(),
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            color: Colors.deepOrange,
          )
        ],
        context: null,
      ).show();
    }
    //Navigator.of(context).pop();
  }

  double calCulateDecimatPlace(double val) {
    double mySecRoundValue = 0;
    if (val.toString().contains('.')) {
      final dec = val.toString().split(".")[1];
      if (dec.length > 2) {
        if (int.parse(dec[2]) > 5) {
          String firstval = val.toString().split(".")[0];
          String firstvaldec = dec[0];
          String secvaldec = (int.parse(dec[1]) + 1).toString();
          String finalValue = firstval + '.' + firstvaldec + secvaldec;
          mySecRoundValue = double.parse(finalValue);
        } else if (int.parse(dec[2]) == 5) {
          if (int.parse(dec[1]) <= 4) {
            String firstval = val.toString().split(".")[0];
            String firstvaldec = dec[0];
            String secvaldec = (int.parse(dec[1]) + 1).toString();
            String finalValue = firstval + '.' + firstvaldec + secvaldec;
            mySecRoundValue = double.parse(finalValue);
          } else {
            String firstval = val.toString().split(".")[0];
            String firstvaldec = dec[0];
            String secvaldec = (int.parse(dec[1])).toString();

            String finalValue = firstval + '.' + firstvaldec + secvaldec;
            mySecRoundValue = double.parse(finalValue);
          }
        } else if (int.parse(dec[2]) <= 4) {
          String firstval = val.toString().split(".")[0];
          String firstvaldec = dec[0];
          String secvaldec = (int.parse(dec[1])).toString();

          String finalValue = firstval + '.' + firstvaldec + secvaldec;
          mySecRoundValue = double.parse(finalValue);
        } else {
          String firstval = val.toString().split(".")[0];
          String firstvaldec = dec[0];
          String secvaldec = (int.parse(dec[1])).toString();

          String finalValue = firstval + '.' + firstvaldec + secvaldec;
          mySecRoundValue = double.parse(finalValue);
        }
      } else {
        mySecRoundValue = val;
      }
    }
    return mySecRoundValue;
  }

  Future<List<Order>> getOrder() async {
    if (myOrder.length <= 0) {
      setState(() {
        myOrder = [];
      });
    }
    for (var i = 0; i < myDrinks.length; i++) {
      bool _isILike;
      if (myDrinks[i].Quant > 0) {
        var contain =
            myOrder.where((element) => element.drinkId == myDrinks[i].id);
        if (contain.isNotEmpty) {
          _isILike = false;
          if (myDrinks[i].Quant > 0) {
            int m = myOrder.length;
            if (myDrinks[i].ChMixer.length > 0) {
              List element1 = [];
              for (var name1 in contain) {
                for (var name in name1.mxir) {
                  element1.add(name.id);
                }
              }
              List element2 = [];
              for (var name in myDrinks[i].ChMixer) {
                element2.add(name.cmid);
                setState(() {});
              }
              if (element2.every((item) => element1.contains(item))) {
                for (var j = 0; j < m; j++) {
                  bool result =
                      computeList(myDrinks[i].ChMixer, myOrder[j].mxir);
                  print(result);
                  int mj = m - 1;
                  int mjs = 0;
                  if (result) {
                    print("lord please mamen");
                    myOrder[j].Quant = myOrder[j].Quant + myDrinks[i].Quant;
                    j = m;
                  } else if (j == mj && result == false && mjs == 0) {
                    print(mjs);
                    // _showDialog("Drinklink", "Item already selected please select another combo!");
                    print("lord 1");
                    List<MixerOrd> mx = [];
                    for (var z = 0; z < myDrinks[i].ChMixer.length; z++) {
                      MixerOrd mixerOrd = MixerOrd(
                          myDrinks[i].ChMixer[z].cmid,
                          myDrinks[i].ChMixer[z].cprice.toString(),
                          myDrinks[i].ChMixer[z].cname);
                      mx.add(mixerOrd);
                    }
                    Order ord = Order(
                        myDrinks[i].id,
                        myDrinks[i].drinkCategoryId,
                        myDrinks[i].name,
                        myDrinks[i].Quant,
                        myDrinks[i].price,
                        mx,
                        myDrinks[i].origPrice,
                        myDrinks[i].addIce);
                    setState(() {
                      myOrder.add(ord);
                      mjs = 1;
                      j = m;
                    });
                  }
                }
              } else {
                _isILike = true;
                print(2);
                List<MixerOrd> mx = [];
                for (var z = 0; z < myDrinks[i].ChMixer.length; z++) {
                  MixerOrd mixerOrd = MixerOrd(
                      myDrinks[i].ChMixer[z].cmid,
                      myDrinks[i].ChMixer[z].cprice.toString(),
                      myDrinks[i].ChMixer[z].cname);
                  mx.add(mixerOrd);
                }
                Order ord = Order(
                    myDrinks[i].id,
                    myDrinks[i].drinkCategoryId,
                    myDrinks[i].name,
                    myDrinks[i].Quant,
                    myDrinks[i].price,
                    mx,
                    myDrinks[i].origPrice,
                    myDrinks[i].addIce);
                setState(() {
                  myOrder.add(ord);
                });
              }
            } else {
              bool allowAdd = true;
              for (var j = 0; j < m; j++) {
                List<MixerOrd> mx = [];
                var contain = myOrder.where((element) =>
                    element.drinkId == myDrinks[i].id &&
                    element.aIce == myDrinks[i].addIce);
                bool result1 =
                    computeList(myDrinks[i].ChMixer, myOrder[j].mxir);
                if (result1 &&
                    myDrinks[i].id == myOrder[j].drinkId &&
                    myDrinks[i].addIce == myOrder[j].aIce) {
                  print("lord please");
                  int quantOrder = 0;
                  quantOrder = myOrder[j].Quant + myDrinks[i].Quant;
                  myOrder[j].Quant = quantOrder;
                  j = m;
                  allowAdd = true;
                  myOrder.removeWhere((element) =>
                      element.Quant < quantOrder &&
                      element.drinkId == myDrinks[i].id &&
                      element.aIce == myDrinks[i].addIce &&
                      element.mxir.length <= 0);
                } else if (allowAdd &&
                    contain.isNotEmpty &&
                    myDrinks[i].id == myOrder[j].drinkId &&
                    myDrinks[i].addIce == myOrder[j].aIce &&
                    myDrinks[i].ChMixer.length == 0 &&
                    myOrder[j].mxir[0].id != "") {
                  print("ani raka" + myOrder[j].mxir[0].id);
                  print(contain.length);
                  Order ord = Order(
                      myDrinks[i].id,
                      myDrinks[i].drinkCategoryId,
                      myDrinks[i].name,
                      myDrinks[i].Quant,
                      myDrinks[i].price,
                      mx,
                      myDrinks[i].origPrice,
                      myDrinks[i].addIce);
                  print("mao ni siya" + mx.toString());
                  setState(() {
                    myOrder.add(ord);
                    allowAdd = false;
                  });
                } else if (myDrinks[i].id == myOrder[j].drinkId &&
                    myDrinks[i].addIce != myOrder[j].aIce) {
                  Order ord = Order(
                      myDrinks[i].id,
                      myDrinks[i].drinkCategoryId,
                      myDrinks[i].name,
                      myDrinks[i].Quant,
                      myDrinks[i].price,
                      mx,
                      myDrinks[i].origPrice,
                      myDrinks[i].addIce);
                  print("mao ni siya" + mx.toString());
                  setState(() {
                    myOrder.add(ord);
                  });
                }
              }
            }
          }
        } else {
          if (myDrinks[i].ChMixer.length != 0) {
            _isILike = true;
            List<MixerOrd> mx = [];
            for (var z = 0; z < myDrinks[i].ChMixer.length; z++) {
              MixerOrd mixerOrd = MixerOrd(
                  myDrinks[i].ChMixer[z].cmid,
                  myDrinks[i].ChMixer[z].cprice.toString(),
                  myDrinks[i].ChMixer[z].cname);
              mx.add(mixerOrd);
            }
            Order ord = Order(
                myDrinks[i].id,
                myDrinks[i].drinkCategoryId,
                myDrinks[i].name,
                myDrinks[i].Quant,
                myDrinks[i].price,
                mx,
                myDrinks[i].origPrice,
                myDrinks[i].addIce);
            setState(() {
              myOrder.add(ord);
            });
          } else {
            List<MixerOrd> mx = [];
            Order ord = Order(
                myDrinks[i].id,
                myDrinks[i].drinkCategoryId,
                myDrinks[i].name,
                myDrinks[i].Quant,
                myDrinks[i].price,
                mx,
                myDrinks[i].origPrice,
                myDrinks[i].addIce);
            setState(() {
              myOrder.add(ord);
            });
          }
        }
      }
    }

    return myOrder;
  }

  bool computeList(List<chossenMixer> temp1, List<MixerOrd> temp2) {
    List element3 = [];
    for (var name in temp1) {
      element3.add(name.cmid);
    }
    List element4 = [];
    for (var name in temp2) {
      element4.add(name.id);
      setState(() {});
    }
    if (const IterableEquality().equals(element3, element4)) {
      return true;
    } else {
      return false;
    }
  }

  bool computeIce(List<Drinks> temp1, List<Order> temp2) {
    List element3 = [];
    for (var name in temp1) {
      element3.add(name.addIce);
    }
    List element4 = [];
    for (var name in temp2) {
      element4.add(name.aIce);
      setState(() {});
    }
    if (const IterableEquality().equals(element3, element4)) {
      return true;
    } else {
      return false;
    }
  }

  bool computeList1(List<Drinks> temp1, List<Order> temp2) {
    List element3 = [];
    for (var name in temp1) {
      element3.add(name.id);
    }
    List element4 = [];
    for (var name in temp2) {
      element4.add(name.drinkId);
      setState(() {});
    }
    if (const IterableEquality().equals(element3, element4)) {
      return true;
    } else {
      return false;
    }
  }

  callcompute() async {
    finaltot = 0;
    totalqty = 0;
    for (var i = 0; i < myOrder.length; i++) {
      double tot = double.parse(myOrder[i].Price) * myOrder[i].Quant;
      int qty = myOrder[i].Quant;
      setState(() {
        finaltot = finaltot + tot;
        totalqty = totalqty + qty;
      });
    }

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      orderlenght = 0;
      temporder.clear();
      _pcb = false;
      myDrinks = [];
      myTempCart = getDrinks();
    });
  }
}

class Store {
  final String id;
  final String Name;
  final String Description;
  final String ImageUrl;
  final String cat;

  Store(this.id, this.Name, this.Description, this.ImageUrl, this.cat);
}

class SubMenu {
  final String id;
  final String name;
  final String image;
  final String facility;

  SubMenu(this.id, this.name, this.image, this.facility);
}

class Drinks {
  final String drinkid;
  final String id;
  final String name;
  final String desciption;
  String price;
  int Quant;
  final String drinkCategoryId;
  final List<Mixer> mixer;
  String mid;
  String mprice;
  String origPrice;
  List<chossenMixer> ChMixer;
  String imagePath;
  bool allowIce;
  bool addIce;

  Drinks(
      this.drinkid,
      this.id,
      this.name,
      this.desciption,
      this.price,
      this.Quant,
      this.drinkCategoryId,
      this.mixer,
      this.mid,
      this.mprice,
      this.origPrice,
      this.ChMixer,
      this.imagePath,
      this.allowIce,
      this.addIce);
}

class chossenMixerMultipleQty {
  String indId;
  String cmid;
  String cname;
  String cprice;

  chossenMixerMultipleQty(this.indId, this.cmid, this.cname, this.cprice);
}

class chossenMixerMultiple {
  String indId;
  String cmid;
  String cname;
  String cprice;

  chossenMixerMultiple(this.indId, this.cmid, this.cname, this.cprice);
}

class chossenMixerMultipleRemoved {
  String indId;
  String cmid;
  String cname;
  String cprice;

  chossenMixerMultipleRemoved(this.indId, this.cmid, this.cname, this.cprice);
}

class chossenMixer {
  String indId;
  String cmid;
  String cname;
  String cprice;

  chossenMixer(this.indId, this.cmid, this.cname, this.cprice);
}

class Mixer {
  final int id;
  String name;
  final String ismSelect;
  final List<MixerCat> mx;

  Mixer(this.id, this.name, this.ismSelect, this.mx);
}

class MixerCat {
  final String id;
  final String name;
  final String price;

  MixerCat(this.id, this.name, this.price);
}

class TempOrder {
  final String id;
  final String CatId;
  final String Name;
  int Quant;
  final String Price;

  TempOrder(this.id, this.CatId, this.Name, this.Quant, this.Price);
}

class Order {
  final String drinkId;
  final String CatId;
  final String Name;
  int Quant;
  final String Price;
  List<MixerOrd> mxir;
  final String origPrice;
  bool aIce;
  Order(this.drinkId, this.CatId, this.Name, this.Quant, this.Price, this.mxir,
      this.origPrice, this.aIce);
}

class MixerOrd {
  String id;
  String price;
  String name;

  MixerOrd(this.id, this.price, this.name);
}

class UserORder {
  final String CatId;
  final String Name;
  int Quant;
  final String Price;

  UserORder(this.CatId, this.Name, this.Quant, this.Price);

  Map toJson() => {'id': CatId, 'name': Name, 'quant': Quant, 'price': Price};
}

class Table {
  final String tableid;
  final String tablename;

  Table(this.tableid, this.tablename);
}

class Discount {
  final String discountid;
  final String discountname;
  final double discountpercentage;

  Discount(this.discountid, this.discountname, this.discountpercentage);
}

class PayOrder {
  String id;
  String catid;
  String price;

  PayOrder(this.id, this.catid, this.price);

  Map toJson() => {
        'id': id,
        'drinkCategoryId': catid,
        'price': price,
      };
}

class PayMixer {
  String id;
  String price;

  PayMixer(this.id, this.price);

  Map toJson() => {
        'id': id,
        'price': price,
      };
}

class PayDrinks {
  String quantity;
  String price;
  PayOrder payOrd;
  List<PayMixer> mixOrd = [];
  bool ice;

  PayDrinks(this.quantity, this.price, this.ice, [this.payOrd, this.mixOrd]);

  Map toJson() {
    var mix = jsonEncode(this.mixOrd);
    Map author = this.payOrd != null ? this.payOrd.toJson() : null;
    // Map mi = mix.map != null ? mix.length : null;
    print(this.mixOrd);
    if (mix == null) {
      return {
        'drink': author,
        'quantity': quantity,
        'price': price,
        'withIce': ice
      };
    } else {
      return {
        'drink': author,
        'selectedMixers': this.mixOrd,
        'quantity': quantity,
        'price': price,
        'withIce': ice
      };
    }
  }
}

class CardDetails {
  final String cardid;
  final String maskedPan;
  final String expiry;
  final String cardholderName;
  final String scheme;
  final String cardToken;
  bool select;
  final String showmask;

  CardDetails(this.cardid, this.maskedPan, this.expiry, this.cardholderName,
      this.scheme, this.cardToken, this.select, this.showmask);
}
