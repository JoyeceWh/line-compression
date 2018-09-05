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
// Date:             2018-03-23 14:15                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-03-23 14:15        version 1.0     Wang Hang                        //
// Abstract: Initial                                                          //
//                                                                            //
// *********************************end************************************** //

// INCLUDE FILE

// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module codeword_read(
    clk_i,
    ngrst,

    package_data,
    stat_flag,
    
    decode_resi

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input   clk_i;
input   ngrst;

input [20:0]  package_data;
input  stat_flag;
   
//output [8:0]  unary_code;
//output [8:0]  binary_dode;
output [8:0]  decode_resi;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------

reg [8:0]  decode_resi;

reg [20:0] remain_pack;
reg [20:0] read_buffer;
reg [5:0]  code_lenth;

//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------

//assign move_bit = remain_bit - code_length;
//always @(posedge clk_i or negedge ngrst) begin
//    if(!ngrst)
//        remain_bit <= 5'd21;
//    else if (last_pixel)
//        remain_bit <= 5'd21;
//    else
//        remain <= move_bit;
//end
//

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        remain_pack <= 21'd0;
    else
        remain_pack <= read_buffer;
end

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst)
        code_lenth <= 0;
    else 
         casez(read_buffer[20:12]) 
             9'b1???????? : code_lenth <= 4'd1;
             9'b01??????? : code_lenth <= 4'd3;
             9'b001?????? : code_lenth <= 4'd5;
             9'b0001????? : code_lenth <= 4'd7;
             9'b00001???? : code_lenth <= 4'd9;
             9'b000001??? : code_lenth <= 4'd11;
             9'b0000001?? : code_lenth <= 4'd13;
             9'b00000001? : code_lenth <= 4'd15;
             9'b000000001 : code_lenth <= 5'd17;
             default      : code_lenth <= 4'd0;
         endcase
end

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst) begin
        decode_resi  <= 9'd0;
    end
    else 
         casez(read_buffer[20:12]) 
            9'b1???????? : begin
                decode_resi <= 8'd0;
            end
            9'b01??????? : begin
                decode_resi <= read_buffer[18] + 8'd1;
            end
            9'b001?????? : begin
                decode_resi <= read_buffer[17:16] + 8'd3;
            end
            9'b0001????? : begin
                decode_resi <= read_buffer[16:14] + 8'd7;
            end
            9'b00001???? : begin
                decode_resi <= read_buffer[15:12] + 8'd15;
            end
            9'b000001??? : begin
                decode_resi <= read_buffer[14:10] + 8'd31;
            end
            9'b0000001?? :  begin
                decode_resi <= read_buffer[13:08] + 8'd63;
            end
            9'b00000001? : begin
                decode_resi <= read_buffer[12:06] + 8'd127;
            end 
            9'b000000001 : begin
                decode_resi <= read_buffer[11:04] + 8'd255;
            end
            default :
                decode_resi  <= 8'd0;
            endcase
end




/*
always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst) begin
        unary_code  <= 8'd0;
        binary_code <= 8'd0;
    end
    else begin
         case(read_buffer[20:13]) begin
            9'b1???????? : begin
                unary_code  <= 8'd0;
                binary_code <= 8'd0;
            end
            9'b01??????? : begin
                unary_code  <= read_buffer[20];
                binary_code <= read_buffer[18];
            9'b001?????? : begin
                unary_code  <= read_buffer[20:19];
                binary_code <= read_buffer[17:16];
            end
            9'b0001????? : begin
                unary_code  <= read_buffer[20:18];
                binary_code <= read_buffer[16:14];
            end
            9'b00001???? : begin
                unary_code  <= read_buffer[20:17];
                binary_code <= read_buffer[15:12];
            end
            9'b000001??? : 
                begin
                unary_code  <= read_buffer[20:16];
                binary_code <= read_buffer[14:10];
            end
            9'b0000001?? : 
                begin
                unary_code  <= read_buffer[20:15];
                binary_code <= read_buffer[13:08];
            end
            9'b00000001? :
               begin
                unary_code  <= read_buffer[20:14];
                binary_code <= read_buffer[12:06];
            end 
            9'b000000001 : 
                begin
                unary_code  <= read_buffer[20:13];
                binary_code <= read_buffer[11:04];
            end
         end
     end
end
*/

always @(*) begin
    read_buffer = code_lenth[0] ? {remain_pack[19:0],1'd0} : remain_pack;
    read_buffer = code_lenth[1] ? {read_buffer[18:0],2'd0} : read_buffer;
    read_buffer = code_lenth[2] ? {read_buffer[16:0],4'd0} : read_buffer;
    read_buffer = code_lenth[3] ? {read_buffer[12:0],8'd0} : read_buffer;
    read_buffer = (stat_flag) ? package_data : read_buffer;
    
end











endmodule
// END OF MODULE

