% This is a simple test script to demonstrate all parts of HW #1

close all                                                                               % Close all open windows
clear classes                                                                           % Clear the objects in memory
format compact                                                                          % reduce white space
dbstop if error                                                                         % add dynamic break point

% PROGRAM CONSTANTS
constants.BufferSize          = 882;                                                    % Samples
constants.SamplingRate        = 44100;                                                  % Samples per Second
constants.QueueDuration       = 0.1;                                                    % Seconds - Sets the latency in the objects
constants.TimePerBuffer       = constants.BufferSize / constants.SamplingRate;          % Seconds;
constants.Attack              = .1;                                                    % Attack ramp
constants.Release             = .2;                                                    % Release ramp


% Play the scales

% majorScaleJust=objScale('major',60,'just','C',120);
% playAudio(majorScaleJust,constants);

majorScaleEqual=objScale('major',60,'equal','C',120);
playAudio(majorScaleEqual,constants);

% minorScaleJust=objScale('minor',60,'just','C',120);
% playAudio(minorScaleJust,constants);

minorScaleEqual=objScale('minor',60,'equal','C',120);
playAudio(minorScaleEqual,constants);


% Play the chords
 majorChordJust=objChord('major',60,'just','C',120);
 playAudio(majorChordJust,constants);
% 
% majorChordEqual=objChord('major',60,'equal','C',120);
% playAudio(majorChordEqual,constants);
% 
% minorChordJust=objChord('minor',60,'just','C',120);
% playAudio(majorChordJust,constants);
% 
% minorChordEqual=objChord('minor',60,'equal','C',120);
% playAudio(majorChordEqual,constants);

