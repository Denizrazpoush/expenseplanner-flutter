import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  DateTime userDatepicked;
  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || userDatepicked == null) {
      return null;
    }

    // addTx(enteredTitle,enteredAmount);
    widget.addTx(enteredTitle, enteredAmount, userDatepicked);
    Navigator.of(context).pop();
  }

  void _presentDatepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          userDatepicked = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Card(
              elevation: 5,
              child: Container(
                 padding: EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10),
                        // bottom: MediaQuery.of(context).viewInsets.bottom + 10  ),
                 
                child: Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(20),
                     
                      
                      child: TextField(
                        // onChanged: (value) => inputtitle = value,
                        decoration: InputDecoration(labelText: 'title'),
                        controller: titleController,
                      ),
                    ),
                    Container(
                      // decoration: BoxDecoration(
                      // border: Border.(color: Color.fromARGB(255, 172, 172, 172))),
                      child: TextField(
                          controller: amountController,
                          // onChanged: (value) => inputamount = value,
                          decoration: InputDecoration(labelText: 'amount'),
                          keyboardType: TextInputType.number),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(userDatepicked == null
                      ? 'pick a Date ! '
                      : '${(DateFormat.yMd().format(userDatepicked))}'),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: ElevatedButton(
                      onPressed: _presentDatepicker,
                      child: Text(
                        'open calender',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple)),
                    ),
                  )
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                submitData();
              },
              child: Text('add Transaction'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
