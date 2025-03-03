import 'package:Blockchain/model/transactionItem.dart';
import 'package:flutter/foundation.dart';
import 'package:Blockchain/database/transactionDB.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionItem> transactions = [];

  List<TransactionItem> getTransaction() {
    return transactions;
  }

  // ฟังก์ชันในการโหลดข้อมูลจากฐานข้อมูล
  Future<void> initData() async {
    var db = TransactionDB(dbName: 'transactions.db');
    transactions = await db.loadAllData();
    print('Loaded Transactions: $transactions'); // ✅ Debug
    notifyListeners();
  }

  // ฟังก์ชันเพิ่มข้อมูลธุรกรรมใหม่
  Future<void> addTransaction(TransactionItem transaction) async {
    var db = TransactionDB(dbName: 'transactions.db');
    
    // เพิ่มข้อมูลธุรกรรมลงฐานข้อมูล
    await db.insertDatabase(transaction);
    print('Transaction Added: $transaction'); // พิมพ์ข้อมูลที่เพิ่ม

    // โหลดข้อมูลทั้งหมดใหม่หลังจากเพิ่ม
    transactions.add(transaction); // เพิ่มข้อมูลใน List
    notifyListeners(); // แจ้งให้ UI อัปเดต
  }

  // ฟังก์ชันลบข้อมูลธุรกรรม
  Future<void> deleteTransaction(TransactionItem transaction) async {
    var db = TransactionDB(dbName: 'transactions.db');
    
    // ลบข้อมูลจากฐานข้อมูล
    await db.deleteData(transaction);
    print('Transaction Deleted: $transaction'); // พิมพ์ข้อมูลที่ลบ

    // ลบข้อมูลจาก List
    transactions.remove(transaction);
    notifyListeners(); // แจ้งให้ UI อัปเดต
  }

  // ฟังก์ชันอัปเดตข้อมูลธุรกรรม
  Future<void> updateTransaction(TransactionItem transaction) async {
    var db = TransactionDB(dbName: 'transactions.db');
    
    // อัปเดตข้อมูลในฐานข้อมูล
    await db.updateData(transaction);
    print('Transaction Updated: $transaction'); // พิมพ์ข้อมูลที่อัปเดต

    // หา index ของ transaction ใน List
    int index = transactions.indexWhere((item) => item.keyID == transaction.keyID);
    if (index != -1) {
      transactions[index] = transaction; // อัปเดตข้อมูลใน List
    }

    notifyListeners(); // แจ้งให้ UI อัปเดต
  }
}
