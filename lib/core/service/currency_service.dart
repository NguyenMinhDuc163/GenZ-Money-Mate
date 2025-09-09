import 'package:intl/intl.dart';

enum CurrencyType { usd, vnd, cny }

class CurrencyService {
  // Tỉ giá cố định (có thể thay thế bằng API thực tế)
  static const Map<String, double> _exchangeRates = {
    'USD_VND': 26390.0,
    'CNY_VND': 3705.0,
    'USD_CNY': 7.12,
    'VND_USD': 1 / 26390.0,
    'VND_CNY': 1 / 3705.0,
    'CNY_USD': 1 / 7.12,
  };

  /// Lấy loại tiền theo locale
  static CurrencyType getCurrencyType(String locale) {
    switch (locale) {
      case 'vi':
        return CurrencyType.vnd;
      case 'zh':
        return CurrencyType.cny;
      default:
        return CurrencyType.usd;
    }
  }

  /// Lấy symbol tiền theo loại
  static String getCurrencySymbol(CurrencyType currencyType) {
    switch (currencyType) {
      case CurrencyType.vnd:
        return '₫ ';
      case CurrencyType.cny:
        return '¥ ';
      case CurrencyType.usd:
        return '\$ ';
    }
  }

  /// Lấy số decimal digits theo loại tiền
  static int getDecimalDigits(CurrencyType currencyType) {
    switch (currencyType) {
      case CurrencyType.vnd:
        return 0; // VND không có decimal
      case CurrencyType.cny:
      case CurrencyType.usd:
        return 2;
    }
  }

  /// Convert tiền từ loại này sang loại khác
  static double convertCurrency({
    required double amount,
    required CurrencyType fromCurrency,
    required CurrencyType toCurrency,
  }) {
    if (fromCurrency == toCurrency) {
      return amount; // Không cần convert
    }

    final rateKey =
        '${fromCurrency.name.toUpperCase()}_${toCurrency.name.toUpperCase()}';
    final rate = _exchangeRates[rateKey];

    if (rate == null) {
      throw Exception('Exchange rate not found for $rateKey');
    }

    return amount * rate;
  }

  /// Format tiền theo loại tiền
  static String formatCurrency({
    required double amount,
    required CurrencyType currencyType,
    bool showSymbol = true,
  }) {
    final symbol = showSymbol ? getCurrencySymbol(currencyType) : '';
    final decimalDigits = getDecimalDigits(currencyType);

    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );

    return formatter.format(amount);
  }

  /// Convert và format tiền từ loại gốc sang loại hiện tại
  static String convertAndFormatCurrency({
    required double originalAmount,
    required CurrencyType originalCurrency,
    required CurrencyType targetCurrency,
    bool showSymbol = true,
  }) {
    final convertedAmount = convertCurrency(
      amount: originalAmount,
      fromCurrency: originalCurrency,
      toCurrency: targetCurrency,
    );

    return formatCurrency(
      amount: convertedAmount,
      currencyType: targetCurrency,
      showSymbol: showSymbol,
    );
  }

  /// Lấy tên loại tiền
  static String getCurrencyName(CurrencyType currencyType) {
    switch (currencyType) {
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.vnd:
        return 'VND';
      case CurrencyType.cny:
        return 'CNY';
    }
  }
}
