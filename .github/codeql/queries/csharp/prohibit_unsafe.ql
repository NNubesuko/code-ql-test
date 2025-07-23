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
import csharp.semantics

// Find declarations (classes, methods, etc.) using the 'unsafe' modifier
predicate isUnsafeDeclaration(IHasModifiers m) {
  m.hasModifier("unsafe")
}

// Find usages of pointer types (e.g., int*, char*)
predicate isPointerTypeUsage(PointerType pt) {
  exists(pt)
}

from IHasModifiers m
where isUnsafeDeclaration(m)
select m, "This declaration uses the 'unsafe' keyword."

from PointerType pt
where isPointerTypeUsage(pt)
select pt, "This pointer type may indicate usage of unsafe code."
