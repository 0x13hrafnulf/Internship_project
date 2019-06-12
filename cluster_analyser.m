function cluster_analyser
clc
clear all


main_window = figure('Name', 'Cluster Analyser', 'Units', 'Normalized', 'Position', [0, 0, 0.6, 0.9], 'Visible', 'off', 'MenuBar', 'none', 'Resize', 'on');

uicontrol('Style', 'pushbutton', 'String', 'Open file', 'Units', 'Normalized', ...
        'Position', [0.73, 0.9, 0.21, 0.05], 'FontWeight', 'bold' , 'FontSize' , 12, 'Callback', @open_file);
uicontrol('Style', 'pushbutton', 'String', 'Save file as', 'Units', 'Normalized', ...
        'Position', [0.73, 0.85, 0.11, 0.05], 'FontWeight', 'bold' ,'FontSize' , 11, 'Callback', @save_file);
uicontrol('Style', 'pushbutton', 'String', 'Save graph as', 'Units', 'Normalized', ...
        'Position', [0.73, 0.8, 0.11, 0.05], 'FontWeight', 'bold' ,'FontSize' , 11,'Callback', @save_graph);
save_method_chosen1 = uicontrol('Style', 'popupmenu', 'String', {'Output graph','Input graph', 'Both graphs'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 12 ,'Position', [0.84, 0.76, 0.1, 0.08]);
save_method_chosen2 = uicontrol('Style', 'popupmenu', 'String', {'Binary (.mat)', 'Text (.txt)'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 12 ,'Position', [0.84, 0.81, 0.1, 0.08]);
uicontrol('Style', 'text', 'String', 'Clustering method', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.73, 0.21, 0.05]);
cluster_method_chosen = uicontrol('Style', 'popupmenu', 'String', { 'K-Means', 'DBSCAN', 'GMM-clusters', 'Hierarchial'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','FontSize' , 11,'Position', [0.73, 0.7, 0.21, 0.05], 'Callback', @m_chosen);
    
%Panel for k-means, hierarchial, gmm
method_panel = uipanel('Parent', main_window, 'Units', 'Normalized', ...
        'Position', [0.73, 0.40, 0.21, 0.3], 'Title', 'Parameters:', 'Visible', 'on');
cluster_num_s = uicontrol('Parent', method_panel, 'Style', 'text', 'String', 'N-Clusters', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.1, 0.8, 0.8, 0.1], 'Visible', 'on');
cluster_num_edt = uicontrol('Parent', method_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.1, 0.7, 0.8, 0.1], 'Visible', 'on');
uicontrol('Parent', method_panel, 'Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.1, 0.2, 0.8, 0.1], 'FontWeight', 'bold' ,'FontSize' , 12, 'Callback', @calculate);

%DBSCAN specific
dbscan_panel = uipanel('Parent', main_window, 'Units', 'Normalized', ...
        'Position', [0.73, 0.40, 0.21, 0.3], 'Title', 'Parameters:', 'Visible', 'off');
dbscan_s1 = uicontrol('Parent', dbscan_panel,'Style', 'text', 'String', 'Epsilon (radius)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.1, 0.8, 0.8, 0.1]);
epsilon =  uicontrol('Parent', dbscan_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.1, 0.7, 0.8, 0.1]);
dbscan_s2 = uicontrol('Parent', dbscan_panel,'Style', 'text', 'String', 'N-Neighbours', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.1, 0.6, 0.8, 0.1]);
min_neigh =  uicontrol('Parent', dbscan_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.1, 0.5, 0.8, 0.1]);
uicontrol('Parent', dbscan_panel, 'Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.1, 0.2, 0.8, 0.1], 'FontWeight', 'bold' ,'FontSize' , 12, 'Callback', @calculate);
%

    
ax1 = axes('Units', 'Normalized', 'Position', [0.05, 0.57, 0.6, 0.40]);
title('Initial Graph','FontWeight','bold');
ylabel('P2','FontSize',10);
xlabel('P1','FontSize',10);
tb1 = axtoolbar(ax1,'default');
tb1.Visible = 'on';

ax2 = axes('Units', 'Normalized', 'Position', [0.05, 0.07, 0.6, 0.40]);   
title('Output Graph','FontWeight','bold');
ylabel('P2','FontSize',10);
xlabel('P1','FontSize',10);
tb2 = axtoolbar(ax2,'default');
tb2.Visible = 'on';

% init
movegui(main_window, 'center');
set(main_window, 'Visible', 'on');
full_filename = [];
input_matrix = [];
filename_for_saving = [];
output_matrix = [];
labels = [];

    function m_chosen(src, event)
        s_method = get(cluster_method_chosen, 'String');
        s_value = get(cluster_method_chosen, 'Value');
        cla(ax2,'reset');
        switch s_method{s_value}
            case 'DBSCAN'
                set(dbscan_panel, 'Visible', 'on');
                set(method_panel, 'Visible', 'off');
            otherwise
                set(dbscan_panel, 'Visible', 'off');
                set(method_panel, 'Visible', 'on');
        end
    end

    function open_file(src, event)
        [filename, pathname] = uigetfile('*.*');
        full_filename = [pathname filename];
        [pathstr, filename_for_saving, ext] = fileparts(full_filename);
        input_matrix = load(full_filename);
        switch ext
            case ".mat"
                input_matrix = input_matrix.D; %specify matrix name that being loaded from file 
        end
        scatter(ax1, input_matrix(:,1), input_matrix(:,2), 'filled');
    end
    
    function fn = get_filename_for_saving()
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        
        switch method{value}
            case 'DBSCAN'
                number_of_clusters = strcat('eps_', eps, '_neighbours_', number_of_neighbours);
        end
        
        fn = strcat(filename_for_saving,'_',method{value},'_params:',number_of_clusters,'_date:',current_date);
    end

    function save_file(src, event)
        
        items = get(save_method_chosen2,'String');
        index_selected = get(save_method_chosen2,'Value');
        save_selected = items{index_selected};
        fileName = get_filename_for_saving();
        
        switch save_selected
            case 'Text (.txt)'
                fileName = strcat(fileName, '.txt');
                dlmwrite(fileName, output_matrix, 'delimiter', ' ');
            otherwise
                fileName = strcat(fileName, '.mat');
                X = output_matrix;
                save(fileName, 'X');
        end
        
        msgbox({'Your file was saved:'; fileName}, 'Success');
       
    end
    function save_graph(src, event)
        
        graphName = get_filename_for_saving();
        
        items = get(save_method_chosen1,'String');
        index_selected = get(save_method_chosen1,'Value');
        save_selected = items{index_selected};
        switch save_selected,
            case 'Both graphs'
                fig = main_window;
                fig.InvertHardcopy = 'off';
                graphName = strcat(graphName,'_', save_selected);
                print(graphName,'-dpng','-noui');
            otherwise
                if(strcmp(save_selected,'Output graph'))
                    ax = ax1;
                else
                    ax = ax2;
                end
                f_new = figure('Visible', 'off');
                f_new.InvertHardcopy = 'off';
                ax_new = copyobj(ax, f_new);
                set(ax_new,'Position','default');
                graphName = strcat(graphName,'_', save_selected);
                print(f_new, graphName,'-dpng');
                close(f_new);
        end
        
        msgbox({'Your graph was saved:'; graphName}, 'Success');
    end 


    function calculate(src,event)
        cla(ax2,'reset');
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        if(isempty(number_of_clusters) & strcmp(method{value}, 'DBSCAN') == 0)
            msgbox('Please enter the number of clusters.', 'Error','error');
        else
            number_of_clusters = str2double(number_of_clusters);
            switch method{value} %check the method for drawing 
            case 'DBSCAN'
                if(isempty(number_of_neighbours) | isempty(eps))
                    msgbox('Please enter the values of epsilon and neighbours', 'Error','error');
                else   
                    number_of_neighbours = str2double(number_of_neighbours);
                    eps = str2double(eps);
                    labels = get_dbscan_result(input_matrix, eps, number_of_neighbours);
                    output_matrix = [input_matrix, labels];
                    draw(max(labels));
                end 
            case 'K-Means'    
                 labels = get_k_means_result(input_matrix, number_of_clusters);
                 output_matrix = [input_matrix, labels];
                 draw(number_of_clusters);
            case 'GMM-clusters'     
                 labels = get_gmm_result(input_matrix, number_of_clusters);
                 output_matrix = [input_matrix, labels];
                 draw(number_of_clusters);
            case 'Hierarchial'     
                 labels = get_hierarchial_result(input_matrix, number_of_clusters);
                 output_matrix = [input_matrix, labels];
                 draw(number_of_clusters);
            end         
        end        
    end

    function draw(n)
            marker = ['+','o','*','.','s','d','^','v','>','<','p','h'];
            colors = ['r', 'g', 'b', 'y', 'm', 'c', 'w', 'k'];
            
            for i = 1:n
                    indexcol = 1 + mod(i, 8);
                    col = colors(indexcol);
                    col2 = colors(8 - indexcol + 1);
                    index = 1 + mod(i, 12);
                    scatter(ax2, output_matrix(labels == i,1), output_matrix(labels == i,2), 'filled', marker(index), 'MarkerFaceColor', col, 'MarkerEdgeColor', col2);
                    hold(ax2, 'on');    
            end
            
            scatter(ax2, output_matrix(labels == 0,1), output_matrix(labels == 0,2), 'filled', 'x', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'b');
            hold(ax2, 'on');
    end
end