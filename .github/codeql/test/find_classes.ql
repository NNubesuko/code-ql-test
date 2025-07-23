/**
 * @id csharp/unsafe-code-prohibition
 * @name Prohibit unsafe code
 * @description Finds all uses of the 'unsafe' keyword in C# code and reports them as alerts.
 * @tags security
 *       correctness
 *       maintainability
 *       unsafe
 * @kind problem
 * @precision very-high
 * @problem.severity error
 */

import csharp

/**
 * Gets a location that corresponds to an 'unsafe' code construct.
 */
predicate isUnsafeCodeLocation(Location loc, string message) {
    // Option 1: Find 'unsafe' methods
    exists(Method m |
        m.isUnsafe() and
        loc = m.getLocation() and
        message = "Method '" + m.getName() + "' is marked as 'unsafe'."
    )
    or
    // Option 2: Find 'unsafe' types (structs or classes)
    exists(Type t |
        t.isUnsafe() and
        loc = t.getLocation() and
        message = "Type '" + t.getName() + "' is marked as 'unsafe'."
    )
    or
    // Option 3: Find explicit 'unsafe' blocks (statements)
    exists(UnsafeStmt s |
        loc = s.getLocation() and
        message = "An 'unsafe' statement block is used here."
    )
    or
    // Option 4: Find 'fixed' statements, which implicitly require an unsafe context
    exists(FixedStmt fs |
        loc = fs.getLocation() and
        message = "A 'fixed' statement is used here, requiring an 'unsafe' context."
    )
}

from Location loc, string message
where isUnsafeCodeLocation(loc, message)
select loc, message
