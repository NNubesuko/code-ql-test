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

from Declaration d
where
  d instanceof IHasModifiers and
  ((IHasModifiers)d).hasModifier("unsafe")
select d, "This declaration uses the 'unsafe' modifier."

union

from PointerType pt
select pt, "This pointer type usage may indicate unsafe code."
