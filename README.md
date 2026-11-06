# SiswaBantu 🇲🇾
### "Ringankan Beban, Tambah Pendapatan"
**Platform Pasaran Mikro & Ekonomi Gig Tertutup Mahasiswa IPTA Selangor**  
*Edisi Lengkap Pertandingan Inovator Muda METASEL (Versi 2.0)*  
*Piawaian Rujukan: IEEE Std 830 / ISO/IEC/IEEE 29148 (SRS) & IEEE Std 829 (STD)*

---

## 🌟 Gambaran Keseluruhan
**SiswaBantu** direka khusus untuk memperkasa kebajikan dan taraf ekonomi mahasiswa di Institusi Pengajian Tinggi Awam (IPTA) negeri Selangor (UiTM Shah Alam, UKM Bangi, UPM Serdang, UNISEL, UNITEN, UIAM, dll). Platform ini menghubungkan pelajar yang memerlukan bantuan harian atau akademik dengan pelajar yang ingin menjana pendapatan sampingan secara terkawal, selamat, dan berpatutan.

---

## 🎨 Tema Reka Bentuk UI/UX (Material Design 3)
Aplikasi mematuhi spesifikasi rasmi identiti negeri Selangor:
- **Merah Selangor (`#D90429`)**: Keberanian, komitmen, dan identiti negeri.
- **Kuning Diraja (`#FFB703`)**: Kedaulatan, integriti, dan kemakmuran ekonomi siswa.
- **Putih Bersih (`#FFFFFF`)**: Ketelusan amanah akaun Escrow.
- Tipografi: *Plus Jakarta Sans* dengan saiz kebolehcapaian minimum 12pt dan kontras tinggi.

---

## 🚀 Ciri & Modul Utama (SRS Compliance)

### 1. Modul 1: Pendaftaran, Pengesahan & Keselamatan Komuniti (Auth & e-KYC)
- **FR-1.1 Pendaftaran E-mel Institusi:** Validasi format domain `.edu.my` (TC-AUTH-01 & TC-AUTH-02) bersama simulasi kod OTP 6-digit.
- **FR-1.2 Pengesahan Kad Matrik (e-KYC):** Pengecaman Teks Optik (Google Cloud Vision OCR Mock) mengekstrak No. Matrik dan memadankan nama pelajar bagi menaik taraf akaun ke status *Verified*.
- **FR-1.3 Dwi-Peranan Satu Akaun (Role Switching):** Togol pantas antara **Mod Pemohon Bantu** (cari/tempah) dan **Mod Penyedia Bantu** (buka servis/jana upah) tanpa log keluar.

### 2. Modul 2: Katalog Servis & Papan Permintaan Pantas (Marketplace & Bantu SOS)
- **FR-2.1 Pengurusan Senarai Servis:** Kategori merangkumi *Runner Kampus, Akademik & Tutor, Teknikal & IT, Kesenian & Rekaan, Dobi & Kebersihan*. Model harga Tetap/Jam dan tempoh SLA (TC-MKT-01).
- **FR-2.2 Carian & Penapisan Pintar:** Carian fuzzy, penapis kampus/kolej kediaman, julat harga (<= RM50 TC-MKT-02), rating $\ge$ 4.0 bintang, dan status aktif sekarang.
- **FR-2.3 Papan Bantu SOS:** Penyiaran tugasan kilat dan kecemasan kampus (ubat farmasi, bateri motor jumper, cetak assignment segera) dengan upah pantas.

### 3. Modul 3: Aliran Kerja Tempahan & Sembang Selamat (Order & Chat Workflow)
- **FR-3.1 Kitaran Hayat Pesanan (State Machine):**
  1. `MENUNGGU_BAYARAN`
  2. `MENUNGGU_TERIMA` (Amanah Escrow Held; auto-cancel countdown)
  3. `SEDANG_DILAKUKAN` (Penyedia mula kerja)
  4. `MENUNGGU_PENGESAHAN` (Muat naik bukti kerja siap)
  5. `SELESAI` (Pemohon sahkan; dana dilepaskan)
  6. `DIBATALKAN` / `PERTIKAIAN`
- **FR-3.2 Pemesejan Dalam Aplikasi:** Sembang masa nyata dengan pin lokasi kolej, lampiran dokumen, dan gambar.
- **FR-3.3 Penapisan Keselamatan Sembang (Anti-Bypass Regex Filter):** Mengesan cubaan berkongsi nombor akaun bank atau pautan bayaran luar, menyensor deretan nombor kepada `************`, dan memaparkan amaran rasmi pencegahan scam (TC-CHT-01).

### 4. Modul 4: Kewangan, Dompet Digital & Sistem Escrow
- **FR-4.1 Pemprosesan Bayaran FPX Sandbox:** Simulasi Maybank2u, CIMB Clicks, Bank Islam, TnG eWallet ke akaun Escrow (TC-ESC-01).
- **FR-4.2 Pelepasan Dana & Tolakan Komisen 5%:**
  $$\text{Pendapatan Bersih} = \text{Harga Servis} \times (1 - 0.05)$$
  $$\text{Komisen Platform (5\%)} = \text{Harga Servis} \times 0.05$$
  (TC-ESC-02)
- **FR-4.3 Pengeluaran Wang (Withdrawal):** Had minimum RM10.00 disahkan dengan ketat (TC-FIN-01).

### 5. Modul 5: Penilaian, Ulasan & Pusat Resolusi Pertikaian
- **FR-5.1 Sistem Penilaian Dua Hala:** 1–5 bintang beserta tag pujian komuniti.
- **FR-5.2 Pengurusan Pertikaian (Dispute Resolution):** Butang "Lapor Isu / Pertikaian" membekukan dana Escrow serta-merta, menghentikan auto-release 72 jam, dan membuka tiket timbang tara admin (TC-DSP-01).

### 6. Modul Pentadbir (Admin Dashboard)
- Ringkasan GMV ekonomi gig, amanah escrow dipegang, dan komisen 5% terkumpul.
- Meja Timbang Tara Pertikaian: 
  - (a) Pulangkan 100% kepada Pemohon
  - (b) Lepaskan 100% kepada Penyedia
  - (c) Pembahagian separa (50/50).

### 7. Pelari Ujian Automatik STD (IEEE Std 829 Test Runner)
- Memaparkan dan menjalankan kesemua 11 kes ujian terperinci (TC-AUTH-01 hingga TC-DSP-01) secara interaktif dengan log masa nyata dan penarafan kelulusan 100%.

---

## 💻 Panduan Menjalankan Aplikasi

Aplikasi telah siap dibina dan sedang berjalan pada persekitaran tempatan anda:

```bash
# Buka pelayan pembangunan (Dev Server)
npm run dev

# Capai di pelayar web
http://localhost:5173/
```

### Mod Paparan Tersedia (Boleh Ditukar di Bar Tajuk):
1. **Paparan Mudah Alih (Mobile View)**: Kerangka telefon pintar moden (iOS/Android) lengkap dengan bar status dan bar navigasi bawah.
2. **Paparan Desktop**: Paparan skrin luas responsif penuh.
3. **Papan Pentadbir (Admin)**: Pusat pemantauan transaksi dan timbang tara pertikaian.
4. **Ujian STD (IEEE)**: Pelari ujian automatik untuk panel juri penilai.
