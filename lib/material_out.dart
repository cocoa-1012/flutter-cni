import 'dart:convert';

import 'package:cni_app/provider/project_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Api/helper.dart';
import 'color.dart';
// import 'materialQrCodepage.dart';
import 'model/projectList.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:qrscan/qrscan.dart' as scanner;

class MaterialOut extends StatefulWidget {
  MaterialOut({Key? key}) : super(key: key);

  @override
  _MaterialOutState createState() => _MaterialOutState();
}

class _MaterialOutState extends State<MaterialOut> {
  Api api = Api();

  List<String> _project = ["Choose Project"];
  String _selectedProject = "Choose Project";

  final TextEditingController _materialCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? stockQty;
  bool loadingProject = false;

  Future getResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var response = await api.getProjectList(token);
    var result = json.decode(response.body);
    print('this is get project $result');
    return result;
  }

  Future getProject() async {
    var projectRes = await getResponse() as List;
    projectRes
        .where((w) =>
            w['proj_status'] == 'On-going' ||
            w['company_name'] == 'Sick Leave' ||
            w['company_name'] == 'Training / On Course' ||
            w['company_name'] == 'Training / On Course ' ||
            w['company_name'] == 'Training/on course' ||
            w['company_name'] == 'On Course' ||
            w['company_name'] == 'Training' ||
            w['company_name'] == 'Leave' ||
            w['company_name'] == 'Survey' ||
            w['company_name'] == 'MC' ||
            w['company_name'] == 'Others, please comment below' ||
            w['company_name'] == 'Others')
        .forEach((data) {
      var model = ProjectList();
      model.projName = data['proj_name'];
      if (!mounted) return;
      setState(() {
        _project.add(model.projName.toString());
        loadingProject = true;
      });
    });

    return _project;
  }

  String? projectId;
  void _onSelectedProject(String value) {
    if (!mounted) return;
    setState(() {
      _selectedProject = value;
    });
    print('this is value selected $_selectedProject');
  }

  @override
  void initState() {
    getProject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: HexColor.fromHex('#9E9E9E'),
          elevation: 3,
          centerTitle: true,
          title: Text(
            'Material Out',
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
          actions: [
            InkWell(
                onTap: () async {
                  // Future _scanQR() async {
                  try {
                    var cameraStatus = await Permission.camera.status;
                    if (cameraStatus.isGranted) {
                      String? cameraScanResult = await scanner.scan();
                      print('This is scan result $cameraScanResult');
                      Provider.of<UserProvider>(context, listen: false)
                          .checkMaterialInventory(
                              '${cameraScanResult.toString()}')
                          .then((value) {
                        _materialCodeController.text =
                            value!.materialCode.toString() == null.toString()
                                ? ''
                                : value.materialCode.toString();
                        _descriptionController.text =
                            value.productDesc.toString() == null.toString()
                                ? ''
                                : value.productDesc.toString();
                        setState(() {
                          stockQty =
                              value.stockQty.toString() == null.toString()
                                  ? ''
                                  : value.stockQty.toString();
                        });
                      }).onError((error, stackTrace) {
                        print('This is scan error $error');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Material Not found'),
                          duration: Duration(seconds: 2),
                        ));
                      });
                      // setState(() {
                      //   result = cameraScanResult
                      //       .toString(); // setting string result with cameraScanResult
                      // });
                    } else {
                      var isGrant = await Permission.camera.request();
                      if (isGrant.isGranted) {
                        String? cameraScanResult = await scanner.scan();
                        print('This is scan result $cameraScanResult');
                        Provider.of<UserProvider>(context, listen: false)
                            .checkMaterialInventory(
                                '${cameraScanResult.toString()}')
                            .then((value) {
                          _materialCodeController.text =
                              value!.materialCode.toString() == null.toString()
                                  ? ''
                                  : value.materialCode.toString();
                          _descriptionController.text =
                              value.productDesc.toString() == null.toString()
                                  ? ''
                                  : value.productDesc.toString();
                          setState(() {
                            stockQty =
                                value.stockQty.toString() == null.toString()
                                    ? ''
                                    : value.stockQty.toString();
                          });
                        }).onError((error, stackTrace) {
                          print('This is scan error $error');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Material Not found'),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
                    }
                  } on PlatformException catch (e) {
                    print(e);
                  }
                  // final result = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => MatarialInvQrcodepage(),
                  //     ));
                  // print(result);
                  // setState(() {
                  //   _materialCodeController.text = result;
                  // });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             MatarialInvQrcodepage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Material Code:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: 70,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          readOnly: true,
                          controller: _materialCodeController,
                          // style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.withOpacity(.5),
                            filled: true,
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 2.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, top: 8.0),
                        child: Text(
                          'Stock Qty: ${stockQty == null ? '' : stockQty}',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Description:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        // height: 70,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          readOnly: true,
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: 3,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.withOpacity(.5),
                            filled: true,
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 2.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Project:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: 70,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 2.0, top: 8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              border: Border.all(
                                  color: Colors.black,
                                  // Color(0xffDEE0E8).withAlpha(10), // set border color
                                  width: 1.0), // set border width
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ) // set rounded corner radius
                              ),
                          child: Theme(
                              data: ThemeData(
                                canvasColor: Colors.black,
                              ),
                              child: DropdownButton<String>(
                                  focusColor: Colors.black,
                                  dropdownColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: _project.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: loadingProject == false
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(
                                              width: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              height: 50,
                                              child: ListView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 3.0,
                                                            top: 5.0),
                                                    child: Text(
                                                      value,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  value == 'Choose Project' ||
                                                          value ==
                                                              _selectedProject
                                                      ? SizedBox()
                                                      : Divider(
                                                          color: Colors.black,
                                                          thickness: 0.5,
                                                        )
                                                ],
                                              ),
                                            ),
                                      // decoration: BoxDecoration(
                                      //     border: Border(
                                      //         bottom: BorderSide(
                                      //             color: Colors.grey,
                                      //             width: 1)))),
                                      // : Column(
                                      //     children: [
                                      //       Text(value,
                                      //           style: TextStyle(
                                      //               color: Colors.black)),
                                      //     ],
                                      //   ),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      _onSelectedProject(value!),
                                  value: _selectedProject
                                  // ),
                                  )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Material Out Qty:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: 70,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          controller: _qtyController,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 2.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Comment:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        // height: 70,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          controller: _commentController,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 2.0)),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 60.0,
                          child: Consumer<UserProvider>(
                            // ignore: deprecated_member_use
                            builder: (_, userdata, child) => FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)),
                              color: Colors.blue,
                              child: postMatrialOut(context),
                              onPressed: () async {
                                if (_selectedProject.toString() ==
                                        'Choose Project' ||
                                    _selectedProject == '' &&
                                        _materialCodeController.text.isEmpty &&
                                        _commentController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Please Choose a Project'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  // }
                                  //  else if (double.parse(stockQty.toString()) <=
                                  //     double.parse(_qtyController.text)) {
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(SnackBar(
                                  //     content: Text(
                                  //         'Material Stock Qty is insuffient'),
                                  //     duration: Duration(seconds: 2),
                                  // ));
                                } else {
                                  if (!await context
                                      .read<UserProvider>()
                                      .materialOut(
                                        userdata.userModel.empid.toString(),
                                        _materialCodeController.text,
                                        _selectedProject.toString(),
                                        _qtyController.text,
                                        _commentController.text,
                                        DateTime.now(),
                                      )) {
                                    switch (context
                                        .read<UserProvider>()
                                        .materialOutState) {
                                      case MaterialOutState.initial:
                                      case MaterialOutState.loading:
                                      case MaterialOutState.complete:
                                      case MaterialOutState.error:
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .messageOut
                                                  .toString()),
                                          duration: Duration(seconds: 2),
                                        ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Material Added'),
                                      duration: Duration(seconds: 2),
                                    ));
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget postMatrialOut(BuildContext context) {
  switch (context.watch<UserProvider>().materialOutState) {
    case MaterialOutState.initial:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case MaterialOutState.loading:
      return Row(children: [
        CircularProgressIndicator(),
        Text(
          'loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SourceSansPro',
          ),
        )
      ]);
    case MaterialOutState.error:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case MaterialOutState.complete:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
  }
}
