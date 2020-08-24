function data = generate_action(agent, data)
%% Funkce generate_action
%
% Vygeneruje dalsi akci  
%
% data = generate_action(agent, data)
%% Vystup 
%  data = struktura pro ukladani stavu a akci  s nove ulozenou akci
%         state  = pole na ukladani stavu
%         action = pole na ukladani akci s nove ulozenou akci
%              t = minuly cas
%      
%% Vstup: 
%  agent = struktura popisujici agenta generujiciho akci 
%            des_rule = rozhodovaci pravidlo, podle ktereho agent generuje akci a 
%  data = struktura pro ukladani stavu a akci
%         state  = pole na ukladani stavu
%         action = pole na ukladani akci 
%              t = minuly cas          

%% Posledni aktualizace:

%% Kod
%
s1 = data.state(data.t);                                                   % aktualni stav
des_rule = agent.des_rule;                                                 % rozhodovaci pravidlo 
m = des_rule(:,s1);                                                        % rozhodovaci pravidlo pro aktualni stav
a1 = dnoise(m);                                                            % dalsi akce vybrana pomoci rozhodovaciho pravidla v aktualnim stavu
data.action(data.t +1) = a1;                                               % ulozim akci do data.action 
end
