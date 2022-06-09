% Computes how many trials would be considered
% as early learning by using two different ways:
% the one from the original Bonstrup paper, and the
% one from the Bonstrup crowdsourcing paper

clear;
close all;
addpath('include');
online = load("results\online.mat").processeddata;
offline = load("results\offline.mat").processeddata;

offline_left = mean(offline.Blockmeanleft);
offline_right = mean(offline.Blockmeanright);
online_left = mean(online.Blockmeanleft);
online_right = mean(offline.Blockmeanright);

total_left = mean([offline.Blockmeanleft; online.Blockmeanleft]);

%% First way
L = @(k, t) k(1) + k(2) / (1 + exp(-k(3) * t));
L_inv = @(k, x) - log((k(1) + k(2) - x) / k(2)) / k(3);
cost_func = @(B, k) sum((B - arrayfun(@(t) L(k, t), 1:36)).^2);
k0 = rand(3, 1);
k_offline_left = fmincon(@(k) cost_func(offline_left, k), k0)
k_offline_right = fmincon(@(k) cost_func(offline_right, k), k0)
k_online_left = fmincon(@(k) cost_func(online_left, k), k0)
k_online_right = fmincon(@(k) cost_func(online_right, k), k0)

k_total_left = fmincon(@(k) cost_func(total_left, k), k0)

%% Second way
L = @(k, t) k(1) + k(2) * (1 - exp(-k(3) * t));
L_inv = @(k, x) - log((k(1) + k(2) - x) / k(2)) / k(3);
cost_func = @(B, k) sum((B - arrayfun(@(t) L(k, t), 1:36)).^2) / 36 + 0.1 * k(2)^2;
k0 = rand(3, 1);
k_offline_left = fmincon(@(k) cost_func(offline_left, k), k0, [], [], [], [], [-2, 0, 0], [4, 9, 6])
k_offline_right = fmincon(@(k) cost_func(offline_right, k), k0, [], [], [], [], [-2, 0, 0], [4, 9, 6])
k_online_left = fmincon(@(k) cost_func(online_left, k), k0, [], [], [], [], [-2, 0, 0], [4, 9, 6])
k_online_right = fmincon(@(k) cost_func(online_right, k), k0, [], [], [], [], [-2, 0, 0], [4, 9, 6])

k_total_left = fmincon(@(k) cost_func(total_left, k), k0, [], [], [], [], [-2, 0, 0], [4, 9, 6])

%% Get trial numbers

t_offline_left = round(L_inv(k_offline_left, 0.95 * (L(k_offline_left, 36) - L(k_offline_left, 1)) + L(k_offline_left, 1)))
t_offline_right = round(L_inv(k_offline_right, 0.95 * (L(k_offline_right, 36) - L(k_offline_right, 1)) + L(k_offline_right, 1)))
t_online_left = round(L_inv(k_online_left, 0.95 * (L(k_online_left, 36) - L(k_online_left, 1)) + L(k_online_left, 1)))
t_online_right = round(L_inv(k_online_right, 0.95 * (L(k_online_right, 36) - L(k_online_right, 1)) + L(k_online_right, 1)))
t_total_left = round(L_inv(k_total_left, 0.95 * (L(k_total_left, 36) - L(k_total_left, 1)) + L(k_total_left, 1)))

%% Plot results
figure
plot(offline_left)
hold on
plot(arrayfun(@(t) L(k_offline_left, t), 1:36))
xline(t_offline_left)

figure
plot(offline_right)
hold on
plot(arrayfun(@(t) L(k_offline_right, t), 1:36))
xline(t_offline_right)

figure
plot(online_left)
hold on
plot(arrayfun(@(t) L(k_online_left, t), 1:36))
xline(t_online_left)

figure
plot(online_right)
hold on
plot(arrayfun(@(t) L(k_online_right, t), 1:36))
xline(t_online_right)

figure
plot(total_left)
hold on
plot(arrayfun(@(t) L(k_total_left, t), 1:36))
xline(t_total_left)
