
// file: clk_8MHz.v
// (c) Copyright 2017-2018, 2023 Advanced Micro Devices, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_5MHz___4.68750______0.000______50.0_____1009.648____613.025
// clk_8MHz___8.00000______0.000______50.0______923.493____613.025
// clk_16MHz__15.78947______0.000______50.0______820.264____613.025
// clk_32MHz__31.57895______0.000______50.0______722.419____613.025
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary______________12____________0.010

`timescale 1ps/1ps

module clk_8MHz_clk_wiz 

 (// Clock in ports
  // Clock out ports
  output        clk_5MHz,
  output        clk_8MHz,
  output        clk_16MHz,
  output        clk_32MHz,
  input         clk_in1
 );
  // Input buffering
  //------------------------------------
wire clk_in1_clk_8MHz;
wire clk_in2_clk_8MHz;
  IBUF clkin1_ibufg
   (.O (clk_in1_clk_8MHz),
    .I (clk_in1));




  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        clk_5MHz_clk_8MHz;
  wire        clk_8MHz_clk_8MHz;
  wire        clk_16MHz_clk_8MHz;
  wire        clk_32MHz_clk_8MHz;
  wire        clk_out5_clk_8MHz;
  wire        clk_out6_clk_8MHz;
  wire        clk_out7_clk_8MHz;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_clk_8MHz;
  wire        clkfbout_buf_clk_8MHz;
  wire        clkfboutb_unused;
    wire clkout0b_unused;
   wire clkout1b_unused;
   wire clkout2b_unused;
   wire clkout3b_unused;
   wire clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg  [7 :0] seq_reg1 = 0;
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg  [7 :0] seq_reg2 = 0;
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg  [7 :0] seq_reg3 = 0;
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg  [7 :0] seq_reg4 = 0;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (50.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (128.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (75),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKOUT2_DIVIDE       (38),
    .CLKOUT2_PHASE        (0.000),
    .CLKOUT2_DUTY_CYCLE   (0.500),
    .CLKOUT2_USE_FINE_PS  ("FALSE"),
    .CLKOUT3_DIVIDE       (19),
    .CLKOUT3_PHASE        (0.000),
    .CLKOUT3_DUTY_CYCLE   (0.500),
    .CLKOUT3_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (83.333))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_clk_8MHz),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clk_5MHz_clk_8MHz),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clk_8MHz_clk_8MHz),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clk_16MHz_clk_8MHz),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clk_32MHz_clk_8MHz),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_clk_8MHz),
    .CLKIN1              (clk_in1_clk_8MHz),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0));

// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------

  BUFG clkf_buf
   (.O (clkfbout_buf_clk_8MHz),
    .I (clkfbout_clk_8MHz));







  BUFGCE clkout1_buf
   (.O   (clk_5MHz),
    .CE  (seq_reg1[7]),
    .I   (clk_5MHz_clk_8MHz));

  BUFH clkout1_buf_en
   (.O   (clk_5MHz_clk_8MHz_en_clk),
    .I   (clk_5MHz_clk_8MHz));
  always @(posedge clk_5MHz_clk_8MHz_en_clk)
        seq_reg1 <= {seq_reg1[6:0],locked_int};


  BUFGCE clkout2_buf
   (.O   (clk_8MHz),
    .CE  (seq_reg2[7]),
    .I   (clk_8MHz_clk_8MHz));
 
  BUFH clkout2_buf_en
   (.O   (clk_8MHz_clk_8MHz_en_clk),
    .I   (clk_8MHz_clk_8MHz));
 
  always @(posedge clk_8MHz_clk_8MHz_en_clk)
        seq_reg2 <= {seq_reg2[6:0],locked_int};


  BUFGCE clkout3_buf
   (.O   (clk_16MHz),
    .CE  (seq_reg3[7]),
    .I   (clk_16MHz_clk_8MHz));
 
  BUFH clkout3_buf_en
   (.O   (clk_16MHz_clk_8MHz_en_clk),
    .I   (clk_16MHz_clk_8MHz));
 
  always @(posedge clk_16MHz_clk_8MHz_en_clk)
        seq_reg3 <= {seq_reg3[6:0],locked_int};


  BUFGCE clkout4_buf
   (.O   (clk_32MHz),
    .CE  (seq_reg4[7]),
    .I   (clk_32MHz_clk_8MHz));

  BUFH clkout4_buf_en
   (.O   (clk_32MHz_clk_8MHz_en_clk),
    .I   (clk_32MHz_clk_8MHz));
	
  always @(posedge clk_32MHz_clk_8MHz_en_clk)
        seq_reg4 <= {seq_reg4[6:0],locked_int};





endmodule
