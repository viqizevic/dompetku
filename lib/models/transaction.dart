class Transaction {
  final int id;
  final String payee;
  final double amount;
  final DateTime date;
  final String category;

  Transaction({
    this.id,
    this.payee,
    this.amount,
    this.date,
    this.category,
  });
}
