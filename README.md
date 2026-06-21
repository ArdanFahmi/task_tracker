# Task Tracker App

## Cara Menjalankan Project

Prasyarat:
- Flutter SDK v3.41.9
- Android Studio / Xcode atau emulator/device yang terpasang
- Dart v3.11.5

Langkah:
1. Clone repository dan masuk ke folder project:
   - git clone <repo-url>
   - cd task_tracker
2. Install dependency:
   - flutter pub get
3. Jalankan aplikasi:
   - flutter run
4. Build release (opsional):
   - flutter build apk --release

## Penjelasan Arsitektur

Project mengikuti prinsip terstruktur (mirip Clean/Layered architecture) dengan pembagian tanggung jawab:
- Presentation: layar, widget, dan komponen UI.
- State: provider dan state controllers (menggunakan Riverpod) yang menjadi penghubung UI dan domain.
- Domain: entity dan use-case (logika bisnis inti).
- Data: repository, data source (local/remote), dan model mapping.

Organisasi file umumnya bersifat feature-based: setiap fitur memiliki folder sendiri berisi UI, provider, repository, dan model terkait. Ini memudahkan skalabilitas dan pengujian.

## Penjelasan State Management

State management diimplementasikan dengan Riverpod, yaitu:
- Provider: untuk nilai/servis yang tidak berubah.
- StateProvider / StateController: untuk state sederhana yang berubah lokal.
- StateNotifierProvider + StateNotifier: untuk state kompleks dan immutable dengan metode untuk memodifikasi state.
- FutureProvider / StreamProvider: untuk operasi asinkron (fetch data atau stream updates).

Alur umum: UI membaca provider -> memanggil method pada notifier/repository -> notifier memperbarui state -> UI bereaksi terhadap perubahan.

## Alasan Memilih Riverpod

Ringkas alasan memilih Riverpod untuk project ini:
- Bebas dari ketergantungan pada widget tree (decoupled dari BuildContext).
- Lebih aman pada compile-time dan mencegah beberapa kelas bug runtime.
- Skalabel untuk aplikasi besar: provider-family, autoDispose, dan kombinasi provider memudahkan manajemen state feature-wise.
- Performa baik: pembaruan terbatas pada listener yang relevan.

## Backend: Supabase (PostgreSQL)

Project ini menggunakan Supabase (PostgreSQL) sebagai backend. Alasan dan keuntungan utama:
- Database SQL lengkap (PostgreSQL) untuk query kompleks dan relasi data.
- Managed service: tidak perlu mengelola server database sendiri.
- Fitur realtime: subscriptions dan realtime updates berguna untuk sinkronisasi task secara langsung.
- Autentikasi bawaan (email/password, OAuth) yang mudah dipadukan dengan aplikasi Flutter.
- Dukungan SDK Dart/Flutter (`supabase_flutter`) mempermudah integrasi.
- Keamanan: dukungan Row-Level Security (RLS) dan policy untuk kontrol akses.
- Cepat untuk prototyping namun cukup kuat untuk skala produksi.

Catatan konfigurasi singkat:
- Simpan SUPABASE_URL dan SUPABASE_ANON_KEY di environment variables.
- Contoh inisialisasi di Flutter: `Supabase.initialize(url: ..., anonKey: ...)` (lihat dokumentasi `supabase_flutter`).

## Table Schema
```
create table public.tasks (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  user_id uuid not null default auth.uid (),
  title character varying not null,
  description character varying null,
  start_date timestamp with time zone not null,
  end_date timestamp with time zone not null,
  status public.task status not null,
  is_deleted boolean not null default false,
  constraint task_pkey primary key (id),
  constraint task_user_id_fkey foreign KEY (user_id) references auth.users (id)
) TABLESPACE pg_default;
```

## Screenshot

<p align="center">
  <img src="assets/screenshots/login.jpg" width="250" />
  <img src="assets/screenshots/register.jpg" width="250" />
  <img src="assets/screenshots/list-task.jpg" width="250" />
  <img src="assets/screenshots/list-task-update-status.jpg" width="250" />
  <img src="assets/screenshots/list-task-more-action.jpg" width="250" />
  <img src="assets/screenshots/form-new-task.jpg" width="250" />
  <img src="assets/screenshots/form-edit-task.jpg" width="250" />
  <img src="assets/screenshots/detail.jpg" width="250" />
  <img src="assets/screenshots/popup-delete.jpg" width="250" />
  <img src="assets/screenshots/profile.jpg" width="250" />
</p>