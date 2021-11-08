import 'package:cni_app/color.dart';
import 'package:cni_app/provider/project_Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:qrscan/qrscan.dart' as scanner;

import 'model/assetLog.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({Key? key}) : super(key: key);

  @override
  _AssetScreenState createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showFilter = false;
  bool isLoad = false;

  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).getAssetLogsStatus();
    });
    if (mounted) {
      setState(() {
        isLoad = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  List assetItem1 = [];
  List assetItem = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: HexColor.fromHex('#9E9E9E'),
        elevation: 3,
        centerTitle: true,
        title: Text(
          'Assets',
          style: TextStyle(fontSize: 24.0, color: Colors.black),
        ),
        actions: [
          isLoad == true
              ? InkWell(
                  onTap: () async {
                    // Future _scanQR() async {
                    try {
                      var cameraStatus = await Permission.camera.status;
                      if (cameraStatus.isGranted) {
                        String? cameraScanResult = await scanner.scan();
                        if (cameraScanResult == null) {
                          Navigator.of(context).pop();
                        } else {
                          Provider.of<UserProvider>(context, listen: false)
                              .checkAssetInventory(cameraScanResult.toString())
                              .then((value) {
                            print(
                                'this is Values  set camera ${cameraScanResult.toString()} and $value');
                            setState(() {
                              var productMap = {
                                'access_code': '${cameraScanResult.toString()}',
                                'decscription': value!.assetDesc,
                                'asset': value.assetCode,
                              };

                              var contain = assetItem.where((element) =>
                                  element['access_code'] ==
                                  cameraScanResult.toString());
                              if (contain.isEmpty) {
                                assetItem.add(productMap);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Asset already in List'),
                                  duration: Duration(seconds: 5),
                                ));
                              }
                            });
                          }).onError((error, stackTrace) {
                            print('this si error $error');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(Provider.of<UserProvider>(context,
                                      listen: false)
                                  .errorMessage
                                  .toString()),
                              duration: Duration(seconds: 5),
                            ));
                            // Navigator.of(context).pop();
                          });
                        }

                        // setState(() {
                        //   result = cameraScanResult
                        //       .toString(); // setting string result with cameraScanResult
                        // });
                      } else {
                        var cameraStatus = await Permission.camera.request();
                        if (cameraStatus.isGranted) {
                          String? cameraScanResult = await scanner.scan();
                          if (cameraScanResult == null) {
                            Navigator.of(context).pop();
                          } else {
                            Provider.of<UserProvider>(context, listen: false)
                                .checkAssetInventory(
                                    cameraScanResult.toString())
                                .then((value) {
                              print(
                                  'this is Values  set camera ${cameraScanResult.toString()} and $value');
                              setState(() {
                                var productMap = {
                                  'access_code':
                                      '${cameraScanResult.toString()}',
                                  'decscription': value!.assetDesc,
                                  'asset': value.assetCode,
                                };

                                var contain = assetItem.where((element) =>
                                    element['access_code'] ==
                                    cameraScanResult.toString());
                                if (contain.isEmpty) {
                                  assetItem.add(productMap);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Asset already in List'),
                                    duration: Duration(seconds: 5),
                                  ));
                                }
                              });
                            }).onError((error, stackTrace) {
                              print('this si error $error');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(Provider.of<UserProvider>(context,
                                        listen: false)
                                    .errorMessage
                                    .toString()),
                                duration: Duration(seconds: 5),
                              ));
                              // Navigator.of(context).pop();
                            });
                          }
                        }
                      }
                    } on PlatformException catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.black,
                    ),
                  ))
              : SizedBox()
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0, right: 20.0),
                  color: Colors.white,
                  child: TabBar(
                    onTap: (value) {
                      if (value == 0) {
                        setState(() {
                          isLoad = true;
                        });
                      } else {
                        setState(() {
                          isLoad = false;
                        });
                      }
                    },
                    controller: _tabController,
                    labelColor: Colors.blue.shade900,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    indicator: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white]),
                        // borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    tabs: [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        text: 'New Loans',
                      ),

                      // second tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Loans List',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // first tab bar view widget
                      Container(
                          margin: EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Column(
                                children:
                                    List.generate(assetItem.length, (index) {
                                  return Container(
                                      padding: EdgeInsets.all(20.0),
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Asset - ${assetItem[index]['asset']} \n ${assetItem[index]['decscription']}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                assetItem
                                                    .remove(assetItem[index]);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 30.0,
                                            ),
                                          )
                                        ],
                                      ));
                                }),
                              ),
                              Consumer<UserProvider>(
                                  builder: (_, accesLog, child) {
                                return Container(
                                  alignment: Alignment.bottomCenter,
                                  child: assetItem.isEmpty
                                      ? SizedBox()
                                      : ElevatedButton(
                                          onPressed: () async {
                                            assetItem.forEach((item) async {
                                              print(
                                                  'This is subkit item ${item['asset']}');
                                              if (!await context
                                                  .read<UserProvider>()
                                                  .assetInventoryPost(
                                                    item['asset'],
                                                    '${accesLog.userModel.empid}',
                                                    item['decscription'],
                                                    DateTime.now(),
                                                    DateTime.now(),
                                                  )) {
                                                switch (context
                                                    .read<UserProvider>()
                                                    .assetInventoryState) {
                                                  case AssetInventoryState
                                                      .initial:
                                                  case AssetInventoryState
                                                      .loading:
                                                  case AssetInventoryState
                                                      .complete:
                                                  case AssetInventoryState
                                                      .error:
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Could not be added, Contact Admin'),
                                                      duration:
                                                          Duration(seconds: 5),
                                                    ));
                                                }
                                              } else {
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .getAssetLogsStatus();
                                                assetItem.clear();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text('Assets Added'),
                                                  duration:
                                                      Duration(seconds: 5),
                                                ));
                                              }
                                            });
                                          },
                                          child: postAssetLog(context)),
                                );
                              })
                            ],
                          )),

                      // second tab bar view widget
                      Container(
                          margin: EdgeInsets.all(8.0),
                          child:
                              // Consumer<UserProvider>(
                              //     builder: (_, accesLog, child)
                              Selector<UserProvider, List<AssetLog>>(
                                  selector: (_, accesLog) =>
                                      accesLog.getAccetlogStatus,
                                  builder: (_, List<AssetLog> cartVal, child) {
                                    var data = cartVal;
                                    return ListView(
                                      children:
                                          List.generate(data.length, (index) {
                                        return Container(
                                            padding: EdgeInsets.all(20.0),
                                            margin:
                                                EdgeInsets.only(bottom: 10.0),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Asset - ${data[index].assetCode} \n\n${data[index].assetName}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey),
                                                ),
                                                Consumer<UserProvider>(
                                                  builder: (_, accesLog,
                                                          child) =>
                                                      InkWell(
                                                          onTap: () async {
                                                            // Future _scanQR() async {
                                                            try {
                                                              var cameraStatus =
                                                                  await Permission
                                                                      .camera
                                                                      .status;
                                                              if (cameraStatus
                                                                  .isGranted) {
                                                                String?
                                                                    cameraScanResult =
                                                                    await scanner
                                                                        .scan();
                                                                Provider.of<UserProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .checkReturnAssetInventory(
                                                                        cameraScanResult
                                                                            .toString())
                                                                    .then(
                                                                        (value) async {
                                                                  // if (value ==
                                                                  //     null) {

                                                                  // }
                                                                  // print(
                                                                  //     'this is Value for access return $value');

                                                                  if (!await context
                                                                      .read<
                                                                          UserProvider>()
                                                                      .assetInventoryreturn(
                                                                        value!
                                                                            .assetCode
                                                                            .toString(),
                                                                        '${accesLog.userModel.empid}',
                                                                        value
                                                                            .assetDesc
                                                                            .toString(),
                                                                        DateTime
                                                                            .now(),
                                                                        DateTime
                                                                            .now(),
                                                                      )) {
                                                                    switch (context
                                                                        .read<
                                                                            UserProvider>()
                                                                        .assetInventoryState) {
                                                                      case AssetInventoryState
                                                                          .initial:
                                                                      case AssetInventoryState
                                                                          .loading:
                                                                      case AssetInventoryState
                                                                          .complete:
                                                                      case AssetInventoryState
                                                                          .error:
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text('Could not be added, contact Admin'),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                        ));
                                                                    }
                                                                  } else {
                                                                    Provider.of<UserProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAssetLogsStatus();
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content: Text(
                                                                          'Assets Return Successfully'),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              5),
                                                                    ));
                                                                  }
                                                                }).onError((error,
                                                                        stackTrace) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'Asset code doesn’t matching to lent asset.'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            5),
                                                                  ));
                                                                });
                                                                // setState(() {
                                                                //   result = cameraScanResult
                                                                //       .toString(); // setting string result with cameraScanResult
                                                                // });
                                                              } else {
                                                                var isGrant =
                                                                    await Permission
                                                                        .camera
                                                                        .request();
                                                                if (isGrant
                                                                    .isGranted) {
                                                                  String?
                                                                      cameraScanResult =
                                                                      await scanner
                                                                          .scan();
                                                                  Provider.of<UserProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .checkReturnAssetInventory(
                                                                          cameraScanResult
                                                                              .toString())
                                                                      .then(
                                                                          (value) async {
                                                                    print(
                                                                        'this is Value for access return $value');

                                                                    if (!await context
                                                                        .read<
                                                                            UserProvider>()
                                                                        .assetInventoryreturn(
                                                                          value!
                                                                              .assetCode
                                                                              .toString(),
                                                                          '${accesLog.userModel.firstName}',
                                                                          value
                                                                              .assetDesc
                                                                              .toString(),
                                                                          DateTime
                                                                              .now(),
                                                                          DateTime
                                                                              .now(),
                                                                        )) {
                                                                      switch (context
                                                                          .read<
                                                                              UserProvider>()
                                                                          .assetInventoryState) {
                                                                        case AssetInventoryState
                                                                            .initial:
                                                                        case AssetInventoryState
                                                                            .loading:
                                                                        case AssetInventoryState
                                                                            .complete:
                                                                        case AssetInventoryState
                                                                            .error:
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Could not be added'),
                                                                            duration:
                                                                                Duration(seconds: 5),
                                                                          ));
                                                                      }
                                                                    } else {
                                                                      Provider.of<UserProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .getAssetLogsStatus();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content:
                                                                            Text('Assets Return Successfully'),
                                                                        duration:
                                                                            Duration(seconds: 5),
                                                                      ));
                                                                    }
                                                                  }).onError((error,
                                                                          stackTrace) {
                                                                    print(
                                                                        'this si error $error');
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content: Text(Provider.of<UserProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .displayMessage2
                                                                          .toString()),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    ));
                                                                  });
                                                                }
                                                              }
                                                            } on PlatformException catch (e) {
                                                              print(e);
                                                            }
                                                          },
                                                          child:
                                                              postAssetReturn(
                                                                  context)),
                                                )
                                              ],
                                            ));
                                      }),
                                    );
                                  })),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

Widget postAssetLog(BuildContext context) {
  switch (context.watch<UserProvider>().assetInventoryState) {
    case AssetInventoryState.initial:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case AssetInventoryState.loading:
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
    case AssetInventoryState.error:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case AssetInventoryState.complete:
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

Widget postAssetReturn(BuildContext context) {
  switch (context.watch<UserProvider>().assetInventoryState) {
    case AssetInventoryState.initial:
      return Icon(
        Icons.arrow_forward_sharp,
        color: Colors.red,
        size: 30.0,
      );
    case AssetInventoryState.loading:
      return Row(children: [
        CircularProgressIndicator(),
      ]);
    case AssetInventoryState.error:
      return Icon(
        Icons.arrow_forward_sharp,
        color: Colors.red,
        size: 30.0,
      );
    case AssetInventoryState.complete:
      return Icon(
        Icons.arrow_forward_sharp,
        color: Colors.red,
        size: 30.0,
      );
  }
}
