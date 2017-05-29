`timescale 1ns / 1ps

`include "defines.vh"

module processor(
  clk,
  reset,
  );
	 
  input clk;
  input reset;
  // could make the ram and the regfile outputs. wud be very convenient for testing.
  // problem becomes if ram is large, we wud need a bus we can access it or some shit.

  wire reg_dst0;
  wire mem_to_reg0;
  wire [`ALU_OP_BITS-1:0] alu_op0;
  wire [`MEM_OP_BITS-1:0] mem_op0;
  wire alu_src0;
  wire reg_write0;
  wire [`JUMP_BITS-1:0] jop0;
  wire address_src0;

  wire reg_dst1;
  wire mem_to_reg1;
  wire [`ALU_OP_BITS-1:0] alu_op1;
  wire [`MEM_OP_BITS-1:0] mem_op1;
  wire alu_src1;
  wire reg_write1;
  wire [`JUMP_BITS-1:0] jop1;
  wire address_src1;

  wire zero0;
  wire less0;
  wire greater0;

  wire zero1;
  wire less1;
  wire greater1;

  wire [`DATA_WIDTH-1:0] ram_read_data;

  wire [`DATA_WIDTH-1:0] reg_read_data_1_0;
  wire [`DATA_WIDTH-1:0] reg_read_data_2_0;

  wire [`DATA_WIDTH-1:0] reg_read_data_1_1;
  wire [`DATA_WIDTH-1:0] reg_read_data_2_1;

  wire [`DATA_WIDTH-1:0] alu_result0;
  wire [`DATA_WIDTH-1:0] alu_result1;

  wire [`NUM_REGISTERS_LOG2-1:0] reg_dst_result0;
  wire [`NUM_REGISTERS_LOG2-1:0] reg_dst_result1;

  wire [`DATA_WIDTH-1:0] alu_src_result0;
  wire [`DATA_WIDTH-1:0] alu_src_result1;
  wire [`DATA_WIDTH-1:0] mem_to_reg_result0;
  wire [`DATA_WIDTH-1:0] mem_to_reg_result1;

  wire [`ADDR_WIDTH-1:0] address_src_result0;
  wire [`ADDR_WIDTH-1:0] address_src_result1;

  wire [`ADDR_WIDTH-1:0] pc;
  wire [`INST_WIDTH-1:0] instruction0;
  wire [`INST_WIDTH-1:0] instruction1;
  
  wire [`INST_WIDTH-1:0] steer_instruction0;
  wire [`INST_WIDTH-1:0] steer_instruction1;

  // if/id
  wire [`INST_WIDTH-1:0] if_id_instruction0;
  wire [`INST_WIDTH-1:0] if_id_instruction1;

  wire if_id_first;

  wire [`OP_CODE_BITS-1:0] opcode0;
  wire [`NUM_REGISTERS_LOG2-1:0] rs0;
  wire [`NUM_REGISTERS_LOG2-1:0] rt0;
  wire [`NUM_REGISTERS_LOG2-1:0] rd0;
  wire [`IMM_WIDTH-1:0] immediate0;
  wire [`ADDR_WIDTH-1:0] address0;
  wire [`SHAMT_BITS-1:0] shamt0;

  wire [`OP_CODE_BITS-1:0] opcode1;
  wire [`NUM_REGISTERS_LOG2-1:0] rs1;
  wire [`NUM_REGISTERS_LOG2-1:0] rt1;
  wire [`NUM_REGISTERS_LOG2-1:0] rd1;
  wire [`IMM_WIDTH-1:0] immediate1;
  wire [`ADDR_WIDTH-1:0] address1;
  wire [`SHAMT_BITS-1:0] shamt1;

  // id/ex
  wire [`INST_WIDTH-1:0] id_ex_instruction0;
  wire [`NUM_REGISTERS_LOG2-1:0] id_ex_rs0, id_ex_rt0, id_ex_rd0;
  wire [`DATA_WIDTH-1:0] id_ex_reg_read_data_1_0, id_ex_reg_read_data_2_0;
  wire [`IMM_WIDTH-1:0] id_ex_immediate0;
  wire [`ADDR_WIDTH-1:0] id_ex_address0;
  wire [`SHAMT_BITS-1:0] id_ex_shamt0;
  wire id_ex_reg_dst0, id_ex_mem_to_reg0, id_ex_alu_src0, id_ex_reg_write0, id_ex_address_src0;
  wire [`JUMP_BITS-1:0] id_ex_jop0;
  wire [`ALU_OP_BITS-1:0] id_ex_alu_op0;
  wire [`MEM_OP_BITS-1:0] id_ex_mem_op0;

  wire [`INST_WIDTH-1:0] id_ex_instruction1;
  wire [`NUM_REGISTERS_LOG2-1:0] id_ex_rs1, id_ex_rt1, id_ex_rd1;
  wire [`DATA_WIDTH-1:0] id_ex_reg_read_data_1_1, id_ex_reg_read_data_2_1;
  wire [`IMM_WIDTH-1:0] id_ex_immediate1;
  wire [`ADDR_WIDTH-1:0] id_ex_address1;
  wire [`SHAMT_BITS-1:0] id_ex_shamt1;
  wire id_ex_reg_dst1, id_ex_mem_to_reg1, id_ex_alu_src1, id_ex_reg_write1, id_ex_address_src1;
  wire [`JUMP_BITS-1:0] id_ex_jop1;
  wire [`ALU_OP_BITS-1:0] id_ex_alu_op1;
  wire [`MEM_OP_BITS-1:0] id_ex_mem_op1;

  wire id_ex_first;

  // ex/mem
  wire [`INST_WIDTH-1:0] ex_mem_instruction0;
  wire [`DATA_WIDTH-1:0] ex_mem_alu_result0;
  wire [`DATA_WIDTH-1:0] ex_mem_data_1_0, ex_mem_data_2_0;
  wire [`ADDR_WIDTH-1:0] ex_mem_address0;
  wire [`ADDR_WIDTH-1:0] ex_mem_address_src_result0;
  wire ex_mem_mem_to_reg0;
  wire ex_mem_reg_write0;
  wire [`JUMP_BITS-1:0] ex_mem_jop0;
  wire [`MEM_OP_BITS-1:0] ex_mem_mem_op0;
  wire [`NUM_REGISTERS_LOG2-1:0] ex_mem_reg_dst_result0;

  wire ex_mem_jump_address;
  wire [`ADDR_WIDTH-1:0] jump_address_result;

  wire [`INST_WIDTH-1:0] ex_mem_instruction1;
  wire [`DATA_WIDTH-1:0] ex_mem_alu_result1;
  wire [`DATA_WIDTH-1:0] ex_mem_data_1_1, ex_mem_data_2_1;
  wire [`ADDR_WIDTH-1:0] ex_mem_address1;
  wire [`ADDR_WIDTH-1:0] ex_mem_address_src_result1;
  wire ex_mem_mem_to_reg1;
  wire ex_mem_reg_write1;
  wire [`JUMP_BITS-1:0] ex_mem_jop1;
  wire [`MEM_OP_BITS-1:0] ex_mem_mem_op1;
  wire [`NUM_REGISTERS_LOG2-1:0] ex_mem_reg_dst_result1;

  wire ex_mem_first;

  // mem/wb
  wire [`INST_WIDTH-1:0] mem_wb_instruction0;
  wire [`DATA_WIDTH-1:0] mem_wb_ram_read_data0, mem_wb_alu_result0;
  wire [`NUM_REGISTERS_LOG2-1:0] mem_wb_reg_dst_result0;
  wire mem_wb_mem_to_reg0, mem_wb_reg_write0;

  wire [`INST_WIDTH-1:0] mem_wb_instruction1;
  wire [`DATA_WIDTH-1:0] mem_wb_ram_read_data1, mem_wb_alu_result1;
  wire [`NUM_REGISTERS_LOG2-1:0] mem_wb_reg_dst_result1;
  wire mem_wb_mem_to_reg1, mem_wb_reg_write1;

  wire [`FORWARD_BITS-1:0] forward_a0;
  wire [`FORWARD_BITS-1:0] forward_a1;
  wire [`FORWARD_BITS-1:0] forward_b0;
  wire [`FORWARD_BITS-1:0] forward_b1;

  wire [`NUM_PIPE_MASKS-1:0] nop0;
  wire [`NUM_PIPE_MASKS-1:0] stall0;

  wire [`NUM_PIPE_MASKS-1:0] nop1;
  wire [`NUM_PIPE_MASKS-1:0] stall1;

  //wire flush;
  wire [`NUM_PIPE_MASKS-1:0] flush;

  wire first;
  wire steer_stall;

  wire [`DATA_WIDTH-1:0] alu_input_mux_1_result0, alu_input_mux_2_result0;
  wire [`DATA_WIDTH-1:0] alu_input_mux_1_result1, alu_input_mux_2_result1;

  assign opcode0 = if_id_instruction0[`OPCODE_MSB:`OPCODE_LSB];
  assign rs0 = if_id_instruction0[`REG_RS_MSB:`REG_RS_LSB];
  assign rt0 = if_id_instruction0[`REG_RT_MSB:`REG_RT_LSB];
  assign rd0 = if_id_instruction0[`REG_RD_MSB:`REG_RD_LSB];
  assign immediate0 = if_id_instruction0[`IMM_MSB:`IMM_LSB];
  assign address0 = if_id_instruction0[`IMM_MSB:`IMM_LSB];
  assign shamt0 = if_id_instruction0[`SHAMT_MSB:`SHAMT_LSB];

  assign opcode1 = if_id_instruction1[`OPCODE_MSB:`OPCODE_LSB];
  assign rs1 = if_id_instruction1[`REG_RS_MSB:`REG_RS_LSB];
  assign rt1 = if_id_instruction1[`REG_RT_MSB:`REG_RT_LSB];
  assign rd1 = if_id_instruction1[`REG_RD_MSB:`REG_RD_LSB];
  assign immediate1 = if_id_instruction1[`IMM_MSB:`IMM_LSB];
  assign address1 = if_id_instruction1[`IMM_MSB:`IMM_LSB];
  assign shamt1 = if_id_instruction1[`SHAMT_MSB:`SHAMT_LSB];

  ///////////////////////////////////////////////////////////////////////////////////////////

  mux2x1 #(`ADDR_WIDTH) jump_address_mux(
  .in0(ex_mem_data_1_0[`ADDR_WIDTH-1:0]), 
  .in1(ex_mem_address0), 
  .sel(ex_mem_jump_address), 
  .out(jump_address_result));

  program_counter pc_unit(
  .clk(clk), 
  .reset(reset),
  .prev_opcode0(instruction0[`OPCODE_MSB:`OPCODE_LSB]),
  .prev_address0(instruction0[`IMM_MSB:`IMM_LSB]),
  .prev_opcode1(instruction1[`OPCODE_MSB:`OPCODE_LSB]),
  .prev_address1(instruction1[`IMM_MSB:`IMM_LSB]),
  .branch_address(jump_address_result), 
  .pc(pc), 
  .flush(flush[`PC_MASK_INDEX]), 
  .stall(stall0[`PC_MASK_INDEX] | steer_stall),
  .nop(nop0[`PC_MASK_INDEX])
  );
  
  instruction_memory im(
  .pc(pc), 
  .instruction0(instruction0),
  .instruction1(instruction1));

  steer str(
  .clk(clk),

  .instruction0_in(instruction0),
  .instruction1_in(instruction1),

  .instruction0_out(steer_instruction0),
  .instruction1_out(steer_instruction1),

  .stall(steer_stall),
  .first(first)
  );

  if_id_register if_id_reg0(
  .clk(clk), 
  .flush(flush[`IF_ID_MASK_INDEX]), 
  .stall(stall0[`IF_ID_MASK_INDEX]), 
  .nop(nop0[`IF_ID_MASK_INDEX]), 

  .instruction_in(steer_instruction0),
  .first_in(first),

  .instruction_out(if_id_instruction0),
  .first_out(if_id_first)
  );

  if_id_register if_id_reg1(
  .clk(clk), 
  .flush(flush[`IF_ID_MASK_INDEX]), 
  .stall(stall1[`IF_ID_MASK_INDEX]), 
  .nop(nop1[`IF_ID_MASK_INDEX]), 

  .instruction_in(steer_instruction1),
  .first_in(),

  .instruction_out(if_id_instruction1),
  .first_out()
  );

  ///////////////////////////////////////////////////////////////////////////////////////////
  
  hazard_detection_unit hdu(
  .id_ex_mem_op(id_ex_mem_op0), 
  .id_ex_rt(id_ex_rt0), 

  .first(if_id_first),

  .if_id_opcode0(opcode0),
  .if_id_opcode1(opcode1),

  .if_id_rs0(rs0), 
  .if_id_rt0(rt0), 
  .if_id_rd0(rd0),

  .if_id_rs1(rs1), 
  .if_id_rt1(rt1), 
  .if_id_rd1(rd1),

  .stall0(stall0),
  .nop0(nop0),

  .stall1(stall1),
  .nop1(nop1));

  control_unit cu0(
  .opcode(opcode0), 
  .reg_dst(reg_dst0), 
  .mem_to_reg(mem_to_reg0), 
  .alu_op(alu_op0), 
  .alu_src(alu_src0), 
  .reg_write(reg_write0), 
  .mem_op(mem_op0), 
  .jop(jop0),
  .address_src(address_src0));

  control_unit cu1(
  .opcode(opcode1), 
  .reg_dst(reg_dst1), 
  .mem_to_reg(mem_to_reg1), 
  .alu_op(alu_op1), 
  .alu_src(alu_src1), 
  .reg_write(reg_write1), 
  .mem_op(mem_op1), 
  .jop(jop1),
  .address_src(address_src1));

  register_file regfile0( 
  .write(mem_wb_reg_write0), 
  .write_address(mem_wb_reg_dst_result0), 
  .write_data(mem_to_reg_result0), 
  .read_address_1(rs0), 
  .read_data_1(reg_read_data_1_0), 
  .read_address_2(rt0), 
  .read_data_2(reg_read_data_2_0));

  register_file regfile1( 
  .write(mem_wb_reg_write1), 
  .write_address(mem_wb_reg_dst_result1), 
  .write_data(mem_to_reg_result1), 
  .read_address_1(rs1), 
  .read_data_1(reg_read_data_1_1), 
  .read_address_2(rt1), 
  .read_data_2(reg_read_data_2_1));

  id_ex_register id_ex_reg0(
  .clk(clk), 
  .flush(flush[`ID_EX_MASK_INDEX]), 
  .stall(stall0[`ID_EX_MASK_INDEX]), 
  .nop(nop0[`ID_EX_MASK_INDEX]), 

  .rs_in(rs0), 
  .rt_in(rt0), 
  .rd_in(rd0), 
  .reg_read_data_1_in(reg_read_data_1_0),
  .reg_read_data_2_in(reg_read_data_2_0), 
  .immediate_in(immediate0), 
  .address_in(address0), 
  .shamt_in(shamt0),
  .reg_dst_in(reg_dst0), 
  .mem_to_reg_in(mem_to_reg0), 
  .alu_op_in(alu_op0), 
  .mem_op_in(mem_op0), 
  .alu_src_in(alu_src0), 
  .reg_write_in(reg_write0), 
  .jop_in(jop0), 
  .address_src_in(address_src0),
  .instruction_in(if_id_instruction0),
  .first_in(if_id_first),

  .rs_out(id_ex_rs0), 
  .rt_out(id_ex_rt0), 
  .rd_out(id_ex_rd0), 
  .reg_read_data_1_out(id_ex_reg_read_data_1_0),
  .reg_read_data_2_out(id_ex_reg_read_data_2_0), 
  .immediate_out(id_ex_immediate0), 
  .address_out(id_ex_address0),
  .shamt_out(id_ex_shamt0),
  .reg_dst_out(id_ex_reg_dst0), 
  .mem_to_reg_out(id_ex_mem_to_reg0), 
  .alu_op_out(id_ex_alu_op0), 
  .mem_op_out(id_ex_mem_op0), 
  .alu_src_out(id_ex_alu_src0), 
  .reg_write_out(id_ex_reg_write0), 
  .jop_out(id_ex_jop0), 
  .address_src_out(id_ex_address_src0),
  .instruction_out(id_ex_instruction0),
  .first_out(id_ex_first)
  );

  id_ex_register id_ex_reg1(
  .clk(clk), 
  .flush(flush[`ID_EX_MASK_INDEX]), 
  .stall(stall1[`ID_EX_MASK_INDEX]), 
  .nop(nop1[`ID_EX_MASK_INDEX]), 

  .rs_in(rs1), 
  .rt_in(rt1), 
  .rd_in(rd1), 
  .reg_read_data_1_in(reg_read_data_1_1),
  .reg_read_data_2_in(reg_read_data_2_1), 
  .immediate_in(immediate1), 
  .address_in(address1), 
  .shamt_in(shamt1),
  .reg_dst_in(reg_dst1), 
  .mem_to_reg_in(mem_to_reg1), 
  .alu_op_in(alu_op1), 
  .mem_op_in(mem_op1), 
  .alu_src_in(alu_src1), 
  .reg_write_in(reg_write1), 
  .jop_in(jop1), 
  .address_src_in(address_src1),
  .instruction_in(if_id_instruction1),
  .first_in(),

  .rs_out(id_ex_rs1), 
  .rt_out(id_ex_rt1), 
  .rd_out(id_ex_rd1), 
  .reg_read_data_1_out(id_ex_reg_read_data_1_1),
  .reg_read_data_2_out(id_ex_reg_read_data_2_1), 
  .immediate_out(id_ex_immediate1), 
  .address_out(id_ex_address1),
  .shamt_out(id_ex_shamt1),
  .reg_dst_out(id_ex_reg_dst1), 
  .mem_to_reg_out(id_ex_mem_to_reg1), 
  .alu_op_out(id_ex_alu_op1), 
  .mem_op_out(id_ex_mem_op1), 
  .alu_src_out(id_ex_alu_src1), 
  .reg_write_out(id_ex_reg_write1), 
  .jop_out(id_ex_jop1), 
  .address_src_out(id_ex_address_src1),
  .instruction_out(id_ex_instruction1),
  .first_out()
  );



  ///////////////////////////////////////////////////////////////////////////////////////////////

  forwarding_unit fu0(
  .id_ex_rs(id_ex_rs0), 
  .id_ex_rt(id_ex_rt0), 

  .first(id_ex_first),

  .ex_mem_rd0(ex_mem_reg_dst_result0), 
  .mem_wb_rd0(mem_wb_reg_dst_result0), 
  .ex_mem_reg_write0(ex_mem_reg_write0), 
  .mem_wb_reg_write0(mem_wb_reg_write0),

  .ex_mem_rd1(ex_mem_reg_dst_result1), 
  .mem_wb_rd1(mem_wb_reg_dst_result1), 
  .ex_mem_reg_write1(ex_mem_reg_write1), 
  .mem_wb_reg_write1(mem_wb_reg_write1),

  .forward_a(forward_a0), 
  .forward_b(forward_b0));

  forwarding_unit fu1(
  .id_ex_rs(id_ex_rs1), 
  .id_ex_rt(id_ex_rt1), 

  .first(id_ex_first),

  .ex_mem_rd0(ex_mem_reg_dst_result0), 
  .mem_wb_rd0(mem_wb_reg_dst_result0), 
  .ex_mem_reg_write0(ex_mem_reg_write0), 
  .mem_wb_reg_write0(mem_wb_reg_write0),

  .ex_mem_rd1(ex_mem_reg_dst_result1), 
  .mem_wb_rd1(mem_wb_reg_dst_result1), 
  .ex_mem_reg_write1(ex_mem_reg_write1), 
  .mem_wb_reg_write1(mem_wb_reg_write1),

  .forward_a(forward_a1), 
  .forward_b(forward_b1));

  // pipe 1
  mux8x3 #(`DATA_WIDTH) alu_input_mux_1_0(
  .in0(id_ex_reg_read_data_1_0), 
  .in1(mem_to_reg_result0), 
  .in2(ex_mem_alu_result0), 
  .in3(mem_to_reg_result1), 
  .in4(ex_mem_alu_result1), 
  .in5(),
  .in6(),
  .in7(),
  .sel(forward_a0), 
  .out(alu_input_mux_1_result0));

  mux8x3 #(`DATA_WIDTH) alu_input_mux_2_0(
  .in0(id_ex_reg_read_data_2_0), 
  .in1(mem_to_reg_result0), 
  .in2(ex_mem_alu_result0), 
  .in3(mem_to_reg_result1), 
  .in4(ex_mem_alu_result1), 
  .in5(),
  .in6(),
  .in7(),
  .sel(forward_b0), 
  .out(alu_input_mux_2_result0));

  // pipe 2
  mux8x3 #(`DATA_WIDTH) alu_input_mux_1_1(
  .in0(id_ex_reg_read_data_2_1), 
  .in1(mem_to_reg_result0), 
  .in2(ex_mem_alu_result0), 
  .in3(mem_to_reg_result1), 
  .in4(ex_mem_alu_result1), 
  .in5(),
  .in6(),
  .in7(),
  .sel(forward_a1), 
  .out(alu_input_mux_1_result1));

  mux8x3 #(`DATA_WIDTH) alu_input_mux_2_1(
  .in0(id_ex_reg_read_data_2_1), 
  .in1(mem_to_reg_result0), 
  .in2(ex_mem_alu_result0), 
  .in3(mem_to_reg_result1), 
  .in4(ex_mem_alu_result1), 
  .in5(),
  .in6(),
  .in7(),
  .sel(forward_b1), 
  .out(alu_input_mux_2_result1));
  //

  mux2x1 #(`DATA_WIDTH) alu_src_mux0(
  .in0(alu_input_mux_2_result0), 
  .in1({16'h0000, id_ex_immediate0}), 
  .sel(id_ex_alu_src0), 
  .out(alu_src_result0));

  mux2x1 #(`DATA_WIDTH) alu_src_mux1(
  .in0(alu_input_mux_2_result1), 
  .in1({16'h0000, id_ex_immediate1}), 
  .sel(id_ex_alu_src1), 
  .out(alu_src_result1));

  alu alu0(
  .alu_op(id_ex_alu_op0), 
  .data1(alu_input_mux_1_result0), 
  .data2(alu_src_result0), 
  .zero(zero0),
  .less(less0),
  .greater(greater0),
  .alu_result(alu_result0));

  alu alu1(
  .alu_op(id_ex_alu_op1), 
  .data1(alu_input_mux_1_result1), 
  .data2(alu_src_result1), 
  .zero(zero1),
  .less(less1),
  .greater(greater1),
  .alu_result(alu_result1));

  mux2x1 #(`NUM_REGISTERS_LOG2) reg_dst_mux0(
  .in0(id_ex_rt0), 
  .in1(id_ex_rd0), 
  .sel(id_ex_reg_dst0), 
  .out(reg_dst_result0));

  mux2x1 #(`NUM_REGISTERS_LOG2) reg_dst_mux1(
  .in0(id_ex_rt1), 
  .in1(id_ex_rd1), 
  .sel(id_ex_reg_dst1), 
  .out(reg_dst_result1));

  mux2x1 #(`ADDR_WIDTH) address_src_mux0(
  .in0(alu_result0[`ADDR_WIDTH-1:0]), 
  .in1(id_ex_address0), 
  .sel(id_ex_address_src0), 
  .out(address_src_result0));

  mux2x1 #(`ADDR_WIDTH) address_src_mux1(
  .in0(alu_result1[`ADDR_WIDTH-1:0]), 
  .in1(id_ex_address1), 
  .sel(id_ex_address_src1), 
  .out(address_src_result1));

  ex_mem_register ex_mem_reg0(
  .clk(clk), 
  .stall(1'b0),
  .flush(flush[`EX_MEM_MASK_INDEX]), 
  .nop(1'b0),

  .alu_result_in(alu_result0), 
  .data_1_in(alu_input_mux_1_result0),
  .data_2_in(alu_input_mux_2_result0), 
  .reg_dst_result_in(reg_dst_result0), 
  .jop_in(id_ex_jop0), 
  .mem_op_in(id_ex_mem_op0), 
  .mem_to_reg_in(id_ex_mem_to_reg0), 
  .reg_write_in(id_ex_reg_write0), 
  .address_in(id_ex_address0), 
  .address_src_result_in(address_src_result0),
  .instruction_in(id_ex_instruction0),
  .first_in(id_ex_first),

  .alu_result_out(ex_mem_alu_result0), 
  .data_1_out(ex_mem_data_1_0), 
  .data_2_out(ex_mem_data_2_0),
  .reg_dst_result_out(ex_mem_reg_dst_result0), 
  .jop_out(ex_mem_jop0), 
  .mem_op_out(ex_mem_mem_op0),
  .mem_to_reg_out(ex_mem_mem_to_reg0), 
  .reg_write_out(ex_mem_reg_write0), 
  .address_out(ex_mem_address0),
  .address_src_result_out(ex_mem_address_src_result0),
  .instruction_out(ex_mem_instruction0),
  .first_out(ex_mem_first)
  );

  ex_mem_register ex_mem_reg1(
  .clk(clk), 
  .stall(1'b0),
  .flush(flush[`EX_MEM_MASK_INDEX]), 
  .nop(1'b0),

  .alu_result_in(alu_result1), 
  .data_1_in(alu_input_mux_1_result1),
  .data_2_in(alu_input_mux_2_result1), 
  .reg_dst_result_in(reg_dst_result1), 
  .jop_in(id_ex_jop1), 
  .mem_op_in(id_ex_mem_op1), 
  .mem_to_reg_in(id_ex_mem_to_reg1), 
  .reg_write_in(id_ex_reg_write1), 
  .address_in(id_ex_address1), 
  .address_src_result_in(address_src_result1),
  .instruction_in(id_ex_instruction1),
  .first_in(),

  .alu_result_out(ex_mem_alu_result1), 
  .data_1_out(ex_mem_data_1_1), 
  .data_2_out(ex_mem_data_2_1),
  .reg_dst_result_out(ex_mem_reg_dst_result1), 
  .jop_out(ex_mem_jop1), 
  .mem_op_out(ex_mem_mem_op1),
  .mem_to_reg_out(ex_mem_mem_to_reg1), 
  .reg_write_out(ex_mem_reg_write1), 
  .address_out(ex_mem_address1),
  .address_src_result_out(ex_mem_address_src_result1),
  .instruction_out(ex_mem_instruction1),
  .first_out()
  );

  ///////////////////////////////////////////////////////////////////////////////////////////////

  ram data_memory(
  .address(ex_mem_address_src_result1), 
  .write_data(ex_mem_data_2_1), 
  .read_data(ram_read_data), 
  .mem_op(ex_mem_mem_op1));

  branch_unit bu(
  .zero(zero0),
  .less(less0),
  .greater(greater0),
  .jop(ex_mem_jop0), 
  .flush(flush),
  .jump_address(ex_mem_jump_address)
  );

  mem_wb_register mem_wb_reg0(
  .clk(clk), 
  .stall(1'b0),
  .flush(1'b0), 
  .nop(1'b0),

  .mem_to_reg_in(ex_mem_mem_to_reg0), 
  .ram_read_data_in(ram_read_data), 
  .alu_result_in(ex_mem_alu_result0), 
  .reg_dst_result_in(ex_mem_reg_dst_result0), 
  .reg_write_in(ex_mem_reg_write0), 
  .instruction_in(ex_mem_instruction0),

  .mem_to_reg_out(mem_wb_mem_to_reg0), 
  .ram_read_data_out(mem_wb_ram_read_data0), 
  .alu_result_out(mem_wb_alu_result0),
  .reg_dst_result_out(mem_wb_reg_dst_result0), 
  .reg_write_out(mem_wb_reg_write0),
  .instruction_out(mem_wb_instruction0)
  );

  mem_wb_register mem_wb_reg1(
  .clk(clk), 
  .stall(1'b0),
  .flush(flush[`MEM_WB_MASK_INDEX] && !ex_mem_first), 
  .nop(1'b0),

  .mem_to_reg_in(ex_mem_mem_to_reg1), 
  .ram_read_data_in(ram_read_data), 
  .alu_result_in(ex_mem_alu_result1), 
  .reg_dst_result_in(ex_mem_reg_dst_result1), 
  .reg_write_in(ex_mem_reg_write1), 
  .instruction_in(ex_mem_instruction1),

  .mem_to_reg_out(mem_wb_mem_to_reg1), 
  .ram_read_data_out(mem_wb_ram_read_data1), 
  .alu_result_out(mem_wb_alu_result1),
  .reg_dst_result_out(mem_wb_reg_dst_result1), 
  .reg_write_out(mem_wb_reg_write1),
  .instruction_out(mem_wb_instruction1)
  );

  ///////////////////////////////////////////////////////////////////////////////////////////////

  mux2x1 #(`DATA_WIDTH) mem_to_reg_mux0(
  .in0(mem_wb_alu_result0), 
  .in1(mem_wb_ram_read_data0), 
  .sel(mem_wb_mem_to_reg0), 
  .out(mem_to_reg_result0));

  mux2x1 #(`DATA_WIDTH) mem_to_reg_mux1(
  .in0(mem_wb_alu_result1), 
  .in1(mem_wb_ram_read_data1), 
  .sel(mem_wb_mem_to_reg1), 
  .out(mem_to_reg_result1));

endmodule











