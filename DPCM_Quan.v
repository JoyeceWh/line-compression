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
// Date:             2018-03-16 11:20                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-03-16 11:20        version 1.0     Wang Hang                        //
// Abstract: Initia                                                          //
//                                                                            //
// *********************************end************************************** //

// INCLUDE FILE

// 1 clock to finish the quan


// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module DPCM_Quan(

    clk_i,
    ngrst,
    
    pixel_counter,
    data_in,
    residual_q,

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------
parameter QW = 0;

//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input   clk_i;
input   ngrst;

input [3:0]   pixel_counter;
input [7:0]   data_in;
output [8:0]   residual_q;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------
reg [7:0] last_pixel;
reg [8:0]      residual_q;
wire [7:0]      residual_tmp;
wire [8:0]      residual;
wire [7:0]      inverse_res;
//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------

assign residual_tmp = (data_in < last_pixel) ? (last_pixel - data_in) : ( data_in - last_pixel);
assign residual = (data_in < last_pixel) ? {1'd1,residual_tmp} : {1'd0,residual_tmp};


always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        residual_q <= 9'b0000_0000_0;
    else if (pixel_counter == 4'd1)
        residual_q <= data_in;
    else    
        residual_q <= {residual[8], (residual[7:0] >> QW)};
end


assign inverse_res = residual_tmp; 
//assign inverse_res = {(residual_tmp >> QW),QW'd0}; 
//


always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        last_pixel <= 8'b0000_0000;
    else if(residual[8] == 0)   
        last_pixel <= last_pixel + inverse_res ;
    else
        last_pixel <= last_pixel - inverse_res ;
   // $display("last_pixel is %b\n",last_pixel);
   // 
   // $display("residual_tmp is %b\n",residual_tmp );
   // $display("residual is %b\n",residual);
   // $display("data_in is %b\n",data_in );

end




endmodule
// END OF MODULE

