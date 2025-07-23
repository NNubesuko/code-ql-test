/**
 * @name Find all classes
 * @description Test query to find all classes in C# code.
 * @kind problem
 * @id csharp/test/find-classes
 * @tags test
 */

import csharp

from Class c
select c, "This is a class."
