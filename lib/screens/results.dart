import 'package:Quiziq/provider/provider.dart';
import 'package:Quiziq/screens/connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

List<String> categories = [];
List<int> userScores = [];
List<String> storedTimes = [];

class _ResultState extends State<Result> {
  void initstate() {
    super.initState();
    checkConnectivity();
  }

  final CollectionReference results =
      FirebaseFirestore.instance.collection('Results');

  int Index = 0;
  String sortByOption = 'Normal';

  String connectionStatus = 'Unknown';

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        connectionStatus = 'No internet connection';
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => InternetCheckWidget(),
        ));
      });
    } else {}
  }

  Future<void> deleteAll() async {
    final collection =
        await FirebaseFirestore.instance.collection("Results").get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }

    return batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<Providers>(context).getUserScores();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Results',
        ),
        backgroundColor: Colors.blue.shade400,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == '1') {
                // Provider.of<Providers>(context, listen: false).clearResults();
                deleteAll();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: '1',
                child: Text('Clear Result'),
              ),
              PopupMenuItem(
                value: '2',
                child: Row(
                  children: [
                    Text('Sort by: '),
                    DropdownButton<String>(
                      value: sortByOption,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          Provider.of<Providers>(context, listen: false)
                              .sortResults(newValue);
                        }
                      },
                      items: <String>['Normal', 'Last Played']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Results')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Results Not Found'),
            );
          }
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          List results = userData['results'];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Consumer<Providers>(
                    builder: (context, Providers, child) {
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (BuildContext context, int index) {
                          var resultSnap = results[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Color(0xFFA32EC1),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              height: 80,
                              child: ListTile(
                                leading: Text(
                                  '${index + 1}',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                title: Text('Score: ${resultSnap['Score']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),
                                subtitle: Text(
                                  'Category:\n ${resultSnap['Category']}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                trailing: Text(
                                  textAlign: TextAlign.right,
                                  '${resultSnap['Datetime']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
