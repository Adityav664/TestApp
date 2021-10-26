import 'dart:convert';
import 'models/userlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: Room(),
    ));

class Room extends StatefulWidget {
  const Room({Key? key}) : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final TextEditingController searchcontroller = TextEditingController();
  List<User> users=[];
  var data=null;
  bool loading = false;
  @override
  Widget build(BuildContext context) {

    final TextEditingController searchcontroller = TextEditingController();
    bool searchlist=false;
    Future<Object> list;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Room"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 60,
                color: Colors.grey[100],
                child: Container(
                  margin:const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius:const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child:Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      controller: searchcontroller,
                      decoration:InputDecoration(
                        border: InputBorder.none,
                        contentPadding:const EdgeInsets.only(left: 10),
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          )
                      ),
                      onChanged: (value){
                        print(value);
                        getdata(value);
                        // setState(() {
                        //   data=value;
                        // });
                      },
                      
                    ),
                  )
                ),
              ),
              // Expanded(child: FutureBuilder<List<User?>>(
              //   future: getdata(data),
              //   builder: (context,snapshot){
              //     if(snapshot.connectionState==ConnectionState.waiting){
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //     return ListView.builder(
              //       itemCount: snapshot.data?.length,
              //       itemBuilder:(context,index){
              //         final user=snapshot.data?[index];
              //       return ListTile(
              //         title: Text(user?.name??""),
              //       );
              //     }
              //     );
              //   }
              //   ))
              Expanded(
                child: loading ?
                const Center(child:CircularProgressIndicator())
                :ListView.builder(
                  itemCount: users.length,
                  itemBuilder:(context,index){
                    final user=users[index];
                    return Text(user.name ?? "");
                  }
                  )
              )
            ],
          )
        )
      )
    );
  }

  getdata(String value) async {
    print(value);
    setState(() {
      loading=true;
      searchcontroller.text=value;

    });
    List<User> listdata =[];
    var url = Uri.parse('https://codeeditor-backend.herokuapp.com/api/list/');
      var response = await http.post(url, body: {
        "username": value,
      });
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body) ?? [];
        for (var element in data) {
          listdata.add(User.fromMap(element));
        }
        setState(() {
          loading=false;
          users=listdata;
          searchcontroller.text=value;
        });
      }
      //print(response.body);
      // setState(() {
      //   data=response.body;
      // });
  }

  // Future<List<User?>> getdata(String value) async {
  //   print(value);
  //   try {
  //     List<User?> users = [];
  //     var url = Uri.parse('https://codeeditor-backend.herokuapp.com/api/list/');
  //     var response = await http.post(url, body: {
  //       "username": value,
  //     });

  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body) ?? [];
  //       for (var element in data) {
  //         users.add(User.fromMap(element));
  //       }
  //     }
  //     return users;
  //   } catch (error) {
  //     print('Error getting users ${error.toString()}');
  //     rethrow;
  //   }

   
  // }
}

