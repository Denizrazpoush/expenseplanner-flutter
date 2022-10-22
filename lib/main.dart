import 'package:first_app/widgets/new_transaction.dart';
import 'package:flutter/services.dart';
import './widgets/transation_list.dart';
import './models/transaction.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown

  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'expense planner',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  final List<Transaction> _usertransaction = [];

  void addNew_Transactions(
      String txTitle, double txAmount, DateTime userDatepicked) {
    final Transaction newList = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: userDatepicked);

    setState(() {
      _usertransaction.add(newList);
    });
  }

  void startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(addNew_Transactions);
        });
  }

  List<Transaction> get reCentTransactions {
    return _usertransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void deleteTransaction(String id) {
    return setState(() {
      _usertransaction.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget theAppBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('expense app'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => startNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ))
        : AppBar(
            title: Text('expense app'),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => startNewTransaction(context),
                icon: Icon(Icons.add),
              )
            ],
          );
    final TransactionWidget = Container(
      height: (MediaQuery.of(context).size.height -
              theAppBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [

        //   BoxShadow(
        //     color: Color.fromARGB(255, 206, 29, 237).withOpacity(0.4),
        //     spreadRadius: 10,
        //     blurRadius: 20,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      padding: EdgeInsets.all(10),
      child: TransactionList(_usertransaction, deleteTransaction),
    );

    final pageBody =SafeArea(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLandScape)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('show chart'),
              Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  })
            ]),
          if (!isLandScape)
            Container(
                height: (media.size.height -
                        theAppBar.preferredSize.height -
                        media.padding.top) *
                    0.3,
                child: Chart(reCentTransactions)),
          if (!isLandScape) TransactionWidget,
          if (isLandScape)
            _showChart
                ? Container(
                    height: (media.size.height -
                            theAppBar.preferredSize.height -
                            media.padding.top) *
                        0.7,
                    child: Chart(reCentTransactions))
                : TransactionWidget
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: theAppBar, child: pageBody)
        : Scaffold(
            appBar: theAppBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => startNewTransaction(context)),
          );
  }
}
