function plotLine(l,range,color)
    % ax + by + c = 0 => y = -ax/b -c/b
    f = @(x) (-l(1) / l(2) * x - l(3) / l(2));
    p = fplot(f, range,color);
    p.LineWidth = 1;
   
end