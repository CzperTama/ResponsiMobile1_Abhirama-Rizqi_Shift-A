import 'package:flutter/material.dart';
import 'package:responsi1/helpers/api.dart';
import 'package:responsi1/helpers/api_url.dart';
import 'package:responsi1/helpers/user_info.dart';
import 'package:responsi1/ui/review_detail.dart';
import 'package:responsi1/ui/registrasi_page.dart';
import 'package:responsi1/widget/warning_dialog.dart';
import 'package:responsi1/helpers/app_exception.dart';
import '../model/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final Api _api = Api('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                _buttonLogin(),
                const SizedBox(height: 30),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return ElevatedButton(
      child: const Text("Login"),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    _api.post(ApiUrl.login, {
      'email': _emailTextboxController.text,
      'password': _passwordTextboxController.text,
    }).then((response) async {
      final login = Login.fromJson(response);
      if (login.isSuccessful) {
        await UserInfo().setToken(login.token ?? '');
        if (login.userId != null) {
          await UserInfo().setUserId(login.userId!);
          await UserInfo().setUserEmail(login.userEmail ?? '');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ReviewDetail()));
        } else {
          _showWarningDialog("Data pengguna tidak valid");
        }
      } else {
        _showWarningDialog("Login gagal: ${login.data ?? 'Terjadi kesalahan'}");
      }
    }).catchError((error) {
      print("Error during login: $error");
      _showWarningDialog("Terjadi kesalahan: ${error.toString()}");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WarningDialog(
        description: message,
        okClick: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()));
        },
      ),
    );
  }
}