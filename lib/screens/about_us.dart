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
          child: Column(
            children: [
              Image.asset('assets/images/about_us.jpg'),
              const SizedBox(height: 20,),
              const Text('Developed By',style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              const Text('Name : Patel Gautam Manilal',style: TextStyle(),),
              const SizedBox(height: 5,),
              const Text('Mobile Number : +91 81559 77453',style: TextStyle(),),
              const SizedBox(height: 5,),
              const Text('Email ID : methaniyagautam@gmail.com',style: TextStyle(),),
              const SizedBox(height: 20,),
              const Text('Other Team Members',style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              const Text('1. Om Sorathiya : +91 97379 48264',style: TextStyle(),),
              const SizedBox(height: 5,),
              const Text('2. Rohan Kabariya : +91 63532 41438',style: TextStyle(),),
            ],
          ),
        ),
      ),
    );
  }
}
