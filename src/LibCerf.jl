# SPDX-License-Identifier: MIT
module LibCerf

export erf, erfc, erfcx, erfi
export faddeeva_w, im_w, re_w
export dawson, voigt, voigt_hwhm

const ComplexFloat = Complex{T} where {T<:AbstractFloat}

include("cerf_h.jl")

"""
    erf(z)

Error function of complex arguments.
"""
erf
erf(z::T) where {T<:ComplexFloat} = T(cerf(ComplexF64(z)))

"""
    erfc(z)

Complementary error function of complex arguments.
"""
erfc
erfc(z::T) where {T<:ComplexFloat} = T(cerfc(ComplexF64(z)))

"""
    erfcx(x)
    erfcx(z)

Underflow-compensated complementary error function of
real or complex arguments.
"""
erfcx
# NOTE: erfcx(x::Float64) defined in cerf_h.jl
erfcx(x::T) where {T<:Union{Float16,Float32}} = T(erfcx(Float64(x)))
erfcx(z::T) where {T<:ComplexFloat} = T(cerfcx(ComplexF64(z)))

"""
    erfi(x)
    erfi(z)

Imaginary error function of real or complex arguments.
"""
erfi
# NOTE: erfi(x::Float64) defined in cerf_h.jl
erfi(x::T) where {T<:Union{Float16,Float32}} = T(erfi(Float64(x)))
erfi(z::T) where {T<:ComplexFloat} = T(cerfi(ComplexF64(z)))

"""
    faddeeva_w(z)

Faddeeva's scaled complex error function of complex arguments.
"""
faddeeva_w
faddeeva_w(z::T) where {T<:ComplexFloat} = T(w_of_z(ComplexF64(z)))

"""
    im_w(x)
    im_w(re, im)

Imaginary part of Faddeeva's scaled complex error function of real arguments.
"""
im_w
im_w(x::T) where {T<:AbstractFloat} = T(im_w_of_x(Float64(x)))
im_w(re::T, im::T) where {T<:AbstractFloat} = T(im_w_of_z(Float64(re), Float64(im)))

"""
    re_w(re, im)

Real part of Faddeeva's scaled complex error function of real arguments.
"""
re_w
re_w(re::T, im::T) where {T<:AbstractFloat} = T(re_w_of_z(Float64(re), Float64(im)))

"""
    dawson(x)
    dawson(z)

Dawson integral of real or complex arguments.
"""
dawson
# NOTE: dawson(x::Float64) defined in cerf_h.jl
dawson(x::T) where {T<:Union{Float16,Float32}} = T(dawson(Float64(x)))
dawson(z::T) where {T<:ComplexFloat} = T(cdawson(ComplexF64(z)))

"""
    voigt(x, sigma, gamma)

Convolution of a Gaussian and a Lorentzian of real arguments.
"""
voigt
function voigt(x::T, sigma::T, gamma::T) where {T<:Union{Float16,Float32}}
    T(voigt(Float64(x), Float64(sigma), Float64(gamma)))
end

"""
    voigt_hwhm(sigma, gamma)

Full width at half maximum of the Voigt function of real arguments.
"""
voigt_hwhm
function voigt_hwhm(sigma::T, gamma::T) where {T<:Union{Float16,Float32}}
    T(voigt_hwhm(Float64(sigma), Float64(gamma)))
end

end # module LibCerf
