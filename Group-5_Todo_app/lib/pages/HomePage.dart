// ignore_for_file: deprecated_member_use

import 'package:firebase_app_web/Service/Auth_Service.dart';
import 'package:firebase_app_web/main.dart';
import 'package:firebase_app_web/pages/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'create_task.dart';
import 'detailsPage.dart';

List<Map> todosList = [];
List<Map> displayables = [];
var completedVar = 0, pendingVar = 0;

class HomePage extends StatefulWidget {
  // Declare a field that holds the Todo.
  final useremail;
  HomePage({Key key, String user, this.useremail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(useremail);
}

class _HomePageState extends State<HomePage> {
  var useremail;
  _HomePageState(this.useremail);

  void getData() async {
    http.Response response =
        await http.get(Uri.parse('https://gorest.co.in/public/v2/todos'));
    if (response.statusCode == 200) {
      var data = response.body;
      var todos = jsonDecode(data);
      for (int i = 0; i < 20; i++) {
        var formattedDate =
            DateFormat("yyyy-MM-dd", "en_US").parse(todos[i]['due_on']);
        todos[i]['due_on'] = formattedDate.toString();
        var tasks = todos[i];

        setState(() {
          todosList.add(tasks);
          displayables = todosList;
        });

        if (todos[i]['status'] == 'completed') {
          completedVar++;
        } else {
          pendingVar++;
        }
      }
      print("Hello world");
      print(todosList[0]['title']);
    }
  }

  AuthClass authClass = AuthClass();
  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.indigo,
        actions: [
          Center(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 17),
            ),
          ),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authClass.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignInPage()),
                    (route) => true);
              }),
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text(
                "Username",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              accountEmail: new Text(useremail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/lapi_books.jpg'),
              ),
              decoration: new BoxDecoration(color: Colors.blueGrey),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Authenticated User'),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Details'),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit'),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Row(
          children: [
            ///Container for Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ToDo LIST",
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey[200]),
                    ),

                    ///For spacing
                    SizedBox(
                      height: 4,
                    ),

                    Row(
                      children: [
                        ///Text
                        Text(
                          "Get To Work",
                          style: TextStyle(
                            fontSize: 50,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),

                        Spacer(),

                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total Todos: " + todosList.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "completed: " + completedVar.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Pending: " + pendingVar.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    ///List of all the task
                    todosList != []
                        ? Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? _searchbar(index)
                                      : _listItem(index - 1);
                                },
                                separatorBuilder: (context, index) => Divider(
                                      height: 16,
                                      color: Colors.transparent,
                                    ),
                                itemCount: displayables.length + 1),
                          )
                        : CircularProgressIndicator,

                    ///For spacing
                    SizedBox(
                      height: 16,
                    ),

                    ///Button for add new task
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: Colors.grey,
                        child: Text(
                          "ADD NEW TASK",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateTaskScreen()));
                        },
                        splashColor: Color.fromARGB(255, 171, 208, 212),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _searchbar(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'search todos...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            displayables = todosList.where((tods) {
              var todoTitle = todosList[index]['title'].toLowerCase();
              if (index == todosList.length) {
                index = index;
              } else {
                index++;
              }

              return todoTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey[100]),
            color: displayables[index]['status'] == 'completed'
                ? Colors.indigo
                : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Show completed check
            ///Task Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    displayables[index]['title'],
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: displayables[index]['status'] == 'completed'
                            ? Colors.white
                            : Colors.grey[800]),
                  ),
                ),

                ///For Space

                SizedBox(
                  width: 4,
                ),

                displayables[index]['status'] == 'completed'
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      )
                    : Container()
              ],
            ),

            ///For Space
            SizedBox(
              height: 8,
            ),

            ///Task Detail
            Row(
              children: [
                Text(
                  displayables[index]['due_on'],
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: displayables[index]['status'] == 'completed'
                          ? Colors.white70
                          : Colors.grey[500]),
                ),
                Spacer(),
                displayables[index]['status'] == 'completed'
                    ? Text(
                        "COMPLETED",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Colors.white),
                      )
                    : Text(
                        displayables[index]['status'].toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: displayables[index]['status'] == 'completed'
                                ? Colors.white70
                                : Colors.grey[700]),
                      ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (DetailsPage(
                      todo: displayables[index],
                    ))));
      },
    );
  }
}
