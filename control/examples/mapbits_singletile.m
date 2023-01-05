%% To do
 % Get flip correct
 % Want imagesc to reflect precisely what's going on
 % Set up horizontal and vertical imagesc

 function [conf_t1] = mapbits_singletile(confmat)
%% Confmat should be 16 x 32 arrangement of integers 1-4
    %bt1 = confmat(:,1:16).';
    g = (confmat == 1)*1 + (confmat == 3)*2 + (confmat == 2)*3 + (confmat == 4)*4;
    bt1 = g.';
    %bt2 = confmat(:,17:32);
    %bt2(16,15);
    for r = 1:16
        for d = 1:16
            conf_t1(d, (2*r-1):2*r) = int2bit(bt1(d,r)-1, 2).';
     %       conf_t2(d, (2*r-1):2*r) = int2bit(bt2(d,r)-1, 2).';
        end    
    end
    % Accomodate 2 tiles orientated such that the 
    % power supply socket is on the top
    conf_t1 = rot90(rot90(conf_t1));
    %conf_t1 = rot90(conf_t1);
    %conf_t2 = rot90(rot90(conf_t2));
end

