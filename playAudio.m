function out=playAudio(notes,oscParams,constants)

% Instantiate Objects
Generator = objSynth(notes,oscParams,constants);
%Speaker = dsp.AudioPlayer('QueueDuration',constants.QueueDuration,'BufferSizeSource','Property','BufferSize',constants.BufferSize);
Speaker = audioDeviceWriter('SampleRate',constants.SamplingRate,'BufferSize',constants.BufferSize);

audio=zeros(1,constants.BufferSize);
pause(1)                                                % Allow soundcard time to start up

%audio = step(Generator);
audio = Generator.advance;
out=[audio];
while ~isempty(audio)
    step (Speaker, audio);
    
    %audio = step(Generator);
    audio = Generator.advance;
    out=[out;audio];
end

