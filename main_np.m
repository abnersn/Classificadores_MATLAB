close all; clear; clc;

K_FOLD = 10;
SAMPLES = 50;
FOLD_SIZE = SAMPLES / K_FOLD;

fprintf("> Nearest Prototype\n> K Fold: %d\n", K_FOLD);
fprintf("# Par�metros utilizados:\n - M�dia da Transformada de Fourier do sinal\n - Curtose da Transformada de Fourier do Sinal\n - Erro quadrado m�dio em rela��o � Transformada de Fourier m�dia dos sinais da classe 1\n - Erro quadrado m�dio em rela��o � Transformada de Fourier m�dia dos sinais da classe 2\n");

load('Classe1.mat');
load('Classe2.mat');

erro_global = 0;

classes = [zeros(1, 5); ones(1,5)];

for w = 1:FOLD_SIZE:SAMPLES
    % Separa �ndices de treino e de teste
    indices_teste = w:(w + FOLD_SIZE - 1);
    indices_treino = 1:SAMPLES;
    indices_treino(indices_teste) = [];
    
    % Amostras de teste
    teste_cls_1 = Classe1(:, indices_teste);
    teste_cls_2 = Classe2(:, indices_teste);

    % Amostras de treino
    treino_cls_1 = Classe1(:, indices_treino);
    treino_cls_2 = Classe2(:, indices_treino);

    % Transformadas de Fourier dos sinais da classe 1
    fourier_cls_1 = abs(fftshift(fft(treino_cls_1)));
    fourier_cls_1 = fourier_cls_1(250:280, :);
    fourier_cls_1 = fourier_cls_1 ./ max(fourier_cls_1);

    % Transformada de Fourier dos sinais da classe 2
    fourier_cls_2 = abs(fftshift(fft(treino_cls_2)));
    fourier_cls_2 = fourier_cls_2(250:280, :);
    fourier_cls_2 = fourier_cls_2 ./ max(fourier_cls_2);

    % Vetor global de treino com ambas as classes
    treino = [treino_cls_1 treino_cls_2];
    
    % Vetor global de testes com ambas as classes
    teste = [teste_cls_1 teste_cls_2];
    
    % Observa��o: "Sinais" a seguir referem-se �s transformadas de Fourier
    % das amostras no dom�nio do tempo.
    
    % Calcula a m�dia de cada sinal
    media_sinal = [mean(fourier_cls_1) mean(fourier_cls_2)];
    
    % Calcula a Curtose de cada sinal
    curtose_sinal = [kurtosis(fourier_cls_1) kurtosis(fourier_cls_2)];
    
    % Calcula erro quadrado m�dio de cada sinal em rela��o ao sinal m�dio
    % da classe 1.
    sinal_medio_1 = mean(fourier_cls_1, 2);
    sinal_medio_2 = mean(fourier_cls_2, 2);
    eqm_1 = mean(sqrt([(sinal_medio_1 - fourier_cls_1).^2 (sinal_medio_1 - fourier_cls_2).^2]));
    
    % Calcula erro quadrado m�dio de cada sinal em rela��o ao sinal m�dio
    % da classe 2.
    eqm_2 = mean(sqrt([(sinal_medio_1 - fourier_cls_1).^2 (sinal_medio_1 - fourier_cls_2).^2]));

    % Erro para este ciclo do k-fold
    erro_ciclo = 0;

    for i = 1:5
        amostra_teste_cls_1 = teste_cls_1(:, i);
        amostra_teste_cls_2 = teste_cls_2(:, i);

        teste_fourier_cls_1 = abs(fftshift(fft(amostra_teste_cls_1)));
        teste_fourier_cls_1 = teste_fourier_cls_1(250:280, :);
        teste_fourier_cls_1 = teste_fourier_cls_1./ max(teste_fourier_cls_1);

        teste_fourier_cls_2 = abs(fftshift(fft(amostra_teste_cls_2)));
        teste_fourier_cls_2 = teste_fourier_cls_2(250:280, :);
        teste_fourier_cls_2 = teste_fourier_cls_2./ max(teste_fourier_cls_2);

        teste_media_sinal_cls_1 = mean(teste_fourier_cls_1);
        teste_media_sinal_cls_2 = mean(teste_fourier_cls_2);

        teste_curtose_cls_1 = kurtosis(teste_fourier_cls_1);
        teste_curtose_cls_2 = kurtosis(teste_fourier_cls_2);
        
        % EQM da amostra 1 em rela��o ao sinal m�dio da classe 1
        teste_eqm_11 = mean(sqrt((teste_fourier_cls_1 - sinal_medio_1) .^ 2));
        
        % EQM da amostra 1 em rela��o ao sinal m�dio da classe 2
        teste_eqm_12 = mean(sqrt((teste_fourier_cls_1 - sinal_medio_2) .^ 2));
        
        % EQM da amostra 2 em rela��o ao sinal m�dio da classe 1
        teste_eqm_21 = mean(sqrt((teste_fourier_cls_2 - sinal_medio_1) .^ 2));
        
        % EQM da amostra 2 em rela��o ao sinal m�dio da classe 2
        teste_eqm_22 = mean(sqrt((teste_fourier_cls_2 - sinal_medio_2) .^ 2));
        
        distancias_cls_1 = sqrt((teste_media_sinal_cls_1 - mean(media_sinal))^2 + (teste_curtose_cls_1 - mean(curtose_sinal))^2 + (teste_eqm_11 - mean(eqm_1))^2 + (teste_eqm_12 - mean(eqm_2))^2 );
        distancias_cls_2 = sqrt((teste_media_sinal_cls_2 - mean(media_sinal))^2 + (teste_curtose_cls_2 - mean(curtose_sinal))^2 + (teste_eqm_21 - mean(eqm_1))^2 + (teste_eqm_22 - mean(eqm_2))^2 );
       
        % Resultados
        if distancias_cls_1 < distancias_cls_2
            result = [0; 1];
        else
            result = [1; 0];
        end
              
        % Vetor de checagem de classe
        classe = [classes(i);classes(i+5)];
        
        if ~isequal(classe,result)
            erro_ciclo = erro_ciclo + 1;
        end
        
    end
    
    erro_global = erro_global + erro_ciclo / K_FOLD;
end

fprintf("Taxa de erro global: %.2f\n", erro_global / (FOLD_SIZE * 2) * 100);