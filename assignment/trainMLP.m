function [trainedMLP,t,whidden,woutput]=trainMLP(traindata,trainclass,...
    hidLayerSz,actFunType)
% MLP NN classification.
%   traindata  - training samples (each column is a sample).
%   trainclass - training labels (row-vector).
%   testdata   - testing samples (each column is a sample).
%   hidLayerSz - sizes of hidden layers in NN (length = number of layers).
%   actFun     - type of activation function to be used ('tanh'/'ReLU').
%   testclass  - resulting testing labels (row-vector).
%   t          - number of training epochs used.
%   whidden    - weights for a hidden layer.
%   woutput    - weights for an output layer.

%==== Preparation steps ====%

plotIterPeriod = 2000; % Number of epochs between plotting.
                       % (Too small = slow computations.)

% Data parameters.
N=size(traindata,2); % Number of training samples.
d=size(traindata,1); % Data dimensionality.
classes=max(trainclass); % Class number.
hidNum = length(hidLayerSz); % Number of hidden layers.

maxepochs=40000; % Epoch limit.

% Error function values (SSE).
J=zeros(1,maxepochs);

% Training rate.
rho=0.1/N;
%rho=0.0001;

% Generating outputs of NN for each sample.
trainoutput=zeros(classes,N);
for i=1:N,
    % One class-one neuron encoding (each output neuron represents one
    % class.
  trainoutput(trainclass(i),i)=1;
end

% Generating extended input samples.
extendedinput=[traindata;ones(1,N)];

% Function for initializing layer weights.
initLayerW = @(prvSz, nxtSz) ((rand(prvSz+1,nxtSz)-0.5)*2*0.3);

% Random initialization of weights.
whidden = cell(hidNum, 1);
whidden{1} = initLayerW(d,hidLayerSz(1));
if(hidNum > 1)
    for h = 2:hidNum
        whidden{h} = initLayerW(hidLayerSz(h-1), hidLayerSz(h));
    end
end

% Random initialization of output weights.
woutput=initLayerW(hidLayerSz(hidNum),classes);

% Selection of the activation function.
switch actFunType
    case 'ReLU'
        actFun = @(inp)max(0,inp);
        actFunDer = @(act)(act > 0);
    otherwise % including 'tanh'
        actFun = @(inp)tanh(inp);
        actFunDer = @(act)(1 - act.^2);
end

%==== Training of the NN ====%

t=0; % Iteration counter.

while 1 % Termintaion of the training algorithm is below.
  t=t+1; % Iteration counter.
  
  %-- Feedforward --%
  
  % Feedforward routine.
  [eyhidden, youtput] = feedForward();
  
  % Calculating error function value (SSE).
  J(t)=0.5*sum(sum((youtput-trainoutput).^2));

  % Output current results.
  if (mod(t,plotIterPeriod)==0)
    % Update plot of error-function. Semilogarithmic graph (log by y axe).
    semilogy(1:t,J(1:t)); 
    
    % Print iteration number.
    iterStr = sprintf('Iteration %d', t);
    disp(iterStr);
    
    % Command to immediately update figures.
    drawnow;
  end
  
  %-- Training termination --%
  
  % Stopping by error-function value.
  if (J(t)<1e-12)
    break;
  end;
  
  % Stopping by iterations passed.
  if (t>maxepochs) 
    break;
  end
  
  % Stopping by change in the error function.
  if t > 1
      if abs(J(t)-J(t-1)) < 1e-12
       break;
      end
  end

  %-- Backpropogation --%
  
  % Output error.
  deltaoutput=(youtput-trainoutput);
  
  % Hidden neurons error.
  deltahidden = cell(hidNum, 1);
  deltahidden{hidNum} = (woutput(1:end-1,:)*deltaoutput).*...
      actFunDer(eyhidden{hidNum}(1:end-1,:));
  if(hidNum > 1)
      for h = (hidNum-1):-1:1
          deltahidden{h} = (whidden{h+1}(1:end-1,:)*deltahidden{h+1}).*...
              actFunDer(eyhidden{h}(1:end-1,:));
      end
  end

  % Computing and applying weight changes.
  deltawhidden = cell(hidNum, 1);
  deltawhidden{1}=-rho*extendedinput*deltahidden{1}';
  if(hidNum > 1)
      for h = 2:hidNum
          deltawhidden{h}=-rho*eyhidden{h-1}*deltahidden{h}';
      end
  end
  deltawoutput = -rho*eyhidden{hidNum}*deltaoutput';
  for h = 1:hidNum
      whidden{h}=whidden{h}+deltawhidden{h};
  end
  woutput=woutput+deltawoutput;
end


% Classifyer.
trainedMLP = @(testdata)mlpClassify(testdata,whidden,woutput,actFun);

%==== Helper function ====%

% Helper function.
function [eyhidden, youtput] = feedForward()
    
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