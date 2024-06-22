#!/bin/bash
# This is a quick and dirty script to mount and copy files into a new folder
# IMG is easier to mount than other file formats

# IMG_FILE="/path/to/yourimagefile.img"
# DESTINATION_DIR="/path/to/destination/${IMG_NAME}"

IMAGE_PATH="$1"
DESTINATION_DIR="$2"

printf "Mini IMG Extractor, Jason Chalom 2024 \n"

if [ -z "$IMAGE_PATH" ] || [ -z "$DESTINATION_DIR" ]; then
  printf "Usage: $0 IMAGE_PATH DESTINATION_DIR \n" >&2
  exit 1
fi

if [ ! -e "${IMAGE_PATH}" ]; then
  printf "Error: Image file not found. \n" >&2
  exit 1
fi

mkdir -p "${DESTINATION_DIR}"
if [ ! -d "${DESTINATION_DIR}" ]; then
  printf "Error: Destination directory does not exist. \n" >&2
  exit 1
fi

sudo mount -o loop "${IMAGE_PATH}" "${DESTINATION_DIR}/"

cp -R "${DESTINATION_DIR}/"* "${DESTINATION_DIR}/"
sudo umount "${DESTINATION_DIR}/"
