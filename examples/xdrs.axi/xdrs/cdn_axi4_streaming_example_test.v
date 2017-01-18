// (c) Copyright 2011 - 2012 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

//----------------------------------------------------------------------------
// Project    : Pheidippides
// Company    : Cadence Design Systems
//----------------------------------------------------------------------------
// Description: 
// This file contains an example test for the AXI 4 streaming Master and 
// Slave BFMs.
// It demonstrates how to stimulate the following conditions from both the
// master and slave perspectives:
// 1  Simple master to slave transfer example
// 2  Looped master to slave transfers example
// 3  Simple master to slave packet example
// 4  Looped master to slave packets example
// 5  Ragged master to slave packet example i.e. less data at the end of the
//    packet than can be supported
// 6  Packet data interleaving example
//----------------------------------------------------------------------------

// (c) Copyright 2011 - 2012 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

//----------------------------------------------------------------------------
// Project    : Pheidippides
// Company    : Cadence Design Systems
//----------------------------------------------------------------------------
// Description: 
// This file is a simple testbench for the AXI 4 Streaming BFMs.
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Required timescale.
//----------------------------------------------------------------------------
`timescale 1ns / 1ps

//----------------------------------------------------------------------------
// Local Defines.
//----------------------------------------------------------------------------

// Response Type Defines
`define RESPONSE_OKAY   2'b00
`define RESPONSE_EXOKAY 2'b01
`define RESPONSE_SLVERR 2'b10
`define RESPONSE_DECERR 2'b11

// AMBA AXI 4 streaming Range Constants
`define MAX_BURST_LENGTH 1
   
// AMBA AXI 4 streaming Bus Size Constants
`define PROT_BUS_WIDTH 3
`define RESP_BUS_WIDTH 2

// Define for intenal control value
`define DESTVALID_FALSE 1'b0
`define DESTVALID_TRUE  1'b1
`define IDVALID_TRUE  1'b1
`define IDVALID_FALSE 1'b0

//----------------------------------------------------------------------------
// Create the testbench.
//----------------------------------------------------------------------------

module cdn_axi4_streaming_example_tb;
   
   //------------------------------------------------------------------------
   // Configuration Parameters
   //------------------------------------------------------------------------
   parameter MASTER_NAME = "MASTER_0";
   parameter SLAVE_NAME = "SLAVE_0";
   parameter DATA_BUS_WIDTH = 32;
   parameter ID_BUS_WIDTH   = 8;
   parameter DEST_BUS_WIDTH = 4;
   parameter USER_BUS_WIDTH = 8;
   parameter MAX_PACKET_SIZE = 10;
   parameter MAX_OUTSTANDING_TRANSACTIONS = 8;
   parameter STROBE_NOT_USED = 0;
   parameter KEEP_NOT_USED = 0;
   
   //------------------------------------------------------------------------
   // Other testbench signals
   //------------------------------------------------------------------------
   
   reg tb_ACLK;
   reg tb_ARESETn;

   //------------------------------------------------------------------------
   // Add an instance of the AXI 4 streaming MASTER BFM
   //------------------------------------------------------------------------
   cdn_axi_bfm_0  #(.C_M_AXIS_NAME(MASTER_NAME),
                                   .C_M_AXIS_TDATA_WIDTH(DATA_BUS_WIDTH),
                                   .C_M_AXIS_TID_WIDTH(ID_BUS_WIDTH),
                                   .C_M_AXIS_TDEST_WIDTH(DEST_BUS_WIDTH),
                                   .C_M_AXIS_TUSER_WIDTH(USER_BUS_WIDTH),
                                   .C_M_AXIS_MAX_PACKET_SIZE(MAX_PACKET_SIZE),
                                   .C_M_AXIS_MAX_OUTSTANDING_TRANSACTIONS(MAX_OUTSTANDING_TRANSACTIONS),
                                   .C_M_AXIS_STROBE_NOT_USED(STROBE_NOT_USED),
                                   .C_M_AXIS_KEEP_NOT_USED(KEEP_NOT_USED))
   master_0(.m_axis_aclk    (tb_ACLK),
            .m_axis_aresetn (tb_ARESETn),
            // Transfer Channel
            .m_axis_tvalid (slave_0.TVALID),
            .m_axis_tready (slave_0.TREADY),
            .m_axis_tdata  (slave_0.TDATA),
            .m_axis_tstrb  (slave_0.TSTRB),
            .m_axis_tkeep  (slave_0.TKEEP),
            .m_axis_tlast  (slave_0.TLAST),
            .m_axis_tid    (slave_0.TID),
            .m_axis_tdest  (slave_0.TDEST),
            .m_axis_tuser  (slave_0.TUSER));
   
   //------------------------------------------------------------------------
   // Add an instance of the AXI 4 streaming SLAVE BFM
   //------------------------------------------------------------------------
   cdn_axi4_streaming_slave_bfm #(SLAVE_NAME,
                                  DATA_BUS_WIDTH,
                                  ID_BUS_WIDTH,
                                  DEST_BUS_WIDTH,
                                  USER_BUS_WIDTH,
                                  MAX_PACKET_SIZE,
                                  MAX_OUTSTANDING_TRANSACTIONS,
                                  STROBE_NOT_USED,
                                  KEEP_NOT_USED)
   slave_0(.ACLK    (tb_ACLK),
           .ARESETn (tb_ARESETn),
           // Transfer Channel
           .TVALID (master_0.cdn_axi4_streaming_master_bfm_inst.TVALID),
           .TREADY (master_0.cdn_axi4_streaming_master_bfm_inst.TREADY),
           .TDATA  (master_0.cdn_axi4_streaming_master_bfm_inst.TDATA),
           .TSTRB  (master_0.cdn_axi4_streaming_master_bfm_inst.TSTRB),
           .TKEEP  (master_0.cdn_axi4_streaming_master_bfm_inst.TKEEP),
           .TLAST  (master_0.cdn_axi4_streaming_master_bfm_inst.TLAST),
           .TID    (master_0.cdn_axi4_streaming_master_bfm_inst.TID),
           .TDEST  (master_0.cdn_axi4_streaming_master_bfm_inst.TDEST),
           .TUSER  (master_0.cdn_axi4_streaming_master_bfm_inst.TUSER));

   //------------------------------------------------------------------------
   // Include Test Level API
   //------------------------------------------------------------------------
  // `include "cdn_axi_test_level_api.v"

   //------------------------------------------------------------------------
   // Simple Reset Generator and test
   //------------------------------------------------------------------------

   initial begin
      
      tb_ARESETn = 1'b1;
      #10 tb_ARESETn = 1'b0;
      #50;
      // Release the reset on the posedge of the clk.
      @(posedge tb_ACLK);
      tb_ARESETn = 1'b1;
      @(posedge tb_ACLK);
   end

   
   //------------------------------------------------------------------------
   // Simple Clock Generator
   //------------------------------------------------------------------------
   initial tb_ACLK = 1'b0;
   always #10 tb_ACLK = !tb_ACLK;


// (c) Copyright 2011 - 2012 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

//----------------------------------------------------------------------------
// Project    : Pheidippides
// Company    : Cadence Design Systems
//----------------------------------------------------------------------------
// Description: 
// This file contains the common checkers and tasks required for making test
// writing using the Cadence AXI 3 BFMs easier.
//----------------------------------------------------------------------------

//------------------------------------------------------------------------
// TEST LEVEL API TASKS
//------------------------------------------------------------------------

         

//------------------------------------------------------------------------
// TEST LEVEL API: CHECK_RESPONSE_VECTOR_OKAY
//------------------------------------------------------------------------
// Description:
// CHECK_RESPONSE_VECTOR_OKAY(response,burst_length)
// This task checks if the response vector returned from the READ_BURST
// task is equal to OKAY
//------------------------------------------------------------------------
task automatic CHECK_RESPONSE_VECTOR_OKAY;
   input [(`RESP_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] response;
   input integer                                       burst_length;
   integer                                             i;
   begin
      for (i = 0; i < burst_length+1; i = i+1) begin
         CHECK_RESPONSE_OKAY(response[i*`RESP_BUS_WIDTH +: `RESP_BUS_WIDTH]);
      end
   end
endtask

//------------------------------------------------------------------------
// TEST LEVEL API: CHECK_RESPONSE_VECTOR_EXOKAY
//------------------------------------------------------------------------
// Description:
// CHECK_RESPONSE_VECTOR_EXOKAY(response,burst_length)
// This task checks if the response vector returned from the READ_BURST
// task is equal to EXOKAY
//------------------------------------------------------------------------
task automatic CHECK_RESPONSE_VECTOR_EXOKAY;
   input [(`RESP_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] response;
   input integer                                       burst_length;
   integer                                             i;
   begin
      for (i = 0; i < burst_length+1; i = i+1) begin
         CHECK_RESPONSE_EXOKAY(response[i*`RESP_BUS_WIDTH +: `RESP_BUS_WIDTH]);
      end
   end
endtask


//------------------------------------------------------------------------
// TEST LEVEL API: CHECK_RESPONSE_OKAY
//------------------------------------------------------------------------
// Description:
// CHECK_RESPONSE_OKAY(response)
// This task checks if the return response is equal to OKAY
//------------------------------------------------------------------------
task automatic CHECK_RESPONSE_OKAY;
   input [`RESP_BUS_WIDTH-1:0] response;
   begin
      if (response !== `RESPONSE_OKAY) begin
         $display("TESTBENCH ERROR! Response is not OKAY",
                  "\n expected = 0x%h",`RESPONSE_OKAY,
                  "\n actual   = 0x%h",response);
         $stop;
      end
   end
endtask

//------------------------------------------------------------------------
// TEST LEVEL API: CHECK_RESPONSE_EXOKAY
//------------------------------------------------------------------------
// Description:
// CHECK_RESPONSE_EXOKAY(response)
// This task checks if the return response is equal to EXOKAY
//------------------------------------------------------------------------
task automatic CHECK_RESPONSE_EXOKAY;
   input [`RESP_BUS_WIDTH-1:0] response;
   begin
      if (response !== `RESPONSE_EXOKAY) begin
         $display("TESTBENCH ERROR! Response is not EXOKAY",
                  "\n expected = 0x%h",`RESPONSE_EXOKAY,
                  "\n actual   = 0x%h",response);
         $stop;
      end
   end
endtask

//------------------------------------------------------------------------
// TEST LEVEL API: COMPARE_DATA
//------------------------------------------------------------------------
// Description:
// COMPARE_DATA(expected,actual)
// This task checks if the actual data is equal to the expected data.
// X is used as don't care but it is not permitted for the full vector
// to be don't care.
//------------------------------------------------------------------------
task automatic COMPARE_DATA;
   input [(DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] expected;
   input [(DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] actual;
   begin
      if (expected === 'hx || actual === 'hx) begin
         $display("TESTBENCH ERROR! COMPARE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
         $stop;
      end
      
      if (actual != expected) begin
         $display("TESTBENCH ERROR! Data expected is not equal to actual.",
                  "\n expected = 0x%h",expected,
                  "\n actual   = 0x%h",actual);
         $stop;
      end
   end
endtask

//----------------------------------------------------------------------------
// END OF FILE
//----------------------------------------------------------------------------

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TDATA
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TDATA(expected,actual)
   // This task checks if the actual tdata is equal to the expected tdata.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TDATA;
      input [DATA_BUS_WIDTH-1:0] expected;
      input [DATA_BUS_WIDTH-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TDATA cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TDATA expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask
   
   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TUSER
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TUSER(expected,actual)
   // This task checks if the actual tuser is equal to the expected tuser.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TUSER;
      input [USER_BUS_WIDTH-1:0] expected;
      input [USER_BUS_WIDTH-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TUSER cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TUSER expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TID
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TID(expected,actual)
   // This task checks if the actual tid is equal to the expected tid.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TID;
      input [ID_BUS_WIDTH-1:0] expected;
      input [ID_BUS_WIDTH-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TID cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TID expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TDEST
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TDEST(expected,actual)
   // This task checks if the actual tdest is equal to the expected tdest.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TDEST;
      input [DEST_BUS_WIDTH-1:0] expected;
      input [DEST_BUS_WIDTH-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TDEST cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TDEST expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TSTRB
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TSTRB(expected,actual)
   // This task checks if the actual tstrb is equal to the expected tstrb.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TSTRB;
      input [(DATA_BUS_WIDTH/8)-1:0] expected;
      input [(DATA_BUS_WIDTH/8)-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TSTRB cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TSTRB expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TKEEP
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TKEEP(expected,actual)
   // This task checks if the actual tkeep is equal to the expected tkeep.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TKEEP;
      input [(DATA_BUS_WIDTH/8)-1:0] expected;
      input [(DATA_BUS_WIDTH/8)-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TKEEP cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TKEEP expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TLAST
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TLAST(expected,actual)
   // This task checks if the actual tlast is equal to the expected tlast.
   //------------------------------------------------------------------------
   task automatic COMPARE_TLAST;
      input expected;
      input actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TLAST cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! TLAST expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TDATA_VECTOR
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TDATA_VECTOR(expected,actual)
   // This task checks if the actual data is equal to the expected data.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TDATA_VECTOR;
      input [(DATA_BUS_WIDTH*(MAX_PACKET_SIZE+1))-1:0] expected;
      input [(DATA_BUS_WIDTH*(MAX_PACKET_SIZE+1))-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TDATA_VECTOR cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! Data expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_TUSER_VECTOR
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_TUSER_VECTOR(expected,actual)
   // This task checks if the actual user data is equal to the expected user
   // data.
   // X is used as don't care but it is not permitted for the full vector
   // to be don't care.
   //------------------------------------------------------------------------
   task automatic COMPARE_TUSER_VECTOR;
      input [(USER_BUS_WIDTH*(MAX_PACKET_SIZE+1))-1:0] expected;
      input [(USER_BUS_WIDTH*(MAX_PACKET_SIZE+1))-1:0] actual;
      begin
         if (expected === 'hx || actual === 'hx) begin
            $display("TESTBENCH ERROR! COMPARE_TUSER_VECTOR cannot be performed with an expected or actual vector that is all 'x'!");
            $stop;
         end
         
         if (actual != expected) begin
            $display("TESTBENCH ERROR! User data expected is not equal to actual.",
                     "\n expected = 0x%h",expected,
                     "\n actual   = 0x%h",actual);
            $stop;
         end
      end
   endtask
   
   //------------------------------------------------------------------------
   // TEST LEVEL API: COMPARE_DATASIZE
   //------------------------------------------------------------------------
   // Description:
   // COMPARE_DATASIZE(expected,actual)
   // This task checks if the actual datasize is equal to the expected datasize.
   //------------------------------------------------------------------------
   task automatic COMPARE_DATASIZE;
      input integer expected;
      input integer actual;
      begin
         if (actual != expected) begin
            $display("TESTBENCH ERROR! DATASIZE expected is not equal to actual.",
                     "\n expected = %0d",expected,
                     "\n actual   = %0d",actual);
            $stop;
         end
      end
   endtask

   //------------------------------------------------------------------------
   // TEST BENCH LEVEL API: REPORT_MASTER_STATUS
   //------------------------------------------------------------------------
   // Description:
   // REPORT_MASTER_STATUS(number_of_expected_errors_warnings_and_pending)
   // This task calls the masters report_status function which returns the 
   // total of the errors + warnings + pending counters. This return number 
   // is compared with the input 
   // number_of_expected_errors_warnings_and_pending
   //------------------------------------------------------------------------
   task automatic REPORT_MASTER_STATUS;
      input integer number_of_expected_errors_warnings_and_pending;
      integer       result;
      begin
         result = tb.master_0.cdn_axi4_streaming_master_bfm_inst.report_status(0);
         if (result != number_of_expected_errors_warnings_and_pending) begin
            $display("-------------------------------------------------------");
            $display("ERROR: EXAMPLE TEST : MASTER FAILED");
            $display("-------------------------------------------------------");
            $finish;
         end
         else begin
            $display("-------------------------------------------------------");
            $display("EXAMPLE TEST : MASTER PASSED");
            $display("-------------------------------------------------------");
         end
      end
   endtask
   
   //------------------------------------------------------------------------
   // TEST BENCH LEVEL API: REPORT_SLAVE_STATUS
   //------------------------------------------------------------------------
   // Description:
   // REPORT_SLAVE_STATUS(number_of_expected_errors_warnings_and_pending)
   // This task calls the slaves report_status function which returns the 
   // total of the errors + warnings + pending counters. This return number 
   // is compared with the input 
   // number_of_expected_errors_warnings_and_pending
   //------------------------------------------------------------------------
   task automatic REPORT_SLAVE_STATUS;
      input integer number_of_expected_errors_warnings_and_pending;
      integer       result;
      begin
         result = tb.slave_0.report_status(0);
         if (result != number_of_expected_errors_warnings_and_pending) begin
            $display("-------------------------------------------------------");
            $display("ERROR: EXAMPLE TEST : SLAVE FAILED");
            $display("-------------------------------------------------------");
            $finish;
         end
         else begin
            $display("-------------------------------------------------------");
            $display("EXAMPLE TEST : SLAVE PASSED");
            $display("-------------------------------------------------------");
         end
      end
   endtask
   
endmodule

//----------------------------------------------------------------------------
// END OF FILE
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// The test module.
//----------------------------------------------------------------------------

module test;

   //------------------------------------------------------------------------
   // Configuration Parameters
   //------------------------------------------------------------------------
   parameter MASTER_NAME = "MASTER_0";
   parameter SLAVE_NAME = "SLAVE_0";
   parameter DATA_BUS_WIDTH = 32;
   parameter ID_BUS_WIDTH   = 8;
   parameter DEST_BUS_WIDTH = 4;
   parameter USER_BUS_WIDTH = 8;
   parameter MAX_PACKET_SIZE = 10;
   parameter MAX_OUTSTANDING_TRANSACTIONS = 8;
   parameter STROBE_NOT_USED = 0;
   parameter KEEP_NOT_USED = 0;

   // Create an instance of the example tb
   cdn_axi4_streaming_example_tb #(MASTER_NAME,
                                   SLAVE_NAME,
                                   DATA_BUS_WIDTH,
                                   ID_BUS_WIDTH,
                                   DEST_BUS_WIDTH,
                                   USER_BUS_WIDTH,
                                   MAX_PACKET_SIZE,
                                   MAX_OUTSTANDING_TRANSACTIONS,
                                   STROBE_NOT_USED,
                                   KEEP_NOT_USED) tb();
   
   // Local Variables
   reg [ID_BUS_WIDTH-1:0]       mtestID;  
   reg [DEST_BUS_WIDTH-1:0]     mtestDEST;
   reg [DATA_BUS_WIDTH-1:0]     mtestDATA [3:0];
   reg [(DATA_BUS_WIDTH/8)-1:0] mtestSTRB;
   reg [(DATA_BUS_WIDTH/8)-1:0] mtestKEEP;
   reg                          mtestLAST;
   reg [USER_BUS_WIDTH-1:0]     mtestUSER;
   integer                      mtestDATASIZE;
   reg [(DATA_BUS_WIDTH*(MAX_PACKET_SIZE))-1:0] v_mtestDATA;
   reg [(USER_BUS_WIDTH*(MAX_PACKET_SIZE))-1:0] v_mtestUSER;
   
   reg [ID_BUS_WIDTH-1:0]       stestID;  
   reg [DEST_BUS_WIDTH-1:0]     stestDEST;
   reg [DATA_BUS_WIDTH-1:0]     stestDATA [3:0];
   reg [(DATA_BUS_WIDTH/8)-1:0] stestSTRB;
   reg [(DATA_BUS_WIDTH/8)-1:0] stestKEEP;
   reg                          stestLAST;
   reg [USER_BUS_WIDTH-1:0]     stestUSER;
   integer                      stestDATASIZE;
   reg [(DATA_BUS_WIDTH*(MAX_PACKET_SIZE))-1:0] v_stestDATA [2:0];
   reg [(USER_BUS_WIDTH*(MAX_PACKET_SIZE))-1:0] v_stestUSER [2:0];

   reg [(DATA_BUS_WIDTH/8)-1:0] all_valid_strobe;
   reg [(DATA_BUS_WIDTH/8)-1:0] all_valid_keep;

   integer                     i; // Simple loop integer. 
   integer                     j; // Simple loop integer. 
      
   // Test Status Bits
   reg                         slave_finished_example1 = 1'b0;
   reg                         slave_finished_example2 = 1'b0;
   reg                         slave_finished_example3 = 1'b0;
   reg                         slave_finished_example4 = 1'b0;
   reg                         slave_finished_example5 = 1'b0;
   reg                         slave_finished_example6 = 1'b0;
   reg                         slave_finished = 1'b0;

   //------------------------------------------------------------------------
   // Create the test vectors
   //------------------------------------------------------------------------
   initial begin
      // When performing debug enable all levels of INFO messages.
      tb.master_0.cdn_axi4_streaming_master_bfm_inst.set_channel_level_info(1);
      tb.slave_0.set_channel_level_info(1);
      for (i=0; i < (DATA_BUS_WIDTH/8); i=i+1) begin
         mtestDATA[0][i*8 +: 8] = 8'h00;
         mtestDATA[1][i*8 +: 8] = 8'hAA;
         mtestDATA[2][i*8 +: 8] = 8'h55;
         mtestDATA[3][i*8 +: 8] = 8'hFF;
      end
      
      for (j=0; j < (DATA_BUS_WIDTH/8); j=j+1) begin
         all_valid_strobe[j] = 1'b1;
         all_valid_keep[j] = 1'b1;
      end
      
      for (j=0; j < USER_BUS_WIDTH; j=j+1) begin
         mtestUSER = 1'b1;
      end

      for (j=0; j < ((DATA_BUS_WIDTH*(MAX_PACKET_SIZE))/8); j=j+1) begin
         v_mtestDATA[j*8 +: 8] = j;
      end

      for (j=0; j < ((USER_BUS_WIDTH*(MAX_PACKET_SIZE))/8); j=j+1) begin
         v_mtestUSER[j*8 +: 8] = j;
      end
      
   end
   
   //------------------------------------------------------------------------
   // Drive the MASTER BFM
   //------------------------------------------------------------------------
   initial begin
      // Wait for end of reset
      wait(tb.tb_ARESETn === 0) @(posedge tb.tb_ACLK);
      wait(tb.tb_ARESETn === 1) @(posedge tb.tb_ACLK);
            
      //---------------------------------------------------------------------
      // EXAMPLE TEST 1:
      // Simple master to slave transfer example
      // DESCRIPTION:
      // The following master sends a simple AXI 4 Streaming transfer.
      //---------------------------------------------------------------------

      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 1:");
      $display("Simple transfer example");
      $display("---------------------------------------------------------");

      mtestID = 4;
      mtestDEST = 2;
      mtestSTRB = all_valid_strobe;
      mtestKEEP = all_valid_keep;
      mtestLAST = 1;
      
      tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_TRANSFER(mtestID,
                                mtestDEST,
                                mtestDATA[0],
                                mtestSTRB,
                                mtestKEEP,
                                mtestLAST,
                                mtestUSER);

      wait(slave_finished_example1 == 1'b1);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 1: FINISHED!");
      $display("---------------------------------------------------------");

      //---------------------------------------------------------------------
      // EXAMPLE TEST 2:
      // Looped transfers example.
      // DESCRIPTION:
      // The following master code sends 3 transfers in a loop.
      //---------------------------------------------------------------------

      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 2:");
      $display("Looped transfers example.");
      $display("---------------------------------------------------------");


      for (i = 0; i < 4; i=i+1) begin
         
         mtestID = i+1;
         mtestDEST = i+4;
         mtestSTRB = all_valid_strobe;
         mtestKEEP = all_valid_keep;
         mtestLAST = 0;
         if (i == 3) mtestLAST = 1;

         tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_TRANSFER(mtestID,
                                   mtestDEST,
                                   mtestDATA[i],
                                   mtestSTRB,
                                   mtestKEEP,
                                   mtestLAST,
                                   mtestUSER);
         
         $display("EXAMPLE TEST 2 : Loop = %0d",i);

      end

      wait(slave_finished_example2 == 1'b1);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 2: FINISHED!");
      $display("---------------------------------------------------------");

      //---------------------------------------------------------------------
      // EXAMPLE TEST 3:
      // Simple master to slave packet example
      // DESCRIPTION:
      // The following master sends a simple AXI 4 Streaming packet.
      //---------------------------------------------------------------------

      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 3:");
      $display("Simple packet example");
      $display("---------------------------------------------------------");

      mtestID = 7;
      mtestDEST = 8;
      mtestDATASIZE = MAX_PACKET_SIZE*(DATA_BUS_WIDTH/8);

      tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_PACKET(mtestID,
                              mtestDEST,
                              v_mtestDATA,
                              mtestDATASIZE,
                              v_mtestUSER);

      wait(slave_finished_example3 == 1'b1);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 3: FINISHED!");
      $display("---------------------------------------------------------");

      //---------------------------------------------------------------------
      // EXAMPLE TEST 4:
      // Looped master to slave packets example.
      // DESCRIPTION:
      // The following master code sends 3 packets in a loop.
      //---------------------------------------------------------------------

      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 4:");
      $display("Looped master to slave packets example.");
      $display("---------------------------------------------------------");


      for (i = 0; i < 4; i=i+1) begin
         
         mtestID = i+1;
         mtestDEST = i+4;

         tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_PACKET(mtestID,
                                 mtestDEST,
                                 v_mtestDATA,
                                 mtestDATASIZE,
                                 v_mtestUSER);
         
         $display("EXAMPLE TEST 4 : Loop = %0d",i);

      end

      wait(slave_finished_example4 == 1'b1);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 4: FINISHED!");
      $display("---------------------------------------------------------");

      //---------------------------------------------------------------------
      // EXAMPLE TEST 5:
      // Ragged master to slave packet example
      // DESCRIPTION:
      // The following master sends an AXI 4 Streaming packet with a
      // payload shorter than the max packet size. This is controlled by
      // making the mtestDATASIZE less than the data vector.
      //---------------------------------------------------------------------

      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 5:");
      $display("Ragged master to slave packet example");
      $display("---------------------------------------------------------");

      mtestID = 7;
      mtestDEST = 8;
      mtestDATASIZE = (MAX_PACKET_SIZE*(DATA_BUS_WIDTH/8))-2;

      tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_PACKET(mtestID,
                              mtestDEST,
                              v_mtestDATA,
                              mtestDATASIZE,
                              v_mtestUSER);

      wait(slave_finished_example5 == 1'b1);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 5: FINISHED!");
      $display("---------------------------------------------------------");

      //---------------------------------------------------------------------
      // EXAMPLE TEST 6:
      // Packet Data Interleaving example
      // DESCRIPTION:
      // The following master code sends 3 packets interleaved
      //---------------------------------------------------------------------

      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 6:");
      $display("Looped master to slave packets example.");
      $display("---------------------------------------------------------");

      mtestDATASIZE = (MAX_PACKET_SIZE*(DATA_BUS_WIDTH/8));

      // The following code does a write data interleave of depth 3
      tb.master_0.cdn_axi4_streaming_master_bfm_inst.set_packet_transfer_gap(2);

      fork
         begin
            mtestID = 1;
            mtestDEST = 1;
            tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_PACKET(mtestID,
                                    mtestDEST,
                                    v_mtestDATA,
                                    mtestDATASIZE,
                                    v_mtestUSER);
         end
         begin
            mtestID = 2;
            mtestDEST = 2;
            tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_PACKET(mtestID,
                                    mtestDEST,
                                    v_mtestDATA,
                                    mtestDATASIZE,
                                    v_mtestUSER);
         end
         begin
            mtestID = 3;
            mtestDEST = 3;
            tb.master_0.cdn_axi4_streaming_master_bfm_inst.SEND_PACKET(mtestID,
                                    mtestDEST,
                                    v_mtestDATA,
                                    mtestDATASIZE,
                                    v_mtestUSER);
         end
      join
      

      wait(slave_finished_example6 == 1'b1);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST 6: FINISHED!");
      $display("---------------------------------------------------------");

      repeat(10) @(posedge tb.tb_ACLK);
      
      wait(slave_finished == 1'b1);
      
      tb.REPORT_MASTER_STATUS(0);
      tb.REPORT_SLAVE_STATUS(0);
      $display("---------------------------------------------------------");
      $display("EXAMPLE TEST : PASSED");
      $display("---------------------------------------------------------");
      $display("Test Completed Successfully");
      $display("---------------------------------------------------------");
      $display("COMPLETE EXAMPLE TEST FINISHED!");
      $display("---------------------------------------------------------");
      $finish;

      // Catch the sync error if we reach this part of the code.
      $display("EXAMPLE TEST : *ERROR : Simulation has gone out of sync.");
      $finish;
      
   end
   
   //------------------------------------------------------------------------
   // Drive the SLAVE BFM
   //------------------------------------------------------------------------
   initial begin
      slave_finished = 1'b0;
      // Wait for end of reset
      wait(tb.tb_ARESETn === 0) @(posedge tb.tb_ACLK);
      wait(tb.tb_ARESETn === 1) @(posedge tb.tb_ACLK);

      //---------------------------------------------------------------------
      // EXAMPLE TEST 1:
      // Simple master to slave transfer example
      // DESCRIPTION:
      // The following slave code receives a simple AXI 4 Streaming transfer.
      //---------------------------------------------------------------------
      
      tb.slave_0.RECEIVE_TRANSFER(0,
                                  `IDVALID_FALSE,
                                  0,
                                  `DESTVALID_FALSE,
                                  stestID,
                                  stestDEST,                                  
                                  stestDATA[0],
                                  stestSTRB,
                                  stestKEEP,
                                  stestLAST,
                                  stestUSER);
      
      tb.COMPARE_TID(4,stestID);
      tb.COMPARE_TDEST(2,stestDEST);
      tb.COMPARE_TDATA(mtestDATA[0],stestDATA[0]);
      tb.COMPARE_TSTRB(all_valid_strobe,stestSTRB);
      tb.COMPARE_TKEEP(all_valid_keep,stestKEEP);
      tb.COMPARE_TLAST(1,stestLAST);
      tb.COMPARE_TUSER(mtestUSER,stestUSER);

      // Slave side of example test 1 complete.
      slave_finished_example1 = 1'b1;

      //---------------------------------------------------------------------
      // EXAMPLE TEST 2:
      // Looped sequential write and read transfers example.
      // DESCRIPTION:
      // The following slave code does 3 write and read burst responses in a
      // for loop.
      //---------------------------------------------------------------------
     
      for (j = 0; j < 4; j=j+1) begin
         tb.slave_0.RECEIVE_TRANSFER(0,
                                     `IDVALID_FALSE,
                                     0,
                                     `DESTVALID_FALSE,
                                     stestID,
                                     stestDEST,
                                     stestDATA[j],
                                     stestSTRB,
                                     stestKEEP,
                                     stestLAST,
                                     stestUSER);
         
         tb.COMPARE_TID(j+1,stestID);
         tb.COMPARE_TDEST(j+4,stestDEST);
         tb.COMPARE_TDATA(mtestDATA[j],stestDATA[j]);
         tb.COMPARE_TSTRB(all_valid_strobe,stestSTRB);
         tb.COMPARE_TKEEP(all_valid_keep,stestKEEP);
         if (j == 3) begin
            tb.COMPARE_TLAST(1'b1,stestLAST);
         end
         else begin
            tb.COMPARE_TLAST(1'b0,stestLAST);
         end
         tb.COMPARE_TUSER(mtestUSER,stestUSER);
      end

      // Slave side of example test 2 complete.
      slave_finished_example2 = 1'b1;

      //---------------------------------------------------------------------
      // EXAMPLE TEST 3:
      // Simple master to slave packet example
      // DESCRIPTION:
      // The following slave code receives a simple AXI 4 Streaming packet.
      //---------------------------------------------------------------------
      
      tb.slave_0.RECEIVE_PACKET(0,
                                `IDVALID_FALSE,
                                0,
                                `DESTVALID_FALSE,
                                stestID,
                                stestDEST,
                                v_stestDATA[0],
                                stestDATASIZE,
                                v_stestUSER[0]);
      
      tb.COMPARE_TID(7,stestID);
      tb.COMPARE_TDEST(8,stestDEST);
      tb.COMPARE_DATASIZE(mtestDATASIZE,stestDATASIZE);
      tb.COMPARE_TDATA_VECTOR(v_mtestDATA,v_stestDATA[0]);
      tb.COMPARE_TUSER_VECTOR(v_mtestUSER,v_stestUSER[0]);

      // Slave side of example test 3 complete.
      slave_finished_example3 = 1'b1;

      //---------------------------------------------------------------------
      // EXAMPLE TEST 4:
      // Looped packets example.
      // DESCRIPTION:
      // The following slave code receives 3 packets in a row.
      //---------------------------------------------------------------------
     
      for (j = 0; j < 4; j=j+1) begin
         stestID = j+1;
         stestDEST = j+4;

         tb.slave_0.RECEIVE_PACKET(stestID,
                                   `IDVALID_TRUE,
                                   stestDEST,
                                   `DESTVALID_TRUE,
                                   stestID,
                                   stestDEST,
                                   v_stestDATA[0],
                                   stestDATASIZE,
                                   v_stestUSER[0]);
         
         tb.COMPARE_TID(j+1,stestID);
         tb.COMPARE_TDEST(j+4,stestDEST);
         tb.COMPARE_DATASIZE(mtestDATASIZE,stestDATASIZE);
         tb.COMPARE_TDATA_VECTOR(v_mtestDATA,v_stestDATA[0]);
         tb.COMPARE_TUSER_VECTOR(v_mtestUSER,v_stestUSER[0]);
      end

      // Slave side of example test 4 complete.
      slave_finished_example4 = 1'b1;

      //---------------------------------------------------------------------
      // EXAMPLE TEST 5:
      // Ragged master to slave packet example
      // DESCRIPTION:
      // The following slave code receives a ragged AXI 4 Streaming packet.
      //---------------------------------------------------------------------
      
      tb.slave_0.RECEIVE_PACKET(0,
                                `IDVALID_FALSE,
                                0,
                                `DESTVALID_FALSE,
                                stestID,
                                stestDEST,
                                v_stestDATA[0],
                                stestDATASIZE,
                                v_stestUSER[0]);
      
      tb.COMPARE_TID(7,stestID);
      tb.COMPARE_TDEST(8,stestDEST);
      tb.COMPARE_DATASIZE(mtestDATASIZE,stestDATASIZE);
      tb.COMPARE_TDATA_VECTOR(v_mtestDATA,v_stestDATA[0]);
      tb.COMPARE_TUSER_VECTOR(v_mtestUSER,v_stestUSER[0]);

      // Slave side of example test 5 complete.
      slave_finished_example5 = 1'b1;

      //---------------------------------------------------------------------
      // EXAMPLE TEST 6:
      // Packet Data Interleaving
      // DESCRIPTION:
      // The following slave code receives a set of 3 interleaved AXI 4 
      // Streaming packets.
      //---------------------------------------------------------------------

      fork
         begin
            tb.slave_0.RECEIVE_PACKET(1,
                                      `IDVALID_TRUE,
                                      1,
                                      `DESTVALID_TRUE,
                                      stestID,
                                      stestDEST,
                                      v_stestDATA[0],
                                      stestDATASIZE,
                                      v_stestUSER[0]);
            
            tb.COMPARE_TID(1,stestID);
            tb.COMPARE_TDEST(1,stestDEST);
            tb.COMPARE_DATASIZE(mtestDATASIZE,stestDATASIZE);
            tb.COMPARE_TDATA_VECTOR(v_mtestDATA,v_stestDATA[0]);
            tb.COMPARE_TUSER_VECTOR(v_mtestUSER,v_stestUSER[0]);
         end
         begin
            tb.slave_0.RECEIVE_PACKET(2,
                                      `IDVALID_TRUE,
                                      2,
                                      `DESTVALID_TRUE,
                                      stestID,
                                      stestDEST,
                                      v_stestDATA[1],
                                      stestDATASIZE,
                                      v_stestUSER[1]);
            
            tb.COMPARE_TID(2,stestID);
            tb.COMPARE_TDEST(2,stestDEST);
            tb.COMPARE_DATASIZE(mtestDATASIZE,stestDATASIZE);
            tb.COMPARE_TDATA_VECTOR(v_mtestDATA,v_stestDATA[1]);
            tb.COMPARE_TUSER_VECTOR(v_mtestUSER,v_stestUSER[1]);
         end
         begin
            tb.slave_0.RECEIVE_PACKET(3,
                                      `IDVALID_TRUE,
                                      3,
                                      `DESTVALID_TRUE,
                                      stestID,
                                      stestDEST,
                                      v_stestDATA[2],
                                      stestDATASIZE,
                                      v_stestUSER[2]);
            
            tb.COMPARE_TID(3,stestID);
            tb.COMPARE_TDEST(3,stestDEST);
            tb.COMPARE_DATASIZE(mtestDATASIZE,stestDATASIZE);
            tb.COMPARE_TDATA_VECTOR(v_mtestDATA,v_stestDATA[2]);
            tb.COMPARE_TUSER_VECTOR(v_mtestUSER,v_stestUSER[2]);
         end         
      join
      
      // Slave side of example test 6 complete.
      slave_finished_example6 = 1'b1;

      // Slave side of example test complete.
      slave_finished = 1'b1;
   end
   
endmodule
//----------------------------------------------------------------------------
// END OF FILE
//----------------------------------------------------------------------------
