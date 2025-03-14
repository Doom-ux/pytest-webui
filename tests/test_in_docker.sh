#!/bin/bash

set -e

# Launch QEMU in background
qemu-system-arm -m 256 -M romulus-bmc -nographic -drive file=./romulus/obmc-phosphor-image-romulus-20250214213550.static.mtd,format=raw,if=mtd -net nic -net user,hostfwd=:0.0.0.0:2222-:22,hostfwd=:0.0.0.0:2443-:443,hostfwd=udp:0.0.0.0:2623-:623,hostname=qemu &
QEMU_PID=$!

SERIAL_DEVICE=/dev/ttyS4

#if ! kill -0 "$QEMU_PID" 2>/dev/null; then
#    echo "QEMU exited unexpectedly."
#    exit 1
#fi

# Wait until serial device is registered and QEMU is ranning.
while [ ! -e "$SERIAL_DEVICE" ]; do
    if ! kill -0 "$QEMU_PID" 2>/dev/null; then
        echo "QEMU exited unexpectedly."
        exit 1
    fi
    sleep 0.1s
done


# Run pytest
pytest test_obmc1.py
