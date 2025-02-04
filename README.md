# Task Management App

Aplikasi Flutter sederhana untuk manajemen tugas dengan fitur autentikasi dan CRUD tugas. Dibangun menggunakan **Clean Architecture** dan **Hive** untuk penyimpanan data lokal.

### Cara Menjalankan Aplikasi

- Clone repository
- Instal dependensi `flutter pub get`
- Jalankan aplikasi `flutter run`

### Penjelasan Arsitektur
Aplikasi ini dibangun menggunakan Clean Architecture, yang memisahkan kode ke dalam beberapa lapisan untuk memudahkan pengelolaan dan pengujian. Berikut adalah penjelasan singkat mengenai lapisan-lapisan utama:

- Presentation Layer: Menangani UI aplikasi. Menggunakan Flutter untuk antarmuka pengguna dan State Management untuk mengelola status UI.
- Domain Layer: Berisi logika bisnis inti aplikasi, seperti proses autentikasi dan manajemen tugas.
- Data Layer: Mengelola sumber daya data. Dalam aplikasi ini, data disimpan menggunakan Hive untuk penyimpanan lokal dan menggunakan mock API (https://reqres.in) untuk autentikasi pengguna.

### Daftar Library Pihak Ketiga

**lutter_bloc**
Library untuk manajemen state menggunakan BLoC (Business Logic Component) pattern. Memisahkan logika aplikasi dari UI dan memungkinkan pengelolaan status aplikasi secara lebih terstruktur dan dapat diuji.

**dio**
Library HTTP client yang digunakan untuk melakukan request ke API. Mendukung berbagai fitur seperti interceptors, request cancellation, dan file downloading.

**email_validator**
Library untuk memvalidasi format email dengan cara yang sederhana dan efisien. Memastikan bahwa input email sesuai dengan format yang benar.

**provider**
Library untuk state management yang memungkinkan pengelolaan dan pembagian state secara efisien di seluruh aplikasi. Biasanya digunakan untuk menyediakan objek dan state di widget tree.

**hive**
Database ringan dan cepat untuk penyimpanan data lokal pada aplikasi Flutter. Data disimpan dalam format key-value dan mendukung tipe data kompleks.

**hive_flutter**
Ekstensi dari Hive yang memberikan integrasi dengan Flutter, memungkinkan penggunaan Hive dalam aplikasi Flutter dengan kemudahan untuk bekerja dengan data reaktif.

**intl**
Library untuk internasionalisasi dan format tanggal/waktu. Digunakan untuk mendukung berbagai format tanggal, mata uang, dan pengaturan lokal sesuai kebutuhan pengguna di berbagai lokasi.

