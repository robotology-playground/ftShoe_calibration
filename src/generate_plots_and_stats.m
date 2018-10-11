function [ stats ] = generate_plots_and_stats( indata, saveFigs, dataPath, folderName, devNames, generateStats )
    stats = NaN;
    if strcmp(saveFigs,'True')
       mkdir(char(strcat(dataPath, '/', folderName,  '/figs')))
    end
    if strcmp(generateStats,'True')
        mkdir(char(strcat(dataPath, '/', folderName,  '/stats')))
    end
    exps = fieldnames(indata);
    for e = 1 : size(exps,1)
        for d = 1 : size(devNames,2)
            figure('Name', strcat(exps{e}, ' Wrenches - ', devNames{d}));
            pos = get(gcf,'pos');
            set(gcf,'pos',[pos(1)-200 pos(2)-300 1280 720])
            
            ftsNames = fieldnames(indata.(exps{e}).fts);
            amtiNames = fieldnames(indata.(exps{e}).amtiInFtsSoR);
            
            if strcmp(generateStats,'True')
                stats.(exps{e}).(devNames{d}).r2 = [];
                stats.(exps{e}).(devNames{d}).rmse = [];
            end
            
            times.fts = indata.(exps{e}).fts.(ftsNames{d}).time - indata.(exps{e}).fts.(ftsNames{d}).time(1);
            times.amti = indata.(exps{e}).amtiInFtsSoR.(amtiNames{d}).time - indata.(exps{e}).amtiInFtsSoR.(amtiNames{d}).time(1);
            
            plotTitles = {'X Force', 'Y Force', 'Z Force', 'X Moment', 'Y Moment', 'Z Moment' };
            
            for j = 1 : size(indata.(exps{e}).fts.(ftsNames{d}).data,2)
                subplot(2,size(indata.(exps{e}).fts.(ftsNames{d}).data,2)/2,j);

                hold on;
                grid on;

                      
                y1 = indata.(exps{e}).fts.(ftsNames{d}).data(:, j);
                y2 = indata.(exps{e}).amtiInFtsSoR.(amtiNames{d}).data(:,j);
                %mean1 = mean(y1);
                %mean2 = mean(y2);
                %y2 = y2 - mean2 + mean1;

                if strcmp(generateStats,'True')
                    r = corrcoef(y1,y2);
                    stats.(exps{e}).(devNames{d}).r2 = [stats.(exps{e}).(devNames{d}).r2, (r(2,1))^2];
                    stats.(exps{e}).(devNames{d}).rmse = [stats.(exps{e}).(devNames{d}).rmse , rms(y1 - y2)];
                end
                
                set(gca,'fontsize',16)
                title(plotTitles(j));
                xlabel('Time [s]');
                if (j < 4)
                    ylabel('Force [N]') 
                else
                    ylabel('Moment [Nm]')
                end
                
                plot(times.fts, y1, 'r', 'LineWidth', 2);
                plot(times.amti, y2, 'k', 'LineWidth', 2);
                

                xlim([times.fts(1), times.fts(end)]);

                %legend(strcat('Amti platform - ',taskData.amtiNames{a}),strcat('ftShoe - ',taskData.ftNames{a}));
                legend('ftShoes','forceplates');
            end
            if strcmp(saveFigs,'True')
                figname = strcat(dataPath, '/', folderName, '/figs/',exps{e}, '_Wrenches_', devNames{d});
                print(figname, '-dpng')
                close all
            end
%             close all
        end
    end
    
    % Generate a csv file for stats
    if strcmp(generateStats,'True')
        fileID = fopen(strcat(dataPath, '/', folderName, '/stats/', 'rsquare.log'),'w');
        fprintf(fileID,'%12s\t\t\t\t\t\t%12s\t\t\t\t\t\n',devNames{1}, devNames{2});
        fprintf(fileID,'%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\n','trial', 'fx', 'fy', 'fz', 'mx', 'my', 'mz','fx', 'fy', 'fz', 'mx', 'my', 'mz');
        for e = 1 : size(exps,1)
                fprintf(fileID,'%6s\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\n', ...
                    exps{e}, stats.(exps{e}).(devNames{1}).r2', stats.(exps{e}).(devNames{2}).r2)';  
        end
        fclose(fileID);

        fileID = fopen(strcat(dataPath, '/', folderName, '/stats/', 'rmse.log'),'w');
        fprintf(fileID,'%12s\t\t\t\t\t\t%12s\t\t\t\t\t\n',devNames{1}, devNames{2});
        fprintf(fileID,'%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\n','trial','fx', 'fy', 'fz', 'mx', 'my', 'mz','fx', 'fy', 'fz', 'mx', 'my', 'mz');
        for e = 1 : size(exps,1)
                fprintf(fileID,'%6s\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%6.4f\n', ...
                    exps{e}, stats.(exps{e}).(devNames{1}).rmse, stats.(exps{e}).(devNames{2}).rmse);  
        end
        fclose(fileID);
    end
end


