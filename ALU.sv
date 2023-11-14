module ALU   (       input                [1:0]ALUK,
                        input   [15:0] SR1_OUT,SR2_MUX_OUT,
                        output logic        [15:0] ALU_OUT);

  always_comb
        begin
            unique case(ALUK)
                2'b00 : ALU_OUT = SR1_OUT + SR2_MUX_OUT;
                2'b01 : ALU_OUT = SR1_OUT & SR2_MUX_OUT;
                2'b10 : ALU_OUT = ~SR1_OUT;
                2'b11 : ALU_OUT = SR1_OUT;
                default: ALU_OUT = 16'hxxxx;
            endcase
        end
      
endmodule