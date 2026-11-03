module datapath(
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  ResultSrc,
    input  logic        PCSrc,
    input  logic        ALUSrc,
    input  logic        RegWrite,
    input  logic [1:0]  ImmSrc,
    input  logic [2:0]  ALUControl,
    output logic        Zero,
    output logic [31:0] PC,
    input  logic [31:0] Instr,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);

    logic [31:0] PCNext;
    logic [31:0] PCPlus4;
    logic [31:0] ImmExt;
    logic [31:0] ShiftedImm;
    logic [31:0] PCTarget;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] Result;

    // Program-counter register and sequential PC address.
    flopr #(.WIDTH(32)) pc_register (
        .d    (PCNext),
        .clk  (clk),
        .reset(reset),
        .q    (PC)
    );

    adder pc_plus_4 (
        .a(PC),
        .b(32'd4),
        .y(PCPlus4)
    );

    // Immediate generation. The README specifies shifting B/J immediates here.
    extend immediate_generator (
        .instr (Instr[31:7]),
        .immsrc(ImmSrc),
        .immext(ImmExt)
    );

    assign ShiftedImm = {ImmExt[30:0], 1'b0};

    adder pc_target_adder (
        .a(PC),
        .b(ShiftedImm),
        .y(PCTarget)
    );

    mux2 #(.WIDTH(32)) pc_source_mux (
        .d0(PCPlus4),
        .d1(PCTarget),
        .s (PCSrc),
        .y (PCNext)
    );

    // Register file: rs1 and rs2 are read; rd receives the write-back result.
    regfile register_file (
        .clk(clk),
        .we3(RegWrite),
        .a1(Instr[19:15]),
        .a2(Instr[24:20]),
        .a3(Instr[11:7]),
        .wd3(Result),
        .rd1(SrcA),
        .rd2(WriteData)
    );

    // Select register operand or sign-extended immediate for the ALU B input.
    mux2 #(.WIDTH(32)) alu_source_mux (
        .d0(WriteData),
        .d1(ImmExt),
        .s (ALUSrc),
        .y (SrcB)
    );

    alu arithmetic_logic_unit (
        .a         (SrcA),
        .b         (SrcB),
        .alucontrol(ALUControl),
        .result    (ALUResult)
    );

    assign Zero = (ALUResult == 32'b0);

    // 00 = ALU result, 01 = memory read data, 10 = PC + 4.
    mux3 #(.WIDTH(32)) result_source_mux (
        .d0(ALUResult),
        .d1(ReadData),
        .d2(PCPlus4),
        .s (ResultSrc),
        .y (Result)
    );

endmodule
