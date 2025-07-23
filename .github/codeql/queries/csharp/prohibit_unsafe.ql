/**
 * @name Prohibit unsafe code
 * @description Finds all uses of the 'unsafe' keyword in C# code and reports them as alerts.
 * @kind problem
 * @id csharp/unsafe-code-prohibition
 * @tags security
 *       correctness
 *       maintainability
 *       unsafe
 */

import csharp

// Unsafe declarations (methods, classes, etc.)
from IHasModifiers decl
where decl.hasModifier("unsafe")
select decl, "This declaration uses the 'unsafe' keyword."

union

// Unsafe pointer types
from PointerType pt
select pt, "Pointer type usage may indicate unsafe code."
