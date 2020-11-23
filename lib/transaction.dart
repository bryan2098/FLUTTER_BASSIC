import 'package:flutter/material.dart';

class Transaction {
  String content;
  double amount;

  Transaction({
    @required this.content,
    @required this.amount,
  });

  @override
  String toString() {
    return 'content: $content, amount: $amount';
  }
}
