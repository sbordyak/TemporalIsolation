classdef TestModel
    properties
        PopA;
        PopB;
        TI;
        TIall;
    end
    methods
        function self = TestModel(pop1, pop2, m, n)
            self.PopA = pop1;
            self.PopB = pop2;
            self.TI = 0;
            self.TIall = zeros(m, n);
        end
        function TemporalIsolation(self, type, cdf_type, pdf_type)
            %% ------------------------------------------------------------------
            % TempIso function
            % Description:
            % Calculates the temporal isolation between 2 populations using
            % the selected method of calculation
            % Implemented methods of calculation include:
            % - Convolution ('conv')
            % - Monte-Carlo ('rng')
            %
            % Inputs:
            % - type, method of finding temporal isolation ('conv' for conv
            % -olution, 'rng' for Monte-Carlo)
            % - cdf_type, method of cdf calculation (see cdf function docum
            % -entation for list of usable strings)
            % - pdf_type, method of pdf calculation (see pdf function docum
            % -entation for list of usable strings)
            %
            % Outputs:
            % - TI, Temporal Isolation calculated value, using Hood 2019
            % equation, room to add other calculation methods
            % - PopA, altered struct/object of population type
            % - PopB, altered struct/object of population type
            %
            % TODO:
            % - Add more calculation types, add way to use other temporal
            % isolation formulas if desired
            %% ------------------------------------------------------------------
            
            timespan = 1:365;
            self.PopA.tissue.distribution = zeros(size(timespan));
            self.PopA.emergence.distribution = zeros(size(timespan));
            self.PopA.lifespan.distribution = zeros(size(timespan));
            self.PopB.tissue.distribution = zeros(size(timespan));
            self.PopB.emergence.distribution = zeros(size(timespan));
            self.PopB.lifespan.distribution = zeros(size(timespan));
            
            tempPDF = makedist(pdf_type, self.PopA.tissue.mean, self.PopA.tissue.std);
            self.PopA.tissue.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, self.PopB.tissue.mean, self.PopB.tissue.std);
            self.PopB.tissue.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, self.PopA.emergence.mean, self.PopA.emergence.std);
            self.PopA.emergence.distribution = pdf(tempPDF, timespan);
            tempPDF = makedist(pdf_type, self.PopB.emergence.mean, self.PopB.emergence.std);
            self.PopB.emergence.distribution = pdf(tempPDF, timespan);
            tempCDF = makedist(cdf_type, self.PopA.lifespan.mean, self.PopA.lifespan.std);
            self.PopA.lifespan.distribution = 1-cdf(tempCDF, timespan);
            tempCDF = makedist(cdf_type, self.PopB.lifespan.mean, self.PopB.lifespan.std);
            self.PopB.lifespan.distribution = 1-cdf(tempCDF, timespan);
            %PopA.tissue.distribution = pdf(pdf_type, timespan, PopA.tissue.mean, PopA.tissue.std);
            %PopB.tissue.distribution = pdf(pdf_type, timespan, PopB.tissue.mean, PopB.tissue.std);
            %PopA.emergence.distribution = pdf(pdf_type, timespan, PopA.emergence.mean, PopA.emergence.std);
            %PopB.emergence.distribution = pdf(pdf_type, timespan, PopB.emergence.mean, PopB.emergence.std);
            %PopA.lifespan.distribution = 1-cdf(cdf_type, timespan, PopA.lifespan.mean, PopA.lifespan.std);
            %PopB.lifespan.distribution = 1-cdf(cdf_type, timespan, PopB.lifespan.mean, PopB.lifespan.std);
            
            if type == 'conv' % Convolution method
                self.PopA.alive = conv(self.PopA.emergence.distribution, self.PopA.lifespan.distribution);
                self.PopA.alive = self.PopA.alive(1:365);
                self.PopB.alive = conv(self.PopB.emergence.distribution, self.PopB.lifespan.distribution);
                self.PopB.alive = self.PopB.alive(1:365);
            elseif type == 'rng' % Random number generation/Monte Carlo method
                birth_PopA = random(self.PopA.emergence.distribution, self.PopA.population, 1);
                death_PopA = birth_PopA + random(self.PopA.lifespan.distribution, self.PopA.population, 1);
                for i = 1:self.PopA.population
                    tmp(i, floor(birth_PopA(i)):ceil(death_PopA(i))) = 1;
                end
                
                self.PopA.alive = sum(tmp);
                
                birth_PopB = random(self.PopB.emergence.distribution, self.PopB.population, 1);
                death_PopB = birth_PopB + random(self.PopB.lifespan.distribution, self.PopB.population, 1);
                for i = 1:self.PopB.population
                    tmp(i, floor(birth_PopB(i)):ceil(death_PopB(i))) = 1;
                end
                
                self.PopB.alive = sum(tmp);
            end
            
            self.TI = 1-sum(self.PopA.alive.*self.PopB.alive)/sqrt(sum(self.PopA.alive.^2)*sum(self.PopB.alive.^2));
        end
        function PopPlot(self)
            %% ------------------------------------------------------------------
            %   PopPlot function
            %   Description:
            %       Plots the overlap chart between 2 populations and gives a 
            %           value for temporal isolation
            %
            %   Inputs:
            %       - PopA, struct/object of population type
            %       - PopB, struct/object of population type
            %       - TI, value for temporal isolation
            %
            %   Outputs:
            %       - Produces a figure
            %% ------------------------------------------------------------------
            
            figure(1)
            plot(1:365,self.PopA.alive,'k',1:365,self.PopB.alive,'r')
            title(sprintf('TI = %.3f, LS mean = %d, LS std = %d',TI,self.PopA.emergence.mean,PopA.emergence.std));
            legend('Population A','Population B')
            xlabel('Julian day');ylabel('Proportion of population alive')
            set(gca,'ylim',[-.005 .05]);
            drawnow
        
        end
        function HeatmapPlot(self)
            %% ------------------------------------------------------------------
            %   PopPlot function
            %   Description:
            %       Plots the set of heatmaps needed between 2 populations
            %
            %   Inputs:
            %       - PopA, struct/object of population type
            %       - PopB, struct/object of population type
            %       - TIall, all values for temporal isolation across a timespan
            %
            %   Outputs:
            %       - Produces figures (heatmaps)
            %
            %   TODO:
            %       - Add and configure heatmaps as necessary, not final version
            %% ------------------------------------------------------------------
            figure(2);
            imagesc(self.PopA.lifespan.mean, self.PopA.lifespan.std, self.TIall);
            colorbar;
            xlabel('Population A lifespan (days)')
            ylabel('Stdev of Population A lifespan (days)')
            title('Temporal Isolation')
            set(gca,'ydir','normal')
            
            %figure(3);
            %imagesc(PopB.lifespan.mean, PopB.lifespan.std, TIall);
            %colorbar;
            %xlabel('Population B lifespan (days)')
            %ylabel('Stdev of Population B lifespan (days)')
            %title('Temporal Isolation')
            %set(gca,'ydir','normal')
            
            figure(4);
            imagesc(self.PopA.emergence.mean, self.PopA.emergence.std, self.TIall);
            colorbar;
            xlabel('Population A emergence');
            ylabel('Stdev of Population A emergence');
            title('Temporal Isolation');
            set(gca, 'ydir', 'normal');
            
            figure(5);
            imagesc(self.PopA.tissue.mean, self.PopA.tissue.std, self.TIall);
            colorbar;
            xlabel('Population A tissue');
            ylabel('stdev of Population A tissue');
            title('Temporal Isolation');
            set(gca, 'ydir', 'normal');
        end
    end
end