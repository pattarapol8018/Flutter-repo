import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูปภาพส่วนบน
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/g1.jpg'),
                  radius: 75,
                ),
              ),
              SizedBox(height: 20),

              // ชื่อและชื่อเล่น
              Center(
                child: Column(
                  children: [
                    Text(
                      'Phattharaphon Pomerungsee',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'First',
                      style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // ข้อมูลส่วนตัว
              buildDetailRow('Hobby', 'เล่นเกม , นอน'),
              buildDetailRow('Food', 'เฟรนช์ฟรายส์ , น้ําพริกอ่อง'),
              buildDetailRow('Birthplace', 'อุตรดิตถ์'),
              SizedBox(height: 20),

              // การศึกษา
              buildSectionTitle('Education'),
              buildDetailRow('Elementary', 'โรงเรียนสร้างตนเองลำน้ำน่านสงเคราะห์ 1 (2005)'),
              buildDetailRow('Primary', 'โรงเรียนสร้างตนเองลำน้ำน่านสงเคราะห์ 1 (2006-2015)'),
              buildDetailRow('High School', 'โรงเรียนเตรียมอุดมศึกษาน้อมเกล้า อุตรดิตถ์ (2016-2021)'),
              buildDetailRow('Undergrad', 'มหาวิทยาลัยนเรศวร (2022)'),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง Section Title
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ฟังก์ชันสร้างรายละเอียดแบบ Row
  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
