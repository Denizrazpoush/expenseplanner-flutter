import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  Function deleteTransaction;

  TransactionList(this.transaction, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white,
                )
              ]),
              child: Column(
                children: [
                  Text('nothing in here ! '),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.7,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                      )
                    ]),
                    child: Image.asset(
                      'assets/images/thecat.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            );
          })
        : Container(
            height: 450,
            child: ListView.builder(
              itemCount: transaction.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 11),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: FittedBox(
                            child: Text(transaction[index].amount.toString())),
                      ),
                    ),
                    title: Text(transaction[index].title),
                    subtitle: Text(
                        DateFormat.yMMMMd().format(transaction[index].date)),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Color.fromARGB(139, 96, 95, 98),
                        ),
                        onPressed: () =>
                            deleteTransaction(transaction[index].id)),
                  ),
                );
              },
            ),
          );
  }
}
