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

# Formatting

- Never run a formatter after adding in new code. The harness will handle this for you.
- If you want to lint or test, use `make lint` or `make test` if they are available.

# Planning Mode

<!-- Placeholder -->

# Code Organization

- Functions should be at most ~55 lines.
- Adding any sort of guard code should be treated with suspicion.
  * When dealing with external data, why was that external data not already verified?
  * When dealing with internal data from a different point in the call stack, why was it not verified further up the call stack?
  * The argument for guard code, conceptually, is to centralize data validation. But, in practice, this means data exists in a state of super-position throughout the program, making each procedure the ambiguous data touches less clear as to its intention.

# Functions

- Creation of thin wrappers is strongly discouraged. Example:
  ```lua
  -- This function hides implementation detail with no benefit toward re-usability or concision.
  local function format_md_table_pipe(text)
    return string.gsub(text, "|", "\\|")
  end
  ```

# Data Management

- Do not create aliases for simple types.
  * This rule also applies to indirection, such as a struct containing a single value.
  * Exception: The alias is meant to imply a limitation on the type's values, but the range of values is too large for an enum.
    + Example: `rune`s in Odin.

- When getting data from an external source (including, but not limited to, the file system, the network, or from a database), the incoming data should be validated as locally to where it is received in the code as possible.

# Testing

- Each functionality of a procedure being tested is one test case.
  - Consider, for example, a saturating add function:
    * Verify it does not do anything when adding two numbers that do not overflow
    * Verify that two numbers that create an overflow are capped at the max value
    * Verify that the two input numbers must be the same data type.
    * Verify that the max value is correct for the datatype of the two numbers being passed
    * Verify the passing two numbers has the same result regardless of the arg order
    * If the function is an intrinsic, make sure it properly changes its behavior to match different architectures
  - It is tempting to combine, say, the architecture max value and the data type max value tests into one "max value" test. But, this would be incorrect. One is meant to verify that overloaded arguments are handled correctly. The other relates to how the function compiles. It is likewise tempting to combine the overload same type requirement with the proper type per overload test. Again, this is incorrect. The former relates to how the overloading is structure, the latter is what happens when in the proper overload.
- Data setup per test must be the absolute most minimal possible to accomplish its purpose. Every piece of data setup creates a new environmental variable. Every piece of data setup is an assumption that might not hold under real conditions.
- When testing function A, which calls function B, do not re-test function B. The purpose of testing function A is to test function A's code paths.
- The admonitions above apply to both unit tests and integration tests. An integration test that creates unnecessary mock data, or that intermixes multiple "unhappy path" conditions, is actively mis-leading.
- Tests need to verify the handling of valid, but junk data.
  * This exercises the procedure's ability to handle said bad data properly. Does it raise an error when it should? Does it fail gracefully when it should?
  * Valid, but junk, data is a threat vector when dealing with user input and external data. Robust handling here prevents bad behavior later.
