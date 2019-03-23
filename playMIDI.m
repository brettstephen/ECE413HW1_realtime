midi = fread(fopen('ROW.mid'));
header_chunk = midi(1:4);
header_length = midi(5:8);
if header_length(4) == 6
    file_format = midi(10);
    num_tracks = midi(12);
    ppqn = midi(13)*16 + midi(14);
end

cand_track_ends = find(midi==255); % split into tracks
track_ends = cand_track_ends(midi(cand_track_ends+1)==47) + 2;
track_starts = [15;track_ends(1:end-1)+1];
% make sure to start track at 4D or 77
for ii = 1:num_tracks
    track = dec2hex(midi(track_starts(ii):track_ends(ii)));
    track_chunk = track(1:4);
    track_length = track(5:8);
    
    mm = find((1:length(track)).'>8 & hex2dec(track)>127);
    jj = mm(1);
    
    while jj < length(track)
        % handle meta-events (from 'Standard MIDI Files 1.0')
        switch track(jj,:)
            case 'FF'
                switch track(jj+1,:)
                    case '2F'

                    case '51' % set tempo
                        ppqn = hex2dec(strcat(track(jj+3,:),track(jj+4,:),track(jj+5,:)));
                    case '54' 
                        
                    case '58' % set time signature
                        nn = hex2dec(track(jj+3,:)); % numerator of time signature
                        dd = 2^hex2dec(track(jj+4,:)); % denominator of time signature
                        cc = hex2dec(track(jj+5,:)); % MIDI clicks per beat
                        bb = hex2dec(track(jj+6,:)); % 32nd notes per 1/4 note beat
                    case '59'

                    otherwise

                end
            
            case dec2hex(9*16:9*16+15) % note on
                channel = hex2dec(track(jj,2)) + 1;
                note = hex2dec(track(jj+1,:));
                freq = 440*2^((note-69)/12);
                velocity = hex2dec(track(jj+2,:));
                %delta_time = 
            case dec2hex(8*16:8*16+15) % note off
                
            case dec2hex(12*16:12*16+15) % patch change
                
            
        end
        
    end
end