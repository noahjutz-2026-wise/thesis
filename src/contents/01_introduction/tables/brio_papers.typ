#table(
  columns: 5,
  table.header([*Reference*], [*Real platform*], [*@RL Algorithm*], [*Simulator*], [*@gl:S2R*]),
  [@waldemarkUsingReinforcementLearning1995],
  [BRIO #footnote[simplified maze]],
  [SRV-Net (@RL:short)],
  [Custom],
  [Direct policy transfer],

  [@abdenebaouiConnectionistArchitectureLearning2007], [BRIO], [QCON], [@gl:ODE:short], [],

  [@metzenBRIOLabyrinthGameA2009], [BRIO], [SARSA($lambda$) + CMAC], [@gl:ODE:short], [✗],

  [@Bergatt2009Quantification], [BRIO], [$crossmark$], [@gl:ODE:short], [$crossmark$],

  [@ofjallCombiningVisionMachine2016], [BRIO], [LWPR], [No], [#sym.crossmark],
  [@jhaLearningTasksComplex], [@gl:CME:short], [MF + MB RL], [Custom], [✗],
  [@baarSimtoRealTransferLearning2019], [@gl:CME:short], [RL], [Custom], [DR],
  [@otaDataEfficientLearningComplex2021], [@gl:CME:short], [NMPC], [Physics+GP], [Sys-ID, GP Res.],
  [@cyberrunner], [BRIO], [DreamerV3], [$crossmark$], [$crossmark$],
  [@cyberrunner2], [BRIO], [DreamerV3 #footnote[with prioritized experience replay]], [$crossmark$], [$crossmark$],
  [@fischertechnik_kugellabyrinth], [Fischertechnik], [$crossmark$], [$crossmark$], [$crossmark$],
)
