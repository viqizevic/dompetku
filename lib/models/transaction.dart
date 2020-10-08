enum TransactionsGroupingOption {
  ByPayee,
  ByCategory,
}

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

  String getGroupName(TransactionsGroupingOption transactionsGroupingOption) {
    switch (transactionsGroupingOption) {
      case TransactionsGroupingOption.ByPayee:
        return payee;
        break;
      case TransactionsGroupingOption.ByCategory:
        return category;
        break;
      default:
        return 'Unknown Group';
    }
  }
}
