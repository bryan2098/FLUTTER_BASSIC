import './transaction_list.dart';

import './transaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Transaction App',
    home: MyApp(),
    theme: ThemeData(
      primaryColor: Colors.red,
      accentColor: Colors.green,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   String _email = '';
//   final _emailEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     print('Run init state');
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _emailEditingController.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     print('Run dispose state');
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused) {
//       print('App is in background mode');
//     } else if (state == AppLifecycleState.resumed) {
//       print('App is in foreground mode');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "This is my test",
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             // can theo chieu doc
//             mainAxisAlignment: MainAxisAlignment.center,

//             // can theo chieu vuong goc
//             crossAxisAlignment: CrossAxisAlignment.center,

//             children: [
//               Container(
//                 // tinh ra khoang cach tu noi dung cach ra 4 phia
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 4,
//                   vertical: 10,
//                 ),
//                 child: TextField(
//                   controller: _emailEditingController,
//                   onChanged: (text) {
//                     this.setState(() {
//                       _email = text;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: const BorderRadius.all(
//                         const Radius.circular(10),
//                       ),
//                     ),
//                     labelText: 'Enter your email',
//                   ),
//                 ),
//               ),
//               Text(
//                 _email,
//                 textDirection: TextDirection.ltr,
//               ),
//               Text(
//                 'Hello',
//                 textDirection: TextDirection.ltr,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // fix loi cheat snackbar

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _contentController = TextEditingController();
  final _amountController = TextEditingController();

  String _content;
  double _amount;

  Transaction _transaction = Transaction(content: '', amount: 0.0);

  List<Transaction> _transactions = List<Transaction>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('Run init state');
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _amountController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print('Run dispose state');
  }

  void insertTransaction() {
    if (_transaction.content.isEmpty || _transaction.amount == 0.0 || _transaction.amount.isNaN) return;

    setState(() {
      _transactions.add(_transaction);
      _transaction = Transaction(content: '', amount: 0.0);
      _contentController.text = '';
      _amountController.text = '';
    });
  }

  void _onBottomShowModalSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Content'),
                  controller: _contentController,
                  onChanged: (value) {
                    setState(() {
                      _transaction.content = value;
                    });
                  },
                ),
                padding: EdgeInsets.all(10),
              ),
              Container(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Amount(money)'),
                    controller: _amountController,
                    onChanged: (value) {
                      setState(() {
                        _transaction.amount = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  padding: EdgeInsets.all(10)),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          this.insertTransaction();
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                        child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ))
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Transaction'),
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              this._onBottomShowModalSheet();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          this._onBottomShowModalSheet();
        },
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                textColor: Colors.pink,
                child: Text('Insert transacion'),
                onPressed: () {
                  this._onBottomShowModalSheet();
                  // _scaffoldKey.currentState.showSnackBar(
                  //   SnackBar(
                  //     content: Text('Transaction list: ' + _transactions.toString()),
                  //     duration: Duration(seconds: 3),
                  //   ),
                  // );
                },
              ),
              TransactionList(
                transactions: _transactions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
