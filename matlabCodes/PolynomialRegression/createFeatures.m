function poly_X = createFeatures(K, T, degree)
    poly = [];
    for d = 0:degree
        for i = 0:d
            poly = [poly, (K.^(d-i) .* T.^i)];
        end
    end
    poly_X = poly;
end