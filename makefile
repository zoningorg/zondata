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
# TODO: Include -Wredundant-decls -Wpadded
CC = gcc
CWARN_GENERAL = -Wall -Wextra -Werror -Wpedantic -Wconversion -Wformat=2 \
	-Wshadow -Wundef -Wvla -Wwrite-strings -Wlogical-op -Wfloat-equal \
	-Wpointer-arith -Winline -Wsystem-headers -Wchar-subscripts \
	-Wdeprecated-declarations -Warray-bounds -Wduplicated-cond -Winit-self \
	-Wduplicated-branches -Wlogical-not-parentheses -Wformat-security \
	-Wformat-signedness -Wformat-zero-length -Wshadow=local \
	-Wshadow=compatible-local -Wshadow=global -Werror=array-bounds \
	-Wzero-length-bounds -Woverlength-strings
CWARN_UNUSED = -Wunused -Wunused-parameter -Wunused-function -Wunused-label \
	-Wunused-value -Wuninitialized -Wunused-variable -Wunused-macros \
	-Wunused-local-typedefs -Wunused-const-variable
CWARN_DECLARATIONS = -Wstrict-prototypes -Wold-style-definition \
	-Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers \
	-Wmissing-include-dirs -Wnested-externs -Wmissing-format-attribute
CWARN_SWITCH = -Wswitch-default -Wswitch-enum
CWARN_POINTERS = -Wincompatible-pointer-types -Wcast-align -Wcast-qual \
	-Wpointer-sign -Wrestrict -Wnull-dereference -Wuseless-cast -Wnonnull \
	-Walloca -Wcast-align=strict -Wbad-function-cast -Wcast-function-type \
	-Wstack-protector -Waddress
CWARN_OPTIMIZATION = -Wdisabled-optimization -Wdouble-promotion \
	-Wunsafe-loop-optimizations -Wunsuffixed-float-constants -Wfloat-conversion
CWARN_IMPLICIT = -Wimplicit-int -Wimplicit-function-declaration \
	-Wimplicit-fallthrough
CWARN_OTHERS = -Wstrict-overflow=5 -Waggregate-return -Winvalid-pch \
	-Wno-unknown-pragmas -Wno-format-nonliteral -Wmultistatement-macros \
	-Wno-long-long -Wno-variadic-macros -Wno-packed -Wstrict-aliasing=3 \
	-Wformat-overflow -Wformat-truncation -Wstringop-overflow -Wpacked \
	-Wno-overlength-strings -Wno-vla -Wstringop-truncation -Wunreachable-code \
	-Wlarger-than=65536 -Wmain -Wnormalized=nfkc
CFLAGS = $(CWARN_GENERAL) \
	$(CWARN_UNUSED) \
	$(CWARN_DECLARATIONS) \
	$(CWARN_SWITCH) \
	$(CWARN_POINTERS) \
	$(CWARN_OPTIMIZATION) \
	$(CWARN_OTHERS) \
	-I./inc/ \
	-I./test/deps/

# All targets. This assumes there exists a .h, .c, and _test.c per target.
TARGETS = array \
	hash_map \
	hash_set \
	linked_list \
	sort_map \
	sort_set

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

# Top-level rule.
all: $(OBJ)

# Automatic rule to run all tests in BIN.
test: $(BIN)
	for test_binary in $(BIN); do \
		./$$test_binary; \
	done; \
	make clean

# Remove created files.
clean:
	rm -f $(OBJ) $(BIN)
