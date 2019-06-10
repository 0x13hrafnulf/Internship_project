function cluster_analyser

main_window = figure('Name', 'Cluster Analyser', 'Units', 'Normalized', 'Position', [0, 0, 0.8, 0.8], 'Visible', 'off', 'MenuBar', 'none');
%zoom on;
%pan on;

uicontrol('Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.73, 0.55, 0.21, 0.05], 'FontWeight', 'bold' ,'FontSize' , 12, 'Callback', @calculate);
uicontrol('Style', 'pushbutton', 'String', 'Open file', 'Units', 'Normalized', ...
        'Position', [0.73, 0.9, 0.21, 0.05], 'FontWeight', 'bold' , 'FontSize' , 12, 'Callback', @open_file);
uicontrol('Style', 'pushbutton', 'String', 'Save file as', 'Units', 'Normalized', ...
        'Position', [0.73, 0.85, 0.11, 0.05], 'FontWeight', 'bold' ,'FontSize' , 11, 'Callback', @save_file);
uicontrol('Style', 'pushbutton', 'String', 'Save graph as', 'Units', 'Normalized', ...
        'Position', [0.73, 0.8, 0.11, 0.05], 'FontWeight', 'bold' ,'FontSize' , 11,'Callback', @save_graph);
save_method_chosen1 = uicontrol('Style', 'popupmenu', 'String', {'Output graph', 'Both graphs'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 12 ,'Position', [0.84, 0.76, 0.1, 0.08]);
save_method_chosen2 = uicontrol('Style', 'popupmenu', 'String', {'Binary (.mat)', 'Text (.txt)'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 12 ,'Position', [0.84, 0.81, 0.1, 0.08]);

cluster_num_s = uicontrol('Style', 'text', 'String', 'Number of clusters', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.65, 0.21, 0.05], 'Visible', 'on');
cluster_num_edt = uicontrol('Style', 'edit', 'String', 'Enter the number of clusters', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.73, 0.62, 0.21, 0.05], 'Visible', 'on');
uicontrol('Style', 'text', 'String', 'Clustering method', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.73, 0.21, 0.05]);
cluster_method_chosen = uicontrol('Style', 'popupmenu', 'String', { 'K-Means', 'DBSCAN', 'GMM-clusters', 'Hierarchial'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','FontSize' , 11,'Position', [0.73, 0.7, 0.21, 0.05], 'Callback', @m_chosen);
%DBSCAN specific
dbscan_s = uicontrol('Style', 'text', 'String', 'DBSCAN properties', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.48, 0.21, 0.05], 'Visible', 'off');
dbscan_s1 = uicontrol('Style', 'text', 'String', 'Epsilon (radius)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.45, 0.21, 0.05], 'Visible', 'off');
epsilon =  uicontrol('Style', 'edit', 'String', 'Enter the value of epsilon', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.73, 0.42, 0.21, 0.05], 'Visible', 'off');
dbscan_s2 = uicontrol('Style', 'text', 'String', 'Number of neighbours', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.35, 0.21, 0.05], 'Visible', 'off');
min_neigh =  uicontrol('Style', 'edit', 'String', 'Enter the number of neighbours', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.73, 0.32, 0.21, 0.05], 'Visible', 'off');
%

    function m_chosen(src, event)
        s_method = get(cluster_method_chosen, 'String');
        s_value = get(cluster_method_chosen, 'Value');
        cla(ax2,'reset');
        if (strcmp(s_method{s_value}, 'DBSCAN'))
            set(dbscan_s, 'Visible', 'on');
            set(dbscan_s1, 'Visible', 'on');
            set(dbscan_s2, 'Visible', 'on');
            set(epsilon, 'Visible', 'on');
            set(min_neigh, 'Visible', 'on');
            set(cluster_num_edt, 'Visible', 'off');
            set(cluster_num_s, 'Visible', 'off');
            
        else
            set(dbscan_s, 'Visible', 'off');
            set(dbscan_s1, 'Visible', 'off');
            set(dbscan_s2, 'Visible', 'off');
            set(epsilon, 'Visible', 'off');
            set(min_neigh, 'Visible', 'off');
            set(cluster_num_edt, 'Visible', 'on');
            set(cluster_num_s, 'Visible', 'on');
        end
    end
    
ax1 = axes('Units', 'Normalized', 'Position', [0.05, 0.57, 0.6, 0.40]);
title('Initial Graph','FontWeight','bold')
ylabel('P2','FontSize',10);
xlabel('P1','FontSize',10);
tb1 = axtoolbar(ax1,'default');
tb1.Visible = 'on';

ax2 = axes('Units', 'Normalized', 'Position', [0.05, 0.07, 0.6, 0.40]);   
title('Output Graph','FontWeight','bold')
ylabel('P2','FontSize',10);
xlabel('P1','FontSize',10);
tb2 = axtoolbar(ax2,'default');
tb2.Visible = 'on';


movegui(main_window, 'center');
set(main_window, 'Visible', 'on');
full_filename = [];
input_matrix = [];
filename_for_saving = [];

    function open_file(src, event)
        [filename, pathname] = uigetfile('*.*');
        full_filename = [pathname filename];
        filename_for_saving = filename;
        match = [".txt", ".mat"];
        filename_for_saving = erase(filename_for_saving,match);
        if(contains(filename, match(1)))
            input_matrix = load(full_filename);
        elseif(contains(filename, match(2)))
            input_matrix = load(full_filename);
            input_matrix = input_matrix.D; %specify matrix name that being loaded from file 
        end
        scatter(ax1, input_matrix(:,1), input_matrix(:,2), 'filled');
    end
    function save_file(src, event)
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        if(strcmp(number_of_clusters,'Enter the number of clusters') & ~strcmp(method{value}, 'DBSCAN'))
            number_of_clusters = 'Null';
        elseif(strcmp(method{value}, 'DBSCAN'))
            number_of_clusters = strcat('eps_', eps, '_neighbours_', number_of_neighbours);
        end
        
        items = get(save_method_chosen2,'String');
        index_selected = get(save_method_chosen2,'Value');
        save_selected = items{index_selected};
        fileName = []
        if(strcmp(save_selected, 'Text (.txt)'))
            fileName = strcat(filename_for_saving,'_',method{value},'_params:',number_of_clusters,'_',current_date, '.txt');
            dlmwrite(fileName, output_matrix, 'delimiter', ' ');
        elseif(strcmp(save_selected,'Binary (.mat)'))
            fileName = strcat(filename_for_saving, '_', method{value},'_params:',number_of_clusters,'_',current_date, '.mat');
            X = output_matrix;
            save(fileName, 'X');
        end
        
        msgbox({'Your file was saved:'; fileName}, 'Success');
       
    end
    function save_graph(src, event)
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        if(strcmp(number_of_clusters,'Enter the number of clusters') & ~strcmp(method{value}, 'DBSCAN'))
           number_of_clusters = 'Null';
        elseif(strcmp(method{value}, 'DBSCAN'))
            number_of_clusters = strcat('eps_', eps, '_neighbours_', number_of_neighbours);
        end
        
        graphName = strcat(filename_for_saving, '_', method{value},'_params:',number_of_clusters,'_',current_date);
        
        items = get(save_method_chosen1,'String');
        index_selected = get(save_method_chosen1,'Value');
        save_selected = items{index_selected};
        
        if(strcmp(save_selected, 'Both graphs'))
            fig = main_window;
            fig.InvertHardcopy = 'off';
            print(graphName,'-dpng','-noui');
        elseif(strcmp(save_selected,'Output graph'))
            f_new = figure('Visible', 'off');
            fig.InvertHardcopy = 'off';
            ax_new = copyobj(ax2, f_new);
            set(ax_new,'Position','default');
            print(f_new, graphName,'-dpng');
            close(f_new);
        end
        
        msgbox({'Your graph was saved:'; graphName}, 'Success');
    end 

output_matrix = []
labels = []
colors = []
%centroids = []
    function calculate(src,event)
        cla(ax2,'reset');
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        if(strcmp(number_of_clusters, 'Enter the number of clusters') & strcmp(method{value}, 'DBSCAN') == 0)
            msgbox('Please enter the number of clusters.', 'Error','error')
        else
            number_of_clusters = str2num(number_of_clusters);
            switch method{value} %kmeans, clusterdata and dendrogram, cluster 
            case 'DBSCAN'
                if(strcmp(number_of_neighbours, 'Enter the number of neighbours') | strcmp(eps, 'Enter the value of epsilon'))
                    msgbox('Please enter the values of epsilon and neighbours', 'Error','error')
                else
                    msgbox('DBSCAN clusterization')
                    number_of_neighbours = str2double(number_of_neighbours);
                    eps = str2double(eps);
                    [labels, colors] = get_dbscan_result(input_matrix, eps, number_of_neighbours);
                end 
            case 'K-Means'
                 msgbox('K-Means clusterization')
                
                 [labels, colors] = get_k_means_result(input_matrix, number_of_clusters);
            case 'GMM-clusters'
                 msgbox('GMM clusterization')
                 
                 [labels, colors] = get_gmm_result(input_matrix, number_of_clusters)
            case 'Hierarchial'
                 msgbox('Hierarchial clusterization')
                 
                 [labels, colors] = get_hierarchial_result(input_matrix, number_of_clusters)
            end
            output_matrix = [input_matrix, labels];
            n = max(labels);
            if(strcmp(method{value}, 'DBSCAN'))
                marker = ['+','o','*','.','s','d','^','v','>','<','p','h'];
                
                for i = 1:n
                    check = labels == i;
                    indexcol = 1 + mod(i, 8);
                    col = colors(indexcol,:);
                    col2 = colors(8 - indexcol + 1,:)
                    index = 1 + mod(i, 12);
                    scatter(ax2, output_matrix(check,1), output_matrix(check,2), 'filled', marker(index), 'MarkerFaceColor', col, 'MarkerEdgeColor', col2);
                    hold(ax2, 'on');
                    
                end
            else
                marker = ['+','o','*','.','x','s','d','^','v','>','<','p','h'];
                for i = 1:number_of_clusters
                    check = labels == i;
                    indexcol = 1 + mod(i, 8);
                    col = colors(indexcol,:);
                    col2 = colors(8 - indexcol + 1,:)
                    index = 1 + mod(i, 13);
                    scatter(ax2, output_matrix(check,1), output_matrix(check,2), 'filled', marker(index), 'MarkerFaceColor', col, 'MarkerEdgeColor', col2);
                    hold(ax2, 'on');
                end
            end
            scatter(ax2, output_matrix(labels == 0,1), output_matrix(labels == 0,2), 'filled', 'x', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r')
            hold(ax2, 'on');
        end        
    end
end