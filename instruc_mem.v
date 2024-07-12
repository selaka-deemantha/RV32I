module instruc_mem(
    input wire [7:0]  address,
    output reg [31:0] data_out
    );

	 reg [31:0] mem [0:255];
	 initial begin
		
		mem[0]=32'h00200513;//reg[10]=imm(2)
		mem[1]=32'h00100113;//reg[2]=imm(1)
		mem[2]=32'h00250233;//reg[4]=reg[10]+reg[2]
		mem[3]=32'h00412223;//mem[imm(4)+reg[2]]=reg[4]
		mem[4]=32'h00412203;
		mem[5]=32'h01F00313;//reg[6]=imm(11111)
		mem[6]=32'h01300393;//reg[7]=imm(10011)
		mem[7]=32'h00737433;//reg6, reg7 and 
		mem[8]=32'h007344B3;//reg6, reg7 xor
		mem[9]=32'h00200513;
		mem[10]=32'h00200513;
		mem[11]=32'h00200513;
		end
	 
	    always @(*) begin

           data_out <= mem[address];
        
    end
	 
endmodule
