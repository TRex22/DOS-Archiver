#!/bin/bash
# This is a quick and dirty script to mount and copy files into a new folder
# IMG is easier to mount than other file formats

# IMG_FILE="/path/to/yourimagefile.img"
# DESTINATION_DIR="/path/to/destination/${IMG_NAME}"

IMAGE_PATH="$1"
DESTINATION_DIR="$2"

if [ -z "$IMAGE_PATH" ] || [ -z "$DESTINATION_DIR" ]; then
  printf "Usage: $0 IMAGE_PATH DESTINATION_DIR" >&2
  exit 1
fi

if [ ! -e "${IMAGE_PATH}" ]; then
  printf "Error: Image file not found." >&2
  exit 1
fi

if [ ! -d "${DESTINATION_DIR}" ]; then
  printf "Error: Destination directory does not exist." >&2
  exit 1
fi

IMG_NAME="$(basename ${IMG_FILE} .img)"

losetup -f --show ${IMG_FILE} > /dev/null
DEVICE=$(sed 's/.*://' <<< "$(losetup --find ${IMG_FILE})")

mkdir -p "${DESTINATION_DIR}"
mount -o loop ${DEVICE} "${DESTINATION_DIR}"
cp -R "${DEVICE}/"* "${DESTINATION_DIR}/"
umount ${DEVICE}
losetup -d ${DEVICE}
