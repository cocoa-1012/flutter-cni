import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Api/helper.dart';
import 'color.dart';
import 'model/projectList.dart';
import 'provider/project_Provider.dart';

class ProjectOt extends StatefulWidget {
  ProjectOt({Key? key}) : super(key: key);

  @override
  _ProjectOtState createState() => _ProjectOtState();
}

class _ProjectOtState extends State<ProjectOt> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _approvedHour = TextEditingController();
  Api api = Api();

  List<String> _project = ["Choose Project"];
  String _selectedProject = "Choose Project";

  bool loadingProject = false;

  Future getResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var response = await api.getProjectList(token);
    var result = json.decode(response.body);
    print('this is $result');
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
      print('this is data ${data['proj_id']}');
      var model = ProjectList();
      model.projId = data['proj_id'];
      model.projName = data['proj_name'];
      if (!mounted) return;
      setState(() {
        _project.add(model.projName.toString() + ':' + model.projId.toString());
        loadingProject = true;
      });
    });

    return _project;
  }

  String? sendlong1;
  String? projectName;

  String? sendlong;
  String? projectId;

  void _onSelectedProject(String value) {
    if (!mounted) return;
    setState(() {
      _selectedProject = value;
      sendlong1 =
          _selectedProject.split(':').sublist(0, 2).join(':').trim().toString();
      projectName =
          sendlong1!.split(':').sublist(0, 1).join(':').trim().toString();
      sendlong =
          _selectedProject.split(':').sublist(1).join(':').trim().toString();
      projectId =
          sendlong!.split(':').sublist(0, 1).join(':').trim().toString();
    });
    print(
        'this is value selected $_selectedProject while $sendlong1 and this is two $projectName');

    print(
        'this is value selected $_selectedProject while $sendlong and this is two $projectId');
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
            'Project OT',
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
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
                            left: 15.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Project:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0, right: 8.0),
                        width: double.infinity,
                        height: 70,
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(
                                left: 8.0, bottom: 2.0, top: 8.0),
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
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 1.0,
                                                            top: 5.0),
                                                    child: Text(
                                                        value
                                                            .split(':')
                                                            .sublist(0, 1)
                                                            .join(':')
                                                            .trim()
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
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
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      _onSelectedProject(value!),
                                  value: _selectedProject),
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 2.0, top: 8.0, right: 8.0),
                        child: Text(
                          'OT Approved Hour:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0, right: 8.0),
                        width: double.infinity,
                        height: 70,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 8.0, bottom: 2.0, top: 8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              border: Border.all(
                                  color: Colors.black,
                                  // Color(0xffDEE0E8).withAlpha(10), // set border color
                                  width: 0.5), // set border width
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ) // set rounded corner radius
                              ),
                          child: TextField(
                            toolbarOptions: ToolbarOptions(
                                copy: false, cut: false, paste: false),
                            keyboardType: TextInputType.number,
                            controller: _approvedHour,
                            decoration: InputDecoration(
                              // hintText: '2.30',
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.grey, width: 2.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Comment:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 2.0, top: 8.0),
                        width: double.infinity,
                        // height: 70,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          controller: _commentController,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: 8,
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
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)),
                            color: Colors.blue,
                            child: postProjectOt(context),
                            onPressed: () async {
                              if (_selectedProject.toString() ==
                                      'Choose Project' ||
                                  _selectedProject == null.toString()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Please Choose a Project'),
                                  duration: Duration(seconds: 2),
                                ));
                              } else if (_approvedHour.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Approve hour canot be empty'),
                                  duration: Duration(seconds: 2),
                                ));
                              } else {
                                if (!await context
                                    .read<UserProvider>()
                                    .projectOT(
                                      projectName.toString(),
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now()),
                                      _approvedHour.text,
                                      projectId.toString(),
                                      _commentController.text,
                                    )) {
                                  switch (context
                                      .read<UserProvider>()
                                      .postProject) {
                                    case PostProject.initial:
                                    case PostProject.loading:
                                    case PostProject.complete:
                                    case PostProject.error:
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Could not be added'),
                                        duration: Duration(seconds: 2),
                                      ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Project OT Added'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  Navigator.pop(context);
                                }
                              }
                            },
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

Widget postProjectOt(BuildContext context) {
  switch (context.watch<UserProvider>().postProject) {
    case PostProject.initial:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case PostProject.loading:
      return Row(children: [
        CircularProgressIndicator(),
        Text(
          'Sending...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SourceSansPro',
          ),
        )
      ]);
    case PostProject.error:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case PostProject.complete:
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
