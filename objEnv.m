% Synthesize single note

%classdef objSynthSineNote < matlab.System
classdef objEnv < handle
    properties
        % Defaults
        envParams                              = confEnv;
        constants                              = confConstants;
    end
    %properties (GetAccess = private)
    properties
        % Private members
        StartPoint;
        ReleasePoint;
        currentTime;
        durationPerBuffer;
        attackInd
        releaseInd
        attackMaxInd
        decayMaxInd
        releaseMaxInd
        attackDecayWaveform
        releaseWaveform
    end
    
    methods
        function obj = objEnv(varargin)
            if nargin > 0
                obj.currentTime=0;
                
                
                if nargin >= 7
                    obj.constants=varargin{7};
                end
                if nargin >= 6
                    obj.envParams.ReleaseTime=varargin{6};
                end
                if nargin >= 5
                    obj.envParams.SustainLevel=varargin{5};
                end
                if nargin >= 4
                    obj.envParams.DecayTime=varargin{4};
                end
                if nargin >= 3
                    obj.envParams.AttackTime=varargin{3};
                end
                if nargin >= 2
                    obj.envParams.ReleasePoint=varargin{2};
                end
                if nargin >=1
                    obj.envParams.StartPoint=varargin{1};
                end
                
            end
            obj.durationPerBuffer=obj.constants.BufferSize/obj.constants.SamplingRate;
            
            obj.attackInd=1;                        %Intialize indices for cases when buffer wraps
            obj.releaseInd=1;
            
            obj.attackMaxInd=ceil(obj.envParams.AttackTime.*obj.constants.SamplingRate);
            obj.decayMaxInd=ceil(obj.envParams.DecayTime.*obj.constants.SamplingRate);
            obj.releaseMaxInd=ceil(obj.envParams.ReleaseTime.*obj.constants.SamplingRate);
            
            obj.attackDecayWaveform=[linspace(0,1,obj.attackMaxInd),linspace(1,obj.envParams.SustainLevel,obj.decayMaxInd)];
            obj.releaseWaveform=linspace(obj.envParams.SustainLevel,0,obj.releaseMaxInd);
            
        end
        
    end
    
    %methods (Access = protected)
    %function audio = stepImpl(~)
    methods
        function env = advance(obj)
            
            timeVec=(obj.currentTime+(0:(1/obj.constants.SamplingRate):((obj.constants.BufferSize-1)/obj.constants.SamplingRate))).';
            indVec=1:length(timeVec);
            
            
            if all (timeVec < obj.StartPoint) % Note has not begun yet
                env=zeros(1,length(indVec));
                minLen=0;
            elseif all (timeVec < obj.ReleasePoint) % Note is still on
                if all(timeVec < (obj.envParams.AttackTime+obj.envParams.DecayTime))
                    % Fill from the buffer for the early part of the envelope
                    
                    startInd=min(find(timeVec >= obj.StartPoint));
                    minLen=obj.constants.BufferSize-startInd+1;
                    
                    env=[zeros(1,(startInd-1)) obj.attackDecayWaveform(obj.attackInd+(0:(minLen-1)))];
                    
                    obj.attackInd=obj.attackInd+minLen;
                elseif any(timeVec < (obj.envParams.AttackTime+obj.envParams.DecayTime))
                    % Fill from the transistion into the sustain portion
                    minLen=min(obj.constants.BufferSize,length(obj.attackDecayWaveform)-obj.attackInd);
                    env=[obj.attackDecayWaveform(obj.attackInd+(0:(minLen-1))) repmat(obj.envParams.SustainLevel,1,obj.constants.BufferSize-minLen)];
                    obj.attackInd=obj.attackInd+minLen;
                else
                    % Fill during the sustain portion
                    env=repmat(obj.envParams.SustainLevel,1,obj.constants.BufferSize);
                end
            elseif any(timeVec < obj.ReleasePoint)
                % end sustain and begin release
                releaseInd=max(timeVec < obj.ReleasePoint);
                minLen=min(BufferSize,length(obj.releaseWaveform)-obj.releaseInd);
                env=[repmat(obj.sustainLevel,1,releaseInd) obj.releaseWaveform(obj.releaseInd+(0:minLen))];
                obj.releaseInd=obj.releaseInd+minLen;
            elseif any(timeVec < (obj.ReleasePoint + obj.envParams.ReleaseTime))
                % finish release
                minLen=min(obj.releaseInd+obj.constants.BufferSize-1,length(obj.releaseWaveform)-obj.releaseInd);
                env=[obj.releaseWaveform(obj.releaseInd+(0:(minLen-1))) zeros(1,obj.constants.BufferSize-minLen)];
                obj.releaseInd=obj.releaseInd+minLen;
            else % time vec is past end of note
                env=[];
            end
            
            
            
            
            obj.currentTime=obj.currentTime+(obj.constants.BufferSize/obj.constants.SamplingRate);      % Advance the internal time
        end
    end
end



