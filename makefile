# MIT License
#
# Copyright (c) 2024 Uriel García Rivas
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# https://github.com/zoningorg/zondata/blob/main/LICENSE

# Compilation. Activate as many warnings as possible for maximum safety.
# TODO: Include -Wredundant-decls -Wpadded -Wc90-c99-compat
#               -Wtraditional-conversion
# NOTE: Exclude -Wc++-compat -Wabi-tag
CC = gcc

# Diagnostic and General Warnings.
CWARN_DIAGNOSTIC = -Wall -Wextra -Werror -Wpedantic -Wsystem-headers

# Conversion and Format Warnings.
CWARN_CONVERSION_FORMAT = -Wconversion -Wformat=2 -Wformat-security \
	-Wformat-signedness -Wformat-zero-length -Woverlength-strings \
	-Wformat-overflow -Wformat-truncation -Wformat-nonliteral -Wformat-y2k

# Variable and Assignment Warnings.
CWARN_VARIABLES = -Wshadow -Wwrite-strings -Wlogical-op -Wfloat-equal \
	-Wpointer-arith -Wchar-subscripts -Wzero-length-bounds -Warray-bounds \
	-Wduplicated-cond -Winit-self -Wduplicated-branches \
	-Wlogical-not-parentheses

# Deprecated and Legacy Warnings.
CWARN_DEPRECATED = -Wdeprecated-declarations -Wold-style-definition \
	-Wmissing-format-attribute

# Preprocessor Warnings.
CWARN_PREPROCESSOR = -Wundef

# Unused Warnings.
CWARN_UNUSED = -Wunused -Wunused-parameter -Wunused-function -Wunused-label \
	-Wunused-value -Wuninitialized -Wunused-variable -Wunused-macros \
	-Wunused-local-typedefs -Wunused-const-variable -Wunused-result \
	-Wunused-but-set-variable -Wunused-but-set-parameter

# Declaration Warnings.
CWARN_DECLARATIONS = -Wstrict-prototypes -Wmissing-prototypes \
	-Wmissing-declarations -Wmissing-field-initializers -Wmissing-include-dirs \
	-Wnested-externs # -Wredundant-decls -Wtraditional-conversion

# Switch Warnings.
CWARN_SWITCH = -Wswitch-default -Wswitch-enum

# Pointer and Cast Warnings.
CWARN_POINTERS = -Wincompatible-pointer-types -Wcast-qual -Wpointer-sign \
	-Wrestrict -Wnull-dereference -Wuseless-cast -Wnonnull -Walloca \
	-Wcast-align=strict -Wbad-function-cast -Wcast-function-type \
	-Wstack-protector -Waddress -Wstringop-overread -Wnonnull-compare

# Optimization Warnings.
CWARN_OPTIMIZATION = -Wdisabled-optimization -Wdouble-promotion \
	-Wunsafe-loop-optimizations -Wunsuffixed-float-constants \
	-Wfloat-conversion -Winline

# Implicit Warnings.
CWARN_IMPLICIT = -Wimplicit-int -Wimplicit-function-declaration \
	-Wimplicit-fallthrough

# Overflow and Size Warnings.
CWARN_OVERFLOW_SIZE = -Wstrict-overflow=5 -Wlarger-than=65536 -Wpacked \
	-Wpacked-not-aligned # -Wpadded

# Compatibility Warnings.
CWARN_COMPATIBILITY = # -Wc90-c99-compat

# Code Quality Warnings.
CWARN_CODE_QUALITY = -Waggregate-return -Winvalid-pch -Wmultistatement-macros \
	-Wstrict-aliasing=3 -Wunreachable-code -Wstringop-overflow \
	-Wstringop-truncation -Wnormalized=nfkc -Walloc-zero \
	-Wshift-count-negative -Wshift-count-overflow -Wmissing-noreturn \
	-Wvariadic-macros -Wjump-misses-init -Wmain -Wvector-operation-performance

# All flags.
CFLAGS = $(CWARN_DIAGNOSTIC) \
	$(CWARN_CONVERSION_FORMAT) \
	$(CWARN_VARIABLES) \
	$(CWARN_DEPRECATED) \
	$(CWARN_PREPROCESSOR) \
	$(CWARN_UNUSED) \
	$(CWARN_DECLARATIONS) \
	$(CWARN_SWITCH) \
	$(CWARN_POINTERS) \
	$(CWARN_OPTIMIZATION) \
	$(CWARN_IMPLICIT) \
	$(CWARN_OVERFLOW_SIZE) \
	$(CWARN_COMPATIBILITY) \
	$(CWARN_CODE_QUALITY) \
	-I./inc/ \
	-I./test/deps/

# All targets. This assumes there exists a .h, .c, and _test.c per target.
TARGETS = zng_array \
	zng_string \
	zng_hash_map \
	zng_hash_set \
	zng_linked_list \
	zng_sort_map \
	zng_sort_set

# Object files.
OBJ_DIR = ./obj
OBJ = $(patsubst %,$(OBJ_DIR)/%.o,$(TARGETS))

# Binary files.
SRC_DIR = ./test/src
BIN_DIR = ./test/bin
BIN = $(patsubst %,$(BIN_DIR)/%_test,$(TARGETS))

# General rule for every object file.
$(OBJ_DIR)/%.o: ./src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# General rule for every test binary.
$(BIN_DIR)/%_test: $(SRC_DIR)/%_test.c $(OBJ_DIR)/%.o
	$(CC) $(CFLAGS) $^ -o $@

# Top-level rule. Creates objects only.
all: $(OBJ)

# Testing rule to create and run all tests in BIN.
test: $(BIN)
	for test_binary in $(BIN); do \
		./$$test_binary; \
	done; \
	make clean

# Remove created files.
clean:
	rm -f $(OBJ) $(BIN)
