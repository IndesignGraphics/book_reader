import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height-150,
          width: double.infinity,
          child: Column(
            children: const [
              // Image.asset('assets/images/about_us.jpg'),
              SizedBox(height: 20,),
              Text('Developed By',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Name : Patel Gautam Manilal',style: TextStyle(),),
              SizedBox(height: 5,),
              Text('Mobile Number : +91 81559 77453',style: TextStyle(),),
              SizedBox(height: 5,),
              Text('Email ID : methaniyagautam@gmail.com',style: TextStyle(),),
              SizedBox(height: 20,),
              Text('Other Team Members',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('1. Om Sorathiya : +91 97379 48264',style: TextStyle(),),
              SizedBox(height: 5,),
              Text('2. Rohan Kabariya : +91 63532 41438',style: TextStyle(),),
            ],
          ),
        ),
      ),
    );
  }
}
