import 'package:flutter/material.dart';
import 'package:account/model/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactions = [
    Transaction(title: 'หนังสือ', amount: 1000, dateTime: DateTime.now()),
    Transaction(title: 'เสื้อยืด', amount: 200, dateTime: DateTime.now()),
    Transaction(title: 'รองเท้า', amount: 1500, dateTime: DateTime.now()),
    Transaction(title: 'กระเป๋า', amount: 1000, dateTime: DateTime.now()),
    Transaction(title: 'KFC', amount: 300, dateTime: DateTime.now()),
    Transaction(title: 'McDonald', amount: 200, dateTime: DateTime.now()),
  ];

  List<Transaction> getTransaction() {
    return transactions;
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    notifyListeners(); // ✅ แจ้งเตือน UI ให้รีเฟรช
  }
}
