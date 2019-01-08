
% First draft a Synthesizer Object

%classdef objSynthSine < matlab.System
classdef objSynthSine < handle
    properties
        % Defaults
        BufferSize                  = 256;                                  % Size of the buffer of audio samples
        SamplingRate                = 44100;                                % Sampling Rate of the audio
        Attack                      = .1;                                   % Time of the attack period of the waveform
        Release                     = .2;                                   % Time of the release period of the waveform
    end
    properties
        %properties (GetAccess = private)
        % Private members
        currentTime;
        arrayNotes                  = objNote.empty(8,0);
        arraySynths                 = objOscSine(8,0);
        durationPerBuffer
    end
    
    methods
        function obj = objSynthSine(varargin)
            if nargin > 0
                % Add the objects to the input
                obj.currentTime=0;
                
                if nargin >= 5
                    obj.SamplingRate=varargin{5};
                end
                if nargin >= 4
                    obj.BufferSize=varargin{4};
                end
                if nargin >= 3
                    obj.Release=varargin{3};
                end
                if nargin >= 2
                    obj.Attack=varargin{2};
                end
                obj.arrayNotes=varargin{1}.arrayNotes;
            end
            obj.durationPerBuffer=obj.BufferSize/obj.SamplingRate;
            
            for cntNote=1:length(obj.arrayNotes)
                obj.arraySynths(cntNote)=objOscSine(obj.arrayNotes(cntNote),obj.Attack,obj.Release,obj.BufferSize,obj.SamplingRate);
            end
            
        end
        
    end
    %methods (Access = protected)
    %function audioAccumulator = stepImpl(obj)
    
    methods
        function audioAccumulator = advance(obj)
            
            audioAccumulator=[];
            for cntNote = 1:length(obj.arrayNotes)
                
                audio = obj.arraySynths(cntNote).advance;
                %audio = step(obj.arraySynths(cntNote));
                if ~isempty(audio)
                    if isempty(audioAccumulator)
                        audioAccumulator=audio;
                    end
                    audioAccumulator=audioAccumulator+audio;
                end
                
            end
        end
    end
end




