classdef Insect < System

properties
    names;
    emergence;
    repro_viability;
    longevity;
    sex_ratio;
    parasite_or_host;
end

methods
    function self = Insect(poh, names_in, emergence_in, longevity_in, sex_ratio_in)
        parasite_or_host = poh;

        if names_in ~= ''
            names = names_in;
        else
            display("Warning: no insect names given");
            names = '';
        end

        if emergence_in ~= 0
            emergence = emergence_in;
            repro_viability = emergence_in + 7;
        else
            display("Warning: no emergence values given");
            emergence = 0;
            repro_viability = 0;
        end

        if longevity_in ~= 0
            longevity = longevity_in;
        else
            display("Warning: no longevity values given");
            longevity = 0;
        end

        if sex_ratio_in ~= 0
            sex_ratio = sex_ratio_in;
        else
            display("Warning: No sex ratio given");
            sex_ratio = 0;
        end

    end

end

end