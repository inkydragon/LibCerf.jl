# Graphics

Plot graphics setup:
```@example plot
using LibCerf
# using Pkg; Pkg.add("UnicodePlots")
using UnicodePlots

# Save png in CI or run as script
is_ci() = get(ENV, "CI", "") == "true" || !isinteractive()
```

## Page TOC

```@contents
Pages = ["graphics.md"]
Depth = 3
```


## Error Functions

> [DLMF: Figure 7.3.1](https://dlmf.nist.gov/7.3#F1):
> Complementary error functions `erfc(x)` and `erfc(10*x)`, `−3 ≤ x ≤ 3`.

```@example plot
re_erfc(x) = real(LibCerf.erfc(complex(x)))
re_erfc10(x) = real(LibCerf.erfc(complex(10*x)))
lineplot(-3, 3, [re_erfc, re_erfc10]; title="erfc(x) and erfc(10*x)", width=65)
```

### 2D erf

> [Erf -- from Wolfram MathWorld](https://mathworld.wolfram.com/Erf.html):

- `Re[erf(z)]`

```@example plot
steps = 1000
x = y = range(start=-2, stop=2; length=steps)
f(x,y) = clamp(real(erf(complex(x,y))), -4.0, 4.0)
contourplot(x, y, f
    ; title = "Re[erf(z)]",
    xlabel="x", ylabel="y",
    levels=16, height=20, width=50)
```

- `Im[erf(z)]`

```@example plot
steps = 1000
x = y = range(start=-2, stop=2; length=steps)
f(x,y) = clamp(imag(erf(complex(x,y))), -4.0, 4.0)
contourplot(x, y, f
    ; title = "Im[erf(z)]",
    xlabel="x", ylabel="y",
    levels=10, height=20, width=50)
```

- `|erf(z)|`

```@example plot
steps = 1000
x = y = range(start=-2, stop=2; length=steps)
abs_erf(x,y) = clamp(abs(erf(complex(x,y))), -4.0, 4.0)
contourplot(x, y, abs_erf
    ; title = "|erf(z)|",
    xlabel="x", ylabel="y",
    levels=10, height=20, width=50)
```

### Modulus of erf

> [DLMF: §Figure 7.3.5](https://dlmf.nist.gov/7.3#F5):
> `|erf⁡(x+i⁢y)|, −3 ≤ x ≤ 3, −3 ≤ y ≤ 3`.

```julia
# @example plot
using GLMakie, LaTeXStrings
GLMakie.activate!()

#= Setup params =#
xlim = ylim = (lo=-3, hi=3)
zlim = (lo=0, hi=5)
steps = 5000
x = y = range(start=xlim.lo, stop=xlim.hi; length=steps+1)
func = erf
cmap = :jet
font_size = 22
title = "|$(func)(x+iy)|"
fig_name = "abs_$(func).png"

#= Eval functions =#
z = @. abs(func(complex(x, y')));

#= Draw surface plot =#
with_theme(colormap = cmap) do
    fig = Figure(; fontsize = font_size)
    ax3d = Axis3(fig[1, 1]; title = title,
        limits = (xlim..., ylim..., zlim...),
        xreversed = true, yreversed = true,
        perspectiveness = 0.5, azimuth = 2.19, elevation = 0.57)
    pltobj = surface!(ax3d, x, y, z; colorrange=(zlim...,))
    Colorbar(fig[1, 2], pltobj; height = Relative(0.5))
    colsize!(fig.layout, 1, Aspect(1, 1.0))
    resize_to_layout!(fig)
    is_ci() ? save(fig_name, fig) : fig
end
# ![abs(erf(z))](abs_erf.png)
```

### Angle of erf

> [Erf - Wolfram](https://reference.wolfram.com/language/ref/Erf.html):

```julia
# @example plot
using GLMakie, LaTeXStrings
GLMakie.activate!()

#= Setup params =#
xlim = ylim = (lo=-2, hi=2)
zlim = (lo=0, hi=4)
color_lim = (lo=-pi, hi=pi)
steps = 5000
x = y = range(start=xlim.lo, stop=xlim.hi; length=steps+1)
func = erf
# wolfram ComplexPlot3D like
cmap = [:cyan, :purple1, :red, :yellow, :green1]
font_size = 22
title = "Angle of $(func)(x+iy)"
fig_name = "angle_$(func).png"

#= Eval functions =#
z = @. abs(func(complex(x, y')));
c = @. angle(func(complex(x, y')));

#= Draw surface plot =#
with_theme(colormap = cmap) do
    fig = Figure(; fontsize = font_size)
    ax3d = Axis3(fig[1, 1]; title = title,
        limits = (xlim..., ylim..., zlim...),
        xreversed = true, yreversed = true,
        aspect = (1, 1, 1/3),
        perspectiveness = 0.5, azimuth = 2.19, elevation = 0.57)
    pltobj = surface!(ax3d, x, y, z; color=c,
    # colorrange=(color_lim...,)
    )
    Colorbar(fig[1, 2], pltobj; height = Relative(0.5))
    colsize!(fig.layout, 1, Aspect(1, 1.0))
    resize_to_layout!(fig)
    is_ci() ? save(fig_name, fig) : fig
end
# ![angle(erf(z))](angle_erf.png)
```

### Modulus of erfc

> [DLMF: §Figure 7.3.6](https://dlmf.nist.gov/7.3#F6):
> `|erf⁡c(x+i⁢y)|, −3 ≤ x ≤ 3, −3 ≤ y ≤ 3`.

```julia
# @example plot
using GLMakie, LaTeXStrings
GLMakie.activate!()

#= Setup params =#
xlim = ylim = (lo=-3, hi=3)
zlim = (lo=0, hi=5)
steps = 5000
x = y = range(start=xlim.lo, stop=xlim.hi; length=steps+1)
func = erfc
cmap = :jet
font_size = 22
title = "|$(func)(x+iy)|"
fig_name = "abs_$(func).png"

#= Eval functions =#
z = @. abs(func(complex(x, y')));

#= Draw surface plot =#
with_theme(colormap = cmap) do
    fig = Figure(; fontsize = font_size)
    ax3d = Axis3(fig[1, 1]; title = title,
        limits = (xlim..., ylim..., zlim...),
        xreversed = true, yreversed = true,
        perspectiveness = 0.5, azimuth = 2.19, elevation = 0.57)
    pltobj = surface!(ax3d, x, y, z; colorrange=(zlim...,))
    Colorbar(fig[1, 2], pltobj; height = Relative(0.5))
    colsize!(fig.layout, 1, Aspect(1, 1.0))
    resize_to_layout!(fig)
    is_ci() ? save(fig_name, fig) : fig
end
# ![abs(erfc(z))](abs_erfc.png)
```


## Dawson’s Integral

> [DLMF: Figure 7.3.2](https://dlmf.nist.gov/7.3#F2):
> Dawson’s integral `F(x)`, `−3.5 ≤ x ≤ 3.5`.

```@example plot
F(x) = real(LibCerf.dawson(complex(x)))
lineplot(-3.5, 3.5, F; title="Dawson's integral F(x)", ylim=(-0.6, 0.6), width=50)
```
