import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../enum/transaction.dart';
import '../service/currency_service.dart';
import 'transaction_model.dart';

part 'totals_transaction_model.freezed.dart';

@freezed
class TotalsTransaction with _$TotalsTransaction {
  const factory TotalsTransaction({
    required double totalIncome,
    required double totalExpense,
    required double totalBalance,
  }) = _TotalsTransactionModel;

  factory TotalsTransaction.calcu(List<Transaction> transactions) {
    // Lấy loại tiền hiện tại để convert
    final currentLocale = Intl.getCurrentLocale();
    final currentCurrencyType = CurrencyService.getCurrencyType(currentLocale);

    // Convert tất cả transaction về loại tiền hiện tại
    final convertedTransactions =
        transactions.map((transaction) {
          final originalCurrencyType = _getCurrencyTypeFromString(
            transaction.originalCurrency,
          );
          final convertedAmount = CurrencyService.convertCurrency(
            amount: transaction.amount,
            fromCurrency: originalCurrencyType,
            toCurrency: currentCurrencyType,
          );
          return transaction.copyWith(amount: convertedAmount);
        }).toList();

    // Tính riêng tổng thu và tổng chi (đều là số dương)
    final totalExpense = convertedTransactions
        .where((transaction) => transaction.category == Category.expense)
        .map((transaction) => transaction.amount)
        .fold(0.0, (prev, amount) => prev + amount);

    final totalIncome = convertedTransactions
        .where((transaction) => transaction.category == Category.income)
        .map((transaction) => transaction.amount)
        .fold(0.0, (prev, amount) => prev + amount);

    return TotalsTransaction(
      // totalExpense = tổng chi (dương)
      totalExpense: totalExpense,

      // totalIncome = tổng thu (dương)
      totalIncome: totalIncome,

      // totalBalance = totalIncome - totalExpense
      totalBalance: totalIncome - totalExpense,
    );
  }

  /// Lấy CurrencyType từ string
  static CurrencyType _getCurrencyTypeFromString(String currencyString) {
    switch (currencyString.toUpperCase()) {
      case 'VND':
        return CurrencyType.vnd;
      case 'CNY':
        return CurrencyType.cny;
      case 'USD':
      default:
        return CurrencyType.usd;
    }
  }
}
