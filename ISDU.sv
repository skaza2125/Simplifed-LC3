//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Given Code - Incomplete ISDU for SLC-3
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//    Revised 07-25-2023
//    Xilinx Vivado
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_OE,
									Mem_WE
				);

	enum logic [4:0] {  Halted, // may need to expand enum logic if we run out of states
						PauseIR1, 
						PauseIR2, 
						S_18, 
						S_33_1,
						S_33_2,
						S_33_3,
						S_35, 
						S_32, 
						S_01,
						S_05,
						S_09,
						S_06,
						S_25_1,
						S_25_2,
						S_25_3,
						S_27,
						S_07,
						S_23,
						S_16_1,
						S_16_2,
						S_16_3,
						S_0,
						S_22,
						S_12,
						S_04,
						S_21}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b0;
		Mem_WE = 1'b0;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;
			S_18 : 
				Next_state = S_33_1; //Notice that we usually have 'R' here, but you will need to add extra states instead 
			S_33_1 :                 //e.g. S_33_2, etc. How many? As a hint, note that the BRAM is synchronous, in addition, 
				Next_state = S_33_2;   //it has an additional output register. 
		    S_33_2 :
		      Next_state = S_33_3;
		    S_33_3:
		      Next_state = S_35;
			S_35 : 
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_32 : 
				case (Opcode)
					4'b0001 : 
						Next_state = S_01;
					4'b0101 :
					   Next_state = S_05;
					4'b1001 :
					   Next_state = S_09;
					4'b0110 :
					   Next_state = S_06;
					4'b0111 :
					   Next_state = S_07;
					4'b0000 :
					   Next_state = S_0; 
					4'b1100 :
					   Next_state = S_12;
					4'b0100 :
					   Next_state = S_04;
					4'b1101 :
					   Next_state = PauseIR1;
					
					// You need to finish the rest of opcodes.....

					default : 
						Next_state = S_18;
				endcase
			S_01 : 
				Next_state = S_18;
			S_05:
			     Next_state = S_18;
            S_09:
                Next_state = S_18;
            S_06:
                Next_state = S_25_1;
            S_25_1:
                Next_state = S_25_2;
            S_25_2:
                Next_state = S_25_3;
            S_25_3:
                Next_state = S_27;
                
            S_27:
                Next_state = S_18;
            S_07:
                Next_state = S_23;
            S_23:
                Next_state = S_16_1;
            S_16_1:
                Next_state = S_16_2;
            S_16_2:
                Next_state = S_16_3;
            S_16_3:
               Next_state = S_18; 
            S_0:
                Next_state = BEN ? S_22 : S_18;
            S_22:
                Next_state = S_18;
            S_12:
                Next_state = S_18;
            S_04:
                Next_state = S_21;
            S_21:
                Next_state = S_18;

			default :;
            
		endcase
		
		
		// Assign control signals based on current state
		case (State)
			Halted: ; 
			S_18 : 
				begin 
					GatePC = 1'b1; // open the PC gate so it can talk on bus
					LD_MAR = 1'b1; // open the mar gate so it can get the value from PC: load it into MAR
					PCMUX = 2'b00; // sets the pc mux to PC+1
					LD_PC = 1'b1; // LOADS PC+1 into PC
				end
			S_33_1, S_33_2 : //You may have to think about this as well to adapt to RAM with wait-states
				begin
					Mem_OE = 1'b1; // choosing the mux mem input 
	           end	
			S_33_3 : //You may have to think about this as well to adapt to RAM with wait-states
				begin
					Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: LD_LED = 1'b1; 
			PauseIR2: LD_LED = 1'b1;  
			S_32 : 
				LD_BEN = 1'b1;
			S_01 : 
				begin 
					SR2MUX = IR_5;
					SR1MUX = 1'b1;
					DRMUX = 1'b0;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
			S_05:
			    begin
			        SR2MUX = IR_5;
					SR1MUX = 1'b1;
					DRMUX = 1'b0;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;			    
				end
            S_09:
               begin
                SR1MUX = 1'b1;
                DRMUX = 1'b0;
                ALUK = 2'b10;
                GateALU = 1'b1;
                LD_REG = 1'b1;
                LD_CC = 1'b1;
			   end
            S_06, S_07:
               begin
                GateMARMUX = 1'b1;
                LD_MAR = 1'b1;
                ADDR2MUX = 2'b01;
                ADDR1MUX =1'b1;
                SR1MUX = 1'b1;
                
			   end
            S_25_1,S_25_2:
                begin
                Mem_OE = 1'b1;
				end
		     S_25_3:
                begin
                Mem_OE = 1'b1;
               LD_MDR = 1'b1;
				end
				
				
            S_27:
                begin
                GateMDR = 1'b1;
                DRMUX = 1'b0;
                LD_REG = 1'b1;
                LD_CC = 1'b1;
				end      
            S_23:
                begin
                //Mem_OE =1'b0; defaults to 0
                GateALU = 1'b1;
                //MIO_EN = 1'b1; cant do this not passed in
                ALUK = 2'b11;
                SR1MUX = 1'b0;
                LD_MDR = 1'b1;
				end
            S_16_1,S_16_2, S_16_3:
                begin
                Mem_WE = 1'b1; //allows mem to be written to
                Mem_OE = 1'b1;
                //GateMDR = 1'b1;
				end
            S_0:
              begin
                //LD_BEN = BEN;  
			  end
            S_22:
                begin
                PCMUX = 2'b10; // output of the adder
                ADDR2MUX = 2'b10; // selects the 9 bit offset
                ADDR1MUX = 1'b0; // selects pc 
                LD_PC = 1'b1; // go inside pc
                
				end
            S_12:
                begin
                SR1MUX = 1'b1; // select IR[8:6]
                ADDR1MUX = 1'b1; // select the SR1 output
                ADDR2MUX = 2'b00; // Select the 0 output of the ADDR2MUX
                PCMUX = 2'b10; // Output of the addr
                LD_PC = 1'b1; // go inside pc
				end
            S_04:
                begin
                GatePC = 1'b1; // put PC on the BUS
                DRMUX = 1'b1; // set it to R7
                LD_REG = 1'b1; // load the register with the PC value from the bus  
				end
            S_21:
                begin
                    PCMUX = 2'b10; // output of the adder
                    ADDR2MUX = 2'b11; // selects the 11 bit offset
                    ADDR1MUX = 1'b0; // selects pc 
                    LD_PC = 1'b1; // go inside pc
				end
			default : ;
		endcase
	end 

	
endmodule