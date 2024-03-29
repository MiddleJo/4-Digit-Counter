//fnd ���ۺ�. 
//�Է����� 5MHz�� clk_wiz�� ������, ����Ʈ �������� ������� mode�� ���� ����ؼ� �������� �����Ѵ�.
//�̰��� mode_out�� �� ĭ�� 1�� ������ ���� �ΰ��Ǿ� fnd_digit�� ������ ���� �۵���ų �� �ֵ��� �Ѵ�.

module shift_reg (input clk_wiz, input rst, input [7:0] seg_in [0:3], output reg [7:0] seg_out, output reg [3:0] mode_out);

    always @(posedge clk_wiz or posedge rst) begin
        if (rst) begin
            mode_out <= 4'b1111; seg_out <= 8'b11000000;
        end
        else begin
            mode_out[0] <= mode_out[3];
            mode_out[3:1] <= mode_out[2:0];            
        end
        case(mode_out)
            4'b0001 : seg_out = seg_in[0];
            4'b0010 : seg_out = seg_in[1];
            4'b0100 : seg_out = seg_in[2];
            4'b1000 : seg_out = seg_in[3];
            default: seg_out = 8'b11000000;
        endcase
    end
endmodule 