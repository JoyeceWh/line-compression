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
// Date:             2018-03-16 15:44                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-03-16 15:44        version 1.0     Wang Hang                        //
// Abstract: Initial                                                          //
//                                                                            //
// *********************************end************************************** //

// 2 clock to finish the exp-golomb coding

// INCLUDE FILE

// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module Exp_Golomb(
    
    clk_i,
    ngrst,

    residual_q,
    pixel_counter,

    codeword,
    code_lingth

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input   clk_i;
input   ngrst;

input [8:0]  residual_q;
input [3:0]  pixel_counter;

output [31:0]   codeword;
output [6:0]  code_lingth;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------
reg [8:0] residual_mapping;
reg [19:0] res_map_tmp;
reg [7:0] residual_q_d1;
reg [8:0] group_id;
reg [6:0]  code_lingth;
reg [31:0]   codeword;
reg [3:0] pixel_counter_d1;
wire [8:0] rmd;
//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------


always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        pixel_counter_d1 <= 9'd0;
    else
        pixel_counter_d1 <= pixel_counter;
end



always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        residual_mapping <= 9'd0;
    else if(residual_q[8] == 0)
        residual_mapping <= {residual_q[7:0],1'b0};
    else
        residual_mapping <= {residual_q[7:0],1'b0} - 1'd1;
end


always @(*) begin  //Exp_Golomb
    if(!ngrst) begin
        group_id = 9'b111111111;
    end else if (residual_mapping==0)begin 
        group_id = 9'b111111111;
    end else if ((residual_mapping>=1'b1)&&(residual_mapping<=1'b1+1'b1))begin
        group_id = 9'b111111110;
    end else if ((residual_mapping>=2'b11)&&(residual_mapping<=2'b11+2'b11))begin
        group_id = 9'b111111100;
    end else if ((residual_mapping>=3'b111)&&(residual_mapping<=3'b111+3'b111))begin
        group_id = 9'b111111000;
    end else if ((residual_mapping>=4'b1111)&&(residual_mapping<=4'b1111+4'b1111))begin
        group_id = 9'b111110000;
    end else if ((residual_mapping>=5'b11111)&&(residual_mapping<=5'b11111+5'b11111))begin
        group_id = 9'b111100000;
    end else if ((residual_mapping>=6'b111111)&&(residual_mapping<=6'b111111+6'b111111))begin
        group_id = 9'b111000000;
    end else if ((residual_mapping>=7'b1111111)&&(residual_mapping<=7'b1111111+7'b1111111))begin
        group_id = 9'b110000000;
    end else if ((residual_mapping>=8'b11111111)&&(residual_mapping<=8'b11111111+8'b11111111))begin
        group_id = 9'b100000000;
    end else if ((residual_mapping>=9'b111111111)&&(residual_mapping<=9'b111111111+9'b111111111))begin
        group_id = 9'b000000000;
    end else
        group_id = 9'b111111111;
end

assign rmd=residual_mapping-~group_id;

always @(*)//form codeword
  begin 
    case(group_id)
	    9'b111111111: res_map_tmp=19'b1;
		9'b111111110: res_map_tmp={group_id[0],1'b1,rmd[0]};
		9'b111111100: res_map_tmp={group_id[1:0],1'b1,rmd[1:0]};
        9'b111111000: res_map_tmp={group_id[2:0],1'b1,rmd[2:0]};
		9'b111110000: res_map_tmp={group_id[3:0],1'b1,rmd[3:0]};
		9'b111100000: res_map_tmp={group_id[4:0],1'b1,rmd[4:0]};
		9'b111000000: res_map_tmp={group_id[5:0],1'b1,rmd[5:0]};
		9'b110000000: res_map_tmp={group_id[6:0],1'b1,rmd[6:0]};
		9'b100000000: res_map_tmp={group_id[7:0],1'b1,rmd[7:0]};
		9'b000000000: res_map_tmp={group_id[8:0],1'b1,rmd[8:0]};
		default: $display("group_id invalid");
	 endcase
  end

//assign res_map_tmp = residual_mapping + 1'd1;
//always @(*) begin
//    if(!ngrst) begin
//        group_id = 0;
//        iso_flag = 32'd1;
//    end else if (res_map_tmp[8]==1)begin 
//        group_id = 4'd7;
//        iso_flag = 32'd128;
//    end else if (res_map_tmp[7]==1)begin
//        group_id = 4'd6;
//        iso_flag = 32'd64;
//    end else if (res_map_tmp[6]==1)begin
//        group_id = 4'd5;
//        iso_flag = 32'd34;
//    end else if (res_map_tmp[5]==1)begin
//        group_id = 4'd4;
//        iso_flag = 32'd16;
//    end else if (res_map_tmp[4]==1)begin
//        group_id = 4'd3;
//        iso_flag = 32'd8;
//    end else if (res_map_tmp[3]==1)begin
//        group_id = 4'd2;
//        iso_flag = 32'd4;
//    end else if (res_map_tmp[2]==1)begin
//        group_id = 4'd1;
//        iso_flag = 32'd2;
//    end else if (res_map_tmp[1]==1)begin
//        group_id = 4'd0;
//        iso_flag = 32'd1;
//    end else
//        group_id = 4'd0;
//        iso_flag = 32'd1;
//end




        
always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        code_lingth <= 7'd0;
    else if (pixel_counter_d1 == 4'd1)
        code_lingth <= 7'd8;
    else
      begin
		 case(group_id)
			9'b111111111: code_lingth<=7'd1;
			9'b111111110: code_lingth<=7'd3;
			9'b111111100: code_lingth<=7'd5;
			9'b111111000: code_lingth<=7'd7;
			9'b111110000: code_lingth<=7'd9;
			9'b111100000: code_lingth<=7'd11;
			9'b111000000: code_lingth<=7'd13;
			9'b110000000: code_lingth<=7'd15;
			9'b100000000: code_lingth<=7'd17;
			9'b000000000: code_lingth<=7'd19;
			default:$display("invalid group_id_d!");
		 endcase
      end

end

always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        residual_q_d1 <= 8'd0;
    else
        residual_q_d1 <= residual_q;
end


always @(posedge clk_i or negedge ngrst) begin
    if(!ngrst)
        codeword <= 32'd0;
    else if (pixel_counter_d1 == 4'd1)
        codeword <= {24'd0,residual_q_d1};
    else
        codeword <= {12'd0,res_map_tmp};
end



endmodule
// END OF MODULE

