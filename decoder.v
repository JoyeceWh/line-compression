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
// Date:             2018-03-22 17:08                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-03-22 17:08        version 1.0     Wang Hang                        //
// Abstract: Initial                                                          //
//                                                                            //
// *********************************end************************************** //

// INCLUDE FILE

// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module decoder(
    clk_i,
    ngrst,

    data_en_i,

    package_data,

    Y_decom,
    Y_decom_en

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input    clk_i;
input    ngrst;

input    data_en_i;

input [31:0]    package_data;

output [7:0]    Y_decom;
output    Y_decom_en;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------
reg [31:0] package_data_d1,package_data_d2;
reg [2:0]  q_d1,q_d2,q_d3;
reg [3:0]  pixel_counter,pixel_counter_d1,pixel_counter_d2,pixel_counter_d3;
reg        data_en_i_d1,data_en_i_d2,data_en_i_d3;
reg [7:0]  first_pixel,first_pixel_d1,first_pixel_d2;
wire [8:0] decode_resi;
wire [7:0] decoder_pixel;
reg [2:0] q;

wire stat_flag_i;
//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        {q_d1,q_d2,q_d3} <= 12'd0;
    else
        {q_d1,q_d2,q_d3} <= {q,q_d1,q_d2};
end


always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        pixel_counter <= 4'd8;
    else if (pixel_counter == 4'd8) 
        pixel_counter <= 4'd1;
    else
        pixel_counter <= pixel_counter +4'd1;
end

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        {pixel_counter_d1,pixel_counter_d2,pixel_counter_d3} <= 12'd0;
    else
        {pixel_counter_d1,pixel_counter_d2,pixel_counter_d3} <= {pixel_counter,pixel_counter_d1,pixel_counter_d2};
end


always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst) begin
        q <= 3'd0;
        first_pixel <= 8'd0;
    end else begin
        q <= package_data_d1[31:29];
        first_pixel <= package_data_d1[28:21];
    end
end


always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        {first_pixel_d1,first_pixel_d2} <= 16'd0;
    else
        {first_pixel_d1,first_pixel_d2} <= {first_pixel,first_pixel_d1};
end

always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        {package_data_d1,package_data_d2} <= 64'd0;
    else
        {package_data_d1,package_data_d2} <= {package_data,package_data_d1};
end


codeword_read code_read_tmp(
   .clk_i               (clk_i ),
   .ngrst               (ngrst ),

   .package_data        (package_data_d1[20:0]),
   .stat_flag       (stat_flag_i),
   
   .decode_resi         (decode_resi )

);


inverse_DPCM invdpcm_tmp(
    .clk_i               (clk_i),
    .ngrst               (ngrst),
    
    .quan_l              (q),
    .first_pixel         (first_pixel),
    .residual            (decode_resi),
    .pixel_counter       (pixel_counter_d1),

    .decoder_pixel       (decoder_pixel)
    

);

always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        {data_en_i_d1,data_en_i_d2,data_en_i_d3} <= 3'd0;
    else
        {data_en_i_d1,data_en_i_d2,data_en_i_d3} <= {data_en_i,data_en_i_d1,data_en_i_d2};
end


assign Y_decom = (pixel_counter_d1==4'd1) ? first_pixel : decoder_pixel;
assign Y_decom_en = data_en_i_d2;

assign stat_flag_i=(pixel_counter==4'd1)? 1'b1:1'b0;








endmodule
// END OF MODULE

