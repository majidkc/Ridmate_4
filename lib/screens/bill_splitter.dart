import 'package:flutter/material.dart';

class ScreenSplit extends StatelessWidget {
  static const routeName = '/billSplitter';

  @override
  Widget build(BuildContext context) {
    final _amountController = TextEditingController();
    final _noController = TextEditingController();
    var amount;
    Size size = MediaQuery.of(context).size;
    final peopleFocus = FocusNode();

    dynamic calculate() {
      final totalAmount = _amountController.text;
      final people = _noController.text;

      amount = double.parse(totalAmount) / double.parse(people);
      print(totalAmount);
      print(people);
      return amount;
    }

    calculateAmount() {
      String total = calculate().toString();
      print(total);
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Amount to be paid by each person:',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      total,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill Splitter',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.04),
            Container(
              width: size.width * 0.9,
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.monetization_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'Enter Amount',
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(peopleFocus);
                },
              ),
            ),
            Container(
              width: size.width * 0.9,
              child: TextField(
                controller: _noController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.people,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'No of People',
                ),
                focusNode: peopleFocus,
                onSubmitted: (_) {
                  calculateAmount();
                },
              ),
            ),
            Container(
              width: size.width * 0.4,
              child: ElevatedButton(
                child: Text(
                  'Calculate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  calculateAmount();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // Background color
                ),
              ),
            ),
          ],
        ),
      ),
      // drawer: AppDrawer(), // If you still want to use this, keep it; otherwise, remove it.
    );
  }
}
