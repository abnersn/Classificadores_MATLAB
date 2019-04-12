function [ result ] = arvore( eqm_1, eqm_2, media, curtose )
%ARVORE Implementa árvore de decisão para os 4 critérios escolhidos.

    if curtose > 0.2
        if media < 0.2
            if eqm_2 > 0.15
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            else
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            end
        else
            
            if eqm_2 > 0.15
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            else
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            end
        end
    else
        if media < 0.2
            if eqm_2 > 0.15
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            else
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            end
        else
            
            if eqm_2 > 0.15
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            else
                if eqm_1 < 0.15
                    result = 0;
                else
                    result = 1;
                end
            end
        end
    end

end

