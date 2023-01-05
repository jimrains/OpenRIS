
function [conf_t1] = mapbits_singletile(confmat)
%% Confmat should be 16 x 16 arrangement of integers 1-4
g = (confmat == 1)*1 + (confmat == 3)*2 + (confmat == 2)*3 + (confmat == 4)*4;
    bt1 = g.';
    for r = 1:16
        for d = 1:16
            conf_t1(d, (2*r-1):2*r) = int2bit(bt1(d,r)-1, 2).';
        end    
    end
    conf_t1 = rot90(rot90(conf_t1));
end

