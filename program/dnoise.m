function e=dnoise(pr)
%% Function dnoise
%
% simulates discrete-valued noise according to given probabilities
%
%% Category: simulation 
%% Description
%   e = dnoise(pr)
%
% e  = generated, integer-valued noise 
% pr = row vector of probabilities pr(i) = Probability( e = i), i=1,...,length of Pr
%                    
%% Tests and examples
% Open the test script in Editor <matlab:open('dnoisete') here>.
% View the test script description with results 
% <matlab:web(strcat('file:///',which('dnoisete.html')),'-helpbrowser')
% here>.

%% Theory
%  
%% See also
%
%% Update history
% August 2013 MK
%% To be done
%  
%% CODE STARTS HERE
% 
if any(pr < 0), error('Probabilities must be non-negative'), end
% Convert probabilites into distribution function
le = length(pr);                               % the number of modelled levels       
pr = cumsum(pr);                               % distribution function
pr = pr/pr(le);                                % normalisation of the distribution function
% generate noise sample
ru = rand;                                     % uniformly generate random number from (0,1)     
for i = 1:le
    if ru < pr(i), e = i; break; end
end
end
