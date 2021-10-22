function data = generate_state(data,system)
%% Funkce generate_state
%
% Vygeneruje dalsi stav  
%
% data = generate_state(data,system)
%
%% Vystup 
%  data = struktura pro ukladani stavu a akci  s nove ulozenou akci
%         state  = pole na ukladani stavu s nove ulozenym stavem
%         action = pole na ukladani akci
%         t = minuly cas
% 
%% Vstup: 
%  data = struktura pro ukladani stavu a akci  s nove ulozenou akci
%         state  = pole na ukladani stavu 
%         action = pole na ukladani akci s ulozenou minulou akci
%                  ovlivnujici generovany stav
%          t = minuly cas  
%  system = struktura systemu 


%% Posledni aktualizace:

%% Kod
% 
a  = data.action(data.t);                                                   % aktualni akce                                           
s1 = data.state(data.t - 1);                                                % aktualni stav
s2 = data.state(data.t - 2);                                                % predchozi stav
m  = system.P_0(:, a, s1, s2);                                              % pravdepodobnosti prechodu k dalsimu stavu pri aktualnich a, s1, s2
s  = dnoise(m);                                                             % dostanu dalsi stav
data.state(1, data.t) = s;                                                  % ulozim si stav do data.state
end
