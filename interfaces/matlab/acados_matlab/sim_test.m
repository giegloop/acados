%% test of native matlab interface

%% compile mex files
% mex -v GCC='/usr/bin/gcc-4.9' ... (-v for verbose, GCC=... to change compiler)

% get acados folder (if set)
acados_folder = getenv('ACADOS_FOLDER');
% default folder
if length(acados_folder) == 0
	acados_folder = '../../../';
end
% set paths
acados_include = ['-I' acados_folder];
acados_interfaces_include = ['-I' acados_folder, 'interfaces'];
acados_lib_path = ['-L' acados_folder, 'lib'];

% compile mex
mex_files ={'sim_create.c',
	'sim_destroy.c',
	'sim_ext_fun_destroy.c',
	'sim_solve.c',
	'sim_set.c',
	'sim_get.c',
	'sim_set_model.c'} ;

for ii=1:length(mex_files)
	mex(acados_include, acados_interfaces_include, acados_lib_path, '-lacados_c', '-lacore', '-lhpipm', '-lblasfeo', mex_files{ii})
end



%% arguments
scheme = 'irk';
sens_forw = 'true';
num_stages = 4;
num_steps = 3;
codgen_model = 'true';



%% model
%model = linear_model;
model = linear_mass_spring_model;
%model = crane_model;

nx = model.nx;
nu = model.nu;



%% acados integrator model
sim_model = acados_integrator_model();
sim_model.set('T', 0.5);
if (strcmp(scheme, 'erk'))
	sim_model.set('type', 'expl');
	sim_model.set('expr', model.expr_expl);
	sim_model.set('sym_x', model.sym_x);
	if isfield(model, 'sym_u')
		sim_model.set('sym_u', model.sym_u);
	end
	sim_model.set('nx', model.nx);
	sim_model.set('nu', model.nu);
else % irk
	sim_model.set('type', 'impl');
	sim_model.set('expr', model.expr_impl);
	sim_model.set('sym_x', model.sym_x);
	sim_model.set('sym_xdot', model.sym_xdot);
	if isfield(model, 'sym_u')
		sim_model.set('sym_u', model.sym_u);
	end
%	if isfield(model, 'sym_z')
%		sim_model.set('sym_z', model.sym_z);
%	end
	sim_model.set('nx', model.nx);
	sim_model.set('nu', model.nu);
%	sim_model.set('nz', model.nz);
end
%sim_model.model_struct




%% acados integrator opts
sim_opts = acados_integrator_opts();
sim_opts.set('codgen_model', codgen_model);
sim_opts.set('num_stages', num_stages);
sim_opts.set('num_steps', num_steps);
sim_opts.set('scheme', scheme);
sim_opts.set('sens_forw', sens_forw);



%% acados integrator
% create integrator
sim = acados_integrator(sim_model, sim_opts);
% (re)set numerical part of model
%sim.set('T', 0.5);

x0 = ones(sim_model.nx, 1); %x0(1) = 2.0;
tic;
sim.set('x', x0);
time_set_x = toc

u = ones(nu, 1);
sim.set('u', u);

% solve
tic;
sim.solve();
time_solve = toc


% get TODO with return value !!!!!
% xn
xn = zeros(nx, 1);
sim.get('xn', xn);
xn
% S_forw
S_forw = zeros(nx, nx+nu);
sim.get('S_forw', S_forw);
S_forw
% Sx
Sx = zeros(nx, nx);
sim.get('Sx', Sx);
Sx
% Su
Su = zeros(nx, nu);
sim.get('Su', Su);
Su


fprintf('\nsuccess!\n\n');


return;