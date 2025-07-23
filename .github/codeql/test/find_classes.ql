/**
 * @name Prohibit unsafe code
 * @description Finds all uses of the 'unsafe' keyword in C# code and reports them as alerts.
 * @kind problem
 * @id csharp/unsafe-code-prohibition
 * @tags security
 * correctness
 * maintainability
 * unsafe
 * @severity error
 */

import csharp

// Option 1: Find 'unsafe' methods
from Method m
where m.isUnsafe()
select m, "Method '" + m.getName() + "' is marked as 'unsafe'."

union

// Option 2: Find 'unsafe' types (structs or classes)
from Type t
where t.isUnsafe()
select t, "Type '" + t.getName() + "' is marked as 'unsafe'."

union

// Option 3: Find explicit 'unsafe' blocks (statements)
// This captures explicit `unsafe { ... }` blocks
from UnsafeStmt s
select s, "An 'unsafe' statement block is used here."

union

// Option 4: Find 'fixed' statements, which implicitly require an unsafe context
// Although 'fixed' statements are within an unsafe context, explicitly flagging them
// ensures coverage even if the outer block isn't explicitly 'unsafe'.
from FixedStmt fs
select fs, "A 'fixed' statement is used here, requiring an 'unsafe' context."
