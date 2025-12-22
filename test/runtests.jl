using LibCerf
using Test

@testset "LibCerf.jl" begin
    @test LibCerf.Libcerf_jll.is_available()

    @testset "Docstrings" begin
        @test isempty(Docs.undocumented_names(LibCerf))
    end
end

for T in (Float64, Float32, Float16)
    CT = Complex{T}

    @testset "erf($CT)" begin
        @test isnan(@inferred(erf(CT(NaN))))

        @test erf(CT(Inf)) == CT(1)
        @test erf(CT(10)) == CT(1)
        @test erf(zero(CT)) == zero(CT)
        @test erf(-CT(10)) == -CT(1)
        @test erf(-CT(Inf)) == -CT(1)
    end

    @testset "erfc($CT)" begin
        @test isnan(@inferred(erfc(CT(NaN))))

        @test erfc(CT(Inf)) == CT(0)
        @test erfc(CT(100)) == CT(0)
        @test erfc(zero(CT)) == CT(1)
        @test erfc(-CT(10)) == CT(2)
        @test erfc(-CT(100)) == CT(2)
        @test erfc(-CT(Inf)) == CT(2)
    end

    @testset "faddeeva_w($CT)" begin
        @test isnan(@inferred(faddeeva_w(CT(NaN))))

        @test faddeeva_w(CT(Inf)) == zero(CT)
        @test faddeeva_w(zero(CT)) == one(CT)
        @test faddeeva_w(-CT(Inf)) == -zero(CT)
    end

    @testset "im_w($T)" begin
        @test isnan(im_w(T(NaN)))
        @test isnan(im_w(T(NaN), T(NaN)))
        # @test isnan(im_w(T(0.0), T(NaN)))
        # @test isnan(im_w(T(NaN), T(0.0)))
        @test_broken im_w(T(0.0), T(NaN)) === T(NaN)
        @test_broken im_w(T(NaN), T(0.0)) === T(NaN)

        @test im_w(T(0)) == T(0)
        @test im_w(T(0), T(0)) == T(0)
    end

    @testset "re_w($T)" begin
        @test isnan(@inferred(re_w(T(NaN), T(NaN))))
        @test isnan(re_w(T(0.0), T(NaN)))
        # @test isnan(re_w(T(NaN), T(0.0)))
        @test_broken re_w(T(NaN), T(0.0)) === T(NaN)

        @test re_w(T(100), T(0)) == T(0)
        @test re_w(T(0), T(0)) == T(1)
        @test re_w(-T(100), T(0)) == T(0)
    end

    @testset "voigt($T)" begin
        @test isnan(@inferred(voigt(T(NaN), T(NaN), T(NaN))))
        @test isnan(voigt(T(0.0), T(NaN), T(NaN)))
        @test isnan(voigt(T(NaN), T(0.0), T(NaN)))
        @test isnan(voigt(T(NaN), T(NaN), T(0.0)))
        # @test isnan(voigt(T(NaN), T(0.0), T(0.0)))
        @test_broken voigt(T(NaN), T(0.0), T(0.0)) === T(NaN)
        @test isnan(voigt(T(0.0), T(NaN), T(0.0)))
        @test isnan(voigt(T(0.0), T(0.0), T(NaN)))

        @test isfinite(voigt(T(0), one(T), one(T)))
        @test iszero(voigt(T(Inf), one(T), one(T)))
    end

    @testset "voigt_hwhm($T)" begin
        @test isnan(@inferred(voigt_hwhm(T(NaN), T(NaN))))
        @test isnan(voigt_hwhm(T(0.0), T(NaN)))
        @test isnan(voigt_hwhm(T(NaN), T(0.0)))

        @test voigt_hwhm(T(0), one(T)) == one(T)
    end

    for TT in (T, CT)
        @testset "erfcx($TT)" begin
            @test isnan(@inferred(erfcx(TT(NaN))))

            @test erfcx(zero(CT)) == one(CT)
            @test iszero(erfcx(CT(Inf)))
            @test isinf(erfcx(CT(-Inf)))
        end

        @testset "erfi($TT)" begin
            @test isnan(@inferred(erfi(TT(NaN))))

            @test erfi(CT(Inf)) == CT(Inf)
            @test erfi(zero(CT)) == zero(CT)
            @test erfi(-CT(Inf)) == -CT(Inf)
        end

        @testset "dawson($TT)" begin
            @test isnan(@inferred(dawson(TT(NaN))))

            @test iszero(dawson(CT(Inf)))
            @test dawson(zero(CT)) == zero(CT)
            @test iszero(dawson(CT(-Inf)))
        end
    end # TT

end # T
