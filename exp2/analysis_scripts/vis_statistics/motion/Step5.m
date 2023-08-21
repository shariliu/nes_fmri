


%% avg energy at each temporal frequency
speed1 = gparams.gaborparams(5,:) == 0; 
speed2 = round(gparams.gaborparams(5,:)) == round(1.333);
speed3 = round(gparams.gaborparams(5,:)) == round((8/3));

speedData = [mean(mean(S_fin(:,speed1))) ...
mean(mean(S_fin(:,speed2))) ...
mean(mean(S_fin(:,speed3)))];



%% avg energy at each spatial frequency
size1 = round(gparams.gaborparams(4,:)) == round(0); 
size2 = round(gparams.gaborparams(4,:)) == round(1.5);
size3 = round(gparams.gaborparams(4,:)) == round(3);
size4 = round(gparams.gaborparams(4,:)) == round(6);
size5 = round(gparams.gaborparams(4,:)) == round(12);
size6 = round(gparams.gaborparams(4,:)) == round(24);

sizeData = [mean(mean(S_fin(:,size1))) ...
mean(mean(S_fin(:,size2))) ...
mean(mean(S_fin(:,size3))) ...
mean(mean(S_fin(:,size4))) ...
mean(mean(S_fin(:,size5))) ...
mean(mean(S_fin(:,size6)))];