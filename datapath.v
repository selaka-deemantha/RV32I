module datapath(
	input clk,
	input rst,
	
	output [31:0] t_op_a,
	output [31:0] t_op_b,
	output [31:0] t_alu_out,
	output t_load,
	output t_store,
	output t_reg_write,
	output [1:0] t_mem_to_reg,
	output t_next_sel,
	output [31:0] t_instr
	);


	
assign t_op_a=op_a;
assign t_op_b=op_b;
assign t_alu_out=alu_out;
assign t_load=load;
assign t_store=store;
assign t_reg_write=reg_write;
assign t_mem_to_reg=mem_to_reg;
assign t_next_sel=next_sel;
assign t_instr=instruction;

	
wire [31:0] op_a;
wire [31:0] op_b;
wire [31:0] op_a_mux_out;
wire [31:0] op_b_mux_out;
wire [31:0] alu_out;
wire [31:0] dmem_out;
wire [31:0] write_back_data;
wire [31:0] imm_mux_out;
wire [31:0] instruction;
reg [31:0] pc;
wire [31:0] pc_inc;
wire [31:0] next_pc;

wire [2:0] func3;
wire func7;
wire [6:0] opcode;

wire reg_write;
wire load;
wire store;
wire branch;
wire op_a_sel;
wire op_b_sel;
wire next_sel;
wire [2:0] imm_sel;
wire [3:0] alu_control;
wire [1:0] mem_to_reg;
wire mem_en;
wire pc_ctrl;


wire [31:0] i_imm,s_imm,sb_imm,uj_imm,u_imm;

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;




wire branch_result;

assign pc_inc=pc+32'd4;

assign opcode=instruction[6:0];
assign rs1=instruction[19:15];
assign rs2=instruction[24:20];
assign rd=instruction[11:7];
assign func3=instruction[14:12];
assign func7=instruction[30];

assign pc_ctrl=next_sel | branch_result;
	
always @(posedge clk, posedge rst) begin
	if(rst) pc<=32'b0;
	else pc<=next_pc;
end

	
registerfile regfile(
	.clk(clk),
	.rst(rst),
	.en(reg_write),
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	.data(write_back_data),
	.op_a(op_a),
	.op_b(op_b)
	);


	
mux2 opa_mux(
	.a(op_a),
	.b(pc),
	.sel(op_a_sel),
	.out(op_a_mux_out)
	);

mux2 opb_mux(
	.a(op_b),
	.b(imm_mux_out),
	.sel(op_b_sel),
	.out(op_b_mux_out)
	);
	
alu alu(
	.a_i(op_a_mux_out),
	.b_i(op_b_mux_out),
	.op_i(alu_control),
	.res_o(alu_out)
	);

data_mem data_mem(
	.clk(clk),
	.rst(rst),
	.store(store),
	.load(load),
	.mask(1111),
	.address(alu_out),
	.data_in(op_b),
	.data_out(dmem_out)
	);
	
mux4 write_back_mux(
	.a(alu_out),
	.b(dmem_out),
	.c(pc_inc),
	.d(0),
	.sel(mem_to_reg),
	.out(write_back_data)
	);

immediategen imm_gen(
	.instr(instruction),
	.i_imme(i_imm),
	.s_imme(s_imm),
	.sb_imme(sb_imm),
	.uj_imme(uj_imm),
	.u_imme(u_imm)
	);
	
mux8 imm_mux(
	.a(i_imm),
	.b(s_imm),
	.c(sb_imm),
	.d(uj_imm),
	.e(u_imm),
	.f(0),
	.g(0),
	.h(0),
	.sel(imm_sel),
	.out(imm_mux_out)
	);
	
branch branch0(
	.op_a(op_a),
	.op_b(op_b),
	.fun3(func3),
	.en(branch),
	.result(branch_result)
	);
	
instruc_mem instruc_mem(
	.address(pc[31:2]),
	.data_out(instruction)
	);
	 
mux2 next_sel_mux(
	.a(pc_inc),
	.b(alu_out),
	.sel(pc_ctrl),
	.out(next_pc)
	);

controlunit controlunit(
	.opcode(opcode),
	.fun3(func3),
	.fun7(func7),
	.reg_write(reg_write),
	.imm_sel(imm_sel),
	.operand_b(op_b_sel),
	.operand_a(op_a_sel),
	.mem_to_reg(mem_to_reg),
	.Load(load),
	.Store(store),
	.Branch(branch),
	.mem_en(mem_en),
	.next_sel(next_sel),
	.alu_control(alu_control)
	);
	
	
endmodule


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	















