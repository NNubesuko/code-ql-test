/**
 * @name Prohibit unsafe code
 * @description Finds all uses of the 'unsafe' keyword in C# code and reports them as alerts.
 * @kind problem
 * @id csharp/unsafe-code-prohibition
 * @tags security
 * correctness
 * maintainability
 * unsafe
 * @severity error # ★Severityを追加
 */

import csharp

// C#の'unsafe'コンテキストを表す述語を使用
// 'UnsafeContext' は C# ライブラリで 'unsafe' コードが許可される場所を識別します。
from UnsafeContext uc
where uc.isUnsafe() // ucが実際に'unsafe'キーワードによってマークされていることを確認
select uc.getLocation(), "This code is marked with the 'unsafe' keyword and should be reviewed or removed."
