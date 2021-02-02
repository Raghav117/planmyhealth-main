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
              // tileColor:
              title: Text(
                findings[index].name,
                style: TextStyle(
                  fontSize: 18,
                  color: colors[index] == false ? Colors.black : Colors.blue,
                ),
              ),
              leading: colors[index] == false
                  ? Icon(Icons.check_box_outline_blank)
                  : Icon(
                      Icons.check_box,
                      color: Colors.blue,
                    ),
            ),
          )),
          InkWell(
            onTap: () {
              Navigator.pop(context, colors);
            },
            child: Container(
              height: 50,
              width: 180,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Center(
                  child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }
}
