function plotclass(mu,Sigma)

% PLOTCLASS plots classes as ellipses
%
% plotclass(mu,Sigma)
%
%	mu	= matrix of expectation values
%	Sigma	= 3D array of covariances

color = ['r','g','b','y','m','c','k'];
t=0:pi/100:2*pi;
hold on
for i=1:size(Sigma,3),
  plot(Sigma(1,1,i)*cos(t)+Sigma(1,2,i)*sin(t)+mu(1,i),Sigma(2,1,i)*cos(t)+Sigma(2,2,i)*sin(t)+mu(2,i),color(mod(i-1,7)+1));
end;
hold off
