function [testclass]=mlpClassify(testdata,whidden,woutput,actFun)
% mlpClassify NN classification.
%   testdata   - testing samples (each column is a sample).
%   actFun     - activation function to be used ('tanh'/'ReLU').
%   whidden    - weights for a hidden layer.
%   woutput    - weights for an output layer.
%   testclass  - resulting testing labels (row-vector).

%==== Testing data classification ====%

N = size(testdata, 2); % Number of testing samples.

% Preparing extended input data.
extendedinput=[testdata;ones(1,size(testdata,2))];

% Feedforward routine.
[~, youtput] = feedForward();

% Retrieving class labels from NN outputs.
[~,testclass]=max(youtput,[],1);



% Helper function.
function [eyhidden, youtput] = feedForward()
    hidNum = length(whidden);
    
    % Hidden layers activation.
    vhidden = cell(hidNum, 1);
    yhidden = cell(hidNum, 1);
    eyhidden = cell(hidNum, 1);
    vhidden{1} = whidden{1}'*extendedinput;
    yhidden{1}=actFun(vhidden{1});
    eyhidden{1}=[yhidden{1};ones(1,N)];
    if(hidNum > 1)
        for hh = 2:hidNum
          vhidden{hh} = whidden{hh}'*eyhidden{hh-1};
          yhidden{hh} = actFun(vhidden{hh});
          eyhidden{hh} = [yhidden{hh};ones(1,N)];
        end
    end

    % Getting output values for all the training samples.
    voutput=woutput'*eyhidden{hidNum};
    youtput=voutput;
end

end