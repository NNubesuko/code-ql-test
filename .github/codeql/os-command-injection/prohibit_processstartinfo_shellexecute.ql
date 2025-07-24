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
 * Gets ProcessStartInfo allocations.
 */
class ProcessStartInfoAlloc extends Expr {
  ProcessStartInfoAlloc() {
    this.getType().hasQualifiedName("System.Diagnostics", "ProcessStartInfo")
  }
}

/**
 * Gets assignments to UseShellExecute property for a given ProcessStartInfo object.
 */
predicate useShellExecuteSetTo(ProcessStartInfoAlloc psi, boolean isFalse) {
  exists(PropertyAccess pa |
    pa.getQualifier() = psi and
    pa.getTarget().hasName("UseShellExecute") and
    exists(Assignment assign |
      assign.getLeftOperand() = pa and
      (
        (isFalse and assign.getRightOperand() instanceof BoolLiteral and assign.getRightOperand().(BoolLiteral).getValue() = false) or
        (not isFalse and assign.getRightOperand() instanceof BoolLiteral and assign.getRightOperand().(BoolLiteral).getValue() = true)
      )
    )
  )
}

from ProcessStartInfoAlloc psi
where
  // Option 1: UseShellExecute is set to true anywhere
  useShellExecuteSetTo(psi, false) = false or
  useShellExecuteSetTo(psi, false) = undefined
select psi, "ProcessStartInfo.UseShellExecute is not explicitly set to false after allocation."
