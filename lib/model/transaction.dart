class Transaction {
  String title;
  double amount;
  final DateTime dateTime; // เปลี่ยนเป็น DateTime

  Transaction({required this.title, required this.amount , required this.dateTime});
}