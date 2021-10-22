%% Main: testovaci program pro michani jednoduchych modelu
% autor:  Yana Podlesna
%
% Simulace algoritmu na základě teorie predstavene v bakalarske praci. 
% Metoda je zamerena na vyreseni prokletí rozměrnosti vznikající v kvantitativním modelování
% složitých vzájemně propojených systémů. 
% Místo odhadu prediktoru závislého na všech parametrech metoda předpokládá užití několika prediktorů, 
% které vznikají odhadováním parametrických modelů, předpokládajích závislost na různých regresorech. 
% Simulace predpoklada rozdeleni na agenta a jednoho poradce. Uvedene tri
% systemy nastavene s ruznou zavislosti na regresorech.
      
%% Kod
%
%% Uklid
clc;
close all;
clear all; 

%% Inicialisace
dur_simulation = 10000;                                                    % delka simulace
dia = 0;                                                                   % indikator dialogu [0/1] = [neni/je] 
vg  = [0:0.05:1]; 
n   =  length(vg);                                                         % sit pro overovani vlivu ruznych vah 
fig = 1;                                                                   % pomocna hodnota pro ukladani grafu
% pocet bodu site
%%
mem = 2;
    save_states = zeros(n, dur_simulation+mem);                            % pomocne pole pro ukladani stavu 
savepred_states = zeros(n, dur_simulation+mem);                            % pomocne pole pro ukladani predpovedi stavu
savepred_sstates = zeros(n, dur_simulation+mem);                           % pomocne pole pro ukladani predpovedi systemu
   save_actions = zeros(n, dur_simulation+mem);                            % pomocne pole pro ukladani akci  
%% Cyklus pres ruzne vahy
for k=1:n                                                                  
  v = vg(k);                                                               % uzita vaha    
  [system, agent, adviser, data, num_adviser]...
      = initialization(dur_simulation,dia);                                % inicializace vsech promennych
  while data.t < dur_simulation                                            % simulace v case 
    data = generate_state(data,system);                                    % simulace dalsiho stavu systemu: z a_{t}, s_{t-1}, s_{t-2} generuje s_{t} 
    agent = learning(agent, data);                                         % krok uceni agenta: opravi statistiku agenta na V_{t}  
    for i = 1:num_adviser
        adviser(i) = learning(adviser(i), data);                           % cyklus pres vsechny poradce, uceni poradcu ziskate V_{i;t} statistiky poradcu 
    end
     data = generate_action(agent, data);                                  % generovani dalsi akci pomoci rozhodovaciho pravidla; generujete akci a_{t+1}  
    for i = 1:num_adviser                                                  % cyklus pres vsechny poradce                  
           agent = merging(agent, adviser(i), data, v);                    % oprava modelu agenta pomoci modelu poradce a vahy: V_{opravene t;s|a_{t+1},s_{t}}                                                                        %     = V_{t;s|a_{t+1},s_{t}} + v*F_{i}(s|a_{t+1},s_{t})
    end  
      data = prediction(agent, data, system);                              % predpovidani agenta: P_{agenta|t}(s_{t+1}|a_{t+1},s_{t}) 
    data.t = data.t + 1;                                                   % prechod k dalsimu casu   
  end
  save_states(k,:) = data.state;                                           % ukladani stavu, ktere probehly pro danou vahu
  save_actions(k,:)= data.action;                                          % ukladani akci, ktere probehly pro danou vahu
  savepred_states(k,:) = data.pred_state;                                  % ukladani predpovedi agenta pro danou vahu
  savepred_sstates(k,:) = data.pred_sstate; 
end
%% Vyhodnoceni kvality predpovedi
chyba = zeros(n,dur_simulation);                                           % pole pro vyhodnoceni kvality predpovedi pro ruzne vahy
chyba2 = zeros(n,dur_simulation);                                          % pole pro vyhodnoceni rozdilu mezi predpovedi systemu a agentu
pocet = zeros(1,n);                                                        % pocet chyb pres casovy cyklus pro vsechny vahy
pocet2 = zeros(1,n);                                                       % pocet rozdilu predpovedi mezi agentem a systemem                                                          
for k=1:n                                                                    
   for t= system.memory + 1:dur_simulation
      if save_states(k,t) == savepred_states(k,t)
         chyba(k,t) = 0;                                                   % tam, kde se stav rovna predpovedi chyba je nula 
      else   
        chyba(k,t) = 1;                                                    % tam, kde se stav nerovna predpovedi chyba je jedna 
      end
   end
   for t= system.memory + 1:dur_simulation
      if savepred_states(k,t) == savepred_sstates(k,t)
         chyba2(k,t) = 0;                                                  % tam, kde se stav predpovedi agenta rovna predpovedi systemu chyba je nula 
      else   
        chyba2(k,t) = 1;                                                   % tam, kde se stav predpovedi agentu nerovna predpovedi systemu chyba je jedna 
      end
   end
   pocet(1,k) = sum(chyba(k,:));                                           % pocet chyb v jednom casovem cyklu s danou vahou                                     
   pocet2(1,k) = sum(chyba2(k,:));                                         % pocet chyb mezi predpovedmi agenta a systemu s danou vahou
end

%% Vystupy
% chyby_zavisle_na_vaze = pocet

% % fig = fig+1;
% % figure(fig)
% % plot(data.state,'.')
% % xlabel('CAS')
% % ylabel('STAV')
% % grid on
% % fig= fig+1;
% % figure(fig)
% % plot(data.action,'.')
% % xlabel('CAS')
% % ylabel('AKCE')
% % grid on


binRange = 1:1:3;
hcx = histcounts(data.state,[binRange Inf]);
hcy = histcounts(data.action,[binRange Inf]);
figure(fig)
bar(binRange,[hcx;hcy]')

xlabel('Typ stavu nebo akce'); 
ylabel('Počty')
legend('Stavy','Akce')
grid on 
set(gca,'yLim',[0 8000]);

fig = fig+1;
binRange = 1:1:3;
hc2 = histcounts(savepred_states(1,[4:dur_simulation]),[binRange Inf]);
hc3 = histcounts(savepred_states(21,[4:dur_simulation]),[binRange Inf]);
hc1 = histcounts(savepred_sstates(1,[4:dur_simulation]),[binRange Inf]);
figure(fig)
bar(binRange,[hc1;hc2;hc3]')
% set(gca,'yLim',[0 7000]);
legend('Předpověď systému','Předpoveď agenta','Předpověď s poradcem')
ylabel('Počty předpovědí')
xlabel('Hodnoty stavů')
grid on

fig = fig+1
figure(fig)
plot(vg,pocet2)
hold on 
plot(vg, pocet2, '.', 'MarkerEdgeColor','k')
% set(gca,'yLim',[0 500]);
xlabel('Váha')
ylabel('Počet chyb')
 
grid on


fig = fig+1
figure(fig)
plot(vg,pocet)
hold on 
plot(vg, pocet, '.', 'MarkerEdgeColor','k')
%  set(gca,'yLim',[2895 2910]);
xlabel('Váha')
ylabel('Počet chyb')
grid on



