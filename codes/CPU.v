module CPU
(
    clk_i,
    rst_i,
    start_i,

    mem_data_i,
    mem_ack_i,
    mem_data_o,
    mem_addr_o,
    mem_enable_o,
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

input       [255:0] mem_data_i;
input               mem_ack_i;
output      [255:0] mem_data_o;
output      [31:0]  mem_addr_o;
output              mem_enable_o;
output              mem_write_o;

wire          [31:0] pc_next;
wire          [31:0] pc_now;
wire          [2:0] ALUCtrl;
wire          [1:0] ALUOp;
wire                ALUSrc;
wire                RegWrite;
wire          [31:0] imm_extended;
wire          [31:0] ALU_data;
wire          [31:0] mux_data;
wire           [31:0] instr;
wire           [31:0] read_data_1;
wire           [31:0] read_data_2;

wire           [31:0] foobar;

wire                NoOp;
wire                MemtoReg;
wire                MemRead;
wire                MemWrite;
wire                Branch;
wire                PCWrite;
wire                flush;
wire                MemStall;
wire                Hazard_Detection_Stall;

assign flush = (Control.Branch_o) && (read_data_1 == read_data_2);
// assign foobar = ALU.data_o;

wire         [31:0] ID_pc;
wire         [31:0] WB_WriteData;

Control Control(
    .Op_i       (instr[6:0]),
    .NoOp_i     (NoOp),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite),
    .MemToReg_o (MemtoReg),
    .MemRead_o  (MemRead),
    .MemWrite_o (MemWrite),
    .Branch_o   (Branch)
);

Adder Add_PC(
    .data1_in   (pc_now),
    .data2_in   (4),
    .data_o     (pc_next)
);

MUX32 MUX_PC(
    .data1_i    (pc_next),
    .data2_i    (ID_Adder.data_o),
    .select_i   (flush),
    .data_o     (PC.pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .stall_i    (MemStall),
    .PCWrite_i  (PCWrite),
    .pc_i       (MUX_PC.data_o),
    .pc_o       (pc_now)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_now),
    .instr_o    (IF_ID.Instruction_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (instr[19:15]),
    .RS2addr_i   (instr[24:20]),
    .RDaddr_i   (MEM_WB.Instruction4_o),
    .RDdata_i   (WB_WriteData),
    .RegWrite_i (MEM_WB.RegWrite_o),
    .RS1data_o   (read_data_1),
    .RS2data_o   (read_data_2)
);

MUX32 MUX_ALUSrc(
    .data1_i    (MUX_EX2.data_o),
    .data2_i    (ID_EX.Imm_o),
    .select_i   (ID_EX.ALUSrc_o),
    .data_o     (ALU.data2_i)
);

Imm_Gen Imm_Gen(
    .instr_i    (instr),
    .imm_o      (imm_extended)
);

ALU ALU(
    .data1_i    (MUX_EX1.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALUCtrl),
    // .data_o     (EX_MEM.ALUResult_i),
    .data_o     (foobar),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (ID_EX.Instruction1_o),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  (ALUCtrl)
);

IF_ID IF_ID(
    .start_i    (start_i),
    .clk_i      (clk_i),
    .stall_i    (Hazard_Detection_Stall || MemStall),
    .flush_i    (flush),
    .pc_i       (PC.pc_o),
    .Instruction_i  (Instruction_Memory.instr_o),
    .pc_o       (ID_pc),
    .Instruction_o  (instr)
);

Adder ID_Adder(
    .data1_in   (imm_extended << 1),
    .data2_in   (ID_pc),
    .data_o     (MUX_PC.data2_i)
);

ID_EX ID_EX(
    .start_i        (start_i),
    .clk_i          (clk_i),
    .stall_i        (MemStall),
    .RegWrite_i     (RegWrite),
    .MemtoReg_i     (MemtoReg),
    .MemRead_i      (MemRead),
    .MemWrite_i     (MemWrite),
    .ALUOp_i        (ALUOp),
    .ALUSrc_i       (ALUSrc),
    .RDdata1_i      (read_data_1),
    .RDdata2_i      (read_data_2),
    .Imm_i          (imm_extended),
    .Instruction1_i ({instr[31:25], instr[14:12]}),
    .Instruction2_i (instr[19:15]),
    .Instruction3_i (instr[24:20]),
    .Instruction4_i (instr[11:7]),
    .RegWrite_o     (EX_MEM.RegWrite_i),
    .MemtoReg_o     (EX_MEM.MemtoReg_i),
    .MemRead_o      (EX_MEM.MemRead_i),
    .MemWrite_o     (EX_MEM.MemWrite_i),
    .ALUOp_o        (ALU_Control.ALUOp_i),
    .ALUSrc_o       (MUX_ALUSrc.select_i),
    .RDdata1_o      (MUX_EX1.data1_i),
    .RDdata2_o      (MUX_EX2.data1_i),
    .Imm_o          (MUX_ALUSrc.data2_i),
    .Instruction1_o (ALU_Control.funct_i),
    .EXRs1_o        (Forwarding_Unit.EXRs1_i),
    .EXRs2_o        (Forwarding_Unit.EXRs2_i),
    .Instruction4_o (EX_MEM.Instruction4_i)
);

MUX32_4WAY MUX_EX1(
    .data1_i        (ID_EX.RDdata1_o),
    .data2_i        (WB_WriteData),
    .data3_i        (EX_MEM.ALUResult_o),
    .data4_i        (),
    .select_i       (Forwarding_Unit.ForwardA_o),
    .data_o         (ALU.data1_i)
);

MUX32_4WAY MUX_EX2(
    .data1_i        (ID_EX.RDdata2_o),
    .data2_i        (WB_WriteData),
    .data3_i        (EX_MEM.ALUResult_o),
    .data4_i        (),
    .select_i       (Forwarding_Unit.ForwardB_o),
    .data_o         (MUX_ALUSrc.data1_i)
);

EX_MEM EX_MEM(
    .start_i        (start_i),
    .clk_i          (clk_i),
    .stall_i        (MemStall),
    .RegWrite_i     (ID_EX.RegWrite_o),
    .MemtoReg_i     (ID_EX.MemtoReg_o),
    .MemRead_i      (ID_EX.MemRead_o),
    .MemWrite_i     (ID_EX.MemWrite_o),
    // .ALUResult_i    (ALU.data_o),
    .ALUResult_i    (foobar),
    .MUX2Result_i   (MUX_EX2.data_o),
    .Instruction4_i (ID_EX.Instruction4_o),
    .RegWrite_o     (MEM_WB.RegWrite_i),
    .MemtoReg_o     (MEM_WB.MemtoReg_i),
    .MemRead_o      (dcache.cpu_MemRead_i),
    .MemWrite_o     (dcache.cpu_MemWrite_i),
    .ALUResult_o    (dcache.cpu_addr_i),
    .MUX2Result_o   (dcache.cpu_data_i),
    .Instruction4_o (MEM_WB.Instruction4_i)
);

dcache_controller dcache(
    // System clock, reset and stall
    .clk_i          (clk_i),
    .rst_i          (rst_i),

    // to Data Memory interface
    .mem_data_i     (mem_data_i),
    .mem_ack_i      (mem_ack_i),
    .mem_data_o     (mem_data_o),
    .mem_addr_o     (mem_addr_o),
    .mem_enable_o   (mem_enable_o),
    .mem_write_o    (mem_write_o),

    // to CPU interface
    .cpu_data_i     (EX_MEM.MUX2Result_o),
    .cpu_addr_i     (EX_MEM.ALUResult_o),
    .cpu_MemRead_i  (EX_MEM.MemRead_o),
    .cpu_MemWrite_i (EX_MEM.MemWrite_o),
    .cpu_data_o     (MEM_WB.RDdata_i),
    .cpu_stall_o    (MemStall)
);

MEM_WB MEM_WB(
    .start_i        (start_i),
    .clk_i          (clk_i),
    .stall_i        (MemStall),
    .RegWrite_i     (EX_MEM.RegWrite_o),
    .MemtoReg_i     (EX_MEM.MemtoReg_o),
    .ALUResult_i    (EX_MEM.ALUResult_o),
    .RDdata_i       (dcache.cpu_data_o),
    .Instruction4_i (EX_MEM.Instruction4_o),
    .RegWrite_o     (Registers.RegWrite_i),
    .MemtoReg_o     (WB_MUX.select_i),
    .ALUResult_o    (WB_MUX.data1_i),
    .RDdata_o       (WB_MUX.data2_i),
    .Instruction4_o (Registers.RDaddr_i)
);

MUX32 WB_MUX(
    .data1_i    (MEM_WB.ALUResult_o),
    .data2_i    (MEM_WB.RDdata_o),
    .select_i   (MEM_WB.MemtoReg_o),
    .data_o     (WB_WriteData)
);

Hazard_Detection Hazard_Detection(
    .IDRs1_i        (instr[19:15]),
    .IDRs2_i        (instr[24:20]),
    .EXRd_i         (ID_EX.Instruction4_o),
    .EXMemRead_i    (ID_EX.MemRead_o),
    .PCWrite_o      (PCWrite),
    .Stall_o        (Hazard_Detection_Stall),
    .NoOp_o         (Control.NoOp_i)
);

Forwarding_Unit Forwarding_Unit(
    .EXRs1_i        (ID_EX.EXRs1_o),
    .EXRs2_i        (ID_EX.EXRs2_o),
    .WBRegWrite_i   (MEM_WB.RegWrite_o),
    .WBRd_i         (MEM_WB.Instruction4_o),
    .MEMRegWrite_i  (EX_MEM.RegWrite_o),
    .MEMRd_i        (EX_MEM.Instruction4_o),
    .ForwardA_o     (MUX_EX1.select_i),
    .ForwardB_o     (MUX_EX2.select_i)
);

endmodule

