// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:qrcode_reader/qrcode_reader.dart';
// import 'dart:convert';
// import 'package:http/http.dart' show get;
// void main() {
//   runApp(new MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'QRCode Tracking NO.',
//       home: new MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   //final Widget child;

//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   final Map<String, dynamic> pluginParameters = {};
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final formKey = GlobalKey<FormState>();
//   Future<String> barcodeString;
// //String barcodeString;
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: const Text('QRCode Tracking NO.'),
//         actions: <Widget>[
//           IconButton(tooltip: 'Upload To Server',
//           icon: Icon(Icons.cloud_upload),
//           onPressed: (){
//             uploadToServer(barcodeString);
//             print(barcodeString);
//           },)
//         ],
//       ),
//       body: new Center(
//           child: new FutureBuilder<String>(
//               future: barcodeString,
//               builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                 return new Text(snapshot.data != null ? snapshot.data : '');
//                  print(snapshot.data);
                 
//           //uploadToServer(barcodeString);
//               })),
//       floatingActionButton: new FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             barcodeString = new QRCodeReader()
//                 .setAutoFocusIntervalInMs(200)
//                 .setForceAutoFocus(true)
//                 .setTorchEnabled(true)
//                 .setHandlePermissions(true)
//                 .setExecuteAfterPermissionGranted(true)
//                 .scan();
//           });
//         },
//         tooltip: 'Reader Tracking NO.',
//         child: new Icon(Icons.add_a_photo),
//       ),
//     );
//   }

//   void uploadToServer(barcodeString){
//     print('You Click Upload');
//     print(formKey.currentState.validate());
//     formKey.currentState.save();
//     print('barcode=$barcodeString.data');
//     sentNewBarcodeToServer(barcodeString);
//   }
// void sentNewBarcodeToServer(
//   String userBarcode) async{
//     String url =
//     'http://androidthai.in.th/sun/addDataOill.php?isAdd=true&Barcode=$userBarcode';
//     var respone = await get(url);
//     var result = json.decode(respone.body);
//     print('result ==>$result');
//     if (result.toString()=='true'){
//       print('back process');
//       Navigator.pop(context);
      
//     }
//   }
// }

import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('QR Counter'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: MaterialButton(
                      onPressed: scan,
                      child: Text("Scanning....")),
                  padding: const EdgeInsets.all(8.0),
                ),
                Text(barcode),
              ],
            ),
          )),
    );
  }

  Future sendtoserver(data) async {
    print('============');
    print(data);
    print('============');

    var url = 'http://androidthai.in.th/sun/addDataOill.php';
    var response = await http.post(url, body: {'isAdd': 'true', 'Barcode': data});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      sendtoserver(this.barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}



