%% Anotações para teste
% REFERENTE A PARTE DE SINAL DE ENTRADA (:
%- Degrau: ones(size(tempo_simulacao)) * valordegrau(objetivo)
%Bom para avaliar a resposta transitória, mudança repentina, tempo de
%resposta

%- Senoide: amplitude = 100; % Amplitude da senoide
%           frequencia = 1; % frequência em Hz
%           valor_objetivo = 680
%           entrada_simulacao = amplitude * sin(2 * pi * frequencia * tempo_simulacao) + valor_objetivo;
%Bom para analisar as diferentes frequencias de entrada

%- Pulso: duracao_pulso = 1; % duração do pulso em segundos
%         valor_objetivo = 680;
%         entrada_simulacao = (tempo_simulacao < duracao_pulso) * valor_objetivo;
%Bom para analisar a resposta ao impulso, avaliar o retorno ao equilibrio
%após perturbações breves e intensas

%- Rampa: taxa_rampa = 20; % taxa de variação da rampa
%         valor_inicial = 630; % Valor inicial da rampa
%         valor_objetivo = 670; % Valor objetivo da rampa
%         entrada_simulacao = taxa_rampa * tempo_simulacao + valor_inicial;
%Ideal para simular o limitador
%Bom para avaliar a respostas de uma entrada que aumenta linearmente

%- Entrada aleatória: amplitude_aleatoria = 200;
%                     entrada_simulacao = rand(size(tempo_simulacao));
%Dedo no cu e gritaria, quando terminar bota só de meme

%% Extração dos dados
% Lendo os dados
dados = readtable('Dados/Tratado/Rep1.xlsx');

% Extraindo valores
potencia = dados.Potencia;
tensao = dados.Tensao;
corrente = dados.Corrente;
throttle = dados.Throttle;
intervalo = dados.Intervalo;

% Convertendo para tempo absoluto
tempo = cumsum(intervalo);

%% Conversão dos Dados para 'idddata'
sampling_time = mean(intervalo);
data_id = iddata(potencia, throttle, sampling_time);

%% Identificação do modelo
modelo_sistema = tfest(data_id, 2, 1); % Estimando a função de transferência de segunda ordem

%% Validação do modelo
compare(data_id, modelo_sistema);
controlador_pid = pidtune(modelo_sistema, 'PID');

% Constantes utilizadas
Kp = controlador_pid.Kp;
Ki = controlador_pid.Ki;
Kd = controlador_pid.Kd;
disp(['Kp: ', num2str(Kp), ' | Ki: ', num2str(Ki), ' | Kd: ', num2str(Kd)]);


%% Simulação do sistema com controle PID
% Tempo de simulação
tempo_simulacao = 0 : 0.01 : 30;

% Sinal de entrada (Ta o degrau por enquanto, ainda n sei qual colocar)
taxa_rampa = 20; % taxa de variação da rampa
valor_inicial = 630; % Valor inicial da rampa
valor_objetivo = 670; % Valor objetivo da rampa
entrada_simulacao = taxa_rampa * tempo_simulacao + valor_inicial;
% No caso vai aumentar continuamente para 680W

% Simulando sistema
saida_simulada = lsim(controlador_pid * modelo_sistema, entrada_simulacao, tempo_simulacao);

% Plotando a resposta
plot(tempo_simulacao, saida_simulada);
xlabel('Tempo (s)');
ylabel('Potência (W)');
title('Resposta do Sistema PID')