function result = stitchH(img_src, H, img_des)
    [~, xdata, ydata] = imtransform(img_src,maketform('projective',H'));

    xdata_out=[min(1,xdata(1)) max(size(img_des,2), xdata(2))];
    ydata_out=[min(1,ydata(1)) max(size(img_des,1), ydata(2))];

    result_src = imtransform(img_src, maketform('projective',H'),...
        'XData',xdata_out,'YData',ydata_out);
    result_des = imtransform(img_des, maketform('affine',eye(3)),...
        'XData',xdata_out,'YData',ydata_out);

    result = result_src + result_des;
    overlap_pt = (result_src > 0.0) & (result_des > 0.0);
    result_avg = (result_src/2 + result_des/2); % Note overflow!
    % extra credit: Now and Then
    % result_avg = (result1);
    
    result(overlap_pt) = result_avg(overlap_pt);
end