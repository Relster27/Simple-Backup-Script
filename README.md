Backup step-by-step:
1. Pastikan hash dari file yang ingin kita backup sudah ada terlebih dahulu. (Bisa menggunakan util ‘sha256sum’).
2. Set up listener pada remote machine yang ingin kita kirim file backupannya.
	  command : nc -l -p 12345 > received_backup.tar.gz
3. Jalankan script ‘backup.sh’ pada machine yang ingin kita lakukan proses backup lalu tunggu sejenak.
    command : sudo ./backup.sh
4. Jika sudah selesai, pada remote machine kita bisa melihat tarball yang sudah kita kirimkan dari local machine.
5. Unzip tarball tersebut, dan file backupan bisa kita akses.
	  command : tar -xzvf received_backup.tar.gz
