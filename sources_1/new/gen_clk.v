// 카운터를 응용하여 분주기 모듈을 만들어봄. 더 효율적인 것이 있을 수 있음.
module gen_clk(input clk, input rst, output reg clk_div);
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            i = 0; clk_div = 0;
        end
        else begin
            i = i+1;
            if (i == 249999) begin           // 2,499,999 를 사용하면 1초에 한번 클락으로 가능.
                i = 0; clk_div = ~clk_div;   // 네자리수까지 보여줘야 하므로 0.1초 클락으로 진행.
            end
        end
    end
endmodule

