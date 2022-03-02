import 'package:bedridden/Screen/edit_environment.dart';
import 'package:bedridden/Screen/edit_health.dart';
import 'package:bedridden/Screen/edit_sick.dart';
import 'package:bedridden/models/sick_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LitlEdit extends StatefulWidget {
  final String idcard;
  const LitlEdit({
    Key? key,
    required this.idcard,
  }) : super(key: key);

  @override
  _LitlEditState createState() => _LitlEditState();
}

List<SickModel> sickmodels = [];

List<String> idCard = [];

//sick
String? addressSick;
String? bondSick;
String? idCardSick;
String? latSick;
String? levelSick;
String? lngSick;
String? nameSick;
String? nationalitySick;
String? patientoccupationSick;
String? phoneSick;
String? raceSick;
String? religionSick;
String? talentSick;
String? typeSexSick;
String? typeStatusSick;
String? typeeducationlevelSick;
String? typepositionSick;
String? urlImageSick;
//Health
String? diseaseHealth;
String? foodsupplementHealth;
String? groupAHealth;
String? groupBHealth;
String? herbHealth;
String? medicineHealth;
// environment
String? accommodationenvironment;
String? typeHomeEnvironmentenvironment;
String? typeHouseenvironment;
String? typeHousingSafetyenvironment;
String? typefacilitiesenvironment;
String? urlenvironmentImageenvironment;
//Family
String? familynameoneFamily;
String? familynamethreeFamily;
String? familynametwoFamily;
String? familyrelationshiponeFamily;
String? familyrelationshipthreeFamily;
String? familyrelationshiptwoFamily;
String? occupationoneFamily;
String? occupationthreeFamily;
String? occupationtwoFamily;

class _LitlEditState extends State<LitlEdit> {
  @override
  void initState() {
    super.initState();
    readAlldata();
  }

  Future<Null> readAlldata() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection('sick')
          .doc(widget.idcard)
          .snapshots()
          .listen((event) {
        DateTime dateTime = event['bond'].toDate();
        DateFormat dateFormat = DateFormat('dd-MMMM-yyyy', 'th');
        String bondStr = dateFormat.format(dateTime);
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            addressSick = event['address'];
            bondSick = bondStr;
            idCardSick = event['idCard'];
            latSick = event['lat'].toString();
            lngSick = event['lng'].toString();
            levelSick = event['level'];
            nameSick = event['name'];
            nationalitySick = event['nationality'];
            patientoccupationSick = event['patientoccupation'];
            phoneSick = event['phone'];
            raceSick = event['race'];
            religionSick = event['religion'];
            talentSick = event['talent'];
            typeSexSick = event['typeSex'];
            typeStatusSick = event['typeStatus'];
            typeeducationlevelSick = event['typeeducation_level'].toString();
            typepositionSick = event['typeposition'].toString();
            urlImageSick = event['urlImage'];
          });
        });
      });
      FirebaseFirestore.instance
          .collection('Health')
          .doc(widget.idcard)
          .snapshots()
          .listen((event) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            diseaseHealth = event['disease'];
            foodsupplementHealth = event['foodsupplement'];
            groupAHealth = event['groupA'];
            groupBHealth = event['groupB'];
            herbHealth = event['herb'];
            medicineHealth = event['medicine'];
          });
        });
      });
      FirebaseFirestore.instance
          .collection('environment')
          .doc('${widget.idcard}')
          .snapshots()
          .listen((event) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            accommodationenvironment = event['accommodation'];
            typeHomeEnvironmentenvironment = event['typeHomeEnvironment'];
            typeHouseenvironment = event['typeHouse'];
            typeHousingSafetyenvironment = event['typeHousingSafety'];
            typefacilitiesenvironment = event['typefacilities'];
            urlenvironmentImageenvironment = event['urlenvironmentImage'];
          });
        });
      });

      FirebaseFirestore.instance
          .collection('Family')
          .doc('${widget.idcard}')
          .snapshots()
          .listen((event) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            familynameoneFamily = event['familynameone'];
            familynamethreeFamily = event['familynamethree'];
            familynametwoFamily = event['familynametwo'];
            familyrelationshiponeFamily = event['familyrelationshipone'];
            familyrelationshipthreeFamily = event['familyrelationshipthree'];
            familyrelationshiptwoFamily = event['familyrelationshiptwo'];
            occupationoneFamily = event['occupationone'];
            occupationtwoFamily = event['occupationtwo'];
            occupationthreeFamily = event['occupationthree'];
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'ประวัติผู้ป่วย',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "ลบข้อมูล  ",
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
            ),
          ),
        ],
        backgroundColor: const Color(0xffdfad98),
        toolbarHeight: 90,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.elliptical(30.0, 30.0))),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      '$urlImageSick',
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrack) => Icon(
                        Icons.error,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'ชื่อ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$nameSick',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'ระดับ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$levelSick',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ส่วนที่ 1 ข้อมูลของผู้ป่วย',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  minWidth: 50,
                  height: 30,
                  onPressed: () {
                    var idcard = widget.idcard;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditSick(idcard: idcard),
                        ));
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: const Color(0xffffede5),
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "แก้ไข",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  color: const Color(0xffdfad98),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('เลขบัตรประจำตัวประชาชน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$idCardSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('วัน/เดือน/ปีเกิด',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$bondSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('เพศ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typeSexSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('สถานะ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typeStatusSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ที่อยู่ปัจจุบัน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$addressSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('พิกัดที่อยู่',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Text('lat : ', style: TextStyle(fontSize: 16)),
                Text('$latSick ', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Text('lng : ', style: TextStyle(fontSize: 16)),
                Text('$lngSick', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Text('เบอร์โทรศัพท์',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$phoneSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('เชื้อชาติ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$raceSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('สัญชาติ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$nationalitySick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ศาสนา',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$religionSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ระดับการศึกษา',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typeeducationlevelSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ก่อนป่วยติดเตียงผู้ป่วยทำอาชีพ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$patientoccupationSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ความสามารถพิเศษ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$talentSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ฐานะของผู้และครอบครัว',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typepositionSick', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ส่วนที่ 2 ข้อมูลด้านสุขภาพ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                MaterialButton(
                  minWidth: 50,
                  height: 30,
                  onPressed: () {
                    var idcard = widget.idcard;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditHealth(idcard: idcard),
                        ));
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: const Color(0xffffede5),
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "แก้ไข",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  color: const Color(0xffdfad98),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('โรคประจำตัวหรือปัญหาสุขภาพ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$diseaseHealth', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ยาที่แพทย์สั่ง',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$medicineHealth', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ผลการตรวจสอบ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$groupAHealth', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('การใช้ยา',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$groupBHealth', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('สมุนไพร',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$herbHealth', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('อาหารเสริม',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$foodsupplementHealth', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ส่วนที่ 3 ข้อมูลสภาพแวดล้อม',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  minWidth: 50,
                  height: 30,
                  onPressed: () {
                    var idcard = widget.idcard;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEnvironment(idcard: idcard),
                        ));
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: const Color(0xffffede5),
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "แก้ไข",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  color: const Color(0xffdfad98),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('สถานะของที่พักอาศัย',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$accommodationenvironment', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ประเภทบ้าน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typeHouseenvironment', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('สภาพสิ่งแวดล้อมในบ้าน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typeHomeEnvironmentenvironment',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ความปลอดภัยของที่อยู่อาศัย',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typeHousingSafetyenvironment',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('สิ่งอำนวยความสะดวก',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$typefacilitiesenvironment', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('รูปสภาพแวดล้อม',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  '$urlenvironmentImageenvironment',
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stackTrack) => Icon(
                    Icons.error,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ส่วนที่ 4 ข้อมูลเครือญาติผู้ป่วย',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  minWidth: 50,
                  height: 30,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: const Color(0xffffede5),
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "แก้ไข",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  color: const Color(0xffdfad98),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('ข้อมูลความสัมพันธ์กับสมาชิกในครอบครัว',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ชื่อ-สกุล สมาชิกในครอบครัว', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('คนที่ 1 :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('ชื่อ-สกุล',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$familynameoneFamily', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ความสัมพันธ์กับผู้ป่วย',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$familyrelationshiponeFamily',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('อาชีพ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$occupationoneFamily', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('คนที่ 2 :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('ชื่อ-สกุล',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$familynametwoFamily', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ความสัมพันธ์กับผู้ป่วย',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$familyrelationshiptwoFamily',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('อาชีพ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$occupationtwoFamily', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('คนที่ 3 :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('ชื่อ-สกุล',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$familynamethreeFamily', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('ความสัมพันธ์กับผู้ป่วย',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$familyrelationshipthreeFamily',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('อาชีพ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$occupationthreeFamily', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
