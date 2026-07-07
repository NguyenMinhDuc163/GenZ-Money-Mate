Bạn hãy sửa lỗi Google Play Console cho Flutter Android app.

Hiện Play Console báo 2 lỗi:

1. Advertising ID declaration trong Play Console đang khai báo app có dùng Advertising ID, nhưng manifest trong active artifact không có permission:
com.google.android.gms.permission.AD_ID

2. Release mới không còn hỗ trợ 916 thiết bị so với release trước.

Yêu cầu sửa:

I. Sửa lỗi Advertising ID

Mở file:

android/app/src/main/AndroidManifest.xml

Thêm permission sau vào trong thẻ <manifest>, nằm bên ngoài thẻ <application>:

<uses-permission android:name="com.google.android.gms.permission.AD_ID" />

Ví dụ cấu trúc đúng:

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="com.google.android.gms.permission.AD_ID" />

    <application>
        ...
    </application>

</manifest>

Không được thêm permission này bên trong <application>.

II. Đảm bảo AdMob App ID vẫn đúng

Trong AndroidManifest.xml, bên trong <application> phải có meta-data AdMob App ID:

<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ANDROID_ADMOB_APP_ID" />

Không được dùng nhầm iOS AdMob App ID.
Android AdMob App ID có dạng:

ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy

III. Kiểm tra lỗi mất 916 thiết bị hỗ trợ

Hãy kiểm tra các file cấu hình Android để tìm nguyên nhân làm giảm số thiết bị hỗ trợ.

Cần kiểm tra các mục sau:

1. minSdkVersion

Mở:

android/app/build.gradle
hoặc
android/app/build.gradle.kts

Kiểm tra defaultConfig:

defaultConfig {
    minSdkVersion ...
    targetSdkVersion ...
}

Không được tự ý tăng minSdkVersion nếu không có dependency bắt buộc.

Với app này, ưu tiên giữ minSdkVersion giống release trước. Nếu không biết release trước là bao nhiêu, kiểm tra git history.

Không tự tăng minSdk lên 26/28/30 nếu không cần.

2. ABI filters

Kiểm tra trong build.gradle/build.gradle.kts có đoạn kiểu:

ndk {
    abiFilters 'arm64-v8a'
}

hoặc:

abiFilters += listOf("arm64-v8a")

Nếu có cấu hình chỉ build arm64-v8a thì app sẽ mất thiết bị 32-bit.

Yêu cầu:
- Không giới hạn ABI nếu không cần.
- Nếu cần khai báo ABI thì phải hỗ trợ ít nhất:
  armeabi-v7a
  arm64-v8a

Không được chỉ để arm64-v8a.

3. uses-feature trong AndroidManifest.xml

Kiểm tra AndroidManifest.xml có các dòng như:

<uses-feature android:name="android.hardware.camera" android:required="true" />
<uses-feature android:name="android.hardware.location.gps" android:required="true" />
<uses-feature android:name="android.hardware.bluetooth" android:required="true" />

Nếu app không bắt buộc cần phần cứng đó để chạy, đổi required thành false:

<uses-feature
    android:name="android.hardware.camera"
    android:required="false" />

Không được để required=true cho camera, GPS, bluetooth, NFC, telephony hoặc sensor nếu app không bắt buộc phải có.

4. Permissions mới

Kiểm tra manifest có thêm permission nào không cần thiết làm Play giới hạn thiết bị không, ví dụ:

android.permission.CAMERA
android.permission.ACCESS_FINE_LOCATION
android.permission.ACCESS_COARSE_LOCATION
android.permission.BLUETOOTH
android.permission.NFC
android.permission.CALL_PHONE
android.permission.READ_PHONE_STATE

App quản lý chi tiêu này hiện không cần các quyền trên. Nếu không dùng thật thì loại bỏ.

IV. Build lại

Sau khi sửa, chạy:

flutter clean
flutter pub get
flutter build appbundle --release

Sau đó kiểm tra file AAB mới được tạo tại:

build/app/outputs/bundle/release/app-release.aab

V. Kiểm tra sau build

Sau khi build xong, kiểm tra merged manifest để đảm bảo có permission AD_ID.

Có thể kiểm tra bằng cách search trong thư mục build:

com.google.android.gms.permission.AD_ID

Kết quả mong muốn:
- AndroidManifest merged có permission AD_ID.
- Không có uses-feature required=true không cần thiết.
- Không có abiFilters chỉ giới hạn arm64-v8a.
- minSdkVersion không bị tăng bất thường.
- Build release thành công.

VI. Không được làm

- Không đổi package name/applicationId.
- Không đổi signing config.
- Không đổi versionCode/versionName nếu không được yêu cầu.
- Không xóa AdMob meta-data.
- Không dùng iOS AdMob App ID cho Android.
- Không tick/bỏ qua lỗi Advertising ID trong Play Console bằng cách thay đổi declaration. App có dùng AdMob nên phải thêm AD_ID permission.