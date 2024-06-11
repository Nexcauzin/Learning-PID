% Definindo o sistema de primeira ordem
sistema = tf(1,[1 10]);

% Sintonizando os controladores com pidtune
[C_pid, info_pid] = pidtune(sistema, 'PID');
[C_pd, info_pd] = pidtune(sistema, 'PD');
[C_pi, info_pi] = pidtune(sistema, 'PI');

% Obtendo as respostas ao degrau
t = 0:0.01:0.8;
y_pid = step(feedback(C_pid*sistema,1), t);
y_pd = step(feedback(C_pd*sistema,1), t);
y_pi = step(feedback(C_pi*sistema,1), t);

% Plotando as respostas
figure
plot(t, y_pid, t, y_pd, t, y_pi)
legend('PID', 'PD', 'PI')
title('Comparação das Respostas')
xlabel('Tempo (s)') 
ylabel('Resposta ao Degrau')
grid on
