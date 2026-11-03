module extend(
    input  logic [31:7] instr,
    input  logic [1:0]  immsrc,
    output logic [31:0] immext
);

    always_comb begin
        case (immsrc)
            // I-type: instruction[31:20] is a 12-bit immediate.
            2'b00: immext = {{20{instr[31]}}, instr[31:20]};

            // S-type: {instruction[31:25], instruction[11:7]} is 12 bits.
            2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // B-type: construct the 12 encoded bits [12:1].
            // The datapath shifts this value left by one when forming the target.
            2'b10: immext = {{20{instr[31]}}, instr[31], instr[7],
                             instr[30:25], instr[11:8]};

            // J-type: construct the 20 encoded bits [20:1].
            // The datapath shifts this value left by one when forming the target.
            2'b11: immext = {{12{instr[31]}}, instr[31], instr[19:12],
                             instr[20], instr[30:21]};

            default: immext = 32'b0;
        endcase
    end

endmodule
