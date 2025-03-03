import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Blockchain/model/transactionItem.dart';
import 'package:Blockchain/provider/transactionProvider.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final senderController = TextEditingController();
  final receiverController = TextEditingController();

  String selectedNetwork = "Ethereum"; // ค่าตั้งต้นของ Network
  final List<String> networkList = [
    "Ethereum",
    "Binance Smart Chain",
    "Polygon",
    "Solana"
  ];

  // ฟังก์ชันสร้าง Address อัตโนมัติ
  String generateRandomAddress() {
    final random = Random();
    const chars = 'abcdef0123456789';
    return '0x' +
        List.generate(40, (index) => chars[random.nextInt(chars.length)])
            .join();
  }

  // ฟังก์ชันสร้าง Transaction Hash
  String _generateTransactionHash(String title, double amount, String sender,
      String receiver, String network, DateTime date) {
    var bytes = utf8.encode('$title$amount$sender$receiver$network$date');
    return sha256.convert(bytes).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มข้อมูล',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // ทำให้ตัวหนังสือสีขาว
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // ทำให้โปร่งใส
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.blueAccent], // ไล่สี
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4), // เงาด้านล่าง
              ),
            ],
          ),
        ),
        elevation: 0, // ลบเส้นขอบ
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // ทำอะไรบางอย่าง เช่น เปิดหน้า Settings
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.deepPurple], // สีไล่ระดับ
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                      titleController, 'ชื่อรายการ', 'กรุณาป้อนชื่อรายการ',
                      filled: true),
                  const SizedBox(height: 16),
                  _buildTextField(amountController, 'จำนวน Token',
                      'กรุณาป้อนจำนวนโทเคนที่มากกว่า 0',
                      isNumber: true, filled: true),
                  const SizedBox(height: 16),
                  _buildAddressField(senderController, 'ที่อยู่ผู้ส่ง',
                      filled: true),
                  const SizedBox(height: 16),
                  _buildAddressField(receiverController, 'ที่อยู่ผู้รับ',
                      filled: true),
                  const SizedBox(height: 16),
                  _buildNetworkDropdown(), // ช่องเลือกเครือข่าย
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var provider = Provider.of<TransactionProvider>(context,
                            listen: false);
                        String transactionHash = _generateTransactionHash(
                          titleController.text,
                          double.parse(amountController.text),
                          senderController.text,
                          receiverController.text,
                          selectedNetwork,
                          DateTime.now(),
                        );
                        int blockNumber = provider.transactions.length + 1;
                        double transactionFee =
                            double.parse(amountController.text) * 0.01;
                        TransactionItem item = TransactionItem(
                          title: titleController.text,
                          amount: double.parse(amountController.text),
                          sender: senderController.text,
                          receiver: receiverController.text,
                          transactionHash: transactionHash,
                          network: selectedNetwork,
                          date: DateTime.now(),
                          blockNumber: blockNumber,
                          transactionFee: transactionFee,
                        );
                        provider.addTransaction(item);
                        provider.initData();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 119, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'เพิ่มข้อมูล',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างช่องกรอกข้อมูล (ทั่วไป)
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String errorMsg, {
    bool isNumber = false,
    bool filled = false, // ✅ เพิ่มพารามิเตอร์ filled
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: filled, // ✅ ใช้ค่าที่รับมา
        fillColor:
            filled ? Colors.white : null, // ✅ ถ้า filled เป็น true จะใช้สีขาว
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      controller: controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }
        if (isNumber) {
          try {
            double amount = double.parse(value);
            if (amount <= 0) {
              return "กรุณาป้อนจำนวนที่มากกว่า 0";
            }
          } catch (e) {
            return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
          }
        }
        return null;
      },
    );
  }

  // ฟังก์ชันสร้างช่องกรอก Address (Hybrid Mode)
  Widget _buildAddressField(
    TextEditingController controller,
    String label, {
    bool filled = false, // ✅ เพิ่มพารามิเตอร์ filled
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              filled: filled, // ✅ ใช้ค่าที่รับมา
              fillColor: filled
                  ? Colors.white
                  : null, // ✅ ถ้า filled เป็น true จะใช้สีขาว
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            controller: controller,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "กรุณาป้อน $label";
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              controller.text = generateRandomAddress();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("🔄", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  // ฟังก์ชันสร้าง Dropdown เลือก Network
  Widget _buildNetworkDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // ✅ ตั้งค่าพื้นหลังเป็นสีขาว
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey), // ✅ เพิ่มเส้นขอบ
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: selectedNetwork,
        decoration: const InputDecoration(
          border: InputBorder.none, // ✅ เอาเส้นขอบของ Dropdown ออก
        ),
        items: [
          'Ethereum','Binance Smart Chain','Polygon','Solana','Avalanche','Arbitrum','Optimism','Fantom','Cronos',
        ]
            .map((network) => DropdownMenuItem(
                  value: network,
                  child: Text(network),
                ))
            .toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedNetwork = newValue;
            });
          }
        },
      ),
    );
  }
}
