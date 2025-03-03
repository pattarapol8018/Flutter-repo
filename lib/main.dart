import 'package:Blockchain/model/transactionItem.dart';
import 'package:Blockchain/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'formScreen.dart';
import 'package:Blockchain/editScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // ✅ นำเข้า Clipboard

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return TransactionProvider();
        })
      ],
      child: MaterialApp(
        title: 'Blockchain',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Blockchain'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // เรียกใช้ initData เพื่อโหลดข้อมูลครั้งแรก
    TransactionProvider provider =
        Provider.of<TransactionProvider>(context, listen: false);
    provider.initData();
  }

  // ✅ ฟังก์ชัน Copy ข้อมูลไปยัง Clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('คัดลอกสำเร็จ: $text')),
    );
  }

  // ✅ ฟังก์ชันปกปิดที่อยู่ (แสดงแค่ 4 ตัวหน้า + 4 ตัวท้าย)
  String maskAddress(String address) {
    if (address.length < 10) return address;
    return address.substring(0, 4) +
        "..." +
        address.substring(address.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormScreen();
              })).then((_) {
                TransactionProvider provider =
                    Provider.of<TransactionProvider>(context, listen: false);
                provider.initData();
              });
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          int itemCount = provider.transactions.length;

          if (itemCount == 0) {
            return Center(
              child: Text(
                'ไม่มีรายการ',
                style: TextStyle(fontSize: 50),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, int index) {
                TransactionItem data = provider.transactions[index];

                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ หัวข้อธุรกรรม
                            Text(
                              data.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),

                            // ✅ แสดงจำนวน Token
                            Text('จำนวน Token: ${data.amount}',
                                style: const TextStyle(fontSize: 12)),

                            // ✅ ค่าธรรมเนียมธุรกรรม
                            Text(
                              'ค่าธรรมเนียม: ${data.transactionFee} ETH',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),

                            // ✅ หมายเลขบล็อก
                            Text(
                              'Block Number: ${data.blockNumber}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                            // ✅ แสดงเครือข่าย (Network)
                            Text(
                              'เครือข่าย: ${data.network}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),

                            // ✅ แสดง Transaction Hash + ปุ่ม Copy
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'Tx Hash: ${maskAddress(data.transactionHash)}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy,
                                      size: 16, color: Colors.blue),
                                  onPressed: () =>
                                      copyToClipboard(data.transactionHash),
                                ),
                              ],
                            ),

                            // ✅ แสดงที่อยู่ผู้ส่ง + ปุ่ม Copy
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'ผู้ส่ง: ${maskAddress(data.sender)}',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy,
                                      size: 16, color: Colors.blue),
                                  onPressed: () => copyToClipboard(data.sender),
                                ),
                              ],
                            ),

                            // ✅ แสดงที่อยู่ผู้รับ + ปุ่ม Copy
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'ผู้รับ: ${maskAddress(data.receiver)}',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy,
                                      size: 16, color: Colors.blue),
                                  onPressed: () =>
                                      copyToClipboard(data.receiver),
                                ),
                              ],
                            ),

                            // ✅ วันที่
                            Text('วันที่: ${data.date?.toIso8601String()}',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey)),

                            // ✅ ปุ่ม Edit และ Delete
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditScreen(item: data);
                                    }));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('ยืนยันการลบ'),
                                          content: const Text(
                                              'คุณต้องการลบรายการใช่หรือไม่?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('ยกเลิก'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('ลบรายการ',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                provider
                                                    .deleteTransaction(data);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 10, thickness: 1, color: Colors.grey),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
