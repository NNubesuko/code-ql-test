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
 * Detects allocations of System.Diagnostics.ProcessStartInfo.
 */
class PSIAlloc extends AllocationExpr {
  PSIAlloc() {
    this.getAllocatedType().getName() = "ProcessStartInfo" and
    this.getAllocatedType().getNamespace() = "System.Diagnostics"
  }
}

/**
 * Gets local variables of type ProcessStartInfo initialized by a 'new' expression.
 */
class PSILocalVar extends LocalVariable {
  PSILocalVar() {
    this.getType().getName() = "ProcessStartInfo" and
    this.getType().getNamespace() = "System.Diagnostics"
  }

  PSIAlloc getInitAlloc() {
    exists(PSIAlloc a |
      a = this.getInitializerExpr()
    )
    result = this.getInitializerExpr() instanceof PSIAlloc
      ? this.getInitializerExpr() as PSIAlloc
      : null
  }
}

/**
 * Returns true if UseShellExecute is set to false for the given variable.
 */
predicate useShellExecuteSetToFalse(PSILocalVar v) {
  exists(PropertyWrite pw |
    pw.getTarget().getName() = "UseShellExecute" and
    pw.getQualifier() instanceof LocalVariableAccess and
    pw.getQualifier().(LocalVariableAccess).getLocalVariable() = v and
    pw.getAssignedValue() instanceof BoolLiteral and
    pw.getAssignedValue().(BoolLiteral).getValue() = false
  )
}

/**
 * Main query: ProcessStartInfo local vars where UseShellExecute is NOT set to false.
 */
from PSILocalVar v
where not useShellExecuteSetToFalse(v)
select v.getLocation(), "ProcessStartInfo variable '" + v.getName() + "' does not have UseShellExecute explicitly set to false. This is insecure."
