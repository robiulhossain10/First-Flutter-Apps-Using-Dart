import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      home: const HomePage(),
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
        actions: [
          IconButton(onPressed: (){
           Fluttertoast.showToast(msg: "Hello Robiul! This is a Toast",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           backgroundColor: Colors.white,
           textColor: Colors.white
           );
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () => {
            print("Car..............")
          }, icon: Icon(Icons.car_crash)),
          IconButton(onPressed: () => {
            print("Location")
          }, icon: Icon(Icons.location_on))
        ],
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
    );
  }
}
