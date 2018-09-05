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
// Date:             2018-03-15 21:46                                         //
// Version Number:   1.0                                                      //
// Abstract:                                                                  //
//                                                                            //
// Modification history:(including time, version, author and abstract)        //
// 2018-03-15 21:46        version 1.0     Wang Hang                          //
// Abstract: Initial                                                          //
//                                                                            //
// *********************************end************************************** //

// INCLUDE FILE

// MODULE DECLARATION
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// INDEX: Module 
//------------------------------------------------------------------------------
module encoder(
    clk_i,
    ngrst,

    data_en_i,

    Y,

    package_data,
    data_en_pa

);

//------------------------------------------------------------------------------
// INDEX:   1. Definitions
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2. Interface
//------------------------------------------------------------------------------

input           clk_i;
input           ngrst;

input           data_en_i;

input [7:0]  Y;

output [31:0]   package_data;
output          data_en_pa;

//------------------------------------------------------------------------------
// INDEX:   3. Wire and Reg Declarations
//------------------------------------------------------------------------------
reg [7:0] data_d1,data_d2,data_d3;
reg       data_en_d1,data_en_d2,data_en_d3;
wire de_flag;
reg [31:0]   package_data;

reg [3:0] pixel_counter;
reg [3:0] pixel_counter_d1,pixel_counter_d2,pixel_counter_d3,pixel_counter_d4,pixel_counter_d5;

wire [8:0] residual_q0,residual_q1,residual_q2,residual_q3,residual_q4,residual_q5,residual_q6,residual_q7;
wire [31:0] codeword_q0,codeword_q1,codeword_q2,codeword_q3,codeword_q4,codeword_q5,codeword_q6,codeword_q7;
wire [6:0] code_length_q0,code_length_q1,code_length_q2,code_length_q3,code_length_q4,code_length_q5,code_length_q6,code_length_q7;
wire [31:0] package_codeword_q0,package_codeword_q1,package_codeword_q2,package_codeword_q3,package_codeword_q4,package_codeword_q5,package_codeword_q6,package_codeword_q7;
wire [9:0] package_length_q0,package_length_q1,package_length_q2,package_length_q3,package_length_q4,package_length_q5,package_length_q6,package_length_q7;
wire state_q0,state_q1,state_q2,state_q3,state_q4,state_q5,state_q6,state_q7;
wire data_en_pa;
//------------------------------------------------------------------------------
// INDEX:   4. Internal Parameters
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   5. Verilog Instance
//------------------------------------------------------------------------------

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst) begin
        {data_d1,data_d2,data_d3} <= 24'd0;
        {data_en_d1,data_en_d2,data_en_d3}   <= 3'd0;
    end
    else begin
        {data_d1,data_d2,data_d3} <= {Y,data_d1,data_d2};
        {data_en_d1,data_en_d2,data_en_d3}   <= {data_en_i,data_en_d1,data_en_d2};
    end
end

assign de_flag = data_en_d2 && !data_en_d3;

always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst) 
        pixel_counter <= 4'd0;
    else if (pixel_counter == 4'd8 || de_flag == 1'd1) 
        pixel_counter <= 4'd1;
    else if (data_en_d2)
        pixel_counter <= pixel_counter + 4'd1;
end


always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst) 
        {pixel_counter_d1,pixel_counter_d2,pixel_counter_d3,pixel_counter_d4,pixel_counter_d5} <= 20'd0;
    else
        {pixel_counter_d1,pixel_counter_d2,pixel_counter_d3,pixel_counter_d4,pixel_counter_d5} <= {pixel_counter,pixel_counter_d1,pixel_counter_d2,pixel_counter_d3,pixel_counter_d4};
end


DPCM_Quan #(.QW(3'd0)) quan_0(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q0)
) ; 

DPCM_Quan #(.QW(3'd1)) quan_1(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q1)
)  ;

DPCM_Quan #(.QW(3'd2)) quan_2(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q2)
)  ;

DPCM_Quan #(.QW(3'd3)) quan_3(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q3)
)  ;

DPCM_Quan #(.QW(3'd4)) quan_4(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q4)
) ; 

DPCM_Quan #(.QW(3'd5)) quan_5(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q5)
)  ;

DPCM_Quan #(.QW(3'd6)) quan_6(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q6)
)  ;

DPCM_Quan #(.QW(3'd7)) quan_7(

    .clk_i          (clk_i),
    .ngrst          (ngrst),
    .pixel_counter  (pixel_counter),
    .data_in        (data_d3),
    .residual_q     (residual_q7)
)  ;

Exp_Golomb exp_coding_q0(
    
   .clk_i           (clk_i        ),
   .ngrst          (ngrst),
                                 
   .residual_q      (residual_q0   ),
   .pixel_counter   (pixel_counter_d1),
                                 
   .codeword        (codeword_q0     ),
   .code_lingth     (code_length_q0  )
);

Exp_Golomb exp_coding_q1(
    
   .clk_i           (clk_i        ),
   .ngrst          (ngrst),
                                 
   .residual_q      (residual_q1   ),
   .pixel_counter   (pixel_counter_d1),
                                 
   .codeword        (codeword_q1     ),
   .code_lingth     (code_length_q1  )
);


Exp_Golomb exp_coding_q2(
    
   .clk_i           (clk_i        ),
   .ngrst          (ngrst),
                                 
   .residual_q      (residual_q2   ),
   .pixel_counter   (pixel_counter_d1),
                                 
   .codeword        (codeword_q2     ),
   .code_lingth     (code_length_q2  )
);

Exp_Golomb exp_coding_q3(
    
   .clk_i           (clk_i        ),
   .ngrst          (ngrst),
                                 
   .residual_q      (residual_q3   ),
   .pixel_counter   (pixel_counter_d1),
                                 
   .codeword        (codeword_q3     ),
   .code_lingth     (code_length_q3  )
);

Exp_Golomb exp_coding_q4(
    
    .clk_i           (clk_i        ),
    .ngrst          (ngrst),
                                  
    .residual_q      (residual_q4   ),
    .pixel_counter   (pixel_counter_d1),
                                  
    .codeword        (codeword_q4     ),
    .code_lingth     (code_length_q4  )
);

Exp_Golomb exp_coding_q5(
    
    .clk_i           (clk_i        ),
    .ngrst          (ngrst),
                                  
    .residual_q      (residual_q5   ),
    .pixel_counter   (pixel_counter_d1),
                                  
    .codeword        (codeword_q5     ),
    .code_lingth     (code_length_q5  )
);

Exp_Golomb exp_coding_q6(
    
    .clk_i           (clk_i        ),
    .ngrst          (ngrst),
                                  
    .residual_q      (residual_q6   ),
    .pixel_counter   (pixel_counter_d1),
                                  
    .codeword        (codeword_q6     ),
    .code_lingth     (code_length_q6  )
);

Exp_Golomb exp_coding_q7(
    
    .clk_i           (clk_i        ),
    .ngrst          (ngrst),
                                  
    .residual_q      (residual_q7   ),
    .pixel_counter   (pixel_counter_d1),
                                  
    .codeword        (codeword_q7     ),
    .code_lingth     (code_length_q7  )
);


package #(.QW(3'd0)) pack_q0(
    .clk_i              ( clk_i         ),
    .ngrst              ( ngrst         ),
                                      
    .codeword           ( codeword_q0      ),
    .code_length        ( code_length_q0   ),
                        
    .pixel_counter      ( pixel_counter_d3 ),
                                      
    .package_codeword   ( package_codeword_q0),
    .package_length     (package_length_q0),
    .state              (state_q0)
);

package #(.QW(3'd1)) pack_q1(
    .clk_i              ( clk_i         ),
    .ngrst              ( ngrst         ),
                                      
    .codeword           ( codeword_q1      ),
    .code_length        ( code_length_q1   ),
                        
    .pixel_counter      ( pixel_counter_d3 ),
                                      
    .package_codeword   ( package_codeword_q1),
    .package_length     (package_length_q1),
    .state              (state_q1)
);

package #(.QW(3'd2)) pack_q2(
    .clk_i              ( clk_i         ),
    .ngrst              ( ngrst         ),
                                      
    .codeword           ( codeword_q2      ),
    .code_length        ( code_length_q2   ),
                        
    .pixel_counter      ( pixel_counter_d3 ),
                                      
    .package_codeword   ( package_codeword_q2),
    .package_length     (package_length_q2),
    .state              (state_q2)
);

package #(.QW(3'd3)) pack_q3(
    .clk_i              ( clk_i         ),
    .ngrst              ( ngrst         ),
                                      
    .codeword           ( codeword_q3      ),
    .code_length        ( code_length_q3   ),
                        
    .pixel_counter      ( pixel_counter_d3 ),
                                      
    .package_codeword   ( package_codeword_q3),
    .package_length     (package_length_q3),
    .state              (state_q3)
);

package #(.QW(3'd4)) pack_q4(
    .clk_i              ( clk_i         ),
    .ngrst              ( ngrst         ),
                                      
    .codeword           ( codeword_q4      ),
    .code_length        ( code_length_q4   ),
                        
    .pixel_counter      ( pixel_counter_d3 ),
                                      
    .package_codeword   ( package_codeword_q4),
    .package_length     (package_length_q4),
    .state              (state_q4)
);

package #(.QW(3'd5)) pack_q5(
    .clk_i              ( clk_i         ),
    .ngrst              ( ngrst         ),
                                      
    .codeword           ( codeword_q5      ),
    .code_length        ( code_length_q5   ),
                        
    .pixel_counter      ( pixel_counter_d3 ),
                                      
    .package_codeword   ( package_codeword_q5),
    .package_length     (package_length_q5),
    .state              (state_q5)
);

package #(.QW(3'd6)) pack_q6(
   .clk_i              ( clk_i         ),
   .ngrst              ( ngrst         ),
                                     
   .codeword           ( codeword_q6      ),
   .code_length        ( code_length_q6   ),
                       
   .pixel_counter      ( pixel_counter_d3 ),
                                     
   .package_codeword   ( package_codeword_q6),
   .package_length     (package_length_q6),
   .state              (state_q6)
);

package #(.QW(3'd7)) pack_q7(
   .clk_i              ( clk_i         ),
   .ngrst              ( ngrst         ),
                                     
   .codeword           ( codeword_q7      ),
   .code_length        ( code_length_q7   ),
                       
   .pixel_counter      ( pixel_counter_d3 ),
                                     
   .package_codeword   ( package_codeword_q7),
   .package_length     (package_length_q7),
   .state              (state_q7)
);


always @(posedge clk_i or negedge ngrst) begin
    if (!ngrst) 
        package_data <= 32'd0;
    else if (state_q0 == 1'd1)// && package_length_q0 < 6'd22)
        package_data <= {3'd0,package_codeword_q0[28:0]};
    else if (state_q1 == 1'd1)// && package_length_q1 < 6'd22)
        package_data <= {3'd1,package_codeword_q1[28:0]};
    else if (state_q2 == 1'd1)// && package_length_q2 < 6'd22)
        package_data <= {3'd2,package_codeword_q2[28:0]};
    else if (state_q3 == 1'd1)// && package_length_q3 < 6'd22)
        package_data <= {3'd3,package_codeword_q3[28:0]};
    else if (state_q4 == 1'd1)// && package_length_q4 < 6'd22)
        package_data <= {3'd4,package_codeword_q4[28:0]};
    else if (state_q5 == 1'd1)// && package_length_q5 < 6'd22)
        package_data <= {3'd5,package_codeword_q5[28:0]};
    else if (state_q6 == 1'd1)// && package_length_q6 < 6'd22)
        package_data <= {3'd6,package_codeword_q6[28:0]};
    else if (state_q7 == 1'd1)// && package_length_q7 < 6'd22)
        package_data <= {3'd7,package_codeword_q7[28:0]};
    else
        package_data <= package_data;

    

//    $display("Now the residual_q0 is %b, time is %d\n",residual_q0,$time);
end


assign  data_en_pa = (pixel_counter_d5 == 4'd8) ? 1'd1 : 1'd0;






endmodule
// END OF MODULE

