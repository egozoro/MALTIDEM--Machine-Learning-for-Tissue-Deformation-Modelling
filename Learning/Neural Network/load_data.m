function [nn_input, nn_output, nn_input_compare, nn_output_compare] = load_data(force_node_compare,node_choice)

iterations = load('iterations.mat');
coordinates = load('coordinates.mat');
nodes_list = load('nodes_list.mat');
force_nodes = load('force_nodes.mat');

force_nodes = force_nodes(force_nodes(:,1)~=force_node_compare,1);
fn = 20;

a=1;

for i = 1:size(force_nodes,1)
    force_node = force_nodes(i);
    dir_name = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',num2str(force_node));
    var_filename = strcat(dir_name,'/All_Nodes_Iterations_Fn',num2str(force_node),'.mat');
    load(var_filename);
    for z = 1:30
        for n = node_choice
            for f = 1:fn
                for g =1:3
                    nn_input(a,g+1) = iterations{z}.force_direction(f,g);
                end
                nn_input(a,5) = iterations{1}.dist_plot(n,f);
                
                th = zeros(3);
                for h=1:3
                    th(h) = iterations{z}.force_direction(fn,h)/norm(iterations{z}.force_direction(fn,:));
                    th(h) = acos(th(h));
                    nn_input(a,5+h) = th(h);
                end
                vectemp = zeros(2,3);
                for xyz = 1:3
                    vectemp(1,xyz) = coordinates(force_node,xyz+1,1);
                    vectemp(2,xyz) = cmbrain(xyz);
                end
                nn_input(a,9) = pdist(vectemp);
                
                r = vrrotvec(coordinates(force_node,2:4,1)-coordinates(nodes_list(n),2:4,1),iterations{z}.force_direction(fn,:));
                nn_input(a,10) = r(1);
                nn_input(a,11) = r(2);
                nn_input(a,12) = r(3);
                nn_input(a,13) = r(4);
                
                for gg = 1:3
                    tho = iterations{z}.displ_max_vector{n,f}(gg)/norm(iterations{z}.displ_max_vector{n,f}(:));
                    tho = acos(tho);
                    
                    nn_output(a,gg) = tho;
                end
                
                a=a+1;
                %end
            end
        end
    end
    a
end

nn_input_compare = NaN;
nn_output_compare = NaN;
a=1;
root = 'user_defined_root';
dir_name = strcat(root, '/Node',num2str(force_node_compare));

var_filename = strcat(dir_name,'/All_Nodes_Iterations_Fn',num2str(force_node_compare),'.mat');
load(var_filename);
for z = 1:30
    for n = node_choice
        for f = 1:fn
            nn_input_compare(a,1) = iterations{z}.cos_plot(n,f);
            for g =1:3
                nn_input_compare(a,g+1) = iterations{z}.force_direction(f,g);
            end
            nn_input_compare(a,5) = iterations{1}.dist_plot(n,f);
            
            for h=1:3
                th(h) = iterations{z}.force_direction(fn,h)/norm(iterations{z}.force_direction(fn,:));
                th(h) = acos(th(h));
                nn_input_compare(a,5+h) = th(h);
            end
            
            for xyz = 1:3
                vectemp(1,xyz) = DATA_coord(force_node_compare,xyz+1,1);
                vectemp(2,xyz) = cmbrain(xyz);
            end
            nn_input_compare(a,9) = pdist(vectemp);
            
            r = vrrotvec(DATA_coord(force_node_compare,2:4,1)-DATA_coord(nodes_list(n),2:4,1),iterations{z}.force_direction(fn,:));
            nn_input_compare(a,10) = r(1);
            nn_input_compare(a,11) = r(2);
            nn_input_compare(a,12) = r(3);
            nn_input_compare(a,13) = r(4);
            
            for gg = 1:3
                tho = iterations{z}.displ_max_vector{n,f}(gg)/norm(iterations{z}.displ_max_vector{n,f}(:));
                tho = acos(tho);
                
                nn_output_compare(a,gg) = tho;
            end
            a=a+1;
        end
    end
end

end
