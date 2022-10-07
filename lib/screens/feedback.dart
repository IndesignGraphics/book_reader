import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String name, number, feedback;
  final url =
      "https://book-reader-7ae88-default-rtdb.asia-southeast1.firebasedatabase.app/feedback.json";

  Future<void> _saveForm(BuildContext context) async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "name": name,
        "mobileNumber": number,
        "feedback": feedback,
        "time": timeStamp.toIso8601String(),
      }),
    );
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      if(!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your valuable feedback submitted successfully.'),
        ),
      );
    } else {
      if(!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong! Try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formkey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: 'Enter your full name',
                            labelText: 'Full Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value.toString();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: 'Enter your mobile number',
                            labelText: 'Mobile Number',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (value.length != 10) {
                              return 'Enter a valid mobile number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            number = value.toString();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: 'Enter your feedback here',
                            labelText: 'Feedback',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter feedback';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            feedback = value.toString();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await _saveForm(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text('SUBMIT')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
