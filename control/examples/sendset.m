
%% Process and send configs

%% Given set [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165]
%% Import configs and send them here

%% Write another function to generate set of configurations
%% Given incidence angles in 15 degree steps

port = 13585;

% load configurations from a MAT file
fn = ['confs_tx', num2str(tx_angle), '.mat'];
load(fn);
a = size(loaded_configs);

tx_angle = 120;
phi_rs = 15:15:165;

for i = 1:a(1)
    conf = squeeze(loaded_configs(i, :, :));
    figure(2);imagesc(conf);
    title(['Tx angle = ', num2str(tx_angle), '^\circ'], 'FontSize', 15)

    % Map integer configuration to bits
    c1 = mapbits_singletile(fliplr(conf));
    % Send configuration c1 to tile 1
    while set_config(c1, 1, sock) == 0
        1;
    end

    phi_rs(i)
    x = input([' :: Configuration ', num2str(i)]);
end

