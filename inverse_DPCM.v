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
// Date:             2018-04-17 17:39                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-04-17 17:39        version 1.0     Wang Hang                        //
// Abstract: Initial                                                          //
//                                                                            //
// *********************************end************************************** //

// INCLUDE FILE

// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module inverse_DPCM(
    clk_i,
    ngrst,

    quan_l,
    first_pixel,
    residual,
    pixel_counter,

    decoder_pixel
    

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input   clk_i;
input   ngrst;

input [2:0]    quan_l;
input [7:0]  first_pixel;
input [8:0]  residual;
input [3:0]  pixel_counter;

output [7:0]  decoder_pixel;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------
wire [8:0] residual_tmp;
reg [7:0] residual_tmp_q;
wire [7:0] last_pixel;
reg [7:0]  decoder_pixel;

//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------
//

assign residual_tmp = (!residual[0]) ? {1'd0, residual[8:1]} : {1'b1,(residual[7:0] + 1'd1)>>1};

always @(*) begin
    residual_tmp_q = quan_l[0] ? {residual_tmp[6:0],1'd0} : residual_tmp;
    residual_tmp_q = quan_l[1] ? {residual_tmp_q[5:0],2'd0} : residual_tmp_q;
    residual_tmp_q = quan_l[2] ? {residual_tmp_q[3:0],4'd0} : residual_tmp_q;
end
    

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        decoder_pixel <= 8'd0;
    else begin
        if (residual[0]==1'd0)
            decoder_pixel <= last_pixel + residual_tmp_q;
        else
            decoder_pixel <= last_pixel - residual_tmp_q;
    end
end

assign last_pixel = (pixel_counter == 4'd1) ?  first_pixel : decoder_pixel;


endmodule
// END OF MODULE

