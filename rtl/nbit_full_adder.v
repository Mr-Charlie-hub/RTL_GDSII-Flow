module nbit_full_adder #(
    parameter N = 8
) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    input  wire         cin,
    output wire [N-1:0] sum,
    output wire         cout
);
    assign {cout, sum} = a + b + cin;
endmodule
