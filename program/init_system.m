function system = init_system(num_state, num_action, memory, dur_simulation)
%% Funkce init_system
%
% Inicializace systemu vytvori strukturu system, ktera odpovida realnemu systemu. 
%
% system = init_system(num_state, num_action, memory, dur_simulation)
%
%% Vystup 
%  system = struktura popisujici simulovany system obsahujici
%  P_0 = pole pravdepodobnosti prechodu   (zvoleno pevne) 
%% Vstupy: 
%           num_state = pocet stavu 
%            num_akce = pocet akci
%              memory = pamet systemu 
%        dur_simulace = delka simulace 
%
%% Kod
%% Systemy zavisle na s_t-2, s_t-2, a_t, s_t
P_0 = zeros(3,3,3,3);

%% System EX1 
% velka zavislost na s_t-1
% alpha = 0.3;
% beta = 0.6; 
% gamma = 0.2; 
% delta = 2; 
% omega = 1;


%% System EX2
% stejna zavislost na kazdem regresoru 

% alpha = 0.3;
% beta = 0.3; 
% gamma = 0.3; 
% delta = 2; 
% omega = 1; 

%% System EX3
% velka zavislost na stavu s_t-2
alpha = 0.3;
beta = 0; 
gamma = 0.5; 
delta = 2; 
omega = 1; 

%% Zadani pravdepodobnosti prechodu systemu

for i4 = 1:3
    for i3 = 1:3
         for i2 = 1:3
             m = alpha*i2 + beta*i3 + gamma*i4;                            % zadani zavislosti na predchozich stavech pomoci regresni funkce m_t
             for i1 = 1:3
                 P_0(i1,i2,i3,i4)=exp(-abs(i1-m))^delta*omega;             % vypocet pravdepodobnosti prechodu na zaklade nastavenych parametru
             end    
                k = sum(P_0(:,i2,i3,i4));                              
                P_0(:,i2,i3,i4)= P_0(:,i2,i3,i4)/k;                        % upraveni pravdepodobnosti tak, aby summa pres predpovidany stav = 1
         end
    end
end


system = struct('P_0', P_0, 'num_state', num_state, 'num_action', num_action, 'memory', memory, 'dur_simulation', dur_simulation);
end
