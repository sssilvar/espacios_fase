function img = detectAndDraw(img, cascadeF, cascadeE, scale, tryflip)
    % downscale image and preprocess it
    fx = 1/scale;
    gray = cv.cvtColor(img, 'RGB2GRAY');
    gray = cv.resize(gray, fx, fx);
    gray = cv.equalizeHist(gray);
    [h,w] = size(gray);

    % detection options
    detectOpts = {
        'ScaleFactor',1.1, ...
        'MinNeighbors',2, ...
        ... 'FindBiggestObject',true, ...
        ... 'DoRoughSearch',true, ...
        'ScaleImage',true, ...
        'MinSize',[30 30]
    };

    % detect faces
    tic
    faces = cascadeF.detect(gray, detectOpts{:});
    if tryflip
        faces2 = cascadeF.detect(cv.flip(gray, 1), detectOpts{:});
        faces2 = cellfun(@(r) [w-r(1)-r(3) r(2:4)], faces2, 'Uniform',false);
        faces = [faces(:); faces2(:)];
    end
    toc

    % draw
    clrs = uint8(255 * lines(7));
    for i=1:numel(faces)
        r = faces{i};
        ii = mod(i-1, size(clrs,1)) + 1;
        drawOpts = {'Color',clrs(ii,:), 'Thickness',3};

        % draw faces
        aspect_ratio = r(3)/r(4);
        if 0.75 < aspect_ratio && aspect_ratio < 1.3
            center = round((r(1:2) + r(3:4)*0.5) * scale);
            radius = round((r(3) + r(4)) * 0.25*scale);
            img = cv.circle(img, center, radius, drawOpts{:});
        else
            pt1 = round(r(1:2) * scale);
            pt2 = round((r(1:2) + r(3:4) - 1) * scale);
            img = cv.rectangle(img, pt1, pt2, drawOpts{:});
        end

        if ~cascadeE.empty()
            % detect nested objects (eyes)
            grayROI = imcrop(gray, [r(1:2)+1 r(3:4)]);
            nestedObjs = cascadeE.detect(grayROI, detectOpts{:});

            % draw eyes
            for j=1:numel(nestedObjs)
                nr = nestedObjs{j};
                center = round((r(1:2) + nr(1:2) + nr(3:4)*0.5) * scale);
                radius = round((nr(3) + nr(4)) * 0.25*scale);
                img = cv.circle(img, center, radius, drawOpts{:});
            end
        end
    end
end