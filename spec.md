# SPEC: Tích hợp AdMob cho ứng dụng GenZ Money Mate

## 1. Bối cảnh

Ứng dụng **GenZ Money Mate** là app Flutter quản lý tài chính cá nhân, đã phát hành trên **Google Play** và **App Store**.

Hiện tại:

* Android đã được AdMob verify.
* iOS chưa verify AdMob vì App Store listing chưa thêm link quảng bá / Marketing URL.
* Lần release iOS tiếp theo sẽ thêm luôn Marketing URL để AdMob có thể crawl `app-ads.txt`.
* Ứng dụng dùng Flutter, nhưng cấu hình AdMob cần tách riêng Android và iOS.
* Code hiển thị quảng cáo có thể dùng chung ở Dart.
* AdMob App ID và Ad Unit ID của Android/iOS không được dùng chung.
* Không hash/mã hóa AdMob ID. Đây không phải secret key, SDK cần đọc đúng ID gốc.

Mục tiêu là tích hợp quảng cáo sao cho:

* Không phá trải nghiệm nhập giao dịch.
* Không gây khó chịu khi người dùng xem số dư, thống kê.
* Tối ưu doanh thu ở các màn có lượt xem cao.
* Tuân thủ placement policy của AdMob.
* Có cấu trúc code dễ mở rộng về sau cho Banner, Interstitial, Native, Rewarded.

---

## 2. Phạm vi triển khai giai đoạn 1

Giai đoạn 1 chỉ triển khai các định dạng sau:

1. **Adaptive Banner**

   * Đặt tại màn Home.
   * Đặt tại màn Statistics / StateView.

2. **Interstitial**

   * Hiển thị sau khi người dùng lưu giao dịch thành công.
   * Có giới hạn tần suất.
   * Không hiện sau mỗi lần lưu.

Không triển khai Native/Rewarded ở giai đoạn 1, nhưng cần thiết kế code để sau này mở rộng dễ dàng.

---

## 3. Vị trí quảng cáo trong app

### 3.1. Home / MainView

File liên quan:

```text
lib/features/home/view/main_view.dart
```

Màn này hiện có flow UI chính:

```text
HeaderAppBarProfile
ExpenseCard
Header Transaction
TransactionList
```

Yêu cầu:

* Thêm 1 adaptive banner ở cuối phần content.
* Không che `BottomNavigationBar`.
* Không che `FloatingActionButton`.
* Không đặt banner quá gần nút thêm giao dịch để tránh bấm nhầm.
* Nếu không load được quảng cáo thì không để khoảng trắng lớn gây xấu UI.

Vị trí mong muốn:

```text
HeaderAppBarProfile
ExpenseCard
Header Transaction
TransactionList
HomeBannerAd
```

Tên widget đề xuất:

```dart
AdBannerWidget(placement: AdPlacement.home)
```

---

### 3.2. Statistics / StateView

File liên quan:

```text
lib/features/home/view/state_view.dart
```

Màn này có 2 tab:

```text
Income
Expense
```

Yêu cầu:

* Thêm adaptive banner dưới phần thống kê/filter.
* Không hiện interstitial khi người dùng đổi tab Income/Expense.
* Banner chỉ là phụ trợ, không được che biểu đồ hoặc danh sách giao dịch.

Vị trí mong muốn:

```text
HeaderAppBarFilter
CustomTabBar
StatsBannerAd
```

Tên widget đề xuất:

```dart
AdBannerWidget(placement: AdPlacement.stats)
```

---

### 3.3. TransactionView / màn thêm giao dịch

File liên quan:

```text
lib/features/transaction/view/transaction_view.dart
```

Màn này là nơi người dùng nhập giao dịch:

```text
Số tiền
Nhóm
Danh mục
Income/Expense
Ngày
Nút Save
```

Yêu cầu quan trọng:

* Không đặt banner trong màn này.
* Không hiện interstitial khi mở màn này.
* Không hiện interstitial khi người dùng chọn group/category/date.
* Không hiện quảng cáo trong modal/bottom sheet chọn danh mục.
* Chỉ được xét hiển thị interstitial sau khi lưu giao dịch thành công và đã quay về màn trước.

Hiện tại `_success()` đang xử lý:

```dart
Alerts.hideLoaderDialog(context);
Alerts.showToastMsg(context, message.tr());
context.pop();
```

Cần cập nhật logic thành:

```text
Ẩn loading
Hiển thị toast thành công
Pop về Home
Sau khi pop, gọi AdService để xét điều kiện hiển thị interstitial
```

Lưu ý:

* Không hiện interstitial nếu vừa mở app.
* Không hiện interstitial nếu chưa đủ cooldown.
* Không hiện interstitial nếu số lần lưu giao dịch chưa đạt ngưỡng.

---

### 3.4. AllViewTransaction

File liên quan:

```text
lib/features/home/view/all_view_transaction.dart
```

Giai đoạn 1 chưa triển khai quảng cáo tại màn này.

Ghi chú cho giai đoạn sau:

* Có thể triển khai Native Ad trong list giao dịch.
* Chèn sau mỗi 8–10 transaction.
* Không hiển thị nếu danh sách dưới 5 giao dịch.
* Native ad phải có label rõ ràng là quảng cáo.

---

### 3.5. RankingView

File liên quan:

```text
lib/features/ranking/view/ranking_view.dart
```

Giai đoạn 1 chưa bắt buộc triển khai quảng cáo tại màn này.

Ghi chú cho giai đoạn sau:

* Có thể thêm banner/native sau `RankingProgressCard`.
* Có thể thêm rewarded ad cho tính năng phụ như:

  * Xem gợi ý tiết kiệm.
  * Mở phân tích nâng cao.
  * Nhận mẹo giảm chi theo từng nhóm.

Không được khóa tính năng cốt lõi sau quảng cáo.

---

## 4. Tần suất hiển thị Interstitial

Interstitial chỉ hiển thị sau khi lưu giao dịch thành công.

Điều kiện đề xuất:

```text
Hiển thị sau mỗi 4 giao dịch thành công
và cooldown tối thiểu 3 phút giữa 2 lần interstitial
```

Cần lưu local state bằng `SharedPreferences`.

Các key đề xuất:

```dart
ad_interstitial_success_transaction_count
ad_last_interstitial_shown_at
```

Logic:

```text
Khi user lưu giao dịch thành công:
1. Tăng counter lên 1.
2. Nếu counter >= 4 và cooldown >= 3 phút:
   - Load/show interstitial nếu sẵn sàng.
   - Reset counter về 0.
   - Lưu thời gian hiển thị mới.
3. Nếu chưa đủ điều kiện:
   - Không làm gì.
```

Không được show interstitial trong các trường hợp:

```text
App vừa mở
User đang nhập form
User đang chọn category/group/date
User đổi tab Income/Expense
User mở Settings
User thoát app
User chưa hoàn thành task chính
```

---

## 5. Cấu trúc file cần thêm

Tạo thư mục:

```text
lib/core/ads/
```

Các file đề xuất:

```text
lib/core/ads/ad_ids.dart
lib/core/ads/ad_placement.dart
lib/core/ads/ad_service.dart
lib/core/ads/widgets/ad_banner_widget.dart
```

---

## 6. Ad placement enum

Tạo file:

```text
lib/core/ads/ad_placement.dart
```

Nội dung đề xuất:

```dart
enum AdPlacement {
  home,
  stats,
  transactionSuccessInterstitial,
  transactionListNative,
  rankingRewarded,
}
```

Giai đoạn 1 chỉ dùng:

```dart
AdPlacement.home
AdPlacement.stats
AdPlacement.transactionSuccessInterstitial
```

---

## 7. Ad IDs

Tạo file:

```text
lib/core/ads/ad_ids.dart
```

Yêu cầu:

* Tách Android/iOS.
* Không hardcode trực tiếp trong widget.
* Có fallback test ID cho debug mode.
* Không dùng `dart:io` trực tiếp nếu app còn build web. Nếu project chỉ build Android/iOS thì có thể dùng `Platform.isAndroid` / `Platform.isIOS`. Nếu muốn an toàn cho web, check `kIsWeb` trước.

Cấu trúc đề xuất:

```dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'ad_placement.dart';

class AdIds {
  const AdIds._();

  static String appIdAndroid = 'ANDROID_ADMOB_APP_ID';
  static String appIdIos = 'IOS_ADMOB_APP_ID';

  static String getAdUnitId(AdPlacement placement) {
    if (kDebugMode) {
      return _getTestAdUnitId(placement);
    }

    if (kIsWeb) {
      throw UnsupportedError('AdMob is not supported on Web');
    }

    if (Platform.isAndroid) {
      return _getAndroidAdUnitId(placement);
    }

    if (Platform.isIOS) {
      return _getIosAdUnitId(placement);
    }

    throw UnsupportedError('Unsupported platform for AdMob');
  }

  static String _getAndroidAdUnitId(AdPlacement placement) {
    switch (placement) {
      case AdPlacement.home:
        return 'ANDROID_HOME_BANNER_AD_UNIT_ID';
      case AdPlacement.stats:
        return 'ANDROID_STATS_BANNER_AD_UNIT_ID';
      case AdPlacement.transactionSuccessInterstitial:
        return 'ANDROID_TRANSACTION_SUCCESS_INTERSTITIAL_AD_UNIT_ID';
      case AdPlacement.transactionListNative:
        return 'ANDROID_TRANSACTION_LIST_NATIVE_AD_UNIT_ID';
      case AdPlacement.rankingRewarded:
        return 'ANDROID_RANKING_REWARDED_AD_UNIT_ID';
    }
  }

  static String _getIosAdUnitId(AdPlacement placement) {
    switch (placement) {
      case AdPlacement.home:
        return 'IOS_HOME_BANNER_AD_UNIT_ID';
      case AdPlacement.stats:
        return 'IOS_STATS_BANNER_AD_UNIT_ID';
      case AdPlacement.transactionSuccessInterstitial:
        return 'IOS_TRANSACTION_SUCCESS_INTERSTITIAL_AD_UNIT_ID';
      case AdPlacement.transactionListNative:
        return 'IOS_TRANSACTION_LIST_NATIVE_AD_UNIT_ID';
      case AdPlacement.rankingRewarded:
        return 'IOS_RANKING_REWARDED_AD_UNIT_ID';
    }
  }

  static String _getTestAdUnitId(AdPlacement placement) {
    if (kIsWeb) {
      throw UnsupportedError('AdMob is not supported on Web');
    }

    if (Platform.isAndroid) {
      switch (placement) {
        case AdPlacement.home:
        case AdPlacement.stats:
          return 'ca-app-pub-3940256099942544/6300978111';
        case AdPlacement.transactionSuccessInterstitial:
          return 'ca-app-pub-3940256099942544/1033173712';
        case AdPlacement.transactionListNative:
          return 'ca-app-pub-3940256099942544/2247696110';
        case AdPlacement.rankingRewarded:
          return 'ca-app-pub-3940256099942544/5224354917';
      }
    }

    if (Platform.isIOS) {
      switch (placement) {
        case AdPlacement.home:
        case AdPlacement.stats:
          return 'ca-app-pub-3940256099942544/2934735716';
        case AdPlacement.transactionSuccessInterstitial:
          return 'ca-app-pub-3940256099942544/4411468910';
        case AdPlacement.transactionListNative:
          return 'ca-app-pub-3940256099942544/3986624511';
        case AdPlacement.rankingRewarded:
          return 'ca-app-pub-3940256099942544/1712485313';
      }
    }

    throw UnsupportedError('Unsupported platform for AdMob');
  }
}
```

Sau khi tôi cung cấp ID thật, thay các placeholder sau:

```text
ANDROID_ADMOB_APP_ID
IOS_ADMOB_APP_ID

ANDROID_HOME_BANNER_AD_UNIT_ID
IOS_HOME_BANNER_AD_UNIT_ID

ANDROID_STATS_BANNER_AD_UNIT_ID
IOS_STATS_BANNER_AD_UNIT_ID

ANDROID_TRANSACTION_SUCCESS_INTERSTITIAL_AD_UNIT_ID
IOS_TRANSACTION_SUCCESS_INTERSTITIAL_AD_UNIT_ID
```

---

## 8. AdService

Tạo file:

```text
lib/core/ads/ad_service.dart
```

Yêu cầu:

* Khởi tạo Google Mobile Ads SDK.
* Load trước interstitial.
* Quản lý frequency cap.
* Không để UI gọi trực tiếp `InterstitialAd.load`.
* Có method riêng cho transaction success.

API đề xuất:

```dart
class AdService {
  Future<void> initialize();

  Future<void> preloadTransactionSuccessInterstitial();

  Future<void> onTransactionSavedSuccessfully();

  Future<bool> canShowTransactionSuccessInterstitial();

  void dispose();
}
```

Logic:

```text
initialize():
- Gọi MobileAds.instance.initialize()
- Preload interstitial transaction success

preloadTransactionSuccessInterstitial():
- Load InterstitialAd với AdPlacement.transactionSuccessInterstitial
- Nếu load fail thì giữ null, không crash app

onTransactionSavedSuccessfully():
- Tăng counter transaction success
- Kiểm tra counter + cooldown
- Nếu đủ điều kiện và interstitial đã load:
  - Show ad
  - Reset counter
  - Save last shown timestamp
  - Sau khi ad dismissed/fail show thì preload ad mới
- Nếu chưa đủ điều kiện:
  - Không show
  - Có thể preload nếu ad null

canShowTransactionSuccessInterstitial():
- counter >= 4
- lastShownAt cách hiện tại >= 3 phút
- interstitial != null
```

Không được để quảng cáo crash app nếu load fail.

---

## 9. Đăng ký AdService vào GetIt

File liên quan:

```text
lib/core/app_injections.dart
```

Thêm import:

```dart
import 'ads/ad_service.dart';
```

Trong `initAppConfig()`:

```dart
final adService = AdService(sharedPreferences: getIt());
await adService.initialize();
getIt.registerLazySingleton<AdService>(() => adService);
```

Yêu cầu:

* Đăng ký sau khi `SharedPreferences` đã init.
* Không làm app crash nếu AdMob init fail.
* Nếu platform là Web thì không init AdMob.

---

## 10. Thêm package

Trong `pubspec.yaml`, thêm:

```yaml
google_mobile_ads: ^5.0.0
```

Nếu version mới hơn tương thích với Flutter hiện tại thì dùng version stable mới nhất.

Sau đó chạy:

```bash
flutter pub get
```

---

## 11. Android config

File liên quan:

```text
android/app/src/main/AndroidManifest.xml
```

Thêm trong thẻ `<application>`:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ANDROID_ADMOB_APP_ID"/>
```

Yêu cầu:

* Dùng Android AdMob App ID dạng có dấu `~`.
* Không dùng Ad Unit ID ở đây.
* Không dùng iOS App ID ở đây.

Ví dụ format:

```text
ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
```

---

## 12. iOS config

File liên quan:

```text
ios/Runner/Info.plist
```

Thêm:

```xml
<key>GADApplicationIdentifier</key>
<string>IOS_ADMOB_APP_ID</string>
```

Yêu cầu:

* Dùng iOS AdMob App ID dạng có dấu `~`.
* Không dùng Ad Unit ID ở đây.
* Không hash/mã hóa ID.
* ID này không phải secret.

Ví dụ format:

```text
ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
```

---

## 13. iOS verification / app-ads.txt

Không cần chờ iOS verify mới được tích hợp SDK.

Lần release iOS này cần:

```text
1. Build app có AdMob iOS App ID + iOS Ad Unit ID.
2. Submit update lên App Store.
3. Trong App Store Connect thêm Marketing URL / Developer Website.
4. Marketing URL trỏ về domain có file app-ads.txt ở root.
```

Ví dụ domain:

```text
https://nguyenduc1603.github.io
```

File cần tồn tại:

```text
https://nguyenduc1603.github.io/app-ads.txt
```

Nội dung hiện tại nếu dùng chung publisher:

```text
google.com, pub-4649011658078977, DIRECT, f08c47fec0942fa0
```

Không cần build thêm bản iOS mới sau khi verify, miễn là ID trong app đã đúng.

Chỉ cần submit lại nếu:

```text
Gắn sai iOS App ID
Gắn sai iOS Ad Unit ID
Quên thêm GADApplicationIdentifier
Quên code load ads
Muốn đổi vị trí quảng cáo
```

---

## 14. Banner widget

Tạo file:

```text
lib/core/ads/widgets/ad_banner_widget.dart
```

Yêu cầu:

* Dùng adaptive banner.
* Không làm app crash nếu load fail.
* Nếu load fail thì return `SizedBox.shrink()`.
* Chỉ render trên Android/iOS.
* Không render trên Web.
* Có loading state nhưng không chiếm chiều cao quá lớn.
* Widget nhận `AdPlacement`.

API đề xuất:

```dart
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({
    super.key,
    required this.placement,
  });

  final AdPlacement placement;

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}
```

Cách dùng:

```dart
const AdBannerWidget(placement: AdPlacement.home)
```

và:

```dart
const AdBannerWidget(placement: AdPlacement.stats)
```

---

## 15. Tích hợp banner vào MainView

File:

```text
lib/features/home/view/main_view.dart
```

Thêm import:

```dart
import '../../../core/ads/ad_placement.dart';
import '../../../core/ads/widgets/ad_banner_widget.dart';
```

Thêm widget sau `TransactionList`.

Hiện tại đoạn `BlocBuilder<MainCubit, MainState>` render `TransactionList`.

Yêu cầu:

* Sau block TransactionList, thêm khoảng cách nhỏ.
* Thêm banner.
* Không làm layout overflow.

Ví dụ mong muốn:

```dart
Expanded(
  child: BlocBuilder<MainCubit, MainState>(
    ...
  ),
),
const SizedBox(height: 8),
const AdBannerWidget(placement: AdPlacement.home),
```

Nếu layout hiện tại không có `Expanded`, cần điều chỉnh để banner không làm overflow trên màn nhỏ.

---

## 16. Tích hợp banner vào StateView

File:

```text
lib/features/home/view/state_view.dart
```

Thêm import:

```dart
import '../../../core/ads/ad_placement.dart';
import '../../../core/ads/widgets/ad_banner_widget.dart';
```

Trong `_buidBody()`, thêm banner ở dưới `CustomTabBar`.

Mong muốn:

```dart
Expanded(
  child: CustomTabBar(...),
),
const SizedBox(height: 8),
const AdBannerWidget(placement: AdPlacement.stats),
```

Không được đặt banner bên trong từng tab nếu gây reload nhiều lần khi đổi tab.

---

## 17. Tích hợp interstitial sau khi lưu giao dịch

File:

```text
lib/features/transaction/view/transaction_view.dart
```

Thêm import:

```dart
import '../../../core/app_injections.dart';
import '../../../core/ads/ad_service.dart';
```

Cập nhật `_success()`.

Logic mong muốn:

```dart
_success(BuildContext context, String message) {
  Alerts.hideLoaderDialog(context);
  Alerts.showToastMsg(context, message.tr());

  context.pop();

  Future.microtask(() {
    getIt<AdService>().onTransactionSavedSuccessfully();
  });
}
```

Nếu context sau pop gây lỗi hoặc timing chưa ổn, có thể dùng:

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  getIt<AdService>().onTransactionSavedSuccessfully();
});
```

Yêu cầu:

* Không show ads trước khi `context.pop()`.
* Không block UI nếu ad chưa load.
* Không hiện nếu chưa đủ frequency cap.

---

## 18. Không tích hợp quảng cáo ở các vị trí sau

Không được thêm ads vào:

```text
lib/features/transaction/view/widgets/transaction_form.dart
```

Không đặt ads trong:

```text
Bottom sheet chọn group
Bottom sheet chọn category
Dialog tạo custom category
Dialog tạo category group
Date picker
Profile form
Language switch
Dark mode switch
```

Lý do:

* Đây là các flow nhập liệu/thiết lập.
* Dễ gây khó chịu.
* Dễ tạo trải nghiệm giống ép click.

---

## 19. App lifecycle

Yêu cầu:

* Khi interstitial dismiss/fail show, preload interstitial mới.
* Khi dispose AdService, dispose interstitial nếu có.
* Không preload liên tục nếu load fail, tránh spam request.
* Có thể retry sau một khoảng thời gian ngắn hoặc khi lần sau user lưu giao dịch.

---

## 20. Debug/Test

Trong debug mode:

* Bắt buộc dùng test ad unit ID.
* Không dùng ID thật khi debug.
* Không click quảng cáo thật.

Cần log nhẹ trong debug:

```text
AdMob initialized
Banner loaded: placement
Banner failed: placement + error
Interstitial loaded
Interstitial failed
Interstitial shown
Interstitial skipped: reason
```

Không dùng `print` quá nhiều trong release.

---

## 21. Release checklist

Trước khi release Android:

```text
[ ] Android AdMob App ID đã thêm vào AndroidManifest.xml
[ ] Android Home Banner Ad Unit ID đúng
[ ] Android Stats Banner Ad Unit ID đúng
[ ] Android Interstitial Ad Unit ID đúng
[ ] Android đã verify app-ads.txt
[ ] Test trên thiết bị thật
[ ] Không crash khi mất mạng
```

Trước khi release iOS:

```text
[ ] iOS AdMob App ID đã thêm vào Info.plist
[ ] iOS Home Banner Ad Unit ID đúng
[ ] iOS Stats Banner Ad Unit ID đúng
[ ] iOS Interstitial Ad Unit ID đúng
[ ] App Store Connect đã thêm Marketing URL / Developer Website
[ ] Domain có /app-ads.txt ở root
[ ] Không cần hash AdMob ID
[ ] Test trên thiết bị iOS thật nếu có thể
```

---

## 22. Acceptance Criteria

Task được xem là hoàn thành khi:

```text
1. App build được trên Android.
2. App build được trên iOS.
3. Debug mode dùng test ads.
4. Release mode dùng ad unit ID thật theo platform.
5. Home hiển thị adaptive banner đúng vị trí.
6. StateView hiển thị adaptive banner đúng vị trí.
7. TransactionView không có banner.
8. Sau khi lưu giao dịch thành công, app pop về Home trước.
9. Interstitial chỉ hiện khi đủ:
   - Ít nhất 4 giao dịch thành công kể từ lần trước.
   - Cooldown tối thiểu 3 phút.
10. Nếu ad load fail, app vẫn hoạt động bình thường.
11. Không có quảng cáo trong modal chọn category/group/date picker.
12. Code được tổ chức trong lib/core/ads/.
13. Không hardcode ad unit ID rải rác trong UI.
```

---

## 23. Các placeholder cần tôi cung cấp

Hiện tại để triển khai production, cần tôi cung cấp các giá trị sau:

```text
ANDROID_ADMOB_APP_ID=
IOS_ADMOB_APP_ID=

ANDROID_HOME_BANNER_AD_UNIT_ID=
IOS_HOME_BANNER_AD_UNIT_ID=

ANDROID_STATS_BANNER_AD_UNIT_ID=
IOS_STATS_BANNER_AD_UNIT_ID=

ANDROID_TRANSACTION_SUCCESS_INTERSTITIAL_AD_UNIT_ID=
IOS_TRANSACTION_SUCCESS_INTERSTITIAL_AD_UNIT_ID=
```

Nếu chưa có stats banner riêng, có thể tạm dùng chung banner ad unit với Home trong giai đoạn đầu, nhưng khuyến nghị nên tạo riêng để đo hiệu quả từng màn.

---

## 24. Ghi chú triển khai sau giai đoạn 1

Sau khi phase 1 ổn định, có thể triển khai phase 2:

```text
Native ad trong AllViewTransaction:
- Chèn sau mỗi 8-10 transaction.
- Không hiện nếu list dưới 5 item.
- Có label "Ad" / "Quảng cáo".

Rewarded trong RankingView:
- User chủ động bấm xem quảng cáo.
- Không tự bật.
- Dùng để mở gợi ý tiết kiệm/phân tích nâng cao.
```

Không triển khai phase 2 trong task hiện tại nếu chưa được yêu cầu.
