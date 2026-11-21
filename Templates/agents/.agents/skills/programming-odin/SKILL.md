---
name: programming-odin
description: >-
  Instructions for programming in the Odin language.
---

## Planning Mode

<!-- Placeholder -->

## Style Guidelines

- Do not used named returns. Example:
  ```odin
      // Do not do this
      add :: proc(a, b: int) -> (sum: int) {
        sum := a + b
        return
      }
  ```
  ```odin
      // Preferred format.
      add :: proc(a, b: int) -> int {
        return a + b
      }
  ```
- For any sort of curly braced code, use a `do` statement instead if doing so would not create a line greater than 79 columns.
