clc;
tstart=tic;
contador =0;
x=zeros(3,3)
% for n_dims=1:11
%     parfor perplexity=1:300
%         accuracy1 = Varying_TSNE_predictor_Function(2^n_dims,perplexity+5);
%         contador=contador+1;
%         x(n_dims,perplexity)=accuracy1;
%         
%     end
%     close all;
% end

%% Ahora encontrando la mediana para el mejor valor obtenido
    parfor iterations=1:100
        accuracy1 = Varying_TSNE_predictor_Function(8,212);
        x_best_conf(iterations)=accuracy1;
        close all
    end
%% graficandos
tend= toc(tstart)
% close all
surf(x, 'edgecolor', 'none');
ylabel('2^n features');
xlabel('perplexity');
zlabel('accuracy');

% z = [0.4 0.5 0.45 0.3];
% x=[10 100 1000 10000];
% y=[5 5 5 15]
% plot3(x ,y,z)
% grid on
% axis square
% 
% [xi, yi] = meshgrid(x,y);
% F = scatteredInterpolant(x',y',z');
% zi = F(xi,yi);
% surf(xi,yi,zi, 'EdgeAlpha', 0)
% hold on
% plot3(x, y, z)





