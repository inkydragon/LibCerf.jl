# Graphics

Plot graphics setup:
```@example plot
using LibCerf
# using Pkg; Pkg.add("UnicodePlots")
using UnicodePlots
```

## Error Functions

> [DLMF: Figure 7.3.1](https://dlmf.nist.gov/7.3#F1):
> Complementary error functions `erfc(x)` and `erfc(10*x)`, `−3 ≤ x ≤ 3`.

```@example plot
re_erfc(x) = real(LibCerf.erfc(complex(x)))
re_erfc10(x) = real(LibCerf.erfc(complex(10*x)))
lineplot(-3, 3, [re_erfc, re_erfc10]; title="erfc(x) and erfc(10*x)", width=65)
```
