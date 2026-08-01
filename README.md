# MediBox — Smart Medicine Box App

Aplikasi Flutter untuk **kotak obat pintar (IoT)**. MediBox memungkinkan pengguna memantau status 5 slot obat secara real-time, mendapatkan rekomendasi obat melalui chatbot, serta menghubungkan perangkat ESP32 miliknya.

## ✨ Fitur

- **🔐 Autentikasi** — Login & Register dengan sesi persisten (GetStorage)
- **📊 Dashboard** — Memantau 5 slot obat dengan status stok real-time (polling otomatis tiap 10 detik)
- **🤖 Chatbot Medibot** — Rekomendasi obat berbasis AI berdasarkan keluhan pengguna
- **📡 Pendaftaran Perangkat** — Menghubungkan perangkat ESP32 melalui MAC address
- **👤 Profil** — Update data profil & manajemen perangkat (tambah/hapus device)

## 🛠 Teknologi

| Teknologi | Kegunaan |
|---|---|
| [Flutter](https://flutter.dev) | Framework UI |
| [GetX](https://pub.dev/packages/get) | State management & navigasi |
| [Dio](https://pub.dev/packages/dio) | HTTP client dengan interceptor |
| [GetStorage](https://pub.dev/packages/get_storage) | Local storage ringan (token & sesi) |

## 🗂 Struktur Proyek

```
lib/
├── app/
│   ├── bindings/        # Initial binding
│   ├── core/
│   │   ├── constants/   # Konfigurasi API (api_constants.dart)
│   │   ├── network/     # DioClient & exception handling
│   │   └── theme/       # Warna & tema aplikasi
│   ├── routes/          # Definisi route & binding (GetX)
│   └── utils/           # Utilitas validasi
├── data/
│   ├── models/          # Model data (user, slot, device, chat)
│   ├── providers/remote/ # Layer HTTP (AuthProvider, SlotProvider, dll)
│   └── repositories/    # Layer bisnis (AuthRepository, dll)
└── modules/             # Fitur per halaman
    ├── auth/            # Login & Register
    ├── splash/          # Splash screen & auto-login
    ├── main/            # Bottom navigation (Beranda, Chat, Profil)
    ├── dashboard/       # Slot obat & statistik
    ├── chat/            # Chatbot Medibot
    ├── device/          # Pendaftaran perangkat ESP32
    └── profile/         # Profil & manajemen perangkat
```

## 🚀 Cara Menjalankan

```bash
# 1. Install dependensi
flutter pub get

# 2. Jalankan aplikasi
flutter run
```

> Pastikan Flutter SDK sudah terinstall. Untuk Android gunakan `flutter run` pada emulator/perangkat, untuk iOS gunakan `flutter run` pada simulator.

## 🔗 API Endpoint

Base URL: `https://medibox.rutherweb.my.id/`

### Autentikasi & Profil

| Method | Endpoint | Fungsi |
|---|---|---|
| POST | `/auth/login` | Login pengguna |
| POST | `/auth/register` | Registrasi pengguna baru |
| GET | `/auth/profile/{user_id}` | Ambil data profil |
| PUT | `/auth/profile/{user_id}` | Update profil (nama, email, password) |

### Slot Obat

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/slots/{user_id}` | Ambil semua slot obat & statusnya |
| POST | `/slots/{user_id}` | Tambah slot obat baru |
| PUT | `/slots/{slot_id}/config` | Update nama obat pada slot |

### Chatbot

| Method | Endpoint | Fungsi |
|---|---|---|
| POST | `/chat` | Kirim pesan ke chatbot |
| GET | `/chat/history/{user_id}` | Riwayat percakapan (maks. 10 pesan terakhir) |

### Perangkat

| Method | Endpoint | Fungsi |
|---|---|---|
| POST | `/device` | Daftarkan/update perangkat ESP32 |
| GET | `/device/{user_id}` | Ambil perangkat berdasarkan user |
| DELETE | `/device/{mac_address}` | Hapus perangkat |

## 📝 Catatan

- **Format MAC Address** — Ditampilkan sebagai `XX:XX:XX:XX:XX:XX`. Jika input berupa 8 digit, otomatis diberi prefix `240AC4` (format umum ESP32).
- **Status Slot** — Status `terisi`/`kosong` diambil dari sensor perangkat dan diperbarui otomatis setiap 10 detik.
- **Satu Perangkat per Akun** — MAC address disimpan langsung di tabel users, sehingga satu akun hanya bisa memiliki satu perangkat.
