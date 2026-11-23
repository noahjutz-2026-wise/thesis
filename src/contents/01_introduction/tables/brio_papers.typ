#table(
  columns: 5,
  table.header([*Reference*], [*Real platform*], [*Simulator*], [*@RL Algorithm*], [*@gl:S2R*]),
  [@fischertechnik_kugellabyrinth], [Fischertechnik], [$crossmark$], [$crossmark$], [$crossmark$],
  [@waldemarkUsingReinforcementLearning1995],
  [BRIO #footnote[simplified maze]],
  [Custom],
  [SRV-Net (@RL:short)],
  [Direct policy transfer],

  [@abdenebaouiConnectionistArchitectureLearning2007], [BRIO], [ODE], [QCON], [],

  [@metzenBRIOLabyrinthGameA2009], [BRIO], [ODE], [SARSA($lambda$) + CMAC], [✗],

  [@Bergatt2009Quantification], [BRIO], [ODE], [$crossmark$], [$crossmark$],

  [@ofjallCombiningVisionMachine2016], [BRIO], [No], [LWPR], [#sym.crossmark],
  [@jhaLearningTasksComplex], [CME], [Custom], [MF + MB RL], [✗],
  [@baarSimtoRealTransferLearning2019], [CME], [Custom], [RL], [DR],
  [@otaDataEfficientLearningComplex2021], [CME], [Physics+GP], [NMPC], [Sys-ID, GP Res.],
  [@cyberrunner], [BRIO], [$crossmark$], [DreamerV3], [$crossmark$],
  [@cyberrunner2], [BRIO], [$crossmark$], [DreamerV3 #footnote[with prioritized experience replay]], [$crossmark$],
)
