import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String keyName;
  final dynamic keyValue;

  final Map<String, IconData> icons = {
    'FOOD': Icons.local_dining,
    'TRANSPORT': Icons.directions_bike,
    'SALARY': Icons.monetization_on
  };

  TransactionTile({this.keyName, this.keyValue});

  List<Widget> _getList(keyValue) {
    List<Widget> list = [];
    keyValue.forEach((value) {
      list.add(Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200],
              width: 1.0,
            ),
          ),
        ),
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Icon(icons[value['category']]),
          ),
          title: Text(value['category']),
          subtitle: Text(value['description']),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: value['transactionType'] == 'IN'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Text(
              '${value['transactionType'] == 'IN' ? '+ ₹' : '- ₹'} ${value['amount']}',
              style: TextStyle(
                color:
                    value['transactionType'] == 'IN' ? Colors.teal : Colors.red,
              ),
            ),
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 72.0),
                  child: Text(value['description']),
                ),
              ],
            )
          ],
        ),
      ));
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(children: _getList(keyValue)),
    );
  }
}
