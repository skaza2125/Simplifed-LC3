module SRMUX   (       input [2:0] SR_SELECT,
                       input logic [15:0] R0,R1,R2,R3,R4,R5,R6,R7,
                       output logic [15:0]SR_OUT);
                        
        always_comb
        begin
            unique case(SR_SELECT)
                3'b000 : SR_OUT = R0;
                3'b001 : SR_OUT = R1;
                3'b010 : SR_OUT = R2;
                3'b011 : SR_OUT = R3;
                3'b100 : SR_OUT = R4;
                3'b101 : SR_OUT = R5;
                3'b110 : SR_OUT = R6;
                3'b111 : SR_OUT = R7; 
            endcase
        end
        
endmodule