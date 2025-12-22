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

# Examples

```jldoctest
julia> [ (x=x, erf=Float32(erf(complex(x)))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, erf::Float32}}:
 (x = -2.0, erf = -0.9953223)
 (x = -1.5, erf = -0.96610516)
 (x = -1.0, erf = -0.8427008)
 (x = -0.5, erf = -0.5204999)
 (x = 0.0, erf = 0.0)
 (x = 0.5, erf = 0.5204999)
 (x = 1.0, erf = 0.8427008)
 (x = 1.5, erf = 0.96610516)
 (x = 2.0, erf = 0.9953223)

julia> [ (x=x, erf=erf(complex(x))) for x in (-Inf, -0.0, 0.0, Inf) ]
4-element Vector{@NamedTuple{x::Float64, erf::ComplexF64}}:
 (x = -Inf, erf = -1.0 + 0.0im)
 (x = -0.0, erf = -0.0 + 0.0im)
 (x = 0.0, erf = 0.0 + 0.0im)
 (x = Inf, erf = 1.0 + 0.0im)

julia> erf(complex(3.14)) + erfc(complex(3.14))
1.0 + 0.0im
```

See also: [`erfc(z)`](@ref), [`erfcx(z)`](@ref), [`erfi(z)`](@ref)

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

# Examples
```jldoctest
julia> [ (x=x, erfc=Float32(erfc(complex(x)))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, erfc::Float32}}:
 (x = -2.0, erfc = 1.9953222)
 (x = -1.5, erfc = 1.9661051)
 (x = -1.0, erfc = 1.8427008)
 (x = -0.5, erfc = 1.5204998)
 (x = 0.0, erfc = 1.0)
 (x = 0.5, erfc = 0.47950011)
 (x = 1.0, erfc = 0.1572992)
 (x = 1.5, erfc = 0.03389485)
 (x = 2.0, erfc = 0.004677735)

julia> [ (x=x, erfc=erfc(complex(x))) for x in (-Inf, 0.0, Inf) ]
3-element Vector{@NamedTuple{x::Float64, erfc::ComplexF64}}:
 (x = -Inf, erfc = 2.0 - 0.0im)
 (x = 0.0, erfc = 1.0 - 0.0im)
 (x = Inf, erfc = 0.0 - 0.0im)

julia> erf(complex(3.141)) + erfc(complex(3.141))
1.0 + 0.0im
```

See also: [`erf(z)`](@ref), [`erfcx(z)`](@ref)

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

# Examples

```jldoctest
julia> [ (x=x, erfcx=Float32(erfcx(complex(x)))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, erfcx::Float32}}:
 (x = -2.0, erfcx = 108.9409)
 (x = -1.5, erfcx = 18.653887)
 (x = -1.0, erfcx = 5.0089803)
 (x = -0.5, erfcx = 1.9523605)
 (x = 0.0, erfcx = 1.0)
 (x = 0.5, erfcx = 0.61569035)
 (x = 1.0, erfcx = 0.42758358)
 (x = 1.5, erfcx = 0.32158542)
 (x = 2.0, erfcx = 0.25539568)

julia> [ (x=x, erfcx=erfcx(complex(x))) for x in (-Inf, 0.0, Inf) ]
3-element Vector{@NamedTuple{x::Float64, erfcx::ComplexF64}}:
 (x = -Inf, erfcx = Inf - 0.0im)
 (x = 0.0, erfcx = 1.0 - 0.0im)
 (x = Inf, erfcx = 0.0 - 0.0im)

julia> erfcx(complex(pi)) - exp(pi^2)*erfc(complex(pi))
0.0 + 0.0im

julia> erfcx(complex(pi)) - faddeeva_w(im * complex(pi))
0.0 - 0.0im
```

See also: [`erf(z)`](@ref), [`erfc(z)`](@ref)

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

# Examples

```jldoctest
julia> [ (x=x, erfi=Float32(erfi(complex(x)))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, erfi::Float32}}:
 (x = -2.0, erfi = -18.564802)
 (x = -1.5, erfi = -4.5847335)
 (x = -1.0, erfi = -1.6504258)
 (x = -0.5, erfi = -0.6149521)
 (x = 0.0, erfi = 0.0)
 (x = 0.5, erfi = 0.6149521)
 (x = 1.0, erfi = 1.6504258)
 (x = 1.5, erfi = 4.5847335)
 (x = 2.0, erfi = 18.564802)

julia> [ (x=x, erfi=erfi(complex(x))) for x in (-Inf, -0.0, 0.0, Inf) ]
4-element Vector{@NamedTuple{x::Float64, erfi::ComplexF64}}:
 (x = -Inf, erfi = -Inf + 0.0im)
 (x = -0.0, erfi = -0.0 + 0.0im)
 (x = 0.0, erfi = 0.0 + 0.0im)
 (x = Inf, erfi = Inf + 0.0im)

julia> erfi(complex(pi)) + im*erf(im*complex(pi))
0.0 + 0.0im
```

See also: [`erf(z)`](@ref)

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
w(z)
= e^{-z^2} \\text{erfc}(-iz)
= \\text{erfcx}(-iz)
```

# Examples
```jldoctest
julia> [ (x=x, w=ComplexF16(faddeeva_w(complex(x)))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, w::ComplexF16}}:
 (x = -2.0, w = Float16(0.01831) - Float16(0.34)im)
 (x = -1.5, w = Float16(0.1054) - Float16(0.4832)im)
 (x = -1.0, w = Float16(0.368) - Float16(0.607)im)
 (x = -0.5, w = Float16(0.779) - Float16(0.479)im)
 (x = 0.0, w = Float16(1.0) + Float16(0.0)im)
 (x = 0.5, w = Float16(0.779) + Float16(0.479)im)
 (x = 1.0, w = Float16(0.368) + Float16(0.607)im)
 (x = 1.5, w = Float16(0.1054) + Float16(0.4832)im)
 (x = 2.0, w = Float16(0.01831) + Float16(0.34)im)

julia> [ (x=x, w=faddeeva_w(complex(x))) for x in (-Inf, -0.0, 0.0, Inf) ]
4-element Vector{@NamedTuple{x::Float64, w::ComplexF64}}:
 (x = -Inf, w = 0.0 - 0.0im)
 (x = -0.0, w = 1.0 - 0.0im)
 (x = 0.0, w = 1.0 + 0.0im)
 (x = Inf, w = 0.0 + 0.0im)

julia> faddeeva_w(complex(pi)) - erfcx(-im * complex(pi))
0.0 + 0.0im
```

See also: [`erfc(z)`](@ref), [`erfcx(z)`](@ref)

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

# Examples

```jldoctest
julia> [ (x=x, w=Float32(im_w(x, 0.0))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, w::Float32}}:
 (x = -2.0, w = -0.34002623)
 (x = -1.5, w = -0.48322734)
 (x = -1.0, w = -0.6071577)
 (x = -0.5, w = -0.47892517)
 (x = 0.0, w = 0.0)
 (x = 0.5, w = 0.47892517)
 (x = 1.0, w = 0.6071577)
 (x = 1.5, w = 0.48322734)
 (x = 2.0, w = 0.34002623)

julia> [ (x=x, w_im=im_w(x)) for x in (-Inf, -0.0, 0.0, Inf) ]
4-element Vector{@NamedTuple{x::Float64, w_im::Float64}}:
 (x = -Inf, w_im = -0.0)
 (x = -0.0, w_im = -0.0)
 (x = 0.0, w_im = 0.0)
 (x = Inf, w_im = 0.0)

julia> faddeeva_w(3.14+0im) - complex(re_w(3.14,0.0), im_w(3.14))
0.0 + 0.0im
```

See also: [`faddeeva_w(z)`](@ref), [`re_w(re, im)`](@ref)
"""
im_w
im_w(x::T) where {T<:AbstractFloat} = T(im_w_of_x(Float64(x)))
im_w(re::T, im::T) where {T<:AbstractFloat} = T(im_w_of_z(Float64(re), Float64(im)))

"""
    re_w(re, im)

Real part of Faddeeva's scaled complex error function of real arguments.

- `re_w(re, im) = real( faddeeva_w(complex(re, im)) )`

# Examples

```jldoctest
julia> [ (x=x, w=Float32(re_w(x, 0.0))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, w::Float32}}:
 (x = -2.0, w = 0.01831564)
 (x = -1.5, w = 0.10539922)
 (x = -1.0, w = 0.36787945)
 (x = -0.5, w = 0.7788008)
 (x = 0.0, w = 1.0)
 (x = 0.5, w = 0.7788008)
 (x = 1.0, w = 0.36787945)
 (x = 1.5, w = 0.10539922)
 (x = 2.0, w = 0.01831564)

julia> [ (x=x, w_im=re_w(x, 0.0)) for x in (-Inf, 0.0, Inf) ]
3-element Vector{@NamedTuple{x::Float64, w_im::Float64}}:
 (x = -Inf, w_im = 0.0)
 (x = 0.0, w_im = 1.0)
 (x = Inf, w_im = 0.0)

julia> faddeeva_w(1.0+2.0im) - complex(re_w(1.0,2.0), im_w(1.0,2.0))
0.0 + 0.0im
```

See also: [`faddeeva_w(z)`](@ref), [`im_w(re, im)`](@ref)
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

# Examples

```jldoctest
julia> [ (x=x, dawson=Float32(dawson(x))) for x in -2:0.5:2 ]
9-element Vector{@NamedTuple{x::Float64, dawson::Float32}}:
 (x = -2.0, dawson = -0.3013404)
 (x = -1.5, dawson = -0.42824906)
 (x = -1.0, dawson = -0.5380795)
 (x = -0.5, dawson = -0.4244364)
 (x = 0.0, dawson = 0.0)
 (x = 0.5, dawson = 0.4244364)
 (x = 1.0, dawson = 0.5380795)
 (x = 1.5, dawson = 0.42824906)
 (x = 2.0, dawson = 0.3013404)

julia> [ (x=x, dawson=dawson(x)) for x in (-Inf, -0.0, 0.0, Inf) ]
4-element Vector{@NamedTuple{x::Float64, dawson::Float64}}:
 (x = -Inf, dawson = -0.0)
 (x = -0.0, dawson = -0.0)
 (x = 0.0, dawson = 0.0)
 (x = Inf, dawson = 0.0)

julia> abs( dawson(complex(pi)) - sqrt(pi)/2*exp(-pi^2)*erfi(complex(pi)) ) < eps(Float64)
true
```

See also: [`erfi(z)`](@ref)

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
