
function model = ensembledModel(model1, E1, model2, E2)
    total = E1 + E2;
    w1 = (total - E1) / total;
    w2 = (total - E2) / total;

    disp([w1, w2, "weights"])

    function error = ensmodel(inputs)
        error = w1*model1(inputs(:, 1), inputs(:, 2)) + w2*model2(inputs')';
    end
    model = @ensmodel;
end