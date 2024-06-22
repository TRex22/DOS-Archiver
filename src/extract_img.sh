#!/bin/bash
# This is a quick and dirty script to mount and copy files into a new folder
# IMG is easier to mount than other file formats

# IMAGE_PATH="/path/to/yourimagefile.img"
# DESTINATION_DIR="/path/to/destination/${IMG_NAME}"

IMAGE_PATH="$1"
DESTINATION_DIR="$2"

printf "Mini IMG Extractor, Jason Chalom 2024 v0.1 \n"

if [ -z "$IMAGE_PATH" ] || [ -z "$DESTINATION_DIR" ]; then
  printf "Usage: $0 IMAGE_PATH DESTINATION_DIR \n" >&2
  exit 1
fi

if [ ! -e "${IMAGE_PATH}" ]; then
  printf "Error: Image file not found. \n" >&2
  exit 1
fi

if [ ! -d "${DESTINATION_DIR}" ]; then
  printf "Error: Destination directory does not exist. \n" >&2
  exit 1
fi

IMG_NAME="$(basename ${IMAGE_PATH%.*})"

mkdir -p "${DESTINATION_DIR}/${IMG_NAME}"
mkdir -p "${DESTINATION_DIR}/tmp_mount"

sudo mount -o loop "${IMAGE_PATH}" "${DESTINATION_DIR}/tmp_mount"
cp -r "${DESTINATION_DIR}/tmp_mount/"* "${DESTINATION_DIR}/${IMG_NAME}"
sudo umount "${DESTINATION_DIR}/tmp_mount"

rm -rf "${DESTINATION_DIR}/tmp_mount"
