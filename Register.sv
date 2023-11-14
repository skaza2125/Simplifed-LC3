module reg_16 ( input                        Clk, Reset, Load,
                    input                    [15:0] D,
                    output logic             [15:0] Data_Out);
                    
        always_ff @ (posedge Clk)
        begin
                // Setting the output Q[16..0] of the register to zeros as Reset is pressed
                if(Reset) //notice that this is a synchronous reset
                    Data_Out <= 16'h0000;
                // Loading D into register when load button is pressed (will eiher be switches or result of sum)
                else if(Load)
                    Data_Out <= D;
               
        end
        
endmodule    
        
module reg_3 (input  logic Clk, Reset, Load,
              input  logic  [2:0] D,
              output logic  [2:0] Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset,
			  Data_Out <= 3'b000;
		 else if (Load)
			  Data_Out <= D;
    end

endmodule

module reg_1 (input  logic Clk, Reset, Load,
              input  logic  D,
              output logic  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset
			  Data_Out <= 1'b0;
		 else if (Load)
			  Data_Out <= D;
    end

endmodule
