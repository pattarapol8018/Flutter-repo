import 'package:Blockchain/model/transactionItem.dart';
import 'package:Blockchain/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // ใช้สำหรับคัดลอกข้อความ

class EditScreen extends StatefulWidget {
  final TransactionItem item;

  EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final senderController = TextEditingController();
  final receiverController = TextEditingController();
  final transactionHashController = TextEditingController();
  final blockNumberController = TextEditingController();
  final transactionFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    amountController.text = widget.item.amount.toString();
    senderController.text = widget.item.sender;
    receiverController.text = widget.item.receiver;
    transactionHashController.text = widget.item.transactionHash;
    blockNumberController.text = widget.item.blockNumber.toString();
    transactionFeeController.text = widget.item.transactionFee.toString();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("คัดลอกเรียบร้อยแล้ว!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.transparent, // ทำให้แอปบาร์เป็นพื้นหลังโปร่งใส
  elevation: 0, // ลบเงาของแอปบาร์
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.deepPurple, Colors.blueAccent], // ไล่ระดับสี
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26, // เงาอ่อนๆ
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
  ),
  title: const Text(
    'แก้ไขธุรกรรม',
    style: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2, // เว้นระยะตัวอักษร
    ),
  ),
  centerTitle: true, // จัดให้ชื่ออยู่ตรงกลาง
  iconTheme: const IconThemeData(color: Colors.white), // ไอคอนเป็นสีขาว
),
      body: Scaffold(
  body: Container(
    width: double.infinity,
    height: double.infinity, // ให้ background เต็มจอ
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black87, Colors.deepPurple], // ไล่สีพื้นหลัง
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: SafeArea( // ป้องกัน UI ชนขอบจอ
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildInputCard("ชื่อรายการ", titleController),
              buildInputCard("จำนวน Token", amountController, isNumeric: true),
              buildCopyField("ผู้ส่ง", senderController),
              buildCopyField("ผู้รับ", receiverController),
              buildInputCard("Transaction Hash", transactionHashController),
              buildInputCard("Block Number", blockNumberController, isNumeric: true),
              buildInputCard("Transaction Fee", transactionFeeController, isNumeric: true),

              const SizedBox(height: 20),

              // ปุ่มบันทึกแบบ Gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 245, 8, 8), Color.fromARGB(255, 192, 109, 0)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var provider = Provider.of<TransactionProvider>(context, listen: false);

                      TransactionItem item = TransactionItem(
                        keyID: widget.item.keyID,
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                        date: widget.item.date,
                        sender: senderController.text,
                        receiver: receiverController.text,
                        transactionHash: transactionHashController.text,
                        blockNumber: int.parse(blockNumberController.text),
                        transactionFee: double.parse(transactionFeeController.text),
                        network: widget.item.network,
                      );

                      provider.updateTransaction(item);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('บันทึกการแก้ไข',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),
    );
  }

  /// สร้าง Card สำหรับใส่ข้อมูลทั่วไป
  Widget buildInputCard(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) => value!.isEmpty ? "กรุณาป้อน $label" : null,
        ),
      ),
    );
  }

  /// สร้างช่องกรอกข้อมูล + ปุ่ม Copy
  Widget buildCopyField(String label, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    value!.isEmpty ? "กรุณาป้อน $label" : null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blueAccent),
              onPressed: () => copyToClipboard(controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
