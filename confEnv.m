% Synthesize single note

%classdef objSynthSineNote < matlab.System
classdef confEnv < handle
    properties
        % Defaults
        StartPoint                                  = 0;
        ReleasePoint                                = Inf   % Time to release the note 
        AttackTime                                  = .01;  %Attack time in seconds
        DecayTime                                   = .05;  %Decay time in seconds
        SustainLevel                                = 0.7;  % Sustain level (1 being max)
        ReleaseTime                                 = .03;  % Time to release from sustain to zero
    end
    %properties (GetAccess = private)
    
    methods
        function obj = confEnv(varargin)
            if nargin > 0
                obj.currentTime=0;
                
                if nargin >= 6
                    obj.ReleaseTime=varargin{6};
                end
                if nargin >= 5
                    obj.SustainLevel=varargin{5};
                end
                if nargin >= 4
                    obj.DecayTime=varargin{4};
                end
                if nargin >= 3
                    obj.AttackTime=varargin{3};
                end
                if nargin >= 2
                    obj.ReleasePoint=varargin{2};
                end
                if nargin >=1
                    obj.StartPoint=varargin{1};
                end
                
            end

        end
        
    end
    
    %methods (Access = protected)
    %function audio = stepImpl(~)
    methods
        function env = advance(obj)
            
        end
    end
end



