function plotmlp(x0,y0,whidden,woutput)
%
% example:
%   
%   plotmlp(0:10,0:10,whidden,woutput);

testdata=zeros(2,length(x0)*length(y0));
for x=1:length(x0),
  for y=1:length(y0),
    testdata(1,x*length(y0)+y)=x0(x);
    testdata(2,x*length(y0)+y)=y0(y);
  end;
end;

extendedinput=[testdata;ones(1,size(testdata,2))];

vhidden=whidden'*extendedinput;
yhidden=tanh(vhidden);

yhidden=[yhidden;ones(1,size(yhidden,2))];

voutput=woutput'*yhidden;
youtput=voutput;

[tmp,testclass]=max(youtput,[],1);

figure;
hold on;

for x=1:length(x0),
  for y=1:length(y0),
    if (testclass(x*length(y0)+y)==1)
      plot(x0(x),y0(y),'r.');
    else
      plot(x0(x),y0(y),'b.');
    end;
  end;
end;
