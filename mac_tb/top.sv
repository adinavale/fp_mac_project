`include "mac.v"

module top_tb();

  reg clk, reset;
  reg [15:0] A, B, mac_result;
  reg [4:0]counter;

  real ar, br, sum;

  localparam SF = 2**-9;

  mac_wrapper mw(.clk(clk), .reset(reset), .A(A), .B(B), .counter(counter), .mac_result(mac_result));

  initial
  begin
    clk = 0;
    reset = 0;
    A = 0;
    B = 0;
    ar = 0.0;
    br = 0.0;
    sum = 0.0;

    #50ns;

    @(posedge clk);
    reset = 1;
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    A = $urandom_range(16'h0, 16'h0A00);
    B = $urandom_range(16'hF600, 16'hFE00);
    ar =  ($itor(signed'(A)*2.0**-9.0));
    br =  ($itor(signed'(B)*2.0**-9.0));
    sum += ar*br;
    $display(" A(Real) = %f", ar);
    $display(" B(Real) = %f", br);

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    $display("Expected sum = %f", sum);
    $display("Calculated sum = %f", ($itor(signed'(mac_result)*2.0**-9.0)) );

    $finish;
  end

  always #10 clk = ~clk;

  initial
  begin
    $dumpfile("waves.vcd");
    $dumpvars;
  end
  
endmodule
