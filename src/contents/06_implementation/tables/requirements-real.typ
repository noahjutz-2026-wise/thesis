#import "/src/common/util.typ": ref_requirement
#table(
  columns: 3,
  align: (center + horizon, start + horizon, start + horizon),
  table.header[*ID*][*Requirement*][*Rationale*],
  [#ref_requirement("req:real_determinism")], [Minimize stochasticity], [Faster learning],
  [#ref_requirement("req:real_safety")], [Reliability], [Unattended operation],
  [#ref_requirement("req:real_speed")],
  [Sufficient Frequency #footnote[TODO replace with something like expandability, introspecability?]],
  [],

  [#ref_requirement("req:real_clean")], [Observable], [Gain insights],
  [#ref_requirement("req:real_reproducible")], [Reproducible], [For future research],
)
