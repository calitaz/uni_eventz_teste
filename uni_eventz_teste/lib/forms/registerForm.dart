import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  bool _autoValidate = false;
  bool _verSenha = true;

  String _nome;
  String _email;
  String _senha;
  String confirmaSenha;

  void initState() {
    super.initState();
  }

  void _validateRegister() async{
    final FormState registerForm = _registerKey.currentState;
    if(registerForm.validate()){
      registerForm.save();
      try{
        var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email, password: _senha);
        var _id = result.user.uid;
        Firestore.instance.collection('usuarios').document(_id).setData(
          {
            'nome': _nome,
            'email': _email
          }
        );
        Navigator.pushNamed(context, '/front');
      }catch(error){
        print(error);
      }
    }else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validaNome(String value){
    if(value.isEmpty) {
      return "Digite seu nome";
    }else if(value.length < 3){
      return "Digite um nome válido";
    }else {
      return null;
    }
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

  String validaSenha(String value){
    if(value.isEmpty) {
      return "Digite sua senha";
    }else if(value.length < 6){
      return "Senha com menos de 6 caracteres";
    }else {
      return null;
    }
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
        key: _registerKey,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.signature, color: Color(0xFF6078ea)),
                  hintText: "digite seu nome",
                  labelText: "Nome",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6078ea),
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  labelStyle: TextStyle(color: Color(0xFF6078ea)),
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) => _nome = value,
                validator: validaNome,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.envelope, color: Color(0xFF6078ea)),
                  hintText: "digite seu e-mail",
                  labelText: "E-mail",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6078ea),
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  labelStyle: TextStyle(color: Color(0xFF6078ea)),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value,
                validator: validaEmail,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.lock, color: Color(0xFF6078ea)),
                  hintText: "digite sua senha",
                  labelText: "Senha",
                  helperText: "deve conter no mínimo de 6 caracteres",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6078ea),
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  labelStyle: TextStyle(color: Color(0xFF6078ea)),
                  suffixIcon: IconButton(
                    icon: _verSenha ? Icon(Icons.visibility, color: Color(0xFF6078ea)) : Icon(Icons.visibility_off,color:  Color(0xFF6078ea).withOpacity(.70)),
                    onPressed: _viewPassword,
                  ),
                ),
                obscureText: _verSenha,
                keyboardType: TextInputType.text,
                key: _passKey,
                onSaved: (value) => _senha = value,
                validator: validaSenha,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.lock, color: Color(0xFF6078ea)),
                  hintText: "digite sua senha novamente",
                  labelText: "Confirmar senha",
                  helperText: "deve ser igual a senha digitada acima",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6078ea),
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  labelStyle: TextStyle(color: Color(0xFF6078ea)),
                  suffixIcon: IconButton(
                    icon: _verSenha ? Icon(Icons.visibility, color: Color(0xFF6078ea)) : Icon(Icons.visibility_off,color:  Color(0xFF6078ea).withOpacity(.70)),
                    onPressed: _viewPassword,
                  ),
                ),
                keyboardType: TextInputType.text,
                obscureText: _verSenha,
                onSaved: (value) => confirmaSenha = value,
                validator: (value) {
                  var password = _passKey.currentState.value;
                  if(value != password){
                    return "Senhas não conferem";
                  }else if(value.isEmpty){
                    return "Confirme sua senha";
                  }else {
                    return null;
                  }
                }
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF6078ea),
                  Color(0xFF17ead9)
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
                  onTap: _validateRegister,
                  child: Center(
                    child: Text("Registrar",
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
            SizedBox(height: 20),
          ],
        ),
      )
    );
  }
}