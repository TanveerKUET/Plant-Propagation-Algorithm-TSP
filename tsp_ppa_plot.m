%read the co-ordinates from the input file
[coordinates] = xlsread('burma14.csv');

%plot the cities
plot(coordinates(:,1),coordinates(:,2));
%find out the rowsize and the column size
[rowsize, colsize] = size(coordinates);
citySize = rowsize;
lastval = citySize+1;
initialcordinate = zeros(lastval,2);
for i=1:citySize
    %v = r1(i,1);
    initialcordinate(i,1) = coordinates(i,1);
    initialcordinate(i,2) = coordinates(i,2);
end
%now add the starting city coordinate
initialcordinate(lastval,1) = coordinates(1,1);
initialcordinate(lastval,2) = coordinates(1,2);
%plot the cities
plot(initialcordinate(:,1),initialcordinate(:,2));
% delcare a matrix for the city distance
data = zeros(rowsize,rowsize);
%now calculate the distance among the cities
for i=1:rowsize
    for j=1:rowsize
        distance = sqrt((coordinates(i,1)-coordinates(j,1))^2+(coordinates(i,2)-coordinates(j,2))^2);
        data(i,j) = distance;
    end
end

N = 50;      
m = rowsize; %number of city

kmax = 100; 
y = 50;  %arbitrary value of y
r1 = rand(m,N);      
                    
for i=1:N
    r1(:,i)= randperm(m,m); 
end
for test_no = 1:kmax 
    f = zeros(1,N);         
    %Now calculating the path cost
    for a=1:N
        pathCost =0;
        j=2;
        loopval = m-1;
        for i=1:loopval
            row = r1(i,a);
            col = r1(j,a);
            pathCost = pathCost+data(row,col);
            j=j+1;
        end
        firstCity = r1(1,a);
        lastCity = r1(14,a);
        pathCostfst_last = data(firstCity,lastCity);
        totalPathcost = pathCost + pathCostfst_last;
        %fprintf('Total path cost of this solution: %f\n', totalPathcost);
        f(1,a) = totalPathcost; %Adding the path cost of 1st and last
    end
    %sort the cost
    f_sorted = sort(f,'ascend');
    %then sort the solution with respect to the sorted value
    for j=1:N
        r1(:,j) = r1(:,find(f==f_sorted(j),1));
    end

    %Now generate short runners for 10% TOP best solution
    shortVal = N/10;
    
    for i=1:shortVal
        %take an arbitray number of y
        %y = randperm(m,1);
        short = ceil(y/i);
        srunner = rand(m,short); %short runners
        for j=1:short
            randomNumber = randi(m,2);
            %swap the random indexed city to generate new solution from short
            %runners to exploit
            tmp = r1(:,i);     %temporarily keep the column of r1

            swapPosition1 = randomNumber(1,1);
            swapPosition2 = randomNumber(2,2);
            swap = tmp (swapPosition1);
            tmp (swapPosition1) = tmp (swapPosition2);
            tmp (swapPosition2) = swap;
            srunner(:,j)= tmp; %generate short number of short runner

            %calculate the path cost
            q=2;
            tmppathCost=0;
                for p=1:loopval
                    row = srunner(p,j);
                    col = srunner(q,j);
                    tmppathCost = tmppathCost+data(row,col);
                    q=q+1;
                end
                firstCity = srunner(1,j);
                lastCity = srunner(14,j);
                pathCostfst_last = data(firstCity,lastCity);
                tmppathCost = tmppathCost + pathCostfst_last;
                %fprintf('Total path cost of this short runner: %f\n', tmppathCost);
            if f_sorted(i)>tmppathCost
               r1(:,i) = srunner(:,j);
            else
                %Ignore srunner
            end
        end    
    end

    %Now work for long runner

    for i=shortVal+1:N
        %lrunner = rand(m,1); 
        randomlong = randperm(m,3); %generate the value of k to apply k-opt rule k>2
        lrunner = r1(:,i); %temporarily keep the column of r1
        swap = lrunner(randomlong(1));
        lrunner(randomlong(1)) = lrunner(randomlong(2));
        lrunner(randomlong(2)) = lrunner(randomlong(3));
        lrunner(randomlong(3)) = swap;
        %calculate the path cost
            q=2;
            tmppathCost=0;
                for p=1:loopval
                    row = lrunner(p,1);
                    col = lrunner(q,1);
                    tmppathCost = tmppathCost+data(row,col);
                    q=q+1;
                end
                firstCity = lrunner(1,1);
                lastCity = lrunner(14,1);
                pathCostfst_last = data(firstCity,lastCity);
                tmppathCost = tmppathCost + pathCostfst_last;
            if f_sorted(i)>tmppathCost
               r1(:,i) = lrunner;
            else
                %Ignore srunner
            end
    end
finalcordinate = zeros(lastval,2);
for i=1:rowsize
    v = r1(i,1);
    finalcordinate(i,1) = coordinates(v,1);
    finalcordinate(i,2) = coordinates(v,2);
end
%now add the starting city coordinate
v = r1(1,1);
finalcordinate(15,1) = coordinates(v,1);
finalcordinate(15,2) = coordinates(v,2);
    
plot(finalcordinate(:,1),finalcordinate(:,2));
fprintf('\n so far obtained best solution is %f\n', f_sorted(1,1));
soln = r1(:,1);
soln = soln.';
display(soln);
end
soln = r1(:,1);
soln = soln.';
display(soln);
display(f_sorted(1,1));
plot(finalcordinate(:,1),finalcordinate(:,2));

