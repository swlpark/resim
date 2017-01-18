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

	reverse  rm (
		.clk              (  clk              ),
		.rstn             (  rstn             ),
		.rc_reqn          (  rc_reqn          ),
		.rc_ackn          (  rc_ackn          ),
		.p_prdy           (  p_prdy           ),
		.p_crdy           (  p_crdy           ),
		.p_cerr           (  p_cerr           ),
		.p_data           (  p_data           ),
		.c_prdy           (  c_prdy           ),
		.c_crdy           (  c_crdy           ),
		.c_cerr           (  c_cerr           ),
		.c_data           (  c_data           )
	);

endmodule



