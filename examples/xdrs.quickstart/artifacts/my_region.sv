/*******************************************************************************   
 * Copyright (c) 2012, Lingkan Gong                                                
 * All rights reserved.                                                            
 *                                                                                 
 * Redistribution and use in source and binary forms, with or without              
 * modification, are permitted provided that the following conditions are met:     
 *                                                                                 
 *  * Redistributions of source code must retain the above copyright notice,       
 *    this list of conditions and the following disclaimer.                        
 *                                                                                 
 *  * Redistributions in binary form must reproduce the above copyright notice,    
 *    this list of conditions and the following disclaimer in the documentation    
 *    and/or other materials provided with the distribution.                       
 *                                                                                 
 *  * Neither the name of the copyright holder(s) nor the names of its             
 *    contributor(s) may be used to endorse or promote products derived from this  
 *    software without specific prior written permission.                          
 *                                                                                 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY           
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES      
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;    
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND     
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT      
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS   
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                    
 *                                                                                 
*******************************************************************************/   

`timescale 1ns/1ps

import ovm_pkg::*;
import mti_fli::*;
import rsv_solyr_pkg::*;
import usr_solyr_pkg::*;

`include "ovm_macros.svh"
`include "rsv_defines.svh"

module my_region
(
	input           clk             ,
	input           rstn            ,
	input           rc_reqn         ,
	output          rc_ackn         ,
	output          p_prdy          ,
	input           p_crdy          ,
	input           p_cerr          ,
	output  [31:0]  p_data          ,
	input           c_prdy          ,
	output          c_crdy          ,
	output          c_cerr          ,
	input   [31:0]  c_data          
);

//-------------------------------------------------------------------
// Declarations
//-------------------------------------------------------------------

	`define NUM_RM 2 // Number of reconfigurable modules in this region
	`define NUM_FR 4 // Number of configuration frames of this region

	typedef virtual interface my_if my_if_type;
	typedef virtual interface portal_if#(`NUM_RM) portal_if_type;
	typedef virtual interface state_if#(`NUM_FR) state_if_type;

	`define rsv_init_portal(rmid_, pif, nm_, sgnt_) begin    \
		pif.module_names[rmid_] = nm_;                       \
		pif.module_sgnts[rmid_] = sgnt_;                     \
	end

	`define rsv_select_module_out(sig_)                 \
	always @(*) begin case (pif.active_module_id)       \
		8'h0: begin rm_rif.sig_ = rm0_rif.sig_; end \
		8'h1: begin rm_rif.sig_ = rm1_rif.sig_; end \
		default: begin rm_rif.sig_ = rm0_rif.sig_; end  \
	endcase end
	
	`define rsv_select_module_in(sig_)                  \
	always @(*) begin case (pif.active_module_id)       \
		8'h0: begin rm0_rif.sig_ = rm_rif.sig_; end \
		8'h1: begin rm1_rif.sig_ = rm_rif.sig_; end \
		default: begin rm0_rif.sig_ = rm_rif.sig_; end  \
	endcase end
	
	`define rsv_select_phase_out(sig_)                  \
	always @(*) begin case (pif.reconf_phase)           \
		8'h0: begin sta_rif.sig_ = rm_rif.sig_; end     \
		8'h1: begin if (eif.sei_en) sta_rif.sig_ = sei_rif.sig_; if (eif.dei_en) dei_rif.sig_ = rm_rif.sig_; end \
		default: begin sta_rif.sig_ = rm_rif.sig_; end  \
	endcase end
	
	`define rsv_select_phase_in(sig_)                   \
	always @(*) begin case (pif.reconf_phase)           \
		8'h0: begin rm_rif.sig_ = sta_rif.sig_; end     \
		8'h1: begin if (eif.dei_en) rm_rif.sig_ = dei_rif.sig_; if (eif.dei_en) sei_rif.sig_ = sta_rif.sig_; end \
		default: begin rm_rif.sig_ = sta_rif.sig_; end  \
	endcase end
	
//-------------------------------------------------------------------
// Selecting the active reconfigurable module
//-------------------------------------------------------------------

	// Portal interface:
	//
	// The portal selects the current active module and the reconfiguration 
	// phase. The source of portal selection is from the class-based environment

	portal_if #(`NUM_RM) pif();
	
	initial begin
		`rsv_init_portal(0, pif, "maximum", 32'h419f137f)
		`rsv_init_portal(1, pif, "reverse", 32'ha33c265b)

	end
	
	// Selecting IO signals of the dynamic side:
	//
	// The IO signals of parallel connected reconfigurable modules 
	// (dynamic side) are interleaved and only one set of IO signals 
	// is active at a time. The selection mimics the swapping of modules 
	// and is controlled by the portal interface, which is in turn 
	// driven by the class-based environment. 

	my_if    rm0_rif(); // reconfigurable module 0
	my_if    rm1_rif(); // reconfigurable module 1
	my_if    rm_rif();  // current active module

	`rsv_select_module_in ( clk              )
	`rsv_select_module_in ( rstn             )
	`rsv_select_module_in ( rc_reqn          )
	`rsv_select_module_out( rc_ackn          )
	`rsv_select_module_out( p_prdy           )
	`rsv_select_module_in ( p_crdy           )
	`rsv_select_module_in ( p_cerr           )
	`rsv_select_module_out( p_data           )
	`rsv_select_module_in ( c_prdy           )
	`rsv_select_module_out( c_crdy           )
	`rsv_select_module_out( c_cerr           )
	`rsv_select_module_in ( c_data           )

	// Connecting IO signals of the static side:
	//
	// The IO signals of the static part of the user logic (static side)
	// are connected to the reconfigurable modules during normal opertion, 
	// or to the error sources during partial reconfiguration. 

	my_if    sta_rif();

	assign sta_rif.clk              = clk                     ;
	assign sta_rif.rstn             = rstn                    ;
	assign sta_rif.rc_reqn          = rc_reqn                 ;
	assign rc_ackn                  = sta_rif.rc_ackn         ;
	assign p_prdy                   = sta_rif.p_prdy          ;
	assign sta_rif.p_crdy           = p_crdy                  ;
	assign sta_rif.p_cerr           = p_cerr                  ;
	assign p_data                   = sta_rif.p_data          ;
	assign sta_rif.c_prdy           = c_prdy                  ;
	assign c_crdy                   = sta_rif.c_crdy          ;
	assign c_cerr                   = sta_rif.c_cerr          ;
	assign sta_rif.c_data           = c_data                  ;

//-------------------------------------------------------------------
// Selecting the reconfiguration phase
//-------------------------------------------------------------------

	// Error interface: 
	//
	// During reconfiguration, errors are injected to both static region (SEI) 
	// and the active reconfigurable module in the dynamic region (DEI). The 
	// selection of reconfiguration phase is controlled by the portal interface 
	// whereas the error interface enables/disables the error sources. Both 
	// interfaces are driven by the class-based environment

	error_if eif();

	always @(*) begin
		eif.active_module_id   = pif.active_module_id;
		eif.reconf_phase       = pif.reconf_phase;
	end
	
	// Selecting the error sources:
	//
	// Error injection mimics the un-defined output to both static & dynamic 
	// sides DURING reconfiguration. Errors injected towoards the static 
	// side stress tests the isolation mechanism of user logic; errors
	// injected to the dynamic side mimics the undifined state of 
	// reconfigurable modules, and assists the testing of the initialization 
	// mechanism of the user logic. The source of the error comes from the 
	// class-based environment
	
	my_if    sei_rif(); // error source to the static side
	my_if    dei_rif(); // error source to the dynamic side
	
	`rsv_select_phase_in ( clk              )
	`rsv_select_phase_in ( rstn             )
	`rsv_select_phase_in ( rc_reqn          )
	`rsv_select_phase_out( rc_ackn          )
	`rsv_select_phase_out( p_prdy           )
	`rsv_select_phase_in ( p_crdy           )
	`rsv_select_phase_in ( p_cerr           )
	`rsv_select_phase_out( p_data           )
	`rsv_select_phase_in ( c_prdy           )
	`rsv_select_phase_out( c_crdy           )
	`rsv_select_phase_out( c_cerr           )
	`rsv_select_phase_in ( c_data           )

//-------------------------------------------------------------------
// State saving/restoring
//-------------------------------------------------------------------

	// State interface:
	//
	// On capture or restore, the state interface is synchronized
	// with the HDL signals (i.e., GCAPTURE: HDL->configuration 
	// memory, GRESTORE: configuration memory -> HDL).
	// 
	// The configuration data is stored in the state interface. 
	// and is maintained by the state_spy artifacts of the class-based part. 
	
	state_if #(`NUM_FR)  rm_sif();
	
	chandle interp;
	initial begin
		interp = mti_Interp();
		
		`rsv_execute_tcl(interp, $psprintf("ReSim::rsv_register_state_spy %m rm0 ./artifacts/spy/my_region_rm0.sll ./artifacts/sbt/my_region_rm0.sbt"))
		`rsv_execute_tcl(interp, $psprintf("ReSim::rsv_register_state_spy %m rm1 ./artifacts/spy/my_region_rm1.sll ./artifacts/sbt/my_region_rm1.sbt"))

	end
	
	always @(*) begin
		rm_sif.active_module_id   = pif.active_module_id;
		rm_sif.reconf_phase       = pif.reconf_phase;
		rm_sif.signature          = pif.module_sgnts[pif.active_module_id];
	end

//-------------------------------------------------------------------
// Functional Coverage for module swapping
//-------------------------------------------------------------------

`ifdef MTI_QUESTA

	covergroup cvg_my_region_drp @pif.active_module_id;
		active_module: coverpoint pif.active_module_id {
			bins cur[] = {[0:`NUM_RM-1]};
			illegal_bins other = default;
		}
		module_transition: coverpoint pif.active_module_id {
			bins cfg[] = ([0:`NUM_RM-1] => [0:`NUM_RM-1]);
			ignore_bins cfg_no_change = (0=>0),(1=>1);
			illegal_bins other = default sequence;
		}
	endgroup
	
	cvg_my_region_drp cvg_0 = new;

`endif

//-------------------------------------------------------------------
// Configuring the Simulation-only Layer
//-------------------------------------------------------------------

	// Pass the interface(s) to the virtual interface(s) in solyr,
	// & parameterize the testbench classes with the user-defined interface(s)

	initial begin

		// Mentor Graphics reconmmend to wrap the interface into a class and use
		// set_config_object to pass interface of module-based DUT to the
		// virtual interface of the class-based verification environment.
		// Here, the convenient macro set_config_interface help you to do that

		`set_config_interface(rsv_if_wrapper #(portal_if_type), "*.rr0.pc", "pif_tag", pif)
		`set_config_interface(rsv_if_wrapper #(state_if_type), "*.rr0.ss", "spy_tag", rm_sif)
		`set_config_interface(rsv_if_wrapper #(error_if_type), "*.rr0.ei", "ei_tag", eif)
		`set_config_interface(rsv_if_wrapper #(my_if_type), "*.rr0.ei", "sei_tag", sei_rif)
		`set_config_interface(rsv_if_wrapper #(my_if_type), "*.rr0.ei", "dei_tag", dei_rif)
		`set_config_interface(rsv_if_wrapper #(my_if_type), "*.rr0.rec", "rec_tag", sta_rif)

		// Set number of reconfigurable modules to the desired value
		// Set number of words in the spy memory to the desired value
		// Set number of signals in the state spy to the desired value

		set_config_int("*.rr0.pc", "num_rm", `NUM_RM);
		set_config_int("*.rr0.ss", "num_fr", `NUM_FR);

		// Set instantiation hierarchy path in artifacts 
		
		set_config_string("*.rr0.pc", "rr_inst", $psprintf("%m"));
		set_config_string("*.rr0.ei", "rr_inst", $psprintf("%m"));
		set_config_string("*.rr0.ss", "rr_inst", $psprintf("%m"));
		set_config_string("*.rr0.rec", "rr_inst", $psprintf("%m"));
		
		// Enable transaction recording by default
		
		set_config_int("*.rr0.rec", "is_record_trans", 1);
		
		// Set your own classes here using the factory mechanism of OVM.
		// You can change the components within the simulation-only layer without editing
		// the source code of the library, for example, if you define your own version of region recorder
		// and error injector, you can replace the default code with your own code, for example:
		//
		//     rsv_error_injector_base::type_id::set_inst_override(my_error_injector::get_type(), "*.rr?.ei");
		//     rsv_region_recorder_base::type_id::set_inst_override(my_region_recorder::get_type(), "*.rr?.rec");
		//
		// As a quick start, you can use the generated default code, which is
		// parameterized with the user-defined interface, and consumes the incomming
		// transactions without processing them, for example:
		//
		//     rsv_error_injector_base::type_id::set_inst_override(rsv_error_injector#(my_if_type)::get_type(), "*.rr?.ei");
		//     rsv_region_recorder_base::type_id::set_inst_override(my_region_recorder#(my_if_type)::get_type(), "*.rr?.rec");
		//
		// For more information about factory, see the OVM User Guide

		rsv_portal_controller_base::type_id::set_inst_override(rsv_portal_controller#(portal_if_type)::get_type(), "*.rr0.pc");
		rsv_state_spy_base::type_id::set_inst_override(rsv_state_spy#(state_if_type)::get_type(), "*.rr0.ss");
		rsv_error_injector_base::type_id::set_inst_override(my_ei::get_type(), "*.rr0.ei");
		rsv_region_recorder_base::type_id::set_inst_override(rsv_region_recorder#(my_if_type)::get_type(), "*.rr0.rec");

	end

//-------------------------------------------------------------------
// Instantiating reconfigurable modules
//-------------------------------------------------------------------

	maximum  rm0 (
		.clk              ( rm0_rif.clk              ),
		.rstn             ( rm0_rif.rstn             ),
		.rc_reqn          ( rm0_rif.rc_reqn          ),
		.rc_ackn          ( rm0_rif.rc_ackn          ),
		.p_prdy           ( rm0_rif.p_prdy           ),
		.p_crdy           ( rm0_rif.p_crdy           ),
		.p_cerr           ( rm0_rif.p_cerr           ),
		.p_data           ( rm0_rif.p_data           ),
		.c_prdy           ( rm0_rif.c_prdy           ),
		.c_crdy           ( rm0_rif.c_crdy           ),
		.c_cerr           ( rm0_rif.c_cerr           ),
		.c_data           ( rm0_rif.c_data           )
	);

	reverse  rm1 (
		.clk              ( rm1_rif.clk              ),
		.rstn             ( rm1_rif.rstn             ),
		.rc_reqn          ( rm1_rif.rc_reqn          ),
		.rc_ackn          ( rm1_rif.rc_ackn          ),
		.p_prdy           ( rm1_rif.p_prdy           ),
		.p_crdy           ( rm1_rif.p_crdy           ),
		.p_cerr           ( rm1_rif.p_cerr           ),
		.p_data           ( rm1_rif.p_data           ),
		.c_prdy           ( rm1_rif.c_prdy           ),
		.c_crdy           ( rm1_rif.c_crdy           ),
		.c_cerr           ( rm1_rif.c_cerr           ),
		.c_data           ( rm1_rif.c_data           )
	);

endmodule



