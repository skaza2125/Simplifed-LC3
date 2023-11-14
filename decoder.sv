module decoder   (       input [2:0]DR_MUX_OUT,
                        output logic R0,R1,R2,R3,R4,R5,R6,R7);
                        
        always_comb
        
        
        begin
        R0 = 1'b0;
        R1 = 1'b0;
        R2 = 1'b0;
        R3 = 1'b0;
        R4 = 1'b0;
        R5 = 1'b0;
        R6 = 1'b0;
        R7 = 1'b0;
            unique case(DR_MUX_OUT)
                3'b000 : R0 = 1'b1;
                3'b001 : R1 = 1'b1;
                3'b010 : R2 = 1'b1;
                3'b011 : R3 = 1'b1;
                3'b100 : R4 = 1'b1;
                3'b101 : R5 = 1'b1;
                3'b110 : R6 = 1'b1;
                3'b111 : R7 = 1'b1; 
               
            endcase
            
        end
        
endmodule