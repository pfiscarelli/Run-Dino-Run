#!/bin/sh
set -e
set -o xtrace

DISKETTE_NAME=dinorun.dsk
SOURCE_PATH=src/dinorun.asm
BINARY_NAME=DINORUN.BIN
BINARY_PATH=bin/$BINARY_NAME
INC_PATH=src/include
LISTING_NAME=rundino.out

rm -f bin/DINORUN.BIN
lwasm $SOURCE_PATH --6809 --includedir=$INC_PATH --list=$LISTING_NAME --symbols --6800compat --output=$BINARY_PATH --format=decb
decb copy -2br $BINARY_PATH $DISKETTE_NAME,$BINARY_NAME
