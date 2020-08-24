function agent = merging(agent, adviser, data, v)
%% Funkce merging
%
% Slucuje data agenta a poradce. Odpovida teorii v sekci 2.2 
%
% agent = merging(agent, adviser, data, v)
%% Popis
%% Vystup 
%       agent = struktura agenta s V_t opravenym dle advisera obsahujici
%               V_0 = pocatecni pocet posloupnosti s' -> a -> s, s' je stav, na kterem je zavisly agent
%               V_t  = pole pro vkladani poctu posloupnosti s' -> a -> s 
%               model = predpovidaci model 
%            des_rule = rozhodovaci pravidlo, podle ktereho agent generuje
%            akci a 
%% Vstup: 
%     agent = struktura agent, ktera se ma opravit
%   adviser = struktura poradce, formalne shodna s agentem, ale operujici na jinem V_t 
%      data = struktura pro ukladani stavu, akci a predpovedi   
%         v = vaha duvery agenta k poradci
%% Posledni aktualizace:

%% Kod
% 
%

model = adviser.model;                                                             % predpovidaci model poradce
V_t = agent.V_t;                                                                   % pocet posloupnosti s-> a -> s1 agenta
a = data.action(data.t + 1);                                                       % aktualni akce
s = data.state(data.t);                                                            % predchozi stav
s1 = data.state(data.t-adviser.dependence);  
model(:, a, s1) = (adviser.V_t(:, a, s1) + adviser.V_0(:,a,s1))/sum(adviser.V_t(:, a, s1) + adviser.V_0(:, a, s1));   %obnoveni modelu poradce: pocet cest deleny poctem pozorovane cetnosti cest 
V_t(:, a, s) = V_t(:, a, s) + v*model(:, a, s1);                                    % aktualizace V_t agenta pomoci modelu poradce

agent.V_t = V_t;                                                                    % ukladani noveho V_t agenta
agent.model(:,a,s)= (V_t(:, a, s) + agent.V_0(:, a, s))/sum(V_t(:, a, s) + agent.V_0(:, a, s)); % oprava modelu agenta na zaklade noveho V_t



end