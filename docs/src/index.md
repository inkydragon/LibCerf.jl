# LibCerf

Documentation for [LibCerf](https://github.com/inkydragon/LibCerf.jl).

```@meta
CurrentModule = LibCerf
```
```@setup plot
using LibCerf
```

```@docs
LibCerf
```

## Index

```@index
```


## Error Functions
```@docs
LibCerf.erf
```
Real part plot of `erf(z)`:
```@example plot
using UnicodePlots
re_erf(x) = real(LibCerf.erf(complex(x)))
lineplot(-4, 4, re_erf; title="Re[Erf(z)]", ylabel="erf(x)")
```

```@docs
LibCerf.erfc
```
Real part plot of `erfc(z)`:
```@example plot
using UnicodePlots
re_erfc(x) = real(LibCerf.erfc(complex(x)))
plt = lineplot(-4, 4, re_erfc; title="Re[Erfc(z)]", ylabel="erfc(x)");
lineplot!(plt, 1, 0; name="y = 1")
```
`erf(x)` and `erfc(x)` relations:
```@example plot
lineplot(-4, 4, [re_erf, re_erfc]; title="Erf(x) + Erfc(z) = 1", ylim=(2, -1))
```

```@docs
LibCerf.erfcx
```
Real part plot of `erfcx(z)`:
```@example plot
using UnicodePlots
re_erfcx(x) = real(LibCerf.erfcx(complex(x)))
lineplot(-1.5, 2, re_erfcx; title="Re[Erfcx(z)]", ylabel="erfcx(x)")
```

```@docs
LibCerf.erfi
```
Real part plot of `erfi(z)`:
```@example plot
using UnicodePlots
re_erfi(x) = real(LibCerf.erfi(complex(x)))
lineplot(-2, 2, re_erfi; title="Re[Erfi(z)]", ylabel="erfi(x)")
```


## Faddeeva function
```@docs
LibCerf.faddeeva_w
```
```@example plot
using UnicodePlots
re_w(x) = real(LibCerf.re_w(x, 0.0))
lineplot(-4, 4, [re_w, im_w];
    title="Rm[w(z)] and Re[w(z)]", ylabel="w(z)", ylim=(1, -0.75))
```

```@docs
LibCerf.im_w
```
```@example plot
using UnicodePlots
lineplot(-5, 5, im_w; title="Im[w(z)]", ylabel="im_w(x)", ylim=(0.75, -0.75))
```

```@docs
LibCerf.re_w
```
```@example plot
using UnicodePlots
re_w(x) = real(LibCerf.re_w(x, 0.0))
lineplot(-2.5, 2.5, re_w; title="Re[w(z)]", ylabel="re_w(x, 0.0)")
```

## Dawson’s Integral
```@docs
LibCerf.dawson
```
Real part plot of `dawson(z)`:
```@example plot
using UnicodePlots
re_dawson(x) = real(LibCerf.dawson(complex(x)))
lineplot(-5, 5, re_dawson;
    title="Re[Dawson(z)]", ylabel="dawson(x+0.0im)", ylim=(0.75, -0.75))
```

## Voigt Functions
```@docs
LibCerf.voigt
LibCerf.voigt_hwhm
```
