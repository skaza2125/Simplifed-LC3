module BUS    (           input GatePC, 
                       input GateMDR, 
                       input GateALU, 
                       input GateMARMUX,
                       input [15:0] MDR,
                       input [15:0] PC,
                       input [15:0] ADDITION,
                       input [15:0] ALU,
                       output logic [15:0] BUS_OUT);
                        
        always_comb
        begin
                if(GatePC)
                    BUS_OUT = PC;
                else if(GateMDR)
                    BUS_OUT = MDR;
                else if(GateALU)
                    BUS_OUT = ALU;
                else if(GateMARMUX)
                    BUS_OUT = ADDITION;
                else
                    BUS_OUT = 16'h0000;
        end
        
endmodule