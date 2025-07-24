/**
 * @id csharp/prohibit_unsafe
 * @name unsafe を禁止する
 * @description C# コード内で unsafe 検出しアラートとして報告します。
 * @tags buffer-overflow
 *       security
 *       unsafe
 * @kind problem
 * @precision very-high
 * @problem.severity error
 */

import csharp

/**
 * unsafe が使用されているコードに対応する場所を取得
 */
predicate isUnsafeCodeLocation(Location loc, string message) {
  // unsafe を使用しているメソッドを取得
  exists(Method m |
    m.isUnsafe() and
    loc = m.getLocation() and
    message = "メソッド '" + m.getName() + "' に unsafe が指定されています。"
  )
  or
  // unsafe を使用している型・構造体・クラスを取得
  exists(Type t |
    t.isUnsafe() and
    loc = t.getLocation() and
    message = "タイプ '" + t.getName() + "' に unsafe が指定されています。"
  )
  or
  // unsafe ステートメントを取得
  exists(UnsafeStmt s |
    loc = s.getLocation() and
    message = "unsafe ステートメントが使用されています。"
  )
  or
  // fixed ステートメントを取得
  exists(FixedStmt fs |
    loc = fs.getLocation() and
    message = "fixed ステートメントは unsafe が要求されます。"
  )
}

from Location loc, string message
where isUnsafeCodeLocation(loc, message)
select loc, message
