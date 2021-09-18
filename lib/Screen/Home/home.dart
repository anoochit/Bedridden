import 'package:bedridden/Screen/edit_sick.dart';
import 'package:bedridden/models/sick_model.dart';
import 'package:bedridden/widgets/show_progess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final primary = Color(0xffdfad98);
  final secondary = Color(0xfff29a94);

  get padding => null;

  List<SickModel> sickmodels = [];
  List<SickModel> sickmodelsLevel1 = [];
  List<SickModel> sickmodelsLevel2 = [];
  List<SickModel> sickmodelsLevel3 = [];
  List<String> docIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllSick();
  }

  Future<Null> readAllSick() async {
    if (sickmodels.length != 0) {
      sickmodels.clear();
      sickmodelsLevel1.clear();
      sickmodelsLevel2.clear();
      sickmodelsLevel3.clear();
      docIds.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('sick')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          SickModel model = SickModel.fromMap(item.data());
          print('## name ==> ${model.name}');
          setState(() {
            sickmodels.add(model);
            if (model.level == '1') {
              sickmodelsLevel1.add(model);
              docIds.add(item.id);
            }
            if (model.level == '2') {
              sickmodelsLevel2.add(model);
              docIds.add(item.id);
            }
            if (model.level == '3') {
              sickmodelsLevel3.add(model);
              docIds.add(item.id);
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'th';
    initializeDateFormatting();
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final IconThemeData data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffdfad98),
        toolbarHeight: 90,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.elliptical(50.0, 50.0))),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildSearch(), //'ค้นหารายชื่อผู้ป่วยติดเตียง'
                buildtTtleListNameAllBedridden(), //'รายชื่อผู้ป่วยติดเตียง,โชว์ทั้งหมด'
                buildtListNameAllBedridden(), //'รายชื่อผู้ป่วยติดเตียง'
                buildtTtleListNameAllBedriddenLevel1(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1,โชว์ทั้งหมด'
                buildtListNameAllBedriddenLevel1(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1'
                buildtTtleListNameAllBedriddenLevel2(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 2,โชว์ทั้งหมด'
                buildtListNameAllBedriddenLevel2(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 2'
                buildtTtleListNameAllBedriddenLevel3(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 3,โชว์ทั้งหมด'
                buildtListNameAllBedriddenLevel3(),//'รายชื่อผู้ป่วยติดเตียง ระดับที่ 3'
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<Null> showSickDialog(SickModel model, int index) async {
    DateTime dateTime = model.bond.toDate();
    DateFormat dateFormat = DateFormat('dd-MMMM-yyyy', 'th');
    String bondStr = dateFormat.format(dateTime);

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(16),
        title: ListTile(
          leading: Container(
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                model.urlImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(model.name),
          subtitle: Text('ระดับที่ = ${model.level}'),
        ),
        children: [
          Text('รหัสบัตรประชาชน : ${model.idCard}'),
          Text('ที่อยู่ : ${model.address}'),
          Text('เบอร์โทรศัพท์ : ${model.phone}'),
          Text('เพศ : ${model.typeSex}'),
          Text('สถานภาพ : ${model.typeStatus}'),
          Text('วัน/เดือน/ปี เกิด : $bondStr'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSick(
                          sickModel: model,
                          docId: docIds[index],
                        ),
                      )).then((value) => readAllSick());
                },
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  confirmDelete(model, index);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }



  Widget buildtListNameAllBedriddenLevel3() {
    return sickmodelsLevel3.length == 0
        ? ShowProgress()
        :Container(
          height: 270,
          child: Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: sickmodelsLevel3.length,
              itemBuilder: (context, index) => Container(
                width: 175,
                child: GestureDetector(
                  onTap: () {
                    print('## You Click index = $index');
                    showSickDialog(sickmodelsLevel3[index], index);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                    child: Card(
                      color: Color(0xffFFD1BB),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              width: 130,
                              height: 80,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  sickmodelsLevel3[index].urlImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  width: 140,
                                  child: Text(
                                    sickmodelsLevel3[index].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  width: 140,
                                  child:
                                      Text(sickmodelsLevel3[index].address),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  width: 140,
                                  child: Text(
                                      'ระดับที่ ${sickmodelsLevel3[index].level}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }

  Row buildtTtleListNameAllBedriddenLevel3() {
    return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "รายชื่อผู้ป่วย ระดับที่ 3",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      TextButton(
          style: TextButton.styleFrom(primary: Colors.black87),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => LoginPage()),
            // );
          },
          child: Text(
            "ทั้งหมด",
            style: TextStyle(
              color: Colors.black54,
            ),
          )),
    ],
  );
  }

  

  Widget buildtListNameAllBedriddenLevel2() {
    return sickmodelsLevel2.length == 0
        ? ShowProgress()
        : Container(
            height: 270,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: sickmodelsLevel2.length,
                itemBuilder: (context, index) => Container(
                  width: 175,
                  child: GestureDetector(
                    onTap: () {
                      print('## You Click index = $index');
                      showSickDialog(sickmodelsLevel2[index], index);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      child: Card(
                        color: Color(0xffFFD1BB),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                width: 130,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    sickmodelsLevel2[index].urlImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(
                                      sickmodelsLevel2[index].name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child:
                                        Text(sickmodelsLevel2[index].address),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(
                                        'ระดับที่ ${sickmodelsLevel2[index].level}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Row buildtTtleListNameAllBedriddenLevel2() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "รายชื่อผู้ป่วย ระดับที่ 2",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black87),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LoginPage()),
              // );
            },
            child: Text(
              "ทั้งหมด",
              style: TextStyle(
                color: Colors.black54,
              ),
            )),
      ],
    );
  }

//'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1'
  Widget buildtListNameAllBedriddenLevel1() {
    return sickmodelsLevel1.length == 0
        ? ShowProgress()
        : Container(
            height: 270,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: sickmodelsLevel1.length,
                itemBuilder: (context, index) => Container(
                  width: 175,
                  child: GestureDetector(
                    onTap: () {
                      print('## You Click index = $index');
                      showSickDialog(sickmodelsLevel1[index], index);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      child: Card(
                        color: Color(0xffFFD1BB),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                width: 130,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    sickmodelsLevel1[index].urlImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(
                                      sickmodelsLevel1[index].name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child:
                                        Text(sickmodelsLevel1[index].address),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(
                                        'ระดับที่ ${sickmodelsLevel1[index].level}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

//'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1,โชว์ทั้งหมด'
  Row buildtTtleListNameAllBedriddenLevel1() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "รายชื่อผู้ป่วย ระดับที่ 1",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black87),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LoginPage()),
              // );
            },
            child: Text(
              "ทั้งหมด",
              style: TextStyle(
                color: Colors.black54,
              ),
            )),
      ],
    );
  }

//'รายชื่อผู้ป่วยติดเตียง'
  Widget buildtListNameAllBedridden() {
    return sickmodels.length == 0
        ? ShowProgress()
        : Container(
            height: 270,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: sickmodels.length,
                itemBuilder: (context, index) => Container(
                  width: 175,
                  child: GestureDetector(
                    onTap: () {
                      print('## You Click index = $index');
                      showSickDialog(sickmodels[index], index);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      child: Card(
                        color: Color(0xffFFD1BB),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                width: 130,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    sickmodels[index].urlImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(
                                      sickmodels[index].name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(sickmodels[index].address),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: 140,
                                    child: Text(
                                        'ระดับที่ ${sickmodels[index].level}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

//'รายชื่อผู้ป่วยติดเตียง,โชว์ทั้งหมด'
  Row buildtTtleListNameAllBedridden() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "รายชื่อผู้ป่วย",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black87),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LoginPage()),
              // );
            },
            child: Text(
              "ทั้งหมด",
              style: TextStyle(
                color: Colors.black54,
              ),
            )),
      ],
    );
  }

//'ค้นหารายชื่อผู้ป่วยติดเตียง'
  Widget buildSearch() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                // controller: TextEditingController(),
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                    hintText: "Search ",
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                    suffixIcon: Material(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(Icons.search),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<Null> confirmDelete(SickModel model, int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Icon(
            Icons.delete,
            size: 48,
            color: Colors.red,
          ),
          title: Text('ต้องการลบข้อมูล ${model.name} หรือไม่ ?'),
          subtitle: Text('ถ้าลบแล้ว ไม่สามารถ กู้ คืนข้อมูลได้'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('sick')
                  .doc(docIds[index])
                  .delete()
                  .then((value) => readAllSick());
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
