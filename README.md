# LibCerf.jl

Julia wrapper for [libcerf](https://jugit.fz-juelich.de/mlz/libcerf).

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://inkydragon.github.io/LibCerf.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://inkydragon.github.io/LibCerf.jl/dev/)
[![Build Status](https://github.com/inkydragon/LibCerf.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/inkydragon/LibCerf.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/inkydragon/LibCerf.jl/graph/badge.svg?token=VByhriTXw2)](https://codecov.io/gh/inkydragon/LibCerf.jl)

> `libcerf`, a self-contained numeric library that provides
> an efficient and accurate implementation of complex error functions,
> along with Dawson, Faddeeva, and Voigt functions.


## Installation

```julia
using Pkg;  Pkg.add("LibCerf")
```

Or using [Pkg REPL mode](https://docs.julialang.org/en/v1/stdlib/Pkg/):

```julia
]add LibCerf
```

## API

Please refer to the [documentation](https://inkydragon.github.io/LibCerf.jl/) for details.

NOTE: `erf`, `erfc`, and `faddeeva_w` only support complex arguments.

### Error Functions

- `erf(z)`: Complex error function
- `erfc(z)`: Complementary error function
- `erfcx(z)`, `erfcx(x)`: Underflow-compensated complementary error function
- `erfi(z)`, `erfi(x)`: Imaginary error function

### Faddeeva Functions

- `faddeeva_w(z)`: Faddeeva's scaled complex error function
- `im_w(x)`: Imaginary part of `faddeeva_w(complex(x, 0.0))`
- `im_w(re, im)`: Imaginary part of `faddeeva_w(complex(re, im))`
- `re_w(re, im)`: Real part of `faddeeva_w(complex(re, im))`

### Dawson's Integral

- `dawson(z)`, `dawson(x)`: Dawson's integral

### Voigt Functions

- `voigt(x, sigma, gamma)`: Voigt's convolution of a Gaussian and a Lorentzian
- `voigt_hwhm(sigma, gamma)`: Half width at half maximum of the Voigt profile

## Similar Packages

- (MIT) [JuliaMath/SpecialFunctions.jl](https://specialfunctions.juliamath.org/stable/functions_overview/#Error-Functions,-Dawson%E2%80%99s-and-Fresnel-Integrals):
    provides a comprehensive collection of special functions based on
    the OpenSpecFun and OpenLibm libraries.  
    For real and complex arguments:
    `erf(z)`, `erfc(z)`, `erfcx(z)`, `erfi(z)`; `faddeeva(z)`; `dawson(z)`;  
    Also note that it also uses the Faddeeva C library.
- (GPL-3.0) [JuliaMath/GSL.jl](https://github.com/JuliaMath/GSL.jl):
    Julia interface to the GNU Scientific Library (GSL).  
    For real arguments ONLY: `sf_erf(x)`, `sf_erfc(x)`; `sf_dawson(x)`
- (GPL-3.0) [markmbaum/Faddeyeva985.jl](https://github.com/markmbaum/Faddeyeva985.jl):
    Julia implementation of Algorithm 985, a fast, moderate-accuracy approximation
    of the Faddeyeva (Faddeeva) function.  
    `faddeyeva(z)`


## License

```jl
# SPDX-License-Identifier: MIT
```

This project is licensed under the terms of the [MIT license](LICENSE).

NOTE: `mlz/libcerf` is licensed under the terms of the
[MIT license](https://jugit.fz-juelich.de/mlz/libcerf/-/blob/main/LICENSE)
