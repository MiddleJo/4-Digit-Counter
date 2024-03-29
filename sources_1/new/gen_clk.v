// ī���͸� �����Ͽ� ���ֱ� ����� ����. �� ȿ������ ���� ���� �� ����.
module gen_clk(input clk, input rst, output reg clk_div);
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            i = 0; clk_div = 0;
        end
        else begin
            i = i+1;
            if (i == 249999) begin           // 2,499,999 �� ����ϸ� 1�ʿ� �ѹ� Ŭ������ ����.
                i = 0; clk_div = ~clk_div;   // ���ڸ������� ������� �ϹǷ� 0.1�� Ŭ������ ����.
            end
        end
    end
endmodule

