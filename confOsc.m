% Synthesize single note

%classdef objSynthSineNote < matlab.System
classdef confOsc < handle
    properties
        % Defaults
        oscType                  = 'sine';
        oscAmpEnv                = confEnv;
        oscFreqEnv               = confEnv;
    end
    %properties (GetAccess = private)
    
    methods
        function obj = confOsc(varargin)
            if nargin > 0
                obj.currentTime=0;

                if nargin >= 3
                    obj.oscFreqEnv=varargin{3};
                end
                if nargin >= 2
                    obj.oscAmpEnv=varargin{2};
                end
                if nargin >=1
                    obj.oscType=varargin{1};
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



