/**
 * @id csharp/processstartinfo-use-shellexecute-prohibition
 * @name Prohibit UseShellExecute not set to false in ProcessStartInfo
 * @description Finds all uses of System.Diagnostics.ProcessStartInfo where the UseShellExecute property is not explicitly set to false.
 * @tags security
 *       correctness
 *       maintainability
 *       process
 * @kind problem
 * @precision very-high
 * @problem.severity error
 */

import csharp

/**
 * Local variable of type ProcessStartInfo
 */
class ProcessStartInfoVar extends LocalVariable {
  ProcessStartInfoVar() {
    this.getType().hasQualifiedName("System.Diagnostics", "ProcessStartInfo")
  }
}

/**
 * Returns true if the variable is assigned UseShellExecute = false somewhere.
 */
predicate useShellExecuteSetToFalse(ProcessStartInfoVar v) {
  exists(PropertyWrite pw |
    pw.getTarget().getQualifier() instanceof LocalVariableAccess and
    pw.getTarget().getQualifier().(LocalVariableAccess).getLocalVariable() = v and
    pw.getTarget().getTarget().hasName("UseShellExecute") and
    pw.getAssignedValue() instanceof BoolLiteral and
    pw.getAssignedValue().(BoolLiteral).getValue() = false
  )
}

/**
 * Returns true if the variable is assigned UseShellExecute = true somewhere.
 */
predicate useShellExecuteSetToTrue(ProcessStartInfoVar v) {
  exists(PropertyWrite pw |
    pw.getTarget().getQualifier() instanceof LocalVariableAccess and
    pw.getTarget().getQualifier().(LocalVariableAccess).getLocalVariable() = v and
    pw.getTarget().getTarget().hasName("UseShellExecute") and
    pw.getAssignedValue() instanceof BoolLiteral and
    pw.getAssignedValue().(BoolLiteral).getValue() = true
  )
}

from ProcessStartInfoVar v
where not useShellExecuteSetToFalse(v)
select v.getLocation(), "ProcessStartInfo variable '" + v.getName() + "' does not have UseShellExecute explicitly set to false. Default (true) or explicitly true may be insecure."
