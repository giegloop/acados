// system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
// acados
#include "acados/utils/external_function_generic.h"
#include "acados_c/external_function_interface.h"
// mex
#include "mex.h"



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
	{

//	mexPrintf("\nin ocp_ext_fun_destroy\n");

	long long *ptr;



	/* RHS */

	// opts_struct

	// TODO use them !!!
//	bool sens_forw = mxGetScalar( mxGetField( prhs[0], 0, "sens_forw" ) );
//	mexPrintf("\n%d\n", sens_forw);
	char *sim_solver = mxArrayToString( mxGetField( prhs[0], 0, "sim_solver" ) );
//	mexPrintf("\n%s\n", sim_solver);


	// TODO check for empty struct member


	/* free memory */

	if(!strcmp(sim_solver, "erk"))
		{
		// C_ocp_ext_fun

		// expl_ode_fun
		ptr = (long long *) mxGetData( mxGetField( prhs[1], 0, "expl_ode_fun" ) );
		external_function_casadi *expl_ode_fun = (external_function_casadi *) ptr[0];
		// expl_vde_for
		ptr = (long long *) mxGetData( mxGetField( prhs[1], 0, "expl_vde_for" ) );
		external_function_casadi *expl_vde_for = (external_function_casadi *) ptr[0];
		// expl_vde_adj
		ptr = (long long *) mxGetData( mxGetField( prhs[1], 0, "expl_vde_adj" ) );
		external_function_casadi *expl_vde_adj = (external_function_casadi *) ptr[0];

		// free external functions
		external_function_casadi_free(expl_ode_fun);
		external_function_casadi_free(expl_vde_for);
		free(expl_ode_fun);
		free(expl_vde_for);
		}
	else if(!strcmp(sim_solver, "irk"))
		{
		// C_ocp_ext_fun

		// impl_ode_fun
		ptr = (long long *) mxGetData( mxGetField( prhs[1], 0, "impl_ode_fun" ) );
		external_function_casadi *impl_ode_fun = (external_function_casadi *) ptr[0];
		// impl_ode_fun_jac_x_xdot
		ptr = (long long *) mxGetData( mxGetField( prhs[1], 0, "impl_ode_fun_jac_x_xdot" ) );
		external_function_casadi *impl_ode_fun_jac_x_xdot = (external_function_casadi *) ptr[0];
		// impl_ode_jac_x_xdot_u
		ptr = (long long *) mxGetData( mxGetField( prhs[1], 0, "impl_ode_jac_x_xdot_u" ) );

		// free external functions
		external_function_casadi *impl_ode_jac_x_xdot_u = (external_function_casadi *) ptr[0];
		external_function_casadi_free(impl_ode_fun);
		external_function_casadi_free(impl_ode_fun_jac_x_xdot);
		external_function_casadi_free(impl_ode_jac_x_xdot_u);
		free(impl_ode_fun);
		free(impl_ode_fun_jac_x_xdot);
		free(impl_ode_jac_x_xdot_u);
		}
	else
		{
		mexPrintf("\nocp_ext_fun_destroy: sim_solver not supported %s\n", sim_solver);
		return;
		}




	/* return */

	return;

	}

