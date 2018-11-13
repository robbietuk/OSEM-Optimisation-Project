% Demo of how to use STIR from matlab to reconstruct some data

% Copyright 2012-06-05 - 2013 Kris Thielemans
% Copyright 2014, 2015 - University College London
% This file is part of STIR.
%
% This file is free software; you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation; either version 2.1 of the License, or
% (at your option) any later version.
%
% This file is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% See STIR/LICENSE.txt for details
clear;clc;


%% go to directory with input files
cd DEMOS/recon_demo
%% initialise reconstruction object
% we will do this here via a .par file 
recon=stir.OSMAPOSLReconstruction3DFloat('recon_demo_OSEM.par');

%% now modify a few settings from in MATLAB for illustration
recon.set_num_subsets(2);
% set filenames to save subset sensitivities (for illustration purposes)
poissonobj=recon.get_objective_function();
poissonobj.set_subsensitivity_filenames('sens_subset%d.hv');
poissonobj.set_recompute_sensitivity(true)

%% get initial image
target=stir.FloatVoxelsOnCartesianGrid.read_from_file('init.hv');
% we will just fill the whole array with 1 here
target.fill(1)
cd ../..
%% run a few iterations and plot intermediate results
s=recon.set_up(target);
figure()
hold on;


for iter=1:2
    fprintf( '\n--------------------- Subiteration %d\n', iter);
    recon.set_start_subiteration_num(iter)
    recon.set_num_subiterations(iter)
    s=recon.reconstruct(target);
    % currently we need to explicitly prevent recomputing sensitivity when we
    % call reconstruct() again in the next iteration
    poissonobj.set_recompute_sensitivity(false)
    % extract to matlab for plotting
    image=target.to_matlab();

    % Output data per iter.
    investigate_slice = 8;
    subplot(2,1,1); plot(image(:,30,investigate_slice))
    subplot(2,1,2); imshow(image(:,:,investigate_slice),[],'InitialMagnification','fit'); colorbar;
    pause(.5)
    drawnow
end


% %plot slice of final image
% figure()
% for i=1:31
%     imshow(image(:,:,i),[],'InitialMagnification','fit'); title('slice: 'i);
%     drawnow
%     pause(.5);
% end


vis3d(image,'parula')
