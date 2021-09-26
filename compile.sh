#!/bin/bash

set -x -e
mkdir -p lib bin
CC=gcc
CPP=g++
AR=ar
STRIP=strip
CFLAGS="-static -Wall -Werror"

cd libfdt
$CC -Werror -Wno-macro-redefined -Wno-sign-compare -I./ -c "fdt.c" \
        "fdt_ro.c" \
        "fdt_wip.c" \
        "fdt_sw.c" \
        "fdt_rw.c" \
        "fdt_strerror.c" \
        "fdt_empty_tree.c" \
        "fdt_addresses.c" \
        "fdt_overlay.c" \
        "acpi.c"
$AR rcs libfdt.a *.o
mv libfdt.a ../lib/libfdt.a
cd ..

cd sysdeps
$CC -I./include -c libufdt_sysdeps_posix.c
$AR rcs libufdt_sysdeps_posix.a *.o
mv libufdt_sysdeps_posix.a ../lib/libufdt_sysdeps_posix.a
cd ..

$CC -v -std=c99 $CFLAGS -I./include -I./libfdt -I./sysdeps/include mkdtimg.c mkdtimg_cfg_create.c mkdtimg_core.c mkdtimg_create.c mkdtimg_dump.c dt_table.c ./lib/libfdt.a ./lib/libufdt_sysdeps_posix.a -o mkdtimg.exe

$STRIP mkdtimg.exe
mv mkdtimg.exe bin/mkdtimg.exe