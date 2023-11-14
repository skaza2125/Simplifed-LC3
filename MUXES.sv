module PC_MUX    (        input                [15:0] PC,BUS_OUT,ALU,
                        input                [1:0] PCMUX,
                        output logic        [15:0] PC_MUX_OUT);
                        
        always_comb
        begin
            unique case(PCMUX)
                2'b00 : PC_MUX_OUT = PC+1;
                2'b01 : PC_MUX_OUT = BUS_OUT;
                2'b10: PC_MUX_OUT = ALU;
                //will need to add a case for the adder later  
                default : PC_MUX_OUT = 16'hXXXX;     
            endcase
        end
        
endmodule

module MDR_MUX    (        input                MIO_EN,
                        input                 [15:0] BUS_OUT, MDR_In, //eventually need to add an output from mem
                        output logic        [15:0] MDR_MUX_OUT);
                        
        always_comb
        begin
            unique case(MIO_EN)
                1'b0: MDR_MUX_OUT = BUS_OUT;
                1'b1: MDR_MUX_OUT = MDR_In; // M[MAR] need to check these bit combos cause I'm not sure they are accurate
                default  : MDR_MUX_OUT = 16'hXXXX;
            endcase
        end
        
endmodule

module SR1MUX   (       input                [15:0] IR,
                        input logic SR1MUX,
                        output logic        [2:0] SR1_MUX_OUT);
                        
        always_comb
        begin
            unique case(SR1MUX)
                1'b0 : SR1_MUX_OUT = IR[11:9];
                1'b1 : SR1_MUX_OUT = IR[8:6];
                default  : SR1_MUX_OUT = 3'bXXX;
            endcase
        end
        
endmodule

module SR2MUX   (       input                [4:0] IR,
                        input [15:0]SR2_OUT,
                        input logic SR2MUX,
                        output logic        [15:0] SR2_MUX_OUT);
                        
        always_comb
        begin
            unique case(SR2MUX)
                1'b1 : SR2_MUX_OUT = {{11{IR[4]}}, IR[4:0]};
                1'b0 : SR2_MUX_OUT = SR2_OUT;
                default  : SR2_MUX_OUT = 16'hXXXX;
            endcase
        end
        
endmodule

module DRMUX   (       input                [15:0] IR,
                        input logic DRMUX,
                        output logic        [2:0] DR_MUX_OUT);
                        
        always_comb
        begin
            unique case(DRMUX)
                1'b0 : DR_MUX_OUT = IR[11:9];
                1'b1 : DR_MUX_OUT = 3'b111;
                default  : DR_MUX_OUT = 3'bXXX;
            endcase
        end
        
endmodule

module ADDR2MUX    (        input                [15:0] IR,
                        input                [1:0] ADDR2MUX,
                        output logic        [15:0] ADDR2_MUX_OUT);
                        
        always_comb
        begin
            unique case(ADDR2MUX)
                2'b00 : ADDR2_MUX_OUT = 16'h0000;
                2'b01 : ADDR2_MUX_OUT = {{10{IR[5]}}, IR[5:0]};
                2'b10: ADDR2_MUX_OUT = {{7{IR[8]}}, IR[8:0]};
                2'b11: ADDR2_MUX_OUT = {{5{IR[10]}}, IR[10:0]};
                default : ADDR2_MUX_OUT = 16'hXXXX;
                
            endcase
        end
        
endmodule

module ADDR1MUX    (    input               [15:0] PC,SR1_OUT,
                        input logic         ADDR1MUX,
                        output logic        [15:0] ADDR1_MUX_OUT);
                        
        always_comb
        begin
            unique case(ADDR1MUX)
                1'b0 : ADDR1_MUX_OUT = PC[15:0];
                1'b1 : ADDR1_MUX_OUT = SR1_OUT;
                default : ADDR1_MUX_OUT = 16'hXXXX;
            endcase
        end
        
endmodule



