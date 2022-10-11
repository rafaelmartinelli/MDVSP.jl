struct Pricing
    data::Data
    routes::Vector{Vector{Route}}
    red_cost::Float64

    function Pricing(data::Data)
        return new(data, Vector{Vector{Route}}(), 0.0)
    end
end

function solve!(pricing::Pricing)

end
