clc
cd 'F:\results\SDCT\scale_1_20'
mat = dir('*.mat');

for i=1:size(mat)
    times_vector(i)=load(mat(i).name);
    final_times(i)= times_vector(i).time;
end
median(final_times)