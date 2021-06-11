using Distributions: isequal, isapprox
using LaTeXStrings
using Plots
using Random, Distributions

begin
    module Model

    const S = 1368; # solar insolation [W/m^2]  (energy per unit time per unit area)
    const α = 0.3; # albedo, or planetary reflectivity [unitless]
    const B = -1.3; # climate feedback parameter [W/m^2/°C],
    const T0 = 14.; # preindustrial temperature [°C]

    absorbed_solar_radiation(; α=α, S=S) = S*(1 - α)/4; # [W/m^2]
    outgoing_thermal_radiation(T; A=A, B=B) = A - B*T;

    const A = S*(1. - α)/4 + B*T0; # [W/m^2].

    greenhouse_effect(CO2; a=a, CO2_PI=CO2_PI) = a*log(CO2/CO2_PI);

    const a = 5.0; # CO2 forcing coefficient [W/m^2]
    const CO2_PI = 280.; # preindustrial CO2 concentration [parts per million; ppm];
    CO2_const(t) = CO2_PI; # constant CO2 concentrations

    const C = 51.; # atmosphere and upper-ocean heat capacity [J/m^2/°C]

    function timestep!(ebm)
        append!(ebm.T, ebm.T[end] + ebm.Δt*tendency(ebm));
        append!(ebm.t, ebm.t[end] + ebm.Δt);
    end;

    tendency(ebm) = (1. /ebm.C) * (
        + absorbed_solar_radiation(α=ebm.α, S=ebm.S)
        - outgoing_thermal_radiation(ebm.T[end], A=ebm.A, B=ebm.B)
        + greenhouse_effect(ebm.CO2(ebm.t[end]), a=ebm.a, CO2_PI=ebm.CO2_PI)
    );

    begin
        mutable struct EBM
            T::Array{Float64, 1}
        
            t::Array{Float64, 1}
            Δt::Float64
        
            CO2::Function
        
            C::Float64
            a::Float64
            A::Float64
            B::Float64
            CO2_PI::Float64
        
            α::Float64
            S::Float64
        end;
        
        # Make constant parameters optional kwargs
        EBM(T::Array{Float64, 1}, t::Array{Float64, 1}, Δt::Real, CO2::Function;
            C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S) = (
            EBM(T, t, Δt, CO2, C, a, A, B, CO2_PI, α, S)
        );
        
        # Construct from float inputs for convenience
        EBM(T0::Real, t0::Real, Δt::Real, CO2::Function;
            C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S) = (
            EBM(Float64[T0], Float64[t0], Δt, CO2;
                C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S);
        );
    end;

    begin
        function run!(ebm::EBM, end_year::Real)
            while ebm.t[end] < end_year
                timestep!(ebm)
            end
        end;
        
        run!(ebm) = run!(ebm, 200.) # run for 200 years by default
    end
    end





    CO2_hist(t) = CO2_PI * (1 .+ fractional_increase(t));
    fractional_increase(t) = ((t .- 1850.)/220).^3;

    begin
        CO2_RCP26(t) = CO2_PI * (1 .+ fractional_increase(t) .* min.(1., exp.(-((t .-1850.).-170)/100))) ;
        RCP26 = EBM(T0, 1850., 1., CO2_RCP26)
        run!(RCP26, 2100.)
        
        CO2_RCP85(t) = CO2_PI * (1 .+ fractional_increase(t) .* max.(1., exp.(((t .-1850.).-170)/100)));
        RCP85 = EBM(T0, 1850., 1., CO2_RCP85)
        run!(RCP85, 2100.)
    end

end

ECS(; B=B̅, a=Model.a) = -a*log(2.)./B;

let 
    initial_year = 1850
    final_year = initial_year + 300
    # when is equal to double CO2 amount in initial_year
    ans = findfirst(isapprox(2*Model.CO2_RCP85.(initial_year), atol=6.0), Model.CO2_RCP85(initial_year:final_year)) 
    ans += initial_year
end

findfirst(isequal(3), 1:4)
Model.CO2_RCP85.(1850:2100)
Model.CO2_RCP85.(2048:2049)
isapprox(2*Model.CO2_RCP85.(1850),Model.CO2_RCP85.(2050), atol=6.0) 
1.0≈1.1
isapprox(1e-10, 0, atol=1e-18)




