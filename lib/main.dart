import 'package:flutter/material.dart';
import 'package:my_app/about.dart';
import 'package:my_app/contact.dart';
import 'package:my_app/home.dart';
import 'package:my_app/school.dart';
// import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: const MySeetingpage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        titleSpacing: 20.0,
        toolbarHeight: 70.0,
        toolbarOpacity: 0.5,
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Fluttertoast.showToast(
        //         msg: "Hello Robiul! This is a Toast",
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.BOTTOM,
        //         backgroundColor: Colors.black,
        //         textColor: Colors.white,
        //       );
        //     },
        //     icon: Icon(Icons.search),
        //   ),
        //   IconButton(
        //     onPressed: () {
        //       Fluttertoast.showToast(
        //         msg: 'Hey Robiul Whats Up',
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.BOTTOM,
        //         backgroundColor: Colors.black,
        //         textColor: Colors.white,
        //       );
        //     },
        //     icon: Icon(Icons.car_crash),
        //   ),
        //   IconButton(
        //     onPressed: () => {
        //       Fluttertoast.showToast(
        //         msg: 'Location Tracked',
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.BOTTOM,
        //         backgroundColor: Colors.lightGreenAccent,
        //         textColor: Colors.black,
        //       ),
        //     },
        //     icon: Icon(Icons.location_on),
        //   ),
        //   SizedBox(width: 10),
        // ],
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: 200.00,
          color: Color.fromARGB(255, 100, 150, 200),
          child: Center(
            child: Text(
              "Hello",
              style: TextStyle(
                fontSize: 40,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      endDrawer: MyDrawer(),
      bottomNavigationBar: MyBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.wechat_sharp, color: Colors.green),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Robiul'),
            accountEmail: Text('arafat@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/file.jpg',
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.pop(context)},
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
            // iconColor: Colors.blue,
            onTap: () => {Navigator.pop(context)},
          ),
          ListTile(
            leading: Icon(Icons.money_sharp),
            title: Text('Money'),
            // iconColor: Colors.blue,
            onTap: () => {Navigator.pop(context)},
          ),
        ],
      ),
    );
  }
}

int currentIndex = 0;

final List<Widget> _pages = [
  MyHomePage(),
  MyAboutPage(),
  MySchoolPage(),
  MyContactPage(),
];

//MySettingPage
class MySeetingpage extends StatefulWidget {
  @override
  State<MySeetingpage> createState() => _MySeetingpageState();
}

class _MySeetingpageState extends State<MySeetingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(() {
            currentIndex = index;
          }),
        },

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
        ],
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
