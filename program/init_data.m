function data = init_data(dur_simulation, s, a, memory)
%% Funkce init_data
%
% Vytvori strukturu data, pro vkladani stavu a akci behem simulace.  
%
%  data = init_data(dur_simulation, s, a, memory)
%% Popis
%% Vystup 
%  data = struktura
%         state                     % state course      [s_{1-memory},s_{1-memory+1},...,s_{1},s_{2} ,...,s_{dur_simulation} ] 
%         pred_state                % prediction course [s_{1-memory},s_{1-memory+1},...,s_{1},sp_{2},...,sp_{dur_simulation}] 
%         action                    % action course     [0           ,a_{1-memory+1},...,a_{1},a_{2} ,...,a_{dur_simulation} ]  
%% Vstup: 
%  dur_simulation = delka simulace 
%  memory = pamet systemu 
%  s = pole pocatecnich stavu 
%  a = pole pocatecnich akci

%% Pomocne promenne 
% t = cas

%% Posledni aktualizace:
% autor     =  YP
% upraveno  =  22.4.20 YP
%              15.5.20 MK
% teorie    =  Bc prace YP
% poznamky  =  asi nalezen a opraven klicovy problem v casovani, presunuto pole na predpovedi sem (od agenta)!!
%
%% Kod
% 
%
t = memory + 1;                                                            % nastavi cas 
    state  = zeros(1,dur_simulation + memory);                             % vytvori pole pro vkladani stavu behem simulace
    action = zeros(1,dur_simulation + memory);                             % vytvori pole pro vkladani akci  behem simulace
pred_state = zeros(1,dur_simulation + memory);                             % pole pro ukladani predpovedi stavu agenta
pred_sstate = zeros(1,dur_simulation + memory);                            % pole pro ukladani predpovedi stavu systemu
for i= 1:memory                                                            
      state(i)  = s(i);                                                    % ulozi do pole pocatecni stavy
  pred_state(i) = s(i);                                                    % stavy splyvaji s predpovedmi 
    action(i+1) = a(i);                                                    % ulozi do pole pocatecni akci
end

data = struct('state',state,'action',action,'pred_state',pred_state, 'pred_sstate', pred_sstate, 'dur_simulation',dur_simulation,'t',t);
end
