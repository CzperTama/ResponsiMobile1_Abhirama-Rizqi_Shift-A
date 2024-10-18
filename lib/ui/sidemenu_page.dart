import 'package:flutter/material.dart';
import 'package:responsi1/ui/review_detail.dart';
import 'package:responsi1/ui/login_page.dart';

class Sidemenu extends StatelessWidget {
  const Sidemenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green.shade100,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green.shade900),
              title: Text('Home', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewDetail()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review, color: Colors.green.shade900),
              title: Text('Ulasan', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewDetail()),
                );
              },
            ),
            Divider(color: Colors.green.shade300),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.green.shade900),
              title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                // Implementasi logout di sini
                // Misalnya, hapus token atau data sesi
                // Kemudian navigasi ke halaman login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}