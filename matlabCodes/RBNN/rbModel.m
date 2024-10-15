
function model = rbModel(inputs, targets, goal, spread)
    net = newrb(inputs', targets', goal, spread);
    model = net;
end
