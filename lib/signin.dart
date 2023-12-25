import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'home.dart';
import 'register.dart';

const String _baseURL = 'http://alitfaily.000webhostapp.com';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final EncryptedSharedPreferences _encryptedData =
      EncryptedSharedPreferences();
  bool _loading = false;

  void loginconfirm(bool success) {
    if (success) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Home()));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Success')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Failed!')));
    }
    setState(() {
      _loading = false;
    });
  }

  void saveData(String id) {
    _encryptedData.setString('myKey', id);
  }

  void checkSavedData() async {
    _encryptedData.getString('myKey').then((String myKey) {
      if (myKey.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Home()));
      }
    });
  }

  /*@override
  void initState(){
    super.initState();
    checkSavedData();
  }*/
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In Page',
            style: TextStyle(
                fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.2,
                ),
                SizedBox(
                  width: w * 0.8,
                  child: TextFormField(
                    controller: _email,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@._-]'))
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter email';
                      } else if (!RegExp(
                              r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                          .hasMatch(value)) {
                        return 'Please enter a valid Email';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: w * 0.8,
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter password';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        checkLogin(saveData, loginconfirm,
                            _email.text.toString(), _password.text.toString());
                      }
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _loading,
                  child: const CircularProgressIndicator(),
                ),
                GestureDetector(
                    onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Register())
                        );
                    },
                    child: const Text('Don\'t have an account? Register now!',
                        style: TextStyle(
                          color: Colors.black, // Text color
                        ))),
              ],
            ),
          ),
        )));
  }
}

void checkLogin(Function(String id) saveData,
    Function(bool success) loginconfirm, String email, String password) async {
  try {
    final response = await http
        .post(Uri.parse('$_baseURL/mobile/login.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert
                .jsonEncode(<String, String>{'email': email, 'pass': password}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      saveData(row['user_id']);
      loginconfirm(true);
    }
  } catch (e) {
    loginconfirm(false);
  }
}
