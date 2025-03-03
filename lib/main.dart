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
        debugShowCheckedModeBanner: false,
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
    // โหลดข้อมูลเมื่อหน้าแรกเปิดขึ้น
    TransactionProvider provider =
        Provider.of<TransactionProvider>(context, listen: false);
    provider.initData();
  }

  // ฟังก์ชัน Copy ข้อมูลไปยัง Clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('คัดลอกสำเร็จ: $text')),
    );
  }

  // ฟังก์ชันปกปิดที่อยู่ (แสดงแค่ 4 ตัวหน้า + 4 ตัวท้าย)
  String maskAddress(String address) {
    if (address.length < 10) return address;
    return address.substring(0, 4) + "..." + address.substring(address.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    widget.title,
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  centerTitle: true,
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.deepPurple, Colors.blueAccent], // ไล่สีจากม่วงไปฟ้า
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  elevation: 4, // เพิ่มเงาให้ AppBar ดูมีมิติ
  
  actions: [
    IconButton(
      icon: const Icon(Icons.search, color: Colors.white),
      onPressed: () {
        // ฟังก์ชันค้นหา (ยังไม่ได้เพิ่ม)
      },
    ),
    IconButton(
      icon: const Icon(Icons.settings, color: Colors.white),
      onPressed: () {
        // ฟังก์ชันตั้งค่า (ยังไม่ได้เพิ่ม)
      },
    ),
  ],
  
),
      body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.black87, Colors.deepPurple],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
  child: Consumer<TransactionProvider>(
    builder: (context, provider, child) {
      int itemCount = provider.transactions.length;

      if (itemCount == 0) {
        return const Center(
          child: Text(
            'ไม่มีรายการ',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      } else {
        return ListView.builder(
          itemCount: itemCount,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          itemBuilder: (context, int index) {
            TransactionItem data = provider.transactions[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('จำนวน Token: ${data.amount}', style: const TextStyle(fontSize: 14)),
                        Text('Block: ${data.blockNumber}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('ค่าธรรมเนียม: ${data.transactionFee} ETH',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('เครือข่าย: ${data.network}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent)),

                    const Divider(height: 10, color: Colors.grey),

                    // Transaction Hash + Copy
                    Row(
                      children: [
                        Expanded(
                          child: Text('Tx Hash: ${maskAddress(data.transactionHash)}',
                              style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.blue),
                          onPressed: () => copyToClipboard(data.transactionHash),
                        ),
                      ],
                    ),

                    // Sender + Copy
                    Row(
                      children: [
                        Expanded(
                          child: Text('ผู้ส่ง: ${maskAddress(data.sender)}', style: const TextStyle(fontSize: 14)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.blue),
                          onPressed: () => copyToClipboard(data.sender),
                        ),
                      ],
                    ),

                    // Receiver + Copy
                    Row(
                      children: [
                        Expanded(
                          child: Text('ผู้รับ: ${maskAddress(data.receiver)}', style: const TextStyle(fontSize: 14)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.blue),
                          onPressed: () => copyToClipboard(data.receiver),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // วันที่
                    Text('วันที่: ${data.date?.toIso8601String()}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),

                    const SizedBox(height: 6),

                    // ปุ่ม Edit และ Delete
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return EditScreen(item: data);
                            }));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('ยืนยันการลบ'),
                                  content: const Text('คุณต้องการลบรายการใช่หรือไม่?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('ยกเลิก'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('ลบรายการ', style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        provider.deleteTransaction(data);
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
            );
          },
        );
      }
    },
  ),
),

      // เพิ่มปุ่ม FloatingActionButton (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormScreen();
          })).then((_) {
            Provider.of<TransactionProvider>(context, listen: false).initData();
          });
        },
        backgroundColor: const Color.fromARGB(255, 0, 89, 255),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
