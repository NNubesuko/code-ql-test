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
 * Gets a location that corresponds to a ProcessStartInfo object where UseShellExecute is not set to false.
 */
predicate isProcessStartInfoShellExecuteLocation(Location loc, string message) {
  // Option 1: UseShellExecute is explicitly set to true
  exists(Assignment assign, MemberAccess ma |
    assign.getTarget() = ma and
    ma.getMember().getName() = "UseShellExecute" and
    assign.getSource() instanceof Literal and
    assign.getSource().(Literal).getValue() = "true" and
    exists(LocalVariable v |
      ma.getBase() = v.getAnAccess() and
      v.getType().getFullName() = "System.Diagnostics.ProcessStartInfo" and
      loc = assign.getLocation() and
      message = "ProcessStartInfo.UseShellExecute is explicitly set to true here."
    )
  )
  or
  // Option 2: UseShellExecute is never set to false after construction (default is true)
  exists(LocalVariable v, Expr e |
    v.getType().getFullName() = "System.Diagnostics.ProcessStartInfo" and
    v.getAnAccess() = e and
    loc = e.getLocation() and
    not exists(Assignment assignF, MemberAccess maF |
      assignF.getTarget() = maF and
      maF.getMember().getName() = "UseShellExecute" and
      maF.getBase() = v.getAnAccess() and
      assignF.getSource() instanceof Literal and
      assignF.getSource().(Literal).getValue() = "false"
    ) and
    // Must be used in a context (such as assignment, method argument, etc.)
    exists(Call c | c.getArgument(_) = e) and
    message = "ProcessStartInfo.UseShellExecute is not set to false. Default (true) is used."
  )
}

from Location loc, string message
where isProcessStartInfoShellExecuteLocation(loc, message)
select loc, message
