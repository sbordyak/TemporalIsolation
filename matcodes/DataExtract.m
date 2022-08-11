 load ./Hood19DataRaw.mat
QgTmp = table2array(raw_emergence_Qg);
QvTmp = table2array(raw_emergence_Qv);
leaf_QgTmp = table2array(avg_leaf_flush_Qg);
leaf_QvTmp = table2array(avg_leaf_flush_Qv);
Qv_flush = table2array(raw_leaf_flush_Qv);
Qg_flush = table2array(raw_leaf_flush_Qg);
long_QgTmp = table2array(raw_longevity_Qg(:,4));
long_QvTmp = table2array(raw_longevity_Qv(:,4));

interpolation_emergence = zeros(54, 6);
for i = 1:3
    distTmp = [0; QgTmp(QgTmp(:,i)~=0,i); 1];
    timeTmp = [timespan(1)-1; timespan(QgTmp(:,i)~=0); timespan(end)+1];
    interpolation_emergence(:,i) = interp1(timeTmp, distTmp, [timespan(1)-1; timespan; timespan(end)+1], 'pchip');
    distTmp = [0; QvTmp(QvTmp(:,i)~=0,i); 1];
    timeTmp = [timespan(1)-1; timespan(QvTmp(:,i)~=0); timespan(end)+1];
    interpolation_emergence(:,i+3) = interp1(timeTmp, distTmp, [timespan(1)-1; timespan; timespan(end)+1], 'pchip');
end
interpolation_leaf_flush = zeros(54, 2);
distTmp = [0; leaf_QgTmp(leaf_QgTmp(:,1)~=0,1); 1];
timeTmp = [timespan(1)-1; timespan(leaf_QgTmp(:,1)~=0); timespan(end)+1];
interpolation_leaf_flush(:,1) = interp1(timeTmp, distTmp, [timespan(1)-1; timespan; timespan(end)+1], 'pchip');
distTmp = [0; leaf_QvTmp(leaf_QvTmp(:,1)~=0,1); 1];
timeTmp = [timespan(1)-1; timespan(leaf_QvTmp(:,1)~=0); timespan(end)+1];
interpolation_leaf_flush(:,2) = interp1(timeTmp, distTmp, [timespan(1)-1; timespan; timespan(end)+1], 'pchip');

Qg_flush_inter = zeros(54, 18);
for i = 1:18
    distTmp = [0; Qg_flush(Qg_flush(:,i)~=0,i); 1];
    timeTmp = [timespan(1)-1; timespan(Qg_flush(:,i)~=0); timespan(end)+1];
    Qg_flush_inter(:,i) = interp1(timeTmp, distTmp, [timespan(1)-1; timespan; timespan(end)+1], 'pchip');
end
Qv_flush_inter = zeros(54, 24);
for i = 1:24
    distTmp = [0; Qv_flush(Qv_flush(:,i)~=0,i); 1];
    timeTmp = [timespan(1)-1; timespan(Qv_flush(:,i)~=0); timespan(end)+1];
    Qv_flush_inter(:,i) = interp1(timeTmp, distTmp, [timespan(1)-1; timespan; timespan(end)+1], 'pchip');
end

pdf_leaf_flush_Qg = diff(Qg_flush_inter);
pdf_leaf_flush_Qv = diff(Qv_flush_inter);

%% Leaf Flush A calculations (RNG)
a = zeros(18,1);
for i = 1:18
    for j = timespan(1):timespan(end)
        a(i) = a(i) + j*pdf_leaf_flush_Qg(j-62,i);
    end
    a(i) = mean(a(i)/sum(pdf_leaf_flush_Qg(:,i)));
end
leaf_flush_mean_mean_A = mean(a);
leaf_flush_mean_std_A = std(a);
b = zeros(18,1);
for i = 1:18
    for j = timespan(1):timespan(end)
        b(i) = b(i) + (j-a(i)).^2 * pdf_leaf_flush_Qg(j-62,i);
    end
    b(i) = sqrt(b(i));
end
leaf_flush_std_mean_A = mean(b);
leaf_flush_std_std_A = std(b);

%% Leaf Flush B calculations (RNG)
a = zeros(18,1);
for i = 1:18
    for j = timespan(1):timespan(end)
        a(i) = a(i) + j*pdf_leaf_flush_Qv(j-62,i);
    end
    a(i) = mean(a(i)/sum(pdf_leaf_flush_Qv(:,i)));
end
leaf_flush_mean_mean_B = mean(a);
leaf_flush_mean_std_B = std(a);
b = zeros(18,1);
for i = 1:18
    for j = timespan(1):timespan(end)
        b(i) = b(i) + (j-a(i)).^2 * pdf_leaf_flush_Qv(j-62,i);
    end
    b(i) = sqrt(b(i));
end
leaf_flush_std_mean_B = mean(b);
leaf_flush_std_std_B = std(b);
    
pdf_emergence = diff(interpolation_emergence);
pdf_leaf_flush = diff(interpolation_leaf_flush);
pdf_longevity(:,1) = diff(1-long_QgTmp);
pdf_longevity(:,2) = diff(1-long_QvTmp);

%% Emergence Mean calculations
a = [0 0 0 0 0 0];
for i = 1:6
    for j = timespan(1):timespan(end)
        a(i) = a(i) + j*pdf_emergence(j-62,i);
    end
end
PopA.emergence.mean = mean(a(1:3)/sum(pdf_emergence(:,1:3)));
emergence_mean_mean_A = PopA.emergence.mean;
emergence_mean_std_A = std(a(1:3)/sum(pdf_emergence(:,1:3)));
PopB.emergence.mean = mean(a(4:6)/sum(pdf_emergence(:,4:6)));
emergence_mean_mean_B = PopB.emergence.mean;
emergence_mean_std_B = std(a(1:3)/sum(pdf_emergence(:,1:3)));

%% Emergence STD calculations
a = [0 0 0 0 0 0];
for i = 1:3
    for j = timespan(1):timespan(end)
        a(i) = a(i) + (j-PopA.emergence.mean).^2 * pdf_emergence(j-62,i);
        a(i+3) = a(i+3) + (j-PopB.emergence.mean).^2 * pdf_emergence(j-62, i+3);
    end
end
a = sqrt(a);
PopA.emergence.std = mean(a(1:3));
emergence_std_mean_A = PopA.emergence.std;
emergence_std_std_A = std(a(1:3));
PopB.emergence.std = mean(a(4:6));
emergence_std_mean_B = PopB.emergence.std;
emergence_std_std_B = std(a(4:6));

%% Tissue Calculations (Not RNG)
b = [0 0];
for i = 1:2
    for j = timespan(1):timespan(end)
        b(i) = b(i) + j*pdf_leaf_flush(j-62,i);
    end
end
PopA.tissue.mean = mean(b(1)/sum(pdf_emergence(:,1)));
PopB.tissue.mean = mean(b(2)/sum(pdf_emergence(:,2)));

b = [0 0];
for j = timespan(1):timespan(end)
    b(1) = b(1) + (j-PopA.tissue.mean).^2 * pdf_leaf_flush(j-62,1);
    b(2) = b(2) + (j-PopB.tissue.mean).^2 * pdf_leaf_flush(j-62,2);
end
b = sqrt(b);
PopA.tissue.std = b(1);
PopB.tissue.std = b(1);

%% Lifespan calculations (Nor RNG)
c = [0 0];
for i = 1:2
    for j = 1:length(pdf_longevity(:,1))
        c(i) = c(i) + j*pdf_longevity(j,i);
    end
end
PopA.lifespan.mean = mean(c(1)/sum(pdf_emergence(:,1)));
PopB.lifespan.mean = mean(c(2)/sum(pdf_emergence(:,2)));

c = [0 0];
for j = 1:length(pdf_longevity(:,1))
    c(1) = c(1) + (j-PopA.lifespan.mean).^2 * pdf_longevity(j,1);
    c(2) = c(2) + (j-PopB.lifespan.mean).^2 * pdf_longevity(j,2);
end
c = sqrt(c);
PopA.lifespan.std = c(1);
PopB.lifespan.std = c(1);

seed = zeros(1,16);
seed(1) = PopA.emergence.mean;
seed(2) = PopA.emergence.std;
seed(3) = PopA.lifespan.mean;
seed(4) = PopA.lifespan.std;
seed(5) = PopA.tissue.mean;
seed(6) = PopA.tissue.std;
seed(7) = 14;
seed(8) = 2;
seed(9) = PopB.emergence.mean;
seed(10) = PopB.emergence.std;
seed(11) = PopB.lifespan.mean;
seed(12) = PopB.lifespan.std;
seed(13) = PopB.tissue.mean;
seed(14) = PopB.tissue.std;
seed(15) = 14;
seed(16) = 2;