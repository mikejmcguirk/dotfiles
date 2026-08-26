---
name: programming
description: >-
  Instructions and guidelines for programming in all languages.
---

# Meta

- The instructions and guidelines below should be applied to new and re-written code. Do not arbitrarily re-write pre-existing code unless specifically requested.

# Comments

- Comments should communicate information that cannot be gleaned by reading the code. Examples:
  * The commented code relates to behavior from another part of the codebase.
  * The commented code is written in a specific way for a non-obvious reason, such as performance optimization or to deal with a subtle logic issue.

# Planning Mode

<!-- Placeholder -->

# Code Organization

- Functions should be at most ~55 lines.

# Data Management

- Do not create aliases for simple types.
  * This rule also applies to indirection, such as a struct containing a single value.
  * Exception: The alias is meant to imply a limitation on the type's values, but the range of values is too large for an enum.
    + Example: `rune`s in Odin.

- When getting data from an external source (including, but not limited to, the file system, the network, or from a database), the incoming data should be validated as locally to where it is received in the code as possible.
