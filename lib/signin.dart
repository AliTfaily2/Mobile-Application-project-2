import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class SignIn extends StatefulWidget {

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void dispose(){
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: h * 0.2,),
            SizedBox(width: w * 0.8,child: TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your username'
              ),
              validator: (String? value){
                if(value == null || value.isEmpty){
                  return 'Please Enter username';
                }else{
                  return null;
                }
              },
            ),),
            const SizedBox(height: 10,),
            SizedBox(width: w * 0.8,child: TextFormField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password'
              ),
              validator: (String? value){
                if(value == null || value.isEmpty){
                  return 'Please Enter password';
                }else{
                  return null;
                }
              },
            ),)
          ],
        ),
      ),
    );
  }
}
