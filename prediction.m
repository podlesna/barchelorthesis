function data = prediction(agent, data, system) 
%% Funkce prediction
%
% Vycisluje a uklada predpoved agenta a predpoved systemu
%
% data = prediction(agent, data) 
%
%% Popis
%% Vystup 
%   data = struktura obsahujici
%         state                     % pole stavu     [s_{1-memory},s_{1-memory+1},...,s_{1},s_{2} ,...,s_{dur_simulation} ] 
%         pred_state                % pole predpovidanych stavu [s_{1-memory},s_{1-memory+1},...,s_{1},sp_{2},...,sp_{dur_simulation}] 
%         pred_sstate               % pole predpovidanych stavu systemu [s_{1-memory},s_{1-memory+1},...,s_{1},sp_{2},...,sp_{dur_simulation}] 
%         action                    % pole akci    [0           ,a_{1-memory+1},...,a_{1},a_{2} ,...,a_{dur_simulation} ]   
%% Vstup: 
%       agent = struktura agenta obsahujici
%               model = predpovidaci model agenta P(s_t | a_t, s_t-1) 
%       data = struktura obsahujici stavy a akci v systemu 
%       system = struktura obsahujici:
%               P_0 = pravdepodobnost prechodu systemu
%% Posledni aktualizace:

%% Kod
% 

model = agent.model;                                                       % predpovidaci model agenta P(s_t | a_t, s_t-1, ..) 
a = data.action(data.t + 1);                                               % aktualni akce
s = data.state(data.t);                                                    % predchozi stav v case t
s1 = data.state(data.t -1);                                                % predchozi stav v case t-1
m = model(:,a,s); 
[v,i] = max(m);                                                            % predpoved agenta podle maxima z pravdepodobnostni tabulky
%i = dnoise(model(:,a,s));                                                 % nahodna predpoved
data.pred_state(data.t + 1) = i;                                           % ulozeni predpovedi

P_0 = system.P_0(:, a, s, s1);                                             % pravdepodobnost prechodu pro cestu s_t-1 -> s_t -> a_t -> s_t+1
[v, k] = max(P_0);                                                         % predpoved systemu podle maxima z pravdepodobnosti prechodu
data.pred_sstate(data.t + 1) = k;                                          % ukladani predpovedi systemu 
end

