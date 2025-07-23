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

from UnsafeBlock unsafeBlock
select unsafeBlock, "This unsafe block should be reviewed or removed as 'unsafe' code is prohibited."
