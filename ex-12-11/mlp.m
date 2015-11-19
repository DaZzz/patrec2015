function [testclass,t,whidden,woutput]=mlp(traindata,trainclass,testdata)
%
% Two layer multilayer perceptron 
%

% Amount of elements in training set
N=size(traindata,2);

% Amount of coordinates 
d=size(traindata,1);

% Amount of classes
classes=max(trainclass);

% Maximum count of iterations
maxepochs=100000;

% Init sums of squared errors array
J=zeros(1,maxepochs);

% Learning rate
rho=0.0001;

% Number of hidden layer neurons
hidden=3; 

% Init train output with proper values
trainoutput=zeros(classes,N);
for i=1:N,
  trainoutput(trainclass(i),i)=1;
end

% Add new coordinate with value 1
extendedinput=[traindata;ones(1,N)];

% Init weights for hidden layer with random values
whidden=(rand(d+1,hidden)-0.5)/10;

% Init output weights with random values
woutput=(rand(hidden+1,classes)-0.5)/10;

% Init step counter
t=0;
J=inf;
while 1
  
  %%%
  % Feed-forward
  %%%
  % Increase step counter
  t=t+1;
  
  % Calculate output of hidden layer
  vhidden=whidden'*extendedinput;
  
  % Pass values through step-function
  yhidden=tanh(vhidden);
  yhidden=[yhidden;ones(1,N)];
  
  
  % Calculate output 
  voutput=woutput'*yhidden;
  youtput=voutput;
  
  % Calculate squared error sum
  J(t)=0.5*sum(sum((youtput-trainoutput).^2));
  
  % Draw each 100 steps
  if (mod(t,100000)==0)
    semilogy(1:t,J(1:t));
    t
    drawnow;
  end
  
  % Break of no errors
  if (J(t)<1e-12)
    break;
  end;
  
  % Break if end of loop
  if (t>maxepochs) 
    break;
  end
  
  % Break if small change
  if t > 1
      if abs(J(t)-J(t-1)) < 1e-12
       break;
      end
  end
  
  %%%
  % Back propagation
  %%%
  
  % Update delta output
  deltaoutput=(youtput-trainoutput);
   
  % Update delta for hidden layer
  deltahidden=(woutput(1:end-1,:)*deltaoutput).*(1-yhidden(1:end-1,:).^2);
  
  % Update delta for weights hidden
  deltawhidden=-rho*extendedinput*deltahidden';
  
  % Update delta for weights output
  deltawoutput=-rho*yhidden*deltaoutput';
  
  % Set new weights
  woutput=woutput+deltawoutput;
  whidden=whidden+deltawhidden;
end

% Pad input with ones
extendedinput=[testdata;ones(1,size(testdata,2))];

% Calculate output of hidden layer
vhidden=whidden'*extendedinput;
yhidden=tanh(vhidden);

% Pad hidden layer
yhidden=[yhidden;ones(1,N)];

% Calcualate output
voutput=woutput'*yhidden;
youtput=voutput;

% Get result
[tmp,testclass]=max(youtput,[],1);

