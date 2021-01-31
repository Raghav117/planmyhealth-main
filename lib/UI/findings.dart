import 'package:flutter/material.dart';
import 'package:plan_my_health/model/findings.dart';

class Findings extends StatefulWidget {
  final List<Finding> findings;

  const Findings({Key key, this.findings}) : super(key: key);

  @override
  _FindingsState createState() => _FindingsState(findings);
}

class _FindingsState extends State<Findings> {
  final List<Finding> findings;
  List<bool> colors = [];

  _FindingsState(this.findings);
  @override
  void initState() {
    super.initState();
    findings.forEach((element) {
      colors.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Findings"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: findings.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                setState(() {
                  colors[index] = !colors[index];
                });
              },
              tileColor:
                  colors[index] == false ? Colors.transparent : Colors.yellow,
              title: Text(
                findings[index].name,
                style: TextStyle(fontSize: 20),
              ),
            ),
          )),
          InkWell(
            onTap: () {
              Navigator.pop(context, colors);
            },
            child: Container(
              child: Text("Done"),
            ),
          )
        ],
      ),
    );
  }
}
