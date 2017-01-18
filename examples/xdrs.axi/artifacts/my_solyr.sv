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
import rsv_solyr_pkg::*;
import usr_solyr_pkg::*;

`include "ovm_macros.svh"
`include "rsv_defines.svh"

// This is the dynamic part of the testbench, which is built on top of OVM
// using SystemVerilog. This module has no IO and can be instantiated inside a
// VHDL/Verilog/SystemVerilog testbench. You can also cut and paste the code
// into your top level testbench if it is written in SystemVerilog.

module my_solyr
(

);

	`define NUM_RR 1 // Number of reconfigurable regions in the solyr
	
	// Instantiate the simulation-only layer;
	// Create, parameterize, & run the solyr in the inital block

	rsv_solyr#(`NUM_RR) solyr;

	initial begin

		$timeformat (-9, 3, "ns", 5);
		
		// Use factory override to replace the base classes with parameterized classes.
		// In particular, the following intial block parameterize the scoreboard artifact. 
		// See the OVM User Guide for factory overrides.
	
		rsv_scoreboard_base#(`NUM_RR)::type_id::set_type_override(rsv_scoreboard#(`NUM_RR)::get_type());
		
		// Create the simulation-only layer by calling the new constructor
		//
		// the 1st parameter is the name of the simulation-only layer,
		// the 2nd parameter is the parent of the simulation-only layer, which is null in this case
		//    (that means solyr is the top of class-based verification environment)

		solyr = new("solyr", null);

		// After instantiation, call the run_test() method of solyr, which is
		// a built-in method provided by OVM. This methods calls all the phases of
		// ovm_component (new, build, connect, run, etc ...).
		//
		// The simulation-only layer will be configured with user-defined parameters and user-defined
		// derived classes. See OVM User Guide for details of configuration and factory mechanism. 
		
		solyr.run_test();
	end

endmodule



