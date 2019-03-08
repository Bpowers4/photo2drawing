function circ_SE = get_SE(size,n)
    center = [size/2,size/2];
    SE = zeros(size);
    for i=1:size
        for j=1:size
            if norm([i,j]-center,n) < size/2
                SE(i,j) = 1;
            end
        end
    end
    circ_SE = SE;
end