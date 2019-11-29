import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {

  final _loginKey = GlobalKey<FormState>();
  bool _verSenha = true;
  bool _autoValidate = false;

  String _email;
  String _senha;

  void initState() {
    super.initState();
  }

  void _validateLogin() async{
    final FormState loginForm = _loginKey.currentState;
    if(loginForm.validate()){
      loginForm.save();
       try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _senha);
          Navigator.of(context).pushReplacementNamed('/home');
        } catch (error) {
          print(error);
      }
    }else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _loginGuest() {
    FirebaseAuth.instance
                .signInAnonymously()
                .then((AuthResult user){
                  print(user);
                  Navigator.of(context).pushReplacementNamed('/home');
                }).catchError((e){
                  print(e);
                });
  }

  String validaEmail(String value) {
    Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return "Digite seu e-mail";
    if (!regex.hasMatch(value))
      return "Digite um e-mail válido";
    else
      return null;
  }

  void _viewPassword(){
    setState(() {
     _verSenha = !_verSenha; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
      key: _loginKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 25),
          Container(
            margin: EdgeInsets.only(left: 30),
            padding: EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("E-mail de usuário",style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0,15.0),
                  blurRadius: 15.0
                ),
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0,-1.0),
                  blurRadius: 1.0
                )
              ]
            ),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                prefixIcon: Icon(Icons.person_outline, color: Color(0xFF6078ea),),
                border: InputBorder.none,
                hintText: "Seu e-mail",
                hintStyle: TextStyle(color: Colors.grey)
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _email = value,
              validator: validaEmail,
            ),
          ),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.only(left: 30),
            padding: EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Senha",style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0,15.0),
                  blurRadius: 15.0
                ),
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0,-1.0),
                  blurRadius: 1.0
                )
              ]
            ),
            child:  TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                prefixIcon: Icon(Icons.lock_outline, color:  Color(0xFF6078ea),),
                suffixIcon: IconButton(
                  icon: _verSenha ? Icon(Icons.visibility, color: Color(0xFF6078ea)) : Icon(Icons.visibility_off,color:  Color(0xFF6078ea).withOpacity(.70)),
                  onPressed: _viewPassword,
                ),
                border: InputBorder.none,
                hintText: "Sua senha",
                hintStyle: TextStyle(color: Colors.grey)
              ),
              obscureText: _verSenha,
              keyboardType: TextInputType.text,
              onSaved: (value) => _senha = value,
            ),
          ),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF17ead9),
                Color(0xFF6078ea)
              ]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6078ea).withOpacity(.3),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0
                )
              ]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  _validateLogin();
                },
                child: Center(
                  child: Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-bold",
                      fontSize: 18,
                      letterSpacing: 1.0
                    )
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: 1.0,
              color: Colors.black26,
            ),
          ),
          SizedBox(height: 15,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1.0,
                color: Color(0xFF6078ea),
              )
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _loginGuest(),
                child: Center(
                  child: Text("Entrar anônimo", 
                    style: TextStyle(
                      color: Color(0xFF6078ea),
                      fontFamily: "Poppins-bold",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.6
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20, left: 100, right: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(FontAwesomeIcons.facebookF, color: Color(0xFF6078ea),),
                Icon(FontAwesomeIcons.google, color: Color(0xFF6078ea)),
                Icon(FontAwesomeIcons.twitter, color: Color(0xFF6078ea))
              ],
            ),
          )
        ],
        ),
        autovalidate: _autoValidate,
      )
    );
  }
}
