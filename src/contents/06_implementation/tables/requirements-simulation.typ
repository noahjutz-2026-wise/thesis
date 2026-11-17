#import "/src/common/util.typ": ref_requirement
#table(
  columns: 3,
  align: (center + horizon, start + horizon, start + horizon),
  table.header[*ID*][*Requirement*][*Rationale*],
  [#ref_requirement("req:sim_fidelity")],
  [Replicate dimensions, dynamics, timing],
  [Transferability],
  [#ref_requirement("req:sim_configurability")],
  [Parameter configurability],
  [@gl:DR],
)
