import 'dart:convert';

import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:driklink/pages/login/resetpassemail.dart';
import 'package:driklink/pages/login/resetpassword.dart';
import 'package:driklink/pages/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class SignIn extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignIn> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  login() async{
    String em = emailController.text;
    String pss = passController.text;
    print('login');
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map map = {
      'data':{
        "userName": em,
        "password": pss,
      },
    };
    var body = json.encode(map['data']);
    String url = 'https://drinklink-prod-be.azurewebsites.net/api/auth/Token';
    final response = await http.post(url,headers: headers, body: body);

    if(response.statusCode == 200 || response.statusCode == 201){
      String token = json.decode(response.body)['token'];
      print(json.decode(response.body)['token']);
      setState(() {
        Prefs.setString('token', token);
      });
      String asd = Prefs.getString('token');
      print(asd);
      setNotif(token,em);

        setState(() {
          Prefs.load();
          Prefs.setString('bfName', '');
          Prefs.setString('blMame', '');
          Prefs.setString('billName', '');
          Prefs.setString('billAdd', '');
          Prefs.setString('billEmail', '');
        });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      print('200');
    }else{
      Alert(
        context: context,
        title: "Sign in",
        content: Container(
          child: Center(
            child: Text('You have entered an invalid username or password'),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            color: Color(0xFF2b2b61).withOpacity(.7),
          ),

        ],
      ).show();
      print('error');
    }
  }

  setNotif(String su,email)async{

    print(email);
    Prefs.load();
    String ntoken = Prefs.getString('notifToken');
    print("my token: " + ntoken);
    String myt = "'" + ntoken + "'";
    final bod = jsonEncode({'token':  ntoken,'clientAppPlatform': 'ios'});
    Map<String, String> headers = {'Authorization': 'Bearer ' + su,'Content-Type': 'application/json', 'api-version':'1.1'};
    String url = 'https://drinklink-prod-be.azurewebsites.net/api/auth/users/currentUser/notificationToken';

    final response = await http.patch(url,headers: headers, body: bod);
    print('notif response: ');
    print(response.statusCode);
  }

  forgotpassword(String email)async{
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(email);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String url = 'https://drinklink-prod-be.azurewebsites.net/api/auth/users/$encoded/resetcode' ;

    final response = await http.get(url,headers: headers);
    print(response.body.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF2b2b61),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white,size: 30,),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text('SIGN IN', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('Enjoy Drinklink Our Old Friend', style: TextStyle(wordSpacing: 5,color: Colors.deepOrange, fontSize: 16),)
              ),
              Divider(
                color: Colors.deepOrange,
                thickness: 2,
              ),

              Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Text('Enter your credentials and start using app.', style: TextStyle(wordSpacing: 3,color: Colors.white, fontSize: 16),)
              ),
              SizedBox(height: 150,),

              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  controller: emailController,
                  decoration: new InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle: new TextStyle(
                          color: const Color(0xFF424242)
                      )
                  ),

                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  obscureText: true,
                  controller: passController,
                  decoration: new InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle: new TextStyle(
                          color: const Color(0xFF424242)
                      )
                  ),

                ),
              ),


              SizedBox(height: 150,),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: Row(
                  children: [

                    Expanded(
                      child: FlatButton(
                          height: 50,
                          minWidth: double.infinity,
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            login();
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
                              Text('SIGN IN', style: TextStyle(color: Colors.white, fontSize: 18),)
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap:(){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ResetPassEmail()),
                            );
                            // forgotpassword('john@mail.com');
                          },
                          child: Text('Forgot password?', style: TextStyle(color: Colors.white, fontSize: 16),)),

                    ],
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap:(){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Text('NEW USER', style: TextStyle(color: Colors.white, fontSize: 16,decoration: TextDecoration.underline,),)),

                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}


