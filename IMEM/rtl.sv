
module imem (
    input  logic [31:0] a,
    output logic [31:0] rd
);

    logic [31:0] mem [0:63];

    initial begin
        $readmemh("IMEM/program.txt", mem);
    end

    always_comb begin
        rd = mem[a[31:2]];
    end

endmodule
