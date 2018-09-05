// ************************Declaration*************************************** //
// This Verilog file was developed by The Institute of Artificial Intelli-    //
// gence and Robotics, Xi'an Jiaotong University. This file contains infor-   //
// mation confidential and proprietary to The Institute of Artificial         //
// Intelligence and Robotics, Xi'an Jiaotong University. It shall not be      //
// reproduced in whole, or in part, or transferred to other documents,or      //
// disclosed to third parties, or used for any purpose other than that for    //
// which it was obtained, without the prior written consent of The Institute  //
// of Artificial Intelligence and Robotics, Xi'an Jiaotong University. This   //
// notice must accompany any copy of this file.                               //
//                                                                            //
// Copyright (c) 1986--2011 The Institute of Artificial Intelligence and      //
// Robotics,Xi'an Jiaotong University. All rights reserved                    //
//                                                                            //
// File name:                                                                 //
// Author:           Wang Hang                                                //
// Date:             2018-03-17 15:49                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-03-17 15:49        version 1.0     Wang Hang                        //
// Abstract: Initial                                                          //
//                                                                            //
// *********************************end************************************** //

// INCLUDE FILE

// 1 clock to count length and buffer the codeword





// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module package(
    clk_i,
    ngrst,
   
    codeword,
    code_length,
    
    pixel_counter,

    package_codeword,
    package_length,
    state
    

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------
parameter QW=3'd0;

//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input   clk_i;
input   ngrst;
  
input [31:0]  codeword;
input [6:0]   code_length;
   
input [3:0]  pixel_counter;

output [31:0]    package_codeword;
output [9:0]     package_length;
output           state;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------
wire [31:0] package_tmp;
reg [31:0]  tmp;
wire [31:0] pack_code_tmp;
wire [5:0]  move_bit;
wire        last_package_wire;
reg         last_package,last_package_d1;
wire         state;
reg [31:0]    package_codeword;
reg [9:0]     package_length;
reg [5:0]     remain_bit;
//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------
assign move_bit= remain_bit - code_length;

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        remain_bit <= 6'd29;
    else if (last_package_wire)
        remain_bit <= 6'd21;
    else
        remain_bit <= move_bit;
end

always @(codeword or move_bit) begin
    tmp = move_bit[0] ? {codeword[30:0],1'd0} : codeword;
    tmp = move_bit[1] ? {tmp[29:0],2'd0} : tmp;
    tmp = move_bit[2] ? {tmp[27:0],4'd0} : tmp;
    tmp = move_bit[3] ? {tmp[23:0],8'd0} : tmp;
    tmp = move_bit[4] ? {tmp[15:0],16'd0} : tmp;
end


assign  pack_code_tmp = last_package_wire ? {3'b0,codeword[7:0],21'd0}: (package_codeword + tmp);
//assign  pack_code_tmp =  pack_code_tmp + tmp;

always @(posedge clk_i or negedge ngrst)begin
    if (!ngrst)
        package_codeword <= 0;
    else if(last_package_wire) 
        package_codeword <= {3'b0,codeword[7:0],21'd0};
    else
        package_codeword <= pack_code_tmp;
end



always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        package_length <= 10'd0;
    else if (last_package_wire)
        package_length <= 10'd8;
    else
        package_length <= package_length + code_length;
end

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        last_package <= 1'd0;
    else if (pixel_counter == 4'd1)
        last_package <= 7'd1;
    else
        last_package <= 1'd0;
end

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        last_package_d1 <= 1'd0;
    else
        last_package_d1 <= last_package;
end

assign last_package_wire=(pixel_counter==1)? 1'b1:1'b0;
        
assign state = last_package_wire ? ( package_length > 6'd29 ? 1'd0 : 1'd1) : 1'd0;

//always @(posedge clk_i or negedge ngrst) begin
//    if (!ngrst)
//        state <= 1'd1;
//    else if (state_tmp == 1'd0)
//        state <= 1'd0;
//    else
//        state <= state;
//end


endmodule
// END OF MODULE

