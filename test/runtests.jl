using LibCerf
using Test

@testset "LibCerf.jl" begin
    @test LibCerf.Libcerf_jll.is_available()
end

for T in (Float64, Float32, Float16)
    CT = Complex{T}

    @testset "erf($CT)" begin
        @test isnan(erf(CT(NaN)))
    end

    @testset "erfc($CT)" begin
        @test isnan(erfc(CT(NaN)))
    end

    @testset "faddeeva_w($CT)" begin
        @test isnan(faddeeva_w(CT(NaN)))
    end

    @testset "im_w($T)" begin
        @test isnan(im_w(T(NaN)))
        @test isnan(im_w(T(NaN), T(NaN)))
        # @test isnan(im_w(T(0.0), T(NaN)))
        # @test isnan(im_w(T(NaN), T(0.0)))
        @test_broken im_w(T(0.0), T(NaN)) === T(NaN)
        @test_broken im_w(T(NaN), T(0.0)) === T(NaN)
    end

    @testset "re_w($T)" begin
        @test isnan(re_w(T(NaN), T(NaN)))
        @test isnan(re_w(T(0.0), T(NaN)))
        # @test isnan(re_w(T(NaN), T(0.0)))
        @test_broken re_w(T(NaN), T(0.0)) === T(NaN)
    end

    @testset "voigt($T)" begin
        @test isnan(voigt(T(NaN), T(NaN), T(NaN)))
        @test isnan(voigt(T(0.0), T(NaN), T(NaN)))
        @test isnan(voigt(T(NaN), T(0.0), T(NaN)))
        @test isnan(voigt(T(NaN), T(NaN), T(0.0)))
        # @test isnan(voigt(T(NaN), T(0.0), T(0.0)))
        @test_broken voigt(T(NaN), T(0.0), T(0.0)) === T(NaN)
        @test isnan(voigt(T(0.0), T(NaN), T(0.0)))
        @test isnan(voigt(T(0.0), T(0.0), T(NaN)))
    end

    @testset "voigt_hwhm($T)" begin
        @test isnan(voigt_hwhm(T(NaN), T(NaN)))
        @test isnan(voigt_hwhm(T(0.0), T(NaN)))
        @test isnan(voigt_hwhm(T(NaN), T(0.0)))
    end

    for TT in (T, CT)
        @testset "erfcx($TT)" begin
            @test isnan(erfcx(TT(NaN)))
        end

        @testset "erfi($TT)" begin
            @test isnan(erfi(TT(NaN)))
        end

        @testset "dawson($TT)" begin
            @test isnan(dawson(TT(NaN)))
        end
    end # TT
end # T
