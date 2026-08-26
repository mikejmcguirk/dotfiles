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
- If an odinfmt.json file exists, run `odinfmt` on the outputted code.
