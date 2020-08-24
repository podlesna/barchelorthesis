function agent = learning(agent, data)
%% Funkce learning
%
% Uceni agenta/poradce.   
%
% agent = learning(agent, data)

%% Popis
%% Vystup 
%       agent = struktura agenta s opravenym V_t a s opravenym modelem obsahujici
%                 V_0 = pocatecni pocet posloupnosti s' -> a -> s, s' je stav, na kterem je zavisly agent
%                V_t  = pole pro vkladani poctu posloupnosti s' -> a -> s 
%               model = predpovidaci model 
%            des_rule = rozhodovaci pravidlo, podle ktereho agent generuje
%            akci a 
%% Vstup: 
%  agent = struktura agent, v niz se ma upravit V_t  
%   data = struktura
%         state                     % pole stavu      [s_{1-memory},s_{1-memory+1},...,s_{1},s_{2} ,...,s_{dur_simulation} ] 
%         pred_state                % pole predpovidanych stavu [s_{1-memory},s_{1-memory+1},...,s_{1},sp_{2},...,sp_{dur_simulation}] 
%         action                    % pole akci                [0 ,a_{1-memory+1},...,a_{1},a_{2} ,...,a_{dur_simulation} ]  

%% Posledni aktualizace:

%% Kod
% 
V_t = agent.V_t;                                                             % aktualni pocet posloupnosti s -> a -> s1
dependence = agent.dependence;                                               % zavislost
s = data.state(data.t -1 - dependence);                                      % predchozi stav, na kterem zavisi agent
a = data.action(data.t);                                                     % aktualni akce 
s1 = data.state(data.t);                                                     % aktualni stav
V_t(s1, a, s) = V_t(s1, a, s) + 1;                                           % aktualizace V_t, obnoveni statistik pro aposteriorni hustotu pravdepodobnosti
agent.V_t = V_t;                                                             % ulozeni aktualizovaneho V_t
agent.model(:,a,s)= (V_t(:, a, s)+agent.V_0(:,a,s))/sum(V_t(:, a, s)+agent.V_0(:, a, s)); % opraveny model 
end