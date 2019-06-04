function cluster_analyser

main_window = figure('Name', 'Cluster Analyser', 'Units', 'Normalized', 'Position', [0, 0, 0.8, 0.8], 'Visible', 'off', 'MenuBar', 'none');
zoom on;

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

uicontrol('Style', 'text', 'String', 'Number of clusters', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.65, 0.21, 0.05]);
cluster_num_edt = uicontrol('Style', 'edit', 'String', 'Enter the number of clusters', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 11,'Position', [0.73, 0.62, 0.21, 0.05]);
uicontrol('Style', 'text', 'String', 'Clustering method', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.73, 0.73, 0.21, 0.05]);
cluster_method_chosen = uicontrol('Style', 'popupmenu', 'String', {'DBSCAN', 'K-Means', 'GMM-clusters', 'Hierarchial'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','FontSize' , 11,'Position', [0.73, 0.7, 0.21, 0.05]);
    
ax1 = axes('Units', 'Normalized', 'Position', [0.05, 0.57, 0.6, 0.40]);
title('Initial Graph','FontWeight','bold')
ylabel('P2','FontSize',10);
xlabel('P1','FontSize',10);
ax2 = axes('Units', 'Normalized', 'Position', [0.05, 0.07, 0.6, 0.40]);   
title('Output Graph','FontWeight','bold')
ylabel('P2','FontSize',10);
xlabel('P1','FontSize',10);

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
        input_matrix = load(full_filename);
        scatter(ax1, input_matrix(:,1), input_matrix(:,2), 'filled');
    end
    function save_file(src, event)
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        if(strcmp(number_of_clusters,'Enter the number of clusters'))
            number_of_clusters = 'Null';
        end
        
        items = get(save_method_chosen2,'String');
        index_selected = get(save_method_chosen2,'Value');
        save_selected = items{index_selected};
        fileName = []
        if(strcmp(save_selected, 'Text (.txt)'))
            fileName = strcat(filename_for_saving,'_',method{value},'_Nclusters=',number_of_clusters,'_',current_date, '.txt');
            dlmwrite(fileName, output_matrix, 'delimiter', ' ');
        elseif(strcmp(save_selected,'Binary (.mat)'))
            fileName = strcat(filename_for_saving, '_', method{value},'_Nclusters=',number_of_clusters,'_',current_date, '.mat');
            save(fileName, 'output_matrix');
        end
        
        msgbox({'Your file was saved:'; fileName}, 'Success');
        %uiputfile
        %save
        %uisave
        %write, fwrite, export
        %use table container, readtable
    end
    function save_graph(src, event)
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        if(strcmp(number_of_clusters,'Enter the number of clusters'))
            number_of_clusters = 'Null';
        end
        graphName = strcat(filename_for_saving, '_', method{value},'_Nclusters=',number_of_clusters,'_',current_date);
        
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
centroids = []
    function calculate(src,event) 
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        if(strcmp(number_of_clusters, 'Enter the number of clusters'))
            msgbox('Please enter the number of clusters.', 'Error','error')
        else
            number_of_clusters = str2num(number_of_clusters);
            switch method{value} %kmeans, clusterdata and dendrogram, cluster 
            case 'DBSCAN'
                msgbox('DBSCAN clusterization')
               
                %label = get_dbscan_result(input_matrix, number_of_clusters)
            case 'K-Means'
                 msgbox('K-Means clusterization')
                
                 [labels, colors] = get_k_means_result(input_matrix, number_of_clusters)   
            case 'GMM-clusters'
                 msgbox('GMM clusterization')
                 
                 %label = get_gmm_result(input_matrix, number_of_clusters)
            case 'Hierarchial'
                 msgbox('Hierarchial clusterization')
                 
                 %label = get_hierarchial_result(input_matrix, number_of_clusters)
            end
            output_matrix = [input_matrix, labels];
            marker = ['+','o','*','.','x','s','d','^','v','>','<','p','h'];
            for i = 1:number_of_clusters
                check = labels == i;
                col = colors(i,:); 
                index = 1 + mod(i, 13);
                scatter(ax2, output_matrix(check,1), output_matrix(check,2), 'filled', marker(index), 'MarkerFaceColor', col);
                hold(ax2, 'on');
            end
            hold(ax2, 'off');
        end
    end
end