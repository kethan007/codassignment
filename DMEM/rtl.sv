module dmem(
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

    logic [31:0] mem [0:63];

    // Byte address bits [7:2] select one of the 64 aligned 32-bit words.
    always_ff @(posedge clk) begin
        if (we) begin
            mem[a[7:2]] <= wd;
        end
    end

    // Asynchronous/combinational read.
    always_comb begin
        rd = mem[a[7:2]];
    end

endmodule
