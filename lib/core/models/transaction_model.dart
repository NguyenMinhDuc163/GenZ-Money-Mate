import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';
import 'transaction_hive_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String? uuid,
    required String? userId,
    required double amount,
    @TimestampConverter() required DateTime date,
    required int categorysIndex,
    required Category category,
    @Default('USD') String originalCurrency, // Loại tiền gốc
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  factory Transaction.empty() {
    return Transaction(
      uuid: '',
      userId: '',
      amount: 0.0,
      date: DateTime.now(),
      categorysIndex: 0,
      category: Category.expense,
    );
  }

  factory Transaction.fromHiveModel(TransactionHive transactionHive) {
    return Transaction(
      uuid: transactionHive.uuid,
      userId: transactionHive.userId,
      amount: transactionHive.amount,
      date: transactionHive.date,
      categorysIndex: transactionHive.categorysIndex,
      category:
          transactionHive.category == CategoryHive.expense
              ? Category.expense
              : Category.income,
      originalCurrency: transactionHive.originalCurrency ?? 'USD',
    );
  }
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp value) => value.toDate();

  @override
  Timestamp toJson(DateTime value) => Timestamp.fromDate(value);
}

extension TransactionTotalsExtension on List<Transaction> {
  Transaction toCalcTotals() {
    return Transaction(
      uuid: '',
      userId: '',
      amount: fold(0, (previousValue, element) {
        if (element.category == Category.expense) {
          return previousValue - element.amount;
        } else {
          return previousValue + element.amount;
        }
      }),
      date: DateTime.now(),
      categorysIndex: 0,
      category: Category.expense,
    );
  }

  /// Tính tổng với convert về loại tiền hiện tại
  double toCalcTotalsWithCurrencyConversion() {
    return fold(0, (previousValue, element) {
      // Convert amount về loại tiền hiện tại
      final convertedAmount = _convertToCurrentCurrency(element);

      if (element.category == Category.expense) {
        return previousValue - convertedAmount;
      } else {
        return previousValue + convertedAmount;
      }
    });
  }

  double _convertToCurrentCurrency(Transaction transaction) {
    // Import CurrencyService để sử dụng
    // Tạm thời return amount gốc, sẽ implement sau
    return transaction.amount;
  }
}

extension TransactionExtension on Transaction {
  TransactionHive toHiveModel() {
    return TransactionHive(
      uuid: uuid!,
      userId: userId ?? '',
      amount: amount,
      date: date,
      categorysIndex: categorysIndex,
      category:
          category == Category.expense
              ? CategoryHive.expense
              : CategoryHive.income,
      originalCurrency: originalCurrency,
    );
  }
}
