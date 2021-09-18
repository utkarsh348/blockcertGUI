import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

final bool enableInteractiveSelection = true;
void main() {
  runApp(strt());
}

class Keys {
  String? pubkey;
  String? privkey;
  Keys(this.pubkey, this.privkey);

  Keys.fromJson(Map<String, dynamic> json)
      : pubkey = json["PublicKey"],
        privkey = json["PrivateKey"];
}

class strt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
        home: Scaffold(
          body: Text("Welcome to\nBlockcert"),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addCert())
                        );
              },
              splashColor: Colors.black87,
              child: const Icon(Icons.add),
              focusColor: Colors.black87,
              hoverColor: Colors.blueGrey,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: Colors.black87,
              child: IconTheme(
                data: IconThemeData(
                    color: Theme.of(context).colorScheme.onPrimary),
                child: Row(children: <Widget>[
                  //const Spacer(),
                  //const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.approval_outlined),
                    tooltip: 'Check certificate',
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => verify())
                        );
                    },
                    icon: const Icon(Icons.linear_scale_rounded),
                    tooltip: 'Keygen',
                  )
                ]
              ),
            ),
          )
        )
      );
  }
}


class verify extends StatefulWidget {
  const verify({ Key? key }) : super(key: key);

  @override
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<verify> {
  Future<List<Keys>> keys() async {
    var url = "http://localhost:8080/keygen";
    var response = await http.get(Uri.parse(url));


    List<Keys> keylist = [];
        if (response.statusCode == 200) {
          // Map<String, dynamic> keylist = new Map<String, dynamic>.from(convert.jsonDecode(response.body));
          keylist.add(Keys.fromJson(convert.jsonDecode(response.body)));
        }
        return keylist;
  }
  FutureBuilder<List<Keys>> fkey(){
    var futureKey = keys();
    return FutureBuilder<List<Keys>>(
      future: futureKey,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      var keysgens = "Public: "+snapshot.data[0].pubkey+"\n\n"+"Private: "+snapshot.data[0].privkey;
      return Text(keysgens);
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }
    return const CircularProgressIndicator();
    },
  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Verification"), 
        ),
        body: fkey()  
    );
  }
}



/*class addCert extends StatefulWidget {
  const addCert({ Key? key }) : super(key: key);

  @override
  _addCertState createState() => _addCertState();
}

class _addCertState extends State<addCert> {

  createPost(String title, String key) async {
    
}

  
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Future<Text>? _futureres;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureres == null) ? buildColumn() : buildFutureBuilder(),
        ),
      );
  }
  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller1,
          decoration: const InputDecoration(hintText: 'Enter File Name'),
        ),
        TextField(
          controller: _controller2,
          decoration: const InputDecoration(hintText: 'Enter private key'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              createPost(_controller1.text,_controller2.text);
            });
              
            
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Text> buildFutureBuilder() {
    return FutureBuilder<Text>(
      future: _futureres,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
*/

/*class addCert extends StatefulWidget {

  const addCert({ Key? key }) : super(key: key);

  @override
  _addCertState createState() => _addCertState();
}

class _addCertState extends State<addCert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: () async{
        var formData = FormData.fromMap({
        "PrivateKey": "3082013b020100024100bbf503db37325ff3da6424aed129a939fb0abecbf4872f955ea3f04b6b9de803b58c8d2222a48c1ad1e1a5dd5ec71a047004c9e85abdf5cea6cad64c50e367790203010001024100b950161041788a401bd7568f81aba8ac80c6145d746700d42d6e4711a53617b437c571f8188f510da02d451a7614ceae74947ad75cc10b47007f508b03511dad022100e1d47be8d1dd77bd53df1a6577ebce6b79d9b6d0391d8df523be19c8a4ac4437022100d5114159eb8c7aee8ca54dbd1694b8f01148b13a3297071451d8662ec0d839cf02202a89f501492ef794314d505296c15373c9532a6d94a4ad8de4bab56ea71e500702203b5af83aa58cd7fe367e225ee7b87ca09c200507326ab2552dcbbc0390436c2f022100c782791554181b4f79000b657e398c5d2e99c2cce17402fad66db9cc46b8d3dc",
        'Data': await MultipartFile.fromFile('/Users/utkarshgupta/Documents/DevWork/blockcert_gui/frontend/bledit1.jpeg',filename: 'bledit1.jpeg')
      });
      var dio = Dio();
      try{
        var response = await dio.post('http://localhost:8080/new_cert', data: formData);
      }
      catch(e){
        throw e;
      };
      
      }, 
      child: Text("Send")),
    );
  }
}*/

class addCert extends StatefulWidget {
  const addCert({ Key? key }) : super(key: key);

  @override
  _addCertState createState() => _addCertState();
}

class _addCertState extends State<addCert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}