module top(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

    logic [31:0] PC;
    logic [31:0] Instr;
    logic [31:0] ReadData;
    logic [31:0] ALUResult;

    // Instruction fetch.
    imem instruction_memory (
        .a (PC),
        .rd(Instr)
    );

    // CPU core: controller plus datapath.
    riscvsingle cpu (
        .clk      (clk),
        .reset    (reset),
        .PC       (PC),
        .Instr    (Instr),
        .MemWrite (MemWrite),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData (ReadData)
    );

    // Data memory.
    dmem data_memory (
        .clk(clk),
        .we (MemWrite),
        .a  (ALUResult),
        .wd (WriteData),
        .rd (ReadData)
    );

    assign DataAdr = ALUResult;

endmodule
