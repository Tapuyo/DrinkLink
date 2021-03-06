import 'dart:convert';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/orderdetails.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class orderPage extends StatefulWidget {
  @override
  _setPageState createState() => _setPageState();
}

class _setPageState extends State<orderPage> {
  List<Order> orderList = [];
  Future ord;
  String selectS = "Date";
  List<Person> persons = [
    Person(gender: "DATE", url: "https://images.unsplash.com/photo-1555952517-2e8e729e0b44"),
    Person(gender: "PLACE", url: "https://images.unsplash.com/photo-1555952517-2e8e729e0b44"),
    Person(gender: "STATUS", url: "https://images.unsplash.com/photo-1555952517-2e8e729e0b44"),
  ];

  Person selectedPerson;

  @override
  void initState() {
    // TODO: implement initState
        super.initState();
        selectedPerson = persons[0];
        orderList = [];
        ord = getOrders();
  }

  Future<List<Order>> getOrders() async{
   setState(() {
     orderList = [];
   });
    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    Map<String, String> headers = {"Content-Type": "application/json", 'Authorization': 'Bearer ' + token};
    final response = await http.get('https://drinklink-prod-be.azurewebsites.net/api/users/currentUser/orders?pageSize=20&pageNumber=1',headers: headers);
    var jsondata = json.decode(response.body);


    print(json.decode(response.body));
    for (var i = 0; i < jsondata.length ; i++){

      var jsondata1 = await json.decode(response.body)[i]['items'];

      List <MyItems> newItem = [];
      for (var x in jsondata1){
        MyItems nt = new MyItems(x['drink']['name'], x['quantity'].toString());

        newItem.add(nt);

      }
      String st = json.decode(response.body)[i]['timestamp'].toString();

      String dt = '';
      String stt = '';
      final toDayDate = DateTime.now();
      var different = toDayDate.difference(DateTime.parse(st)).inMinutes;
      if(different < 60){
        dt = toDayDate.difference(DateTime.parse(st)).inMinutes.toString() + ' mins';
      }else if(different > 60 && different < 1440){
        dt = toDayDate.difference(DateTime.parse(st)).inHours.toString() + ' hours';
      }else{
        dt = toDayDate.difference(DateTime.parse(st)).inDays.toString() + ' days';
      }
      String bar = json.decode(response.body)[i]['tableId'].toString();
      if(bar == null || bar == 'null'){
        bar = '';
      }
      String cState = json.decode(response.body)[i]['currentState'].toString();
      if(cState == '0'){
        stt = 'Order Created';
      }else if(cState == '1'){
        stt = 'Pending';
      }else if(cState == '2'){
        stt = 'Accepted';
      }else if(cState == '3'){
        stt = 'Payment Processed';
      }else if(cState == '4'){
        stt = 'Ready';
      }else if(cState == '5'){
        stt = 'Completed';
      }else if(cState == '101'){
        stt = 'Failed';
      }else if(cState == '102'){
        stt = 'Canceled';
      }else if(cState == '103'){
        stt = 'Rejected';
      }else if(cState == '104'){
        stt = 'Not Collected';
      }else if(cState == '105'){
        stt = 'Payment Failed';
      }

      setState(() {
        Order myorder = new Order(json.decode(response.body)[i]['id'].toString(),dt.toString(),newItem,bar,stt,cState);

        orderList.add(myorder);
      });

    }
    return orderList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2b61),
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text("View Orders",style: TextStyle(fontSize: 20, color: Colors.white),),
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),

      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [

              // DropDown<Person>(
              //   items: persons,
              //
              //   //hint: Text("Select"),
              //   initialValue: persons.first,
              //   onChanged: (Person p) {
              //     print(p?.gender);
              //     setState(() {
              //       selectedPerson = p;
              //     });
              //   },
              //   isCleared: selectedPerson == null,
              //   customWidgets: persons.map((p) => buildDropDownRow(p)).toList(),
              //   isExpanded: true,
              // ),
              mybody(),
            ],
          )
        ),
      ),

    );
  }
  mybody(){
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: FutureBuilder(
          future: getOrders(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return  GestureDetector(
                      onTap: (){

                      },
                      child:Card(
                        child: Container(
                          color: Color(0xFF3e3e66),
                            height: 200,
                            width: MediaQuery.of(context).size.width - 20,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  color: Color(0xFF303052),
                                  child: Row(
                                    children: [
                                      Text('#' + snapshot.data[index].barid.toString() + ' Bar',style: TextStyle(color: Colors.white, fontSize: 14),),
                                      Spacer(),
                                      Text(snapshot.data[index].timestamp.toString() + ' ago',style: TextStyle(color: Colors.white, fontSize: 14),),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                  //visible: snapshot.data[index].mixer == null ? false:true,
                                  child: snapshot.data[index].itemslist != null ? Container(
                                      height:  snapshot.data[index].itemslist == null ? 0:50,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            getTextWidgets(snapshot.data[index].itemslist, index),
                                            SizedBox(width: 10,)
                                          ]


                                      )
                                  ):null,

                                ),

                                showSated(snapshot.data[index].id,snapshot.data[index].cState,snapshot.data[index].sttn)

                              ],
                            )
                        ),
                      ),
                    );
                  }
              );

            }
          }

      ),
    );
  }

  showSated(String id,stt,stn){
    if(stn == '0'){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width ,

          child: Container(
              color: Colors.green.withOpacity(.2),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
      );
    }else if(stn == '1'){
      return GestureDetector(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderDetails(id)),
          );
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            width: MediaQuery.of(context).size.width ,

            child: Container(
                color: Colors.green.withOpacity(.5),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
        ),
      );
    }else if(stn == '2'){
      return GestureDetector(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderDetails(id)),
          );
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            width: MediaQuery.of(context).size.width ,

            child: Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
        ),
      );
    }else if(stn == '3'){
      return GestureDetector(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderDetails(id)),
          );
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            width: MediaQuery.of(context).size.width ,

            child: Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
        ),
      );
    }else if(stn == '4'){
      return GestureDetector(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderDetails(id)),
          );
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            width: MediaQuery.of(context).size.width ,

            child: Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
        ),
      );
    }else if(stn == '5'){
      return GestureDetector(
        onTap: (){
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => OrderDetails(id)),
          // );
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            width: MediaQuery.of(context).size.width ,

            child: Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
        ),
      );
    }else if(stn == '101'){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width ,

          child: Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
      );
    }else if(stn == '102'){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width ,

          child: Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
      );
    }else if(stn == '103'){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width ,

          child: Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
      );
    }else if(stn == '104'){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width ,

          child: Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
      );
    }else if(stn == '105'){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width ,

          child: Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(child: Text(stt.toString(),style: TextStyle(color: Colors.white, fontSize: 20),)))
      );
    }

  }


  Widget getTextWidgets(List<MyItems> strings, int ind)
  {
    int select;
    List<Widget> list = new List<Widget>();

    for(var i = 0; i < strings.length; i++){
      list.add(

          Container(
            padding: EdgeInsets.fromLTRB(0,0,10,0),
            child: GestureDetector(
              onTap: (){

              },
              child: new Container(
                // decoration: BoxDecoration(
                //   // borderRadius: BorderRadius.circular(10),
                //   // border: Border.all(
                //   //     color: Colors.white54.withOpacity(.5)
                //   // ),
                //
                // ), //
                padding: EdgeInsets.fromLTRB(10,5,10,5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(strings[i].itemsquantity.toString() + ' x', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 20),),
                        SizedBox(width: 20,),
                        Text(strings[i].itemsname.toString(), style: TextStyle(color: Colors.white,fontSize: 20),),
                      ],
                    ),
                    SizedBox(height: 5,),

                  ],
                ),
              ),
            ),
          )

      );
    }
    return new Row(children: list);
  }

  Row buildDropDownRow(Person person) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(person?.gender ?? "DATE", style: TextStyle(fontSize: 20),)),

      ],
    );
  }

}
class Person {
  final String gender;
  final String name;
  final String url;

  Person({this.name, this.gender, this.url});
}

class Order{
  final String id;
 final String timestamp;
 final List<MyItems> itemslist;
 final String barid;
 final String cState;
 final String sttn;

  Order(this.id,this.timestamp,this.itemslist,this.barid,this.cState,this.sttn);
}
class MyItems{
  final String itemsname;
  final String itemsquantity;

  MyItems(this.itemsname,this.itemsquantity);
}