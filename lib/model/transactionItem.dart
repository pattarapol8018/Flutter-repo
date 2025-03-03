class TransactionItem {
  int? keyID; // สำหรับใช้ในการเก็บ ID ของธุรกรรม
  String title; // ชื่อรายการ
  double amount; // จำนวนเงิน
  String sender; // ที่อยู่ผู้ส่ง
  String receiver; // ที่อยู่ผู้รับ
  String transactionHash; // Hash ของธุรกรรม
  DateTime? date; // วันที่
   int blockNumber; // หมายเลขบล็อก
  double transactionFee; // ค่าธรรมเนียมธุรกรรม
  String network;

  // Constructor
  TransactionItem({
    this.keyID,
    required this.title,
    required this.amount,
    required this.sender,
    required this.receiver,
    required this.transactionHash,
    this.date,
    required this.blockNumber, // เพิ่ม parameter สำหรับ Block Number
    required this.transactionFee, // เพิ่ม parameter สำหรับ Transaction Fee
    required this.network,
  });
}
