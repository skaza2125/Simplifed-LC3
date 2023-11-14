
module NZPLogic  (    input                [15:0] BUS_OUT,
                        output logic [2:0]        NZP_OUT);


logic [15:0] INVERT_BUS;
always_comb
begin

    INVERT_BUS = ~(BUS_OUT);
            
    if(INVERT_BUS == 16'hFFFF)
        NZP_OUT = 3'b010;
    else
    begin
    
    if(BUS_OUT[15] == 1'b0)
        NZP_OUT = 3'b001;
    else
        NZP_OUT = 3'b100;

    end

end
endmodule

module BENLOGIC( input [2:0]NZP_OUT, input [15:0] IR, output logic BEN_IN);
always_comb 
    begin
//       BEN_IN = ((IR[11] & NZP_OUT[0]) | (IR[10] & NZP_OUT[1]) | (IR[9] & NZP_OUT[2]));
       if((IR[11:9] == 3'b000) | (IR[11:9] == 3'b111))
				BEN_IN = 1'b1;
			else if((IR[11:9] & NZP_OUT) != 3'b000)
				BEN_IN = 1'b1;
			else
				BEN_IN = 1'b0;

    end

endmodule