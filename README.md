# UTS Manajemen Basis Data 

Nama: Fadhillah Rizqia Arfin (NIM 1237050056)

## Menjalankan
1. `cp .env.example .env`, 
2. `docker compose up -d`
3. Jalankan skrip di folder `sql/` berurutan (01, 02, 03) sebagai user `postgres`

## Akses
| Layanan | Alamat |
|---|---|
| PostgreSQL (eksternal, DBeaver) | localhost:22056 |
| pgAdmin4 | http://localhost:44056 |
| PostgreSQL dari pgAdmin (internal Docker) | host `postgres_arfin`, port 5432 |

## Isi
- Skema `salam`, tabel `mahasiswas` (primary key, unique, check)
- User `backend_dev` (CRUD), `bi_dev` (read only), `data_engineer` (pemilik skema)
- Fitur tambahan: tabel `audit_log` + trigger, view `v_mahasiswa_aktif`, healthcheck PostgreSQL
