
% First draft a Synthesizer Object

%classdef objSynthSine < matlab.System
classdef objSynthSine < handle
    properties
        % Defaults                              
        oscConfig                   = confOsc;                               
        constants                   = confConstants;
    end
    properties
        %properties (GetAccess = private)
        % Private members
        currentTime;
        arrayNotes                  = objNote.empty(8,0);
        arraySynths                 = objOscSine.empty(8,0);
    end
    
    methods
        function obj = objSynthSine(varargin)
            if nargin > 0
                % Add the objects to the input
                obj.currentTime=0;

                if nargin >= 3
                    obj.constants=varargin{3};
                end
                if nargin >= 2
                    obj.oscConfig=varargin{2};
                end
                obj.arrayNotes=varargin{1}.arrayNotes;
            end
            
            for cntNote=1:length(obj.arrayNotes)
                obj.arraySynths(cntNote)=objOscSine(obj.arrayNotes(cntNote),obj.oscConfig,obj.constants);
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




