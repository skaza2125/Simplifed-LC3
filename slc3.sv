//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//      Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//------------------------------------------------------------------------------


module slc3(
    input logic [15:0] SW,
    input logic    Clk, Reset, Run, Continue,
    output logic [15:0] LED,
    input logic [15:0] Data_from_SRAM,
    output logic OE, WE,
    output logic [7:0] hex_seg,
    output logic [3:0] hex_grid,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,
    output logic [15:0] ADDR,
    output logic [15:0] Data_to_SRAM
);

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC, ALU;//amaan said let this be output of registers

logic [3:0] hex_4[3:0]; 
logic [2:0] NZP, NZP_OUT;

//create local variables 


//input to bus mux is all of the gate signals + MDR, PC(will need to add more later)



logic [15:0] PC_MUX_OUT, MDR_MUX_OUT,ADDR2_MUX_OUT, ADDR1_MUX_OUT,ALU_OUT,SR2_MUX_OUT;
logic [15:0] BUS_OUT; // output of bus
logic [2:0] SR1_MUX_OUT, DR_MUX_OUT; // output of the SR1 Mux, DRMUX, SR2MUX and ALU 

logic[15:0] SR1_OUT, SR2_OUT; // outputs of the register
logic BEN_IN;



HexDriver HexA (
    .clk(Clk),
    .reset(Reset),
    .in({hex_4[3][3:0],  hex_4 [2][3:0], hex_4[1][3:0], hex_4[0][3:0]}),
    .hex_seg(hex_seg),
    .hex_grid(hex_grid)
);

//HexDriver HexA (
//    .clk(Clk),
//    .reset(Reset),
//    .in({IR[15:12],  IR[11:8], IR[7:4], IR[3:0]}),
//    .hex_seg(hex_seg),
//    .hex_grid(hex_grid)
//);

HexDriver HexB (
    .clk(Clk),
    .reset(Reset),
    .in({PC[15:12],  PC[11:8], PC[7:4], PC[3:0]}),
    .hex_seg(hex_segB),
    .hex_grid(hex_gridB)
);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//    MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//    input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;

assign LED = IR;

// Instantiate the rest of your modules here according to the block diagram of the SLC-3
// including your register file, ALU, etc..

BUS BUS(.*, .GatePC(GatePC), .GateMDR(GateMDR), .GateALU(GateALU), .GateMARMUX(GateMARMUX), .MDR(MDR), .PC(PC), .ADDITION(ADDR1_MUX_OUT + ADDR2_MUX_OUT), .ALU(ALU_OUT), .BUS_OUT(BUS_OUT)); // the BUS

PC_MUX PC_MUX(.*, .ALU(ADDR1_MUX_OUT + ADDR2_MUX_OUT), .PC(PC),.PCMUX(PCMUX), .BUS_OUT(BUS_OUT), .PC_MUX_OUT(PC_MUX_OUT)); // PC MUX 

MDR_MUX MDR_MUX(.*, .MIO_EN(MIO_EN) , .BUS_OUT(BUS_OUT), .MDR_In(MDR_In), .MDR_MUX_OUT(MDR_MUX_OUT)); // MDR MUX

SR1MUX SR1_MUX(.*, .IR(IR), .SR1MUX(SR1MUX), .SR1_MUX_OUT(SR1_MUX_OUT)); //SR1 MUX

SR2MUX SR2_MUX(.*, .IR(IR[4:0]), .SR2_OUT(SR2_OUT), .SR2MUX(SR2MUX), .SR2_MUX_OUT(SR2_MUX_OUT)); // SR2 MUX

DRMUX DR_MUX(.*, .IR(IR), .DRMUX(DRMUX), .DR_MUX_OUT(DR_MUX_OUT)); // DR MUX

ADDR2MUX ADDR2_MUX(.*, .IR(IR), .ADDR2MUX(ADDR2MUX), .ADDR2_MUX_OUT(ADDR2_MUX_OUT));

ADDR1MUX ADDR1_MUX(.*, .PC(PC), .ADDR1MUX(ADDR1MUX),.SR1_OUT(SR1_OUT), .ADDR1_MUX_OUT(ADDR1_MUX_OUT));

ALU ALU_UNIT(.*, .ALUK(ALUK), .SR1_OUT(SR1_OUT), .SR2_MUX_OUT(SR2_MUX_OUT), .ALU_OUT(ALU_OUT));

RegisterUnit REGISTER_UNIT(.*, .BUS(BUS_OUT), .DR_MUX_OUT(DR_MUX_OUT), .SR1_MUX_OUT(SR1_MUX_OUT), .SR2(IR[2:0]), .SR1_OUT(SR1_OUT), .SR2_OUT(SR2_OUT));




// You may use the second (right) HEX driver to display additional debug information
// For example, Prof. Cheng's solution code has PC being displayed on the right HEX

NZPLogic NZP_LOGIC(.*, .BUS_OUT(BUS_OUT) , .NZP_OUT(NZP));

reg_3 NZP_reg(.*, .Load(LD_CC), .D(NZP), .Data_Out(NZP_OUT));

BENLOGIC BEN_LOGIC(.*);

reg_1 BEN_reg(.*, .Load(LD_BEN), .D(BEN_IN), .Data_Out(BEN));


reg_16 MDR_REG ( .*, .Reset(Reset), .Load(LD_MDR), .D(MDR_MUX_OUT[15:0]), .Data_Out(MDR[15:0]));

reg_16 PC_REG ( .*, .Reset(Reset), .Load(LD_PC), .D(PC_MUX_OUT[15:0]), .Data_Out(PC[15:0]));

reg_16 IR_REG ( .*, .Reset(Reset), .Load(LD_IR), .D(BUS_OUT[15:0]), .Data_Out(IR[15:0]));

reg_16 MAR_REG ( .*, .Reset(Reset), .Load(LD_MAR), .D(BUS_OUT[15:0]), .Data_Out(MAR[15:0]));



// Our I/O controller (note, this plugs into MDR/MAR)

Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]), 
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
    .*, .Reset(Reset), .Run(Run), .Continue(Continue),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE)
);
    
endmodule