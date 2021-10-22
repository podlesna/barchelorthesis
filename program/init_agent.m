function agent = init_agent(num_state, num_action, dependence, dur_simulace, degrees_of_freedom) 
%% Funkce init_agent
%
% Vytvori strukturu agent/poradce 
%
%  agent = init_agent(num_state, num_action, dependence, dur_simulace, degrees_of_freedom)
%  agent = init_agent(num_state, num_action, dependence, dur_simulace) 5
%% Vystup
%       agent = struktura agenta obsahujici
%                 V_0 = pocatecni pocet posloupnosti s' -> a -> s, s' je stav, na kterem je zavisly agent
%                V_t  = pole pro vkladani poctu posloupnosti s' -> a -> s
%               model = predpovidaci model 
%            des_rule = rozhodovaci pravidlo, podle ktereho agent generuje akci a 
%% Vstupy
%        num_state    = pocet stavu
%        num_action   = pocet akci 
%        dependence   = zavislost agenta na stavu 
%        dur_simulace = delka simulace 
% degrees_of_freedom  = pocet myslenych pozorovani tvoricich statistiku V_0

%% Posledni aktualizace:
% autor     =  YP
% upraveno  =  28.4.20 YP
%              15.5.20 MK
% teorie    =  Bc prace YP
% poznamky  =  pole na predikci presunuto do struktury data

%% Kod
% 
if nargin < 5, degrees_of_freedom = 5; end
% V_0 = randi([0,5],num_state, num_action, num_state);                       % vygeneruje pocatecni pocty probehlych posloupnosti s'-> a -> s
      V_0 = degrees_of_freedom*rand([num_state, num_action, num_state]);    % vygeneruje pocatecni pocty probehlych posloupnosti s'-> a -> s
       %V_0 = zeros(num_state, num_action, num_state); 
       V_t = zeros(num_state, num_action, num_state);                        % pripravi pole pro vkladani dalsich posloupnosti s' -> a -> s
     model = V_0/num_state/degrees_of_freedom;                               % vytvori pocatecni predpovidajici model
  des_rule = ones(num_action, num_state)/num_action;                         % vytvori rozhodovaci pravidlo 
%% Struktura agent
agent = struct('V_0',V_0,'V_t',V_t,'model',model,'num_state',num_state,'num_action',num_action,'des_rule',des_rule,'dependence',dependence,...
               'degrees_of_freedom',degrees_of_freedom);
end
