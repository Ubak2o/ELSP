import 'package:capstone/screen/myhome.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header part of the drawer
          InkWell(
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => MyHome(),
              ),
            ),
            child: buildHeader(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {

                        
                       },
                      icon: Icon(Icons.checklist),
                      tooltip: 'Survey',
                    ),
                    SizedBox(width: 10,),
                    Text('Background Survey'),
                  ],
                ),
                
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings),
                      tooltip: 'Settings',
                    ),
                    SizedBox(width: 10,),
                    Text('Settings'),
                  ],
                ),
                const Divider( height: 50, color: Colors.black, thickness: 1,),
                
                 Row(
                  children: [
                    IconButton(
                      onPressed: () { },
                      icon: Icon(Icons.logout),
                      tooltip: 'Log out',
                    ),
                    SizedBox(width: 10,),
                    Text('Log out'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildHeader() =>GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 175, 221, 238),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 20,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Color.fromARGB(255, 175, 221, 238),
                backgroundImage: AssetImage('user.png'),
              ),
              SizedBox(height: 15),
              Text(
                'User Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(Icons.email_outlined, color: Colors.black),
                  Text(
                    ' user email',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );