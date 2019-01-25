% Synthesize single note

%classdef objSynthSineNote < matlab.System
classdef objOsc < handle
    properties
        % Defaults
        oscConfig                   = confOsc;
        constants                   = confConstants;
    end
    %properties (GetAccess = private)
    properties
        % Private members
        currentTime;
        note                  = objNote;
        EnvGen                = objEnv;
    end
    
    methods
        function obj = objOsc(varargin)
            if nargin > 0
                obj.currentTime=0;
                
                if nargin >= 3
                    obj.constants=varargin{3};
                end
                if nargin >= 2
                    obj.oscConfig=varargin{2};
                end
                obj.note=varargin{1};
            end
            
            obj.EnvGen=objEnv(obj.note.startTime,obj.note.endTime,obj.oscConfig.oscAmpEnv.AttackTime,...
                obj.oscConfig.oscAmpEnv.DecayTime,obj.oscConfig.oscAmpEnv.SustainLevel,obj.oscConfig.oscAmpEnv.ReleaseTime,...
                obj.constants);
            
        end
        
    end
    
    %methods (Access = protected)
    %function audio = stepImpl(~)
    methods
        function audio = advance(obj)
            
            obj.EnvGen.StartPoint=obj.note.startTime;   % set the end point again in case it has changed
            obj.EnvGen.ReleasePoint=obj.note.endTime;   % set the end point again in case it has changed
            
            timeVec=(obj.currentTime+(0:(1/obj.constants.SamplingRate):((obj.constants.BufferSize-1)/obj.constants.SamplingRate))).';
            noteTime=timeVec-obj.note.startTime;
            
            mask = obj.EnvGen.advance;
            if isempty(mask)
                audio=[];
            else
                if all (mask == 0)
                    audio = zeros(1,obj.constants.BufferSize).';
                else
                    audio=obj.note.amplitude.*mask(:).*sin(2*pi*obj.note.frequency*timeVec);
                end
            end
            obj.currentTime=obj.currentTime+(obj.constants.BufferSize/obj.constants.SamplingRate);      % Advance the internal time
        end
    end
end




