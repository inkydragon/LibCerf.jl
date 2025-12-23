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

## Dawson’s Integral

> [DLMF: Figure 7.3.2](https://dlmf.nist.gov/7.3#F2):
> Dawson’s integral `F(x)`, `−3.5 ≤ x ≤ 3.5`.

```@example plot
F(x) = real(LibCerf.dawson(complex(x)))
lineplot(-3.5, 3.5, F; title="Dawson's integral F(x)", ylim=(-0.6, 0.6), width=50)
```
