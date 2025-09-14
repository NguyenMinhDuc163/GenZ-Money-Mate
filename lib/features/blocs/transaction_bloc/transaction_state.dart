part of 'transaction_cubit.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = Loading;
  const factory TransactionState.success(String message) = Success;
  const factory TransactionState.error(String message) = Error;
  const factory TransactionState.loadTransaction({
    Categorys? categorys, // Có thể null khi sử dụng custom category
    CustomCategory? customCategory, // Custom category được chọn
    required DateTime transactionDate,
    required Category transactionCategory,
  }) = LoadTransaction;
}
