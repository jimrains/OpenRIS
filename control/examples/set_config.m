%% On Pi side, run: ~/USCRIS/control/socket-server.py
%% On PC side, run: sock = tcpclient("192.168.4.1", 13585)

%% conf_mat = configuration matrix of dimensions 32 x 16
%% tile_number = tile number ## Need to add documentation on how this translates
%% sock = socket set up via tcpclient("<ip_address>", <port_number>)  e.g. tcpclient("192.168.4.1", 13567)

function success = set_config(conf_mat, tile_number, sock)

    g = mat2str(conf_mat);
    data = g(2:end-1); 
    data = strcat(sprintf('%02d', tile_number), data);
    write(sock, data);
    pause(0.01)
    % Wait until Pi is ready for more data
    rec = read(sock);
    to = 1;
    % While acknowledgement is not received, start countdown to timeout
    while (length(rec) == 0)
        rec = read(sock);
        to = to + 1;
        if to == 1000
            to = 1
            rec = 98;
            break;
        end
    end
    if rec == 97
        success = 1;
    end
    if rec == 98
        success = 0;
    end
end