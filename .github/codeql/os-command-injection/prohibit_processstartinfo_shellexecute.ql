/**
 * @id csharp/prohibit_processstartinfo_shellexecute
 * @name ProcessStartInfo.UseShellExecute の有効化を禁止する
 * @description C# コード内で ProcessStartInfo.UseShellExecute が false 以外に設定されているコードを検出しアラートとして報告します。
 * @tags os-command-injection
 *       security
 *       shellexecute
 * @kind problem
 * @precision very-high
 * @problem.severity error
 */

import csharp

/**
 * ProcessStartInfo オブジェクトの作成または使用状況を取得
 */
class ProcessStartInfoCreation extends ObjectCreation {
  ProcessStartInfoCreation() {
    this.getType().hasName("ProcessStartInfo")
  }
}

/**
 * UseShellExecute へのプロパティアクセスを取得
 */
class UseShellExecuteAccess extends PropertyAccess {
  UseShellExecuteAccess() {
    this.getTarget().hasName("UseShellExecute") and
    this.getQualifier().getType().hasName("ProcessStartInfo")
  }
}

/**
 * UseShellExecute が false 以外のコードに対応する場所を取得
 */
predicate isUseShellExecuteCodeLocation(Location loc, string message) {
  exists(ProcessStartInfoCreation psi |
    // UseShellExecute へ明示的に false に設定されているかチェック
    not exists(Assignment assign, VariableAccess va |
      assign.getLValue().(UseShellExecuteAccess).getQualifier() = va and
      va.getTarget().getAnAssignedValue() = psi and
      assign.getRValue().(BoolLiteral).getBoolValue() = false
    ) and
    // UseShellExecute イニシャライザで明示的に false に設定されているかどうかをチェック
    not exists(MemberInitializer init |
      init.getParent() = psi and
      init.getLValue().(PropertyAccess).getTarget().hasName("UseShellExecute") and
      init.getRValue().(BoolLiteral).getBoolValue() = false
    ) and
    loc = psi.getLocation() and
    message = "ProcessStartInfo 初期化時に UseShellExecute へ false が明示的に設定されていません。"
  )
  or
  exists(UseShellExecuteAccess access, Assignment assign |
    assign.getLValue() = access and
    not assign.getRValue().(BoolLiteral).getBoolValue() = false and
    loc = assign.getLocation() and
    message = "UseShellExecute へ false が明示的に設定されていません。"
  )
}

from Location loc, string message
where isUseShellExecuteCodeLocation(loc, message)
select loc, message
