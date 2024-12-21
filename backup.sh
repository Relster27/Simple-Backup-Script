#!/usr/bin/bash

: '
    What this script does?
        - Dengan asumsi kita sebelumnya sudah menyimpan sha256 dari semua file kedalam satu file bernama 'file_hash.log'
        - Cek sha256 dari semua file yang ingin kita backup dengan 'file_hash.log'
        - Hybrid backup (Local backup & Remote backup)
'

# Change mindfully:
# DIBAWAH INI CUMA PLACEHOLDER!
FILE_HASH="file_hash.log"       # <--- Ganti ini dengan file yang berisi sha256.
LOCAL_BACKUP_DIR="foo/"         # <--- Ganti ini dengan directory atau mounted drive yang diinginkan.
REMOTE_IP="X.X.X.X"             # <--- Ganti ini dengan IP Address dari remote machine.
PORT="12345"

# Output placeholder:
COMPARED_OUT="comparison_result.log"

echo "======================================================"
echo "| Please run this script as root to backup all files |"
echo "======================================================"
echo ""

# Compare part
        sha256sum -c "$FILE_HASH" >  "$COMPARED_OUT" 2>&1;
        echo "Log written in -> ${COMPARED_OUT}"

        # Prompt info
        if grep -q "FAILED" "$COMPARED_OUT"; then
            echo "[INFO]     : There's an error or a tampered file!"
            echo "[INFO]     : Error files aren't included in backup process."
            echo "[INFO]     : Check '${COMPARED_OUT}' to see the details."
            echo "[CONTINUE] : Proceeding to backup."
            echo ""
        else
            echo "[CONTINUE] : Process run smoothly! Proceeding to backup."
            echo ""
        fi

# Backup part
    # Local backup
        echo "[START] Starting Local Backup..."
        while read -r hash FILE; do
            # Skip tampered or permission denied files
            if grep -q "$FILE" "$COMPARED_OUT" && grep -q "FAILED" <<< "$(grep "$FILE" "$COMPARED_OUT")"; then
                echo "[SKIP] : Skipping $FILE"
                continue
            fi

            # Backup valid files
            echo "[BACKUP] : Backing up $FILE -> $LOCAL_BACKUP_DIR"
            cp "$FILE" "$LOCAL_BACKUP_DIR"

        done < "$FILE_HASH"
        echo "[END] Local Backup Done."
        echo ""
        
    # Remote backup
        echo "[START] Starting Remote Backup..."
        # Create tarball of files to send
        tar czv -C "$LOCAL_BACKUP_DIR" . | nc -w 3 "$REMOTE_IP" "$PORT"

        echo "[END] Remote Backup Done."
        echo ""

echo "[EXIT] : Backup Done! Exiting..."
exit 0