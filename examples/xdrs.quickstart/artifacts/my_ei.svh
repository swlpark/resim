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

`ifndef MY_EI_SVH
`define MY_EI_SVH

class my_ei extends rsv_error_injector#(virtual interface my_if);

	// configuration table and parameters
	`ovm_component_utils_begin(my_ei)
	`ovm_component_utils_end

	// new - constructor
	function new (string name, ovm_component parent);
		super.new(name, parent);
	endfunction : new

	// Define your own tasks to inject errors.
	// You should not change the name or the prototype of these tasks.
	// Possible injections include:
	//
	//     x, all-0, all-1, negate, random, no-change

	extern virtual protected task inject_to_static_module(rsv_ei_trans tr);
	extern virtual protected task inject_to_reconfigurable_module(rsv_ei_trans tr);
	extern virtual protected task inject_to_internal_signals(rsv_ei_trans tr);
	extern virtual protected task end_of_injecting_errors(rsv_ei_trans tr);

endclass : my_ei

task my_ei::inject_to_static_module (rsv_ei_trans tr);
	// TODO: Implement your own inject_to_static_module() task here
	// The following is an example of "x" injection to the static module

	// Enable the static error injection. By default, SEI is disabled. 

	ei_vi.sei_en <= 1'b1;
	
	// Use ei_vi.reconf_phase as a trigger to start error injection
	// ei_vi.reconf_phase is asserted during reconfiguration 
	
	@(posedge ei_vi.reconf_phase);
	
	// Drive undefined X values to all output signals
	// of the reconfigurable module.

	sei_vi.rc_ackn          <= 'hx;
	sei_vi.p_prdy           <= 'hx;
	sei_vi.p_data           <= 'hx;
	sei_vi.c_crdy           <= 'hx;
	sei_vi.c_cerr           <= 'hx;


endtask : my_ei::inject_to_static_module

task my_ei::inject_to_reconfigurable_module (rsv_ei_trans tr);
	// TODO: Implement your own inject_to_reconfigurable_module() task here
	// Typically, this task can manipulate signals (including the clock) to inject 
	// error to the ****NEWLY-CONFIGURED**** reconfigurable module. The following is an  
	// example of "x" injection to the reconfigurable modules

	// Enable the dynamic error injection. By default, DEI is disabled. 

	ei_vi.dei_en <= 1'b1;

	// Use ei_vi.reconf_phase as a trigger to start error injection
	// ei_vi.reconf_phase is asserted during reconfiguration 
	
	@(posedge ei_vi.reconf_phase);
	
	// Toggle the clock of the reconfigurable module,
	// so that the X is propogated into the module.

	fork : ei_clocking_thread
		dei_vi.clk = 1'b0;
		repeat(64) begin #2 dei_vi.clk = ~dei_vi.clk; end
	join_none

	dei_vi.rstn             <= 'hx;
	dei_vi.rc_reqn          <= 'hx;
	dei_vi.p_crdy           <= 'hx;
	dei_vi.p_cerr           <= 'hx;
	dei_vi.c_prdy           <= 'hx;
	dei_vi.c_data           <= 'hx;


endtask : my_ei::inject_to_reconfigurable_module

task my_ei::inject_to_internal_signals (rsv_ei_trans tr);
	// TODO: Implement your own inject_to_internal_signals() task here. 
	// Typically, the tasks inject errors to the internal signals of 
	// the reconfigurable module. 
	// 
	// By evaluating the "rsv_iei_hdl_state" API in the Simulator Kernel 
	// Thread (SKT), the following example injects "x" to the ****OLD**** 
	// reconfigurable module. Limited by the implementation of ReSim, 
	// "rsv_iei_hdl_state" does not support VHDL signals and Verilog
	// nets and these signals are ignored. 
	
	logic [7:0] old_rmid = ei_vi.active_module_id;
	logic [7:0] new_rmid = tr.rmid;
	
	`rsv_execute_tcl(interp, $psprintf("ReSim::rsv_iei_hdl_state %s rm%0d x none",rr_inst,old_rmid))
	
	// Users can add other code here to perform design-specific error injection
	// operations. For example, users can "force" a particular signal instead 
	// of injecting error to all signals, or to use the "mem load" command to 
	// change the content of memory elements of the reconfigurable module. 
	
endtask : my_ei::inject_to_internal_signals

task my_ei::end_of_injecting_errors (rsv_ei_trans tr);
	// TODO: Implement your own end_of_injecting_errors() task here. 
	// Typically, this task cleans up and pending operations and ends the 
	// error injection operation
	
endtask : my_ei::end_of_injecting_errors

`endif // MY_EI_SVH



