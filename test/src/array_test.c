/*
 * MIT License
 *
 * Copyright (c) 2024 Uriel García Rivas
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * https://github.com/zoningorg/zondata/blob/main/LICENSE
 */

#include "../../inc/array.h"
#include "../deps/zontest/test.h"

TEST(ArrayAllocation, simple_allocation) {
  const int element = 15;
  array* arr = allocate_array(element);

  EXPECT_TRUE(arr != NULL);
  EXPECT_TRUE(arr->data != NULL);
  EXPECT_EQUAL(arr->size, 1);
  EXPECT_EQUAL(arr->data[0], element);

  deallocate_array(arr);
}

TEST(ArrayAllocation, preset_allocation) {
  const size_t size = 100;
  const int value = 27;
  array* arr = allocate_preset_array(size, value);

  EXPECT_TRUE(arr != NULL);
  EXPECT_EQUAL(arr->size, size);

  for (size_t i = 0; i < arr->size; ++i) {
    EXPECT_EQUAL(arr->data[i], value);
  }

  deallocate_array(arr);
}

TEST(ArrayAllocation, empty_allocation) {
  array* arr = allocate_empty_array();

  EXPECT_TRUE(arr != NULL);
  EXPECT_EQUAL(arr->size, 0);
  EXPECT_EQUAL(arr->data, NULL);

  deallocate_array(arr);
}

TEST(ArrayAllocation, copy_allocation) {
  const size_t size = 100;
  const int value = 46;
  array* arr = allocate_preset_array(size, value);
  array* arr_copy = allocate_copy_array(arr);

  EXPECT_TRUE(arr != NULL && arr_copy != NULL);
  EXPECT_EQUAL(arr->size, arr_copy->size);

  for (size_t i = 0; i < arr->size; ++i) {
    EXPECT_EQUAL(arr->data[i], arr_copy->data[i]);
  }

  deallocate_array(arr);
  deallocate_array(arr_copy);
}

TEST(ArrayManipulation, adding_elements) {
  const size_t size = 100;
  array* arr = allocate_empty_array();

  EXPECT_EQUAL(arr->data, NULL);
  EXPECT_EQUAL(arr->size, 0);

  for (size_t i = 0; i < size; ++i) {
    add_to_array(arr, i);
  }

  EXPECT_TRUE(arr->data != NULL);
  EXPECT_EQUAL(arr->size, size);

  for (int i = 0; i < (int) size; ++i) {
    EXPECT_EQUAL(arr->data[i], i);
  }

  deallocate_array(arr);
}

TEST(ArrayAlgorithm, check_if_exists) {
  array* arr = allocate_preset_array(200, 0);

  for (int i = 0; i < (int) arr->size; ++i) {
    arr->data[i] = i;
  }

  EXPECT_TRUE(exist_in_array(arr, 0));
  EXPECT_TRUE(exist_in_array(arr, arr->size / 2));
  EXPECT_FALSE(exist_in_array(arr, arr->size));

  deallocate_array(arr);
}

TEST(ArrayAlgorithm, check_equal) {
  array* arr = allocate_preset_array(200, 0);
  array* arr_copy = allocate_copy_array(arr);

  EXPECT_TRUE(are_equal_array(arr, arr_copy));
  add_to_array(arr, 1);
  EXPECT_FALSE(are_equal_array(arr, arr_copy));
  add_to_array(arr_copy, 1);
  EXPECT_TRUE(are_equal_array(arr, arr_copy));

  deallocate_array(arr);
  deallocate_array(arr_copy);
}

int main(void) {
  RUN_TESTS("ArrayTest");
  return TEST_RESULT();
}
