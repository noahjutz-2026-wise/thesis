= Implementation

== System Context

- Spaces
  #table(
    columns: 4,
    stroke: none,
    table.header([*Environment*], table.vline(), [*Obs*], [*Act*], [*Rew*]),
    table.hline(),
    [CyberRunner],
    $
      {
        #box[
          `image`: $[0..255]^(64,64,1)$ \
          `states`: $[alpha, beta, x, y] in RR^4$ \
          `goal`: $[x, y]^N in RR^(2N)$ \
          `progress`: $RR$
        ]
      }
    $,
    $
      [-1, 1]^2
    $,
    [See env.py],

    [Marble-Maze],
    [See BoardAgent.cs],
    [See BoardAgent.cs],
    [See BoardAgent.cs],

    [Unified],
    [?],
    [?],
    [?],
  )
