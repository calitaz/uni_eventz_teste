import 'package:flutter/material.dart';
import 'package:uni_eventz_teste/forms/loginForm.dart';
import 'package:uni_eventz_teste/forms/registerForm.dart';



class FrontPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FrontPageState();
  
}

class _FrontPageState extends State<FrontPage> with SingleTickerProviderStateMixin{

  TabController _tabController;  
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void dispose() {
   _tabController.dispose();
   super.dispose();
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {   
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190),
          child: AppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Image.asset("assets/images/logo.png")
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              indicatorWeight: 4.0,
              indicatorColor: Color(0xFF6078ea),
              tabs: <Widget>[
                Tab(
                  child: Text(
                  "Login",
                  style: TextStyle(
                      color: _currentIndex == 0 ? Color(0xFF6078ea) : Colors.grey,
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontFamily: "Poppins-bold",
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                  "Registrar",
                    style: TextStyle(
                      color: _currentIndex == 1 ? Color(0xFF6078ea) : Colors.grey,
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontFamily: "Poppins-bold",
                      fontWeight: FontWeight.w800
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            LoginForm(),
            RegisterForm()
          ],
        )
      ),
    );
    
  }
}
