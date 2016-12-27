%% Initialization
clear ; close all; clc

%% Setup the parameters
input_layer_size  = 400;  % 20x20 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 10;          % 10 labels, from 1 to 10

%% =========== Loading and Visualizing Data =============
% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

load('data.mat');

% Split Data
mtol = size(X,1);
mtrain = 0.8*mtol;
p = randperm(mtol);
TrainX = X(p(1:mtrain),:);
Trainy = y(p(1:mtrain));
TestX = X(p((mtrain+1):end),:);
Testy = y(p((mtrain+1):end));
m = size(TrainX, 1);

% % Randomly select 100 data points to display
% sel = randperm(size(X, 1));
% sel = sel(1:100);

% displayData(X(sel, :));
% fprintf('Program paused. Press enter to continue.\n');
% pause;

%% ================ Initializing Pameters ================
fprintf('\nInitializing Neural Network Parameters ...\n')

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

%% ================= Training =================
% Set Parameter lambda
lambda = 10;
options = optimset('MaxIter', 1000);

% Create function handle for the cost function to be minimized
% costFunction = @(p) nnCostFunction(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, TrainX, Trainy, lambda);

% Different minimization methods

% Built-in fmincg function
% [nn_params, cost, it] = fmincg(costFunction, initial_nn_params, options);


% L-BFGS method
% [nn_params, cost,  it] = lbfgs(costFunction, initial_nn_params, options);


% SGD method
costFunction = @(p, Xp, yp) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, Xp, yp, lambda);

[nn_params, cost, it] = sgd(costFunction, initial_nn_params, TrainX, Trainy, options);

%% ================= Implement Predict =================
simcalerr = @(p) calerr(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, TrainX, Trainy,TestX, Testy);
[errateTrain, errateTest, predTrain, predTest] = simcalerr(nn_params);
fprintf('\nTraining Set Error Rate: %f\n', errateTrain);

fprintf('\nTest Set Error Rate: %f\n', errateTest);


%% ================= Comparason =================
% fixed lambda, changing iteration
% lambda = 1;

% simcalerr = @(p) calerr(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, TrainX, Trainy,TestX, Testy);
% ITT  = [10, 20];
% l = length(ITT);
% errateTrain = zeros(3, l);
% errateTest = zeros(3, l);
% for i = 1:l
%     options = optimset('MaxIter', ITT(i));
%     for j = 1:3
%         if j ==1
%             costFunction = @(p) nnCostFunction(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, TrainX, Trainy, lambda);
%             [nn_params, cost, it] = fmincg(costFunction, initial_nn_params, options);
%         elseif j==2
%             costFunction = @(p) nnCostFunction(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, TrainX, Trainy, lambda);
%             [nn_params, cost,  it] = lbfgs(costFunction, initial_nn_params, options);
%         elseif j==3
%                 costFunction = @(p, Xp, yp) nnCostFunction(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, Xp, yp, lambda);
%             [nn_params, cost, it] = sgd(costFunction, initial_nn_params, TrainX, Trainy, options);
%         end
%         [errateTrain(j,i), errateTest(j,i)] = simcalerr(nn_params);
%     end
% end

% figure;
% hold on;
% col = 'rgb';
% for j = 1:3
%         plot(ITT, errateTrain(j,:), 'linewidth', 2, 'color', col(j));
%         plot(ITT, errateTest(j,:), 'linewidth', 2, 'color', col(j));
% end


% fixed iteration, changing lambda
% options = optimset('MaxIter', 50);

% simcalerr = @(p) calerr(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, TrainX, Trainy,TestX, Testy);
% LAMBDA  = [1, 3, 5, 10, 15, 20, 50];
% l = length(LAMBDA);
% errateTrain = zeros(2, l);
% errateTest = zeros(2, l);
% for i = 1:l
%     lambda = LAMBDA(i);
%     costFunction = @(p) nnCostFunction(p, ...
%                                    input_layer_size, ...
%                                    hidden_layer_size, ...
%                                    num_labels, TrainX, Trainy, lambda);
%     [nn_params, cost, it] = fmincg(costFunction, initial_nn_params, options);
%     [errateTrain(1, i), errateTest(1, i)] = simcalerr(nn_params);
%     [nn_params, cost,  it] = lbfgs(costFunction, initial_nn_params, options);
%     [errateTrain(2, i), errateTest(2, i)] = simcalerr(nn_params);
% end
% figure;
% hold on;
% plot(LAMBDA, errateTrain(1,:), 'linewidth', 2);
% plot(LAMBDA, errateTrain(2,:), 'linewidth', 2);
% plot(LAMBDA, errateTest(1,:), 'linewidth', 2);
% plot(LAMBDA, errateTest(2,:), 'linewidth', 2);

