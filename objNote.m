% First draft a Note Object

classdef objNote
    properties
        % Must be provided
        noteNumber                                                          % Note number in MIDI in string
        temperament                                                         % just or equal
        key                                                                 % Required for Just temperament
        startTime                                                           % Start of the NOte
        endTime                                                             % End time stamp of the note
        
        % Calculated
        frequency                                                           % Derived from note and temperament
        octave                                                              % Derived from noteNumber
        noteName                                                            % Derived from note Number
    end
    
    properties (Constant = true, GetAccess = private)
        % Constants
        refFreq           = 440       % Reference to 440 Hz
        refNote           = 69        % Reference for A==440;
        noteNameList      = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B';
                            'C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B'};  % First row is for sharp keys, second for flat keys
    end
    methods
        function obj = objNote(noteNumber,temperament,key,startTime,endTime)
            if nargin >= 5
                % Only create a non-empty object if the number of inputs is
                % correct
                
                obj.noteNumber=noteNumber;
                obj.key=key;
                obj.startTime=startTime;
                obj.endTime=endTime;
                
                switch temperament
                    case {'just','Just','JUST','j','J'}
                        obj.temperament='just';
                        
                    case {'equal','Equal','EQUAL','e','E'}
                        obj.temperament='equal';
                        % MIDI 69 = 440Hz
                        % Compute the offset from 440 Hz
                        freqDiff=obj.noteNumber-69;
                        obj.frequency=obj.refFreq.*2.^(freqDiff/12);
                        obj.octave=floor(noteNumber/12)-1;
                        
                        noteOffset=rem(noteNumber,12)+1;
                        switch obj.key
                            case {'C','G','D','A','E','B','F#','C#',}
                                obj.noteName=[obj.noteNameList{1,noteOffset} num2str(obj.octave)];
                            case {'F','Bb','Eb','Ab','Db','Gb','Cb','Fb'}
                                obj.noteName=[obj.noteNameList{2,noteOffset} num2str(obj.octave)];
                            otherwise
                                error ('invalid key');
                        end
                    otherwise
                        error('invalid temperament')
                end
            end
        end
    end
end
