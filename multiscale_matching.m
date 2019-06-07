clear all; clc; close all;
image_path = 'images/desk_set/'

for i=1:5
    i
    image_file_path = [image_path num2str(i) '.jpg'];
    [image{i}, descriptors{i}, locs{i}] = sift(image_file_path);
    [locs_sorted{i}, idx] = sortrows(locs{i},3,'descend');
    desc_sorted{i} = descriptors{i}(idx,:);
end

n_im = 5;
num_matches = zeros([n_im, n_im, 10]);


for i=1:5
    for j=i+1:5
        im1 = image{i};
        im2 = image{j};
        
        num_features1 = size(locs_sorted{i}, 1);
        num_features2 = size(locs_sorted{j}, 1);
        
        
        count = 1;
        
        for k=10:10:100
            
            k
            first = 1;
            last1 = floor((k./100).*num_features1)
            last2 = floor((k./100).*num_features2)
            
            d1 = desc_sorted{i}(first:last1, :);
            d2 = desc_sorted{j}(first:last2, :);
            
            loc1 = locs_sorted{i};
            loc2 = locs_sorted{j};
            
            l1 = locs_sorted{i}(first:last1, :);
            l2 = locs_sorted{j}(first:last2, :);
            
            [match_list, n_match] = match_sift(im1, im2, d1, d2, l1, l2);
            
            % Create a new image showing the two images side by side.
            im3 = appendimages(im1,im2);
            
            % Show a figure with lines joining the accepted matches.
            figure('Position', [100 100 size(im3,2) size(im3,1)]);
            colormap('gray');
            imagesc(im3);
            hold on;
            cols1 = size(im1,2);
            scatter([loc1(:,2);loc2(:,2)+cols1], [loc1(:,1);loc2(:,1)]);
            
            for d = 1: size(d1,1)
                
                if (match_list(d) > 0)
                    line([l1(d,2) l2(match_list(d),2)+cols1], ...
                        [l1(d,1) l2(match_list(d),1)], 'Color', 'c');
                end
            end
            hold off;
            uiwait
            clear('d1', 'd2', 'l1', 'l2');
            num_matches(i,j,count) = n_match;
            count = count + 1;
        end
    end
end
