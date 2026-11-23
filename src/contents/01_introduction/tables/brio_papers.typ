#table(
  columns: 5,
  table.header([*Reference*], [*Real platform*], [*@RL Algorithm*], [*Simulator*], [*@gl:S2R*]),
  [@fischertechnik_kugellabyrinth], [Fischertechnik], [$crossmark$], [$crossmark$], [$crossmark$],
  [@waldemarkUsingReinforcementLearning1995],
  [BRIO #footnote[simplified maze]],
  [SRV-Net (@RL:short)],
  [Custom],
  [Direct policy transfer],

  [@abdenebaouiConnectionistArchitectureLearning2007], [BRIO], [QCON], [ODE], [],

  [@metzenBRIOLabyrinthGameA2009], [BRIO], [SARSA($lambda$) + CMAC], [ODE], [✗],

  [@Bergatt2009Quantification], [BRIO], [$crossmark$], [ODE], [$crossmark$],

  [@ofjallCombiningVisionMachine2016], [BRIO], [LWPR], [No], [#sym.crossmark],
  [@jhaLearningTasksComplex], [CME], [MF + MB RL], [Custom], [✗],
  [@baarSimtoRealTransferLearning2019], [CME], [RL], [Custom], [DR],
  [@otaDataEfficientLearningComplex2021], [CME], [NMPC], [Physics+GP], [Sys-ID, GP Res.],
  [@cyberrunner], [BRIO], [DreamerV3], [$crossmark$], [$crossmark$],
  [@cyberrunner2], [BRIO], [DreamerV3 #footnote[with prioritized experience replay]], [$crossmark$], [$crossmark$],
)
