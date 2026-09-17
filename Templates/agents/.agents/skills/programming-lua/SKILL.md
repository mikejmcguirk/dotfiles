---
name: programming-lua
description: >-
  Instructions for programming in the Lua language.
---

## Annotations

* All new functions must have param and return annotations that are emmylua-rust compatible.

- If there is an `emmyrc` file present
  * Run emmylua_check on all changed files to verify no issues.
- Acceptable formats for return annotations:
  ```lua
  ---@return integer, string Optional description of returns
  ```
  ```lua
  ---@return integer foo, string bar
  ---Optional description of returns. If any return is named, name all of them.
  ```

## Data Structure Guidelines

- Prefer procedural code to metatables. If a repeated operation needs to be performed on a table, create a function that takes the table and any relevant data, modifying the table in place. The `@param` annotation for the table should state `Modified in place!`.
- Do not change the data types of tables. If a table requires flexible data, either give it optional fields or create two separate class definitions and make a separate table.
- Generally, the data types of variables should not change. If a variable needs to change data types, create a new variable.
  * Important nuance: emmylua-rust can get confused about `integer` vs `uinteger` variables. Cast is fine to resolve this.

## Style Guidelines

- If there is a `stylua.toml` file present, run stylua on all changed files.
