function [system, agent, adviser, data, num_adviser] = initialization(dur_simulation,dia)
%% Funkce inicialization
%
% Inicializace nastavi parametry a vytvori potrebne struktury. 
% Uzivatel bud zada parametry pomoci dialogu nebo nastavi v programu. 
%
%  [system, agent, adviser, data, num_adviser] = initialization(dur_simulation,dia)
%  [system, agent, adviser, data, num_adviser] = initialization(dur_simulation) 0
%% Popis
%% Vystup: 
%  system  = struktura realneho systemu
%  agent   = struktura hlavniho rozhodujiciho agenta
%  adviser = struktura typu agent pro poradce
%  num_adviser = pocet poradcu 
%% Vstup
%  dur_simulation = delka simulace
%  dia            = indikator dialogu [0/1] = [neni/je] 
%% Pomocne promenne 
% memory     = pamet systemu
% s = pocatecni stavy pred zacatkem simulace 
% a = pocatecni akce  pred zacatkem simulace

%% Kod
% 
% predvolba
if nargin < 2, dia = 0;end

%% Dialog                                                       
if dia                                                                     % dialog pro zadavani parametru 
   num_state  = input('Pocet stavu je = ');                                % pocet moznych stavu systemu
   num_action = input('Pocet akci je = ');                                 % pocet moznych akci  
       memory = input('Pamet systemu urcujici pocet poradcu je =');        % pamet systemu
            A = importdata('system_data.txt');
   disp('Zadejte pocatecni stavy:'); 
   for i = 1:memory
      s(i) = input('Stav'); 
   end
   disp('Zadejte pocatecni akce:'); 
   for i = 1:memory 
      a(i) = input('Akce'); 
   end
   seed = input('Seed je = ');
   v = input('Vaha predpovidanych hodnot je = ');
    rand('seed',seed);                                                       % inicialisace nahodneho generatoru 
%rng(seed,'twister');                                                        % NEPRACUJE VE STAREM MATLABU
%% Predvolby
else
  num_state = 3;                                                             % pocet stavu
  num_action = 3;                                                            % pocet akci
  memory = 2;                                                                % pamet systemu 
  num_adviser = memory -1;                                                   % pocet poradcu 
  seed  = 1;                                                                 % reset of the seed
      s = zeros(1, memory);                                                  % priprava pole pro zacatecni stavy 
      a = zeros(1, memory);                                                  % priprava pole pro zacatecni akce                      
   rand('seed',seed);                                                        % inicialisace nahodneho generatoru 
%rng(seed,'twister');                                                        % NEPRACUJE VE STAREM MATLABU
for i = 1:memory                                                             % generovani pocatecnich stavu a akci
  s(i)  = dnoise(ones(1,num_state));                                         % generovani pocatecniho stavu
  a(i)  = dnoise(ones(1,num_action));                                        % generovanu pocatecnich akci
end
end  
%% Konstrukce poli a struktur 
system = init_system(num_state, num_action, memory, dur_simulation);         % inicializace systemu 
 agent = init_agent(num_state, num_action, 0, dur_simulation);               % inicializace agenta
  data = init_data(dur_simulation, s, a, memory);                            % inicializace dat pro ukladani stavu, akci a predpovedi
for i=1:num_adviser                                                          % inicializace vsech poradcu
    adviser(i) = init_agent(num_state, num_action, i, dur_simulation);       
end
end

