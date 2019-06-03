function cluster_analyser

main_window = figure('Name', 'Cluster Analyser', 'Units', 'Normalized', 'Position', [0, 0, 0.8, 0.8], 'Visible', 'off', 'MenuBar', 'none');


uicontrol('Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.73, 0.55, 0.21, 0.05], 'FontWeight', 'bold' ,'Callback', @calculate);
uicontrol('Style', 'pushbutton', 'String', 'Open file', 'Units', 'Normalized', ...
        'Position', [0.73, 0.9, 0.21, 0.05], 'FontWeight', 'bold' ,'Callback', @open_file);
uicontrol('Style', 'pushbutton', 'String', 'Save file', 'Units', 'Normalized', ...
        'Position', [0.73, 0.85, 0.21, 0.05], 'FontWeight', 'bold' ,'Callback', @save_file);
uicontrol('Style', 'pushbutton', 'String', 'Save graph as', 'Units', 'Normalized', ...
        'Position', [0.73, 0.8, 0.11, 0.05], 'FontWeight', 'bold' ,'Callback', @save_graph);
save_method_chosen = uicontrol('Style', 'popupmenu', 'String', {'Output graph', 'Both graphs'}, 'Units', 'Normalized', ...
        'FontAngle','italic','Position', [0.84, 0.76, 0.1, 0.08]);

uicontrol('Style', 'text', 'String', 'Number of clusters', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'Position', [0.73, 0.65, 0.21, 0.05]);
cluster_num_edt = uicontrol('Style', 'edit', 'String', 'Enter the number of clusters', 'Units', 'Normalized', ...
        'FontAngle','italic','Position', [0.73, 0.62, 0.21, 0.05]);
uicontrol('Style', 'text', 'String', 'Clustering method', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'Position', [0.73, 0.73, 0.21, 0.05]);
cluster_method_chosen = uicontrol('Style', 'popupmenu', 'String', {'DBSCAN', 'K-Means', 'GMM-clusters', 'Hierarchial'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','Position', [0.73, 0.7, 0.21, 0.05]);
    
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
full_filename = []

    function open_file(src, event)
        [filename, pathname] = uigetfile('Open cluster file name');
        full_filename = [pathname filename]   
   
    end 
    function save_file(src, event)
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        if(strcmp(number_of_clusters,'Enter the number of clusters'))
            number_of_clusters = 'Null';
        end
        fileName = strcat(full_filename, method{value},'_Nclusters=',number_of_clusters,'_',current_date);
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
        graphName = strcat(full_filename, method{value},'_Nclusters=',number_of_clusters,'_',current_date);
        
        items = get(save_method_chosen,'String');
        index_selected = get(save_method_chosen,'Value');
        save_selected = items{index_selected};
        disp(save_selected);
        
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


    function calculate(src,event) 
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        if(number_of_clusters == 'Enter the number of clusters')
            msgbox('Please enter the number of clusters.', 'Error','error')
        else
            number_of_clusters = str2num(number_of_clusters);
            switch method{value} %kmeans, clusterdata and dendrogram, cluster 
            case 'DBSCAN'
                msgbox('DBSCAN clusterization')
                disp(number_of_clusters)
                %[p1, p2] = get_dbscan_result(full_filename, number_of_clusters)
            case 'K-Means'
                 msgbox('K-Means clusterization')
                 disp(number_of_clusters)
                 %[p1, p2] = get_k_means_result(full_filename, number_of_clusters)
            case 'GMM-clusters'
                 msgbox('GMM clusterization')
                 disp(number_of_clusters)
                 %[p1, p2] = get_gmm_result(full_filename, number_of_clusters)
            case 'Hierarchial'
                 msgbox('Hierarchial clusterization')
                 disp(number_of_clusters)
                 %[p1, p2] = get_hierarchial_result(full_filename, number_of_clusters)
            end  
        end
    end
end