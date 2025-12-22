# SPDX-License-Identifier: MIT
using Libcerf_jll: Libcerf_jll
const libcerf = Libcerf_jll.libcerf

# compute w(z) = exp(-z^2) erfc(-iz), Faddeeva's scaled complex error function
w_of_z(z::ComplexF64) = ccall((:w_of_z, libcerf), ComplexF64, (ComplexF64,), z)
# special case Im[w(x)] of real x
im_w_of_x(x::Float64) = ccall((:im_w_of_x, libcerf), Cdouble, (Cdouble,), x)
function re_w_of_z(x::Float64, y::Float64)
    ccall((:re_w_of_z, libcerf), Cdouble, (Cdouble, Cdouble), x, y)
end
function im_w_of_z(x::Float64, y::Float64)
    ccall((:im_w_of_z, libcerf), Cdouble, (Cdouble, Cdouble), x, y)
end

# compute erf(z), the error function of complex arguments
cerf(z::ComplexF64) = ccall((:cerf, libcerf), ComplexF64, (ComplexF64,), z)

# compute erfc(z) = 1 - erf(z), the complementary error function
cerfc(z::ComplexF64) = ccall((:cerfc, libcerf), ComplexF64, (ComplexF64,), z)

# compute erfcx(z) = exp(z^2) erfc(z), an underflow-compensated version of erfc
cerfcx(z::ComplexF64) = ccall((:cerfcx, libcerf), ComplexF64, (ComplexF64,), z)
# special case for real x
erfcx(x::Float64) = ccall((:erfcx, libcerf), Cdouble, (Cdouble,), x)

# compute erfi(z) = -i erf(iz), the imaginary error function
cerfi(z::ComplexF64) = ccall((:cerfi, libcerf), ComplexF64, (ComplexF64,), z)
# special case for real x
erfi(x::Float64) = ccall((:erfi, libcerf), Cdouble, (Cdouble,), x)

# compute dawson(z) = sqrt(pi)/2 * exp(-z^2) * erfi(z), Dawson's integral
cdawson(z::ComplexF64) = ccall((:cdawson, libcerf), ComplexF64, (ComplexF64,), z)
# special case for real x
dawson(x::Float64) = ccall((:dawson, libcerf), Cdouble, (Cdouble,), x)

# compute voigt(x,...), the convolution of a Gaussian and a Lorentzian
function voigt(x::Float64, sigma::Float64, gamma::Float64)
    ccall((:voigt, libcerf), Cdouble, (Cdouble, Cdouble, Cdouble), x, sigma, gamma)
end
# compute the full width at half maximum of the Voigt function
function voigt_hwhm(sigma::Float64, gamma::Float64)
    ccall((:voigt_hwhm, libcerf), Cdouble, (Cdouble, Cdouble), sigma, gamma)
end
