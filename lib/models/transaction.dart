class Transaction {
  final int id;
  String payee;
  double amount;
  DateTime date;
  String category;

  Transaction({
    this.id,
    this.payee,
    this.amount,
    this.date,
    this.category,
  });

  bool get isAnExpense {
    return amount < 0;
  }
}
