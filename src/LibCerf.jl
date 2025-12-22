# SPDX-License-Identifier: MIT
"""
    LibCerf

A Julia wrapper for the `libcerf` library.

> `libcerf`, a self-contained numeric library that provides
> an efficient and accurate implementation of complex error functions,
> along with Dawson, Faddeeva, and Voigt functions.

# Exported functions

- [`erf(z)`](@ref):     Complex error function
- [`erfc(z)`](@ref):    Complementary error function
- [`erfcx(z)`](@ref), `erfcx(x)`:
    Underflow-compensated complementary error function
- [`erfi(z)`](@ref), `erfi(x)`:
    Imaginary error function
- [`faddeeva_w(z)`](@ref):  Faddeeva's scaled complex error function
    - [`im_w(x)`](@ref):        imaginary part of `faddeeva_w(complex(x, 0.0))`
    - [`im_w(re, im)`](@ref):   imaginary part of `faddeeva_w(complex(re, im))`
    - [`re_w(re, im)`](@ref):   real part of `faddeeva_w(complex(re, im))`
- [`dawson(z)`](@ref), `dawson(x)`: Dawson's integral
- [`voigt(x, sigma, gamma)`](@ref):
    Voigt's convolution of a Gaussian and a Lorentzian
- [`voigt_hwhm(sigma, gamma)`](@ref):
    Half width at half maximum of the Voigt profile

# References

- S. G. Johnson, J. Wuttke: libcerf, numeric library for complex error functions,
    https://jugit.fz-juelich.de/mlz/libcerf
"""
module LibCerf

export erf, erfc, erfcx, erfi
export faddeeva_w, im_w, re_w
export dawson, voigt, voigt_hwhm

const ComplexFloat = Complex{T} where {T<:AbstractFloat}

include("cerf_h.jl")

"""
    erf(z)

Error function of complex arguments.
```math
\\text{erf}(z) = \\frac{2}{\\sqrt{\\pi}} \\int_0^z e^{-t^2} dt
```

# References
- [DLMF: §7.2.1](https://dlmf.nist.gov/7.2#E1)
- [Erf -- Wolfram MathWorld](https://mathworld.wolfram.com/Erf.html)
"""
erf
erf(z::T) where {T<:ComplexFloat} = T(cerf(ComplexF64(z)))

"""
    erfc(z)

Complementary error function of complex arguments.
```math
\\text{erfc}(z)
= \\frac{2}{\\sqrt{\\pi}} \\int_z^\\infty e^{-t^2} dt
= 1 - \\text{erf}(z)
```

# References
- [DLMF: §7.2.2](https://dlmf.nist.gov/7.2#E2)
- [Erfc -- Wolfram MathWorld](https://mathworld.wolfram.com/Erfc.html)
"""
erfc
erfc(z::T) where {T<:ComplexFloat} = T(cerfc(ComplexF64(z)))

"""
    erfcx(x)
    erfcx(z)

Underflow-compensated complementary error function of
real or complex arguments.
```math
\\text{erfcx}(z)
= \\exp(z^2) \\text{erfc}(z)
= w(iz)
```

# References
- [Faddeeva Package](http://ab-initio.mit.edu/faddeeva/)
"""
erfcx
# NOTE: erfcx(x::Float64) defined in cerf_h.jl
erfcx(x::T) where {T<:Union{Float16,Float32}} = T(erfcx(Float64(x)))
erfcx(z::T) where {T<:ComplexFloat} = T(cerfcx(ComplexF64(z)))

"""
    erfi(x)
    erfi(z)

Imaginary error function of real or complex arguments.
```math
\\text{erfi}(z) = -i \\text{erf}(iz)
```

# References
- [Erfi -- Wolfram MathWorld](https://mathworld.wolfram.com/Erfi.html)
"""
erfi
# NOTE: erfi(x::Float64) defined in cerf_h.jl
erfi(x::T) where {T<:Union{Float16,Float32}} = T(erfi(Float64(x)))
erfi(z::T) where {T<:ComplexFloat} = T(cerfi(ComplexF64(z)))

"""
    faddeeva_w(z)

Faddeeva's scaled complex error function of complex arguments.
```math
w(z) = e^{-z^2} \\text{erfc}(-iz)
```

# References
- [DLMF: §7.2.3](https://dlmf.nist.gov/7.2#E3)
"""
faddeeva_w
faddeeva_w(z::T) where {T<:ComplexFloat} = T(w_of_z(ComplexF64(z)))

"""
    im_w(x)
    im_w(re, im)

Imaginary part of Faddeeva's scaled complex error function of real arguments.

- `im_w(x) = imag( faddeeva_w(complex(x, 0.0)) )`
- `im_w(re, im) = imag( faddeeva_w(complex(re, im)) )`
"""
im_w
im_w(x::T) where {T<:AbstractFloat} = T(im_w_of_x(Float64(x)))
im_w(re::T, im::T) where {T<:AbstractFloat} = T(im_w_of_z(Float64(re), Float64(im)))

"""
    re_w(re, im)

Real part of Faddeeva's scaled complex error function of real arguments.

- `re_w(re, im) = real( faddeeva_w(complex(re, im)) )`
"""
re_w
re_w(re::T, im::T) where {T<:AbstractFloat} = T(re_w_of_z(Float64(re), Float64(im)))

"""
    dawson(x)
    dawson(z)

Dawson integral of real or complex arguments.
```math
\\text{Dawson}(z)
= e^{-z^2} \\int_0^z e^{t^2} dt
= \\frac{\\sqrt{\\pi}}{2} e^{-z^2} \\text{erfi}(z)
```

# References
- [DLMF: §7.2.5](https://dlmf.nist.gov/7.2#E5)
- [Dawson's Integral -- Wolfram MathWorld](https://mathworld.wolfram.com/DawsonsIntegral.html)
"""
dawson
# NOTE: dawson(x::Float64) defined in cerf_h.jl
dawson(x::T) where {T<:Union{Float16,Float32}} = T(dawson(Float64(x)))
dawson(z::T) where {T<:ComplexFloat} = T(cdawson(ComplexF64(z)))

"""
    voigt(x, sigma, gamma)

Convolution of a Gaussian and a Lorentzian of real arguments.
```math
\\text{Voigt}(x; \\sigma, \\gamma)
= \\int_{-\\infty}^{\\infty} G(t; \\sigma) L(x-t; \\gamma) dt
```
where
```math
G(x; \\sigma) = \\frac{1}{\\sigma\\sqrt{2\\pi}} \\exp(-\\frac{x^2}{2\\sigma^2})
```
```math
L(x; \\gamma) = \\frac{ \\gamma }{ \\pi(x^2+\\gamma^2) }
```

# References
- [Voigt profile - Wikipedia](https://en.wikipedia.org/wiki/Voigt_profile)
"""
voigt
function voigt(x::T, sigma::T, gamma::T) where {T<:Union{Float16,Float32}}
    T(voigt(Float64(x), Float64(sigma), Float64(gamma)))
end

"""
    voigt_hwhm(sigma, gamma)

Half width at half maximum of the Voigt function of real arguments.

It is implicitly defined by:
```math
\\text{Voigt}( \\text{VoigtHWHM}( \\sigma, \\gamma); \\sigma, \\gamma)
= \\frac{1}{2} \\text{Voigt}(0; \\sigma, \\gamma)
```

# References
- Wuttke, J. (2025). Power series for the half width of the Voigt function, rederived.
    Journal of Numerical Analysis and Approximation Theory, 54(2), 345-356.
    https://doi.org/10.33993/jnaat542-1640
"""
voigt_hwhm
function voigt_hwhm(sigma::T, gamma::T) where {T<:Union{Float16,Float32}}
    T(voigt_hwhm(Float64(sigma), Float64(gamma)))
end

end # module LibCerf
