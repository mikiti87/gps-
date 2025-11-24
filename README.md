# gps

A new Flutter project.
"Periksa kode yang ada"

melihat dulu bagaimana aplikasi saat ini bekerja, terutama bagian peta dan cara data "catatan" disimpan dalam kode.

Tambahkan 'alat' untuk menyimpan data"

Aplikasi perlu sebuah alat (pustaka kode bernama shared_preferences) untuk bisa menyimpan data di memori telepon. Dengan ini, catatan yang dibuat tidak akan hilang saat aplikasi ditutup.

Pastikan data bisa diubah jadi teks"

Agar bisa disimpan, data catatan (yang berupa objek dalam kode) harus diubah dulu menjadi format teks (JSON). Poin ini hanya memastikan bahwa kemampuan untuk mengubah ini sudah ada.

Buat fungsi Simpan dan Muat"

Perlu dibuat dua fungsi utama:
Fungsi _saveAll(): Untuk menyimpan semua daftar catatan ke memori telepon.
Fungsi _loadSaved(): Untuk memuat kembali semua catatan yang sudah tersimpan saat aplikasi dibuka.

"Buat fitur 'Tambah Catatan' saat peta ditekan lama"

Ini adalah alur utama fiturnya:
Ketika pengguna menekan jarinya agak lama di satu titik pada peta...
Aplikasi akan mencari tahu alamat dari lokasi tersebut.
Akan muncul sebuah kotak dialog untuk pengguna bisa mengetik catatan dan memilih jenisnya (misalnya: "Rumah", "Kantor", "Penting").
Setelah diisi, catatan baru akan ditambahkan dan langsung disimpan secara otomatis.

"Ubah tampilan penanda (pin) di peta"

Tampilan penanda di peta akan diperbarui:
Setiap jenis catatan akan punya ikon dan warna yang berbeda (misalnya, penanda "Rumah" berwarna biru, "Kantor" berwarna hijau).
Jika penanda tersebut diklik, akan muncul pilihan untuk menghapus catatan tersebut dari peta.

"Jaga tampilan tetap simpel"

Fokusnya adalah pada fungsi, jadi tidak perlu membuat desain yang rumit, menambahkan gambar-gambar baru, atau merombak total kode yang sudah ada. Cukup gunakan komponen yang sudah disediakan.
![WhatsApp Image 2025-11-24 at 13 07 47 (1)](https://github.com/user-attachments/assets/c589cd3b-15d5-41b0-8e0e-89d5b7ec75ff)
![WhatsApp Image 2025-11-24 at 13 07 47 (2)](https://github.com/user-attachments/assets/c4a9402e-23dc-49bb-98b6-831647e8253e)
![WhatsApp Image 2025-11-24 at 13 07 47](https://github.com/user-attachments/assets/fcdeac20-1395-4f9c-9dc4-c05e78039d71)


