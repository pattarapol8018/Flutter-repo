import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart'; // ✅ ใช้ Sembast Web
import 'package:Blockchain/model/transactionItem.dart';

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  // ใช้ databaseFactoryWeb สำหรับ Flutter Web
  Future<Database> openDatabase() async {
    final dbFactory = databaseFactoryWeb; // ใช้ Web Database ของ Sembast
    final db = await dbFactory.openDatabase(dbName);
    print("Database Location: $dbName"); // พิมพ์ชื่อฐานข้อมูล
    return db;
  }

  // การเพิ่มข้อมูลลงในฐานข้อมูล
  Future<int> insertDatabase(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    int keyID = await store.add(db, {
      'title': item.title,
      'amount': item.amount,
      'date': item.date?.toIso8601String(),
      'sender': item.sender,
      'receiver': item.receiver,
      'transactionHash': item.transactionHash,
      'blockNumber': item.blockNumber,
      'transactionFee': item.transactionFee,
      'network': item.network, // ✅ เพิ่ม network
    });

    print("Inserted transaction with keyID: $keyID");
    db.close();
    return keyID;
  }

  // โหลดข้อมูลทั้งหมดจากฐานข้อมูล
  Future<List<TransactionItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('date', false)]));

    print("Loaded transactions: $snapshot");

    List<TransactionItem> transactions = [];
    for (var record in snapshot) {
      TransactionItem item = TransactionItem(
        keyID: record.key,
        title: record['title'].toString(),
        amount: double.parse(record['amount'].toString()),
        date: DateTime.tryParse(record['date'].toString()),
        sender: record['sender']?.toString() ?? 'Unknown',
        receiver: record['receiver']?.toString() ?? 'Unknown',
        transactionHash: record['transactionHash']?.toString() ?? 'Unknown',
        blockNumber: record['blockNumber'] is int
            ? record['blockNumber'] as int
            : 0, // ถ้าไม่มีให้ใช้ 0
        transactionFee: record['transactionFee'] is double
            ? record['transactionFee'] as double
            : 0.0, // ถ้าไม่มีให้ใช้ 0.0
        network: record['network']?.toString() ?? 'Unknown', // ✅ โหลด network
      );
      transactions.add(item);
    }

    db.close();
    return transactions;
  }

  // การลบข้อมูล
  Future<void> deleteData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    print("🔹 Trying to delete: keyID=${item.keyID}, title=${item.title}");

    int deletedCount = await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );

    print("✅ Deleted Count: $deletedCount");
  }

  // การอัปเดตข้อมูล
  Future<void> updateData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    final Map<String, dynamic> data = {
      'title': item.title,
      'amount': item.amount,
      'date': item.date?.toIso8601String(),
      'sender': item.sender,
      'receiver': item.receiver,
      'transactionHash': item.transactionHash,
      'blockNumber': item.blockNumber,
      'transactionFee': item.transactionFee,
      'network': item.network, // ✅ อัปเดต network
    };

    await store.update(
      db,
      data,
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );

    print("✅ Updated transaction: keyID=${item.keyID}");
  }
}
