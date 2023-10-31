import 'package:Quiz/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

List<String> categories = [];
List<int> userScores = [];
List<String> storedTimes = [];

class _ResultState extends State<Result> {
  int Index = 0;
  String sortByOption = 'Normal';

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
                Provider.of<Providers>(context, listen: false).clearResults();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<Providers>(builder: (context, Providers, child) {
                Providers.getCategories();
                Providers.getUserScores();
                Providers.loadStoredTimes();
                return ListView.builder(
                  itemCount: userScores.length,
                  itemBuilder: (BuildContext context, int index) {
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
                          title: Text('Score: ${userScores[index]}',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          subtitle: Text(
                            'Category:\n ${categories[index]}',
                            style: TextStyle(fontSize: 15),
                          ),
                          trailing: Text(
                            textAlign: TextAlign.right,
                            '${storedTimes[index]}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
