module RegisterUnit ( input                        Clk, Reset, LD_REG,
                    input                    [15:0] BUS,
                    input [2:0] DR_MUX_OUT, SR1_MUX_OUT, SR2,
                    output logic             [15:0] SR1_OUT, SR2_OUT);
       
       
       
logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7; //all da registers
logic [7:0] register_select;

decoder DECODE(.DR_MUX_OUT(DR_MUX_OUT), .R0(register_select[0]), .R1(register_select[1]),.R2(register_select[2]),.R3(register_select[3]),
.R4(register_select[4]),.R5(register_select[5]),.R6(register_select[6]),.R7(register_select[7]));


SRMUX SR1_SELECT(.*, .SR_SELECT(SR1_MUX_OUT), .R0(R0), .R1(R1),.R2(R2),.R3(R3),.R4(R4), .R5(R5),.R6(R6),.R7(R7), .SR_OUT(SR1_OUT));

SRMUX SR2_SELECT(.*, .SR_SELECT(SR2), .R0(R0), .R1(R1),.R2(R2),.R3(R3),.R4(R4), .R5(R5),.R6(R6),.R7(R7), .SR_OUT(SR2_OUT));


reg_16 R0_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[0]), .D(BUS), .Data_Out(R0));
reg_16 R1_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[1]), .D(BUS), .Data_Out(R1));
reg_16 R2_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[2]), .D(BUS), .Data_Out(R2));
reg_16 R3_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[3]), .D(BUS), .Data_Out(R3));
reg_16 R4_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[4]), .D(BUS), .Data_Out(R4));
reg_16 R5_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[5]), .D(BUS), .Data_Out(R5));
reg_16 R6_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[6]), .D(BUS), .Data_Out(R6));
reg_16 R7_reg (.Clk(Clk), .Reset(Reset), .Load(LD_REG&register_select[7]), .D(BUS), .Data_Out(R7));

endmodule