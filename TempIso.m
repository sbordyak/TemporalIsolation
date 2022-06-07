function [TI, PopA, PopB] = TempIso(type, cdf_type, pdf_type, PopA, PopB)

    timespan = 1:365;
    PopA.tissue.distribution = zeros(size(timespan));
    PopA.emergence.distribution = zeros(size(timespan));
    PopA.lifespan.distribution = zeros(size(timespan));
    PopB.tissue.distribution = zeros(size(timespan));
    PopB.emergence.distribution = zeros(size(timespan));
    PopB.lifespan.distribution = zeros(size(timespan));

    PopA.tissue.distribution = pdf(pdf_type, timespan, PopA.tissue.mean, PopA.tissue.std);
    PopB.tissue.distribution = pdf(pdf_type, timespan, PopB.tissue.mean, PopB.tissue.std);
    PopA.emergence.distribution = pdf(pdf_type, timespan, PopA.emergence.mean, PopA.emergence.std);
    PopB.emergence.distribution = pdf(pdf_type, timespan, PopB.emergence.mean, PopB.emergence.std);
    PopA.lifespan.distribution = cdf(cdf_type, timespan, PopA.lifespan.mean, PopA.lifespan.std);
    PopB.lifespan.distribution = cdf(cdf_type, timespan, PopB.lifespan.mean, PopB.lifespan.std);

    if type == 'conv'
        PopA.alive = conv(PopA.emergence.distribution, PopA.lifespan.distribution);
        PopA.alive = PopA.alive(1:365);
        PopB.alive = conv(PopB.emergence.distribution, PopB.lifespan.distribution);
        PopB.alive = PopB.alive(1:365);
    end

    TI = 1-sum(PopA.alive.*PopB.alive)/sqrt(sum(PopA.alive.^2)*sum(PopB.alive.^2));
end