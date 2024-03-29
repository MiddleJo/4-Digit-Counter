// ���� ���
module counter(clk, rst, seg_out, mode_out);
    input clk, rst;                                         // Ŭ��, ���� ��Ʈ
    output [7:0] seg_out;                                   // 7-���׸�Ʈ ��Ʈ a ~ dp
    output [3:0] mode_out;                                  // digit_0 ~ digit_3 ��Ʈ
    reg [3:0] thous, hunds, tens, units;                    // �ڸ����� ���� ������
    wire [7:0] seg_thous, seg_hunds, seg_tens, seg_units;  // 7-���׸�Ʈ�� ��ȯ�� �ڸ���
    wire clk_wiz, clk_div;                                 // ���ֱ⸦ ���� ���� �ΰ��� Ŭ�� ��ȣ. clk_wiz�� clocking wizard�� ���� �������.
    integer tmp, cnt;                                      // �ڸ��� ��꿡 ���� �ӽ� ����, ī���Ϳ� ���� ����
    reg [3:0] mode_tmp;                                    // ������ ������ digit_0 ~ digit_3�� ��� ��ȣ�� ������ �����ϴ� �迭
    reg [7:0] seg_tmp;                                     // ��尡 �����Ǹ� �׿� ���� 7-���׸�Ʈ�� ������ �ֱ� ���� ����
    
    assign mode_out = mode_tmp;                            // � ĭ�� ������ ���� ��Ʈ. 0010 �̸� �����ʿ��� �ι�° ĭ�� Ų��.
    assign seg_out = seg_tmp;                              // ������ ��忡 ���� �˸��� �ڸ����� �����ϱ� ����

// ī���� ��� ���ۺ�. ���ֱ� ��� gen_clk�� ���� �����Ѵ�.
    always @(posedge clk_div or posedge rst) begin
        if (rst) begin
            cnt <= 0; units <= 0; tens <= 0; hunds <= 0; thous <= 0;
        end
        else if (cnt == 9999) begin
            cnt <= 0; units <= 0; tens <= 0; hunds <= 0; thous <= 0;
        end
        else begin
            cnt = cnt + 1;                                          // �ڸ��� ���. �߰��� tmp ������ Ȱ��. 
            thous = (cnt - (cnt % 1000)) / 1000; tmp = cnt % 1000;  // ���������� ������ �� �ֵ��� �̰Ͱ� ���� �ڵ带 �ۼ��Ͽ���.
            hunds = (tmp - (tmp % 100)) / 100; tmp = tmp % 100; 
            tens = (tmp - (tmp % 10)) / 10;
            units = tmp % 10;
        end
    end

// Shift-Resister ������� mode�� ���� ���������� �������� �о���.
// �̰��� fnd�� ������ ĭ�� ��� �ٲ��ִ� �۵��� ��.
    always @(posedge clk_wiz or posedge rst) begin
        if (rst) begin
            mode_tmp <= 4'b0001; seg_tmp <= 8'b01111111;
        end
        else begin
            mode_tmp[0] <= mode_tmp[3];
            mode_tmp[3:1] <= mode_tmp[2:0];            
        end
        case(mode_out)
            4'b0001 : seg_tmp <= seg_tens; // ������ ��ĭ�� �������� �̵��ǹǷ� �ϳ��� ���� ���� �Ҵ��Ѵ�.
            4'b0010 : seg_tmp <= seg_hunds;
            4'b0100 : seg_tmp <= seg_thous;
            4'b1000 : seg_tmp <= seg_units;
            default: seg_tmp <= 8'b11000000; 
        endcase
    end

clk_wiz_0 wclk(clk_wiz, clk);                             // Clocking Wizard�� ���� Ŭ�� ��ȣ. 5 Mhz ���� ���� ���� �Ұ�
gen_clk gclk(clk_wiz, rst, clk_div);                      // ������� ���Ǵ�� ������� ���ο� Ŭ�� ��ȣ.
seven_segment thous_seg(.digit(thous), .seg(seg_thous));  // õ�� �ڸ� ���׸�Ʈ
seven_segment hunds_seg(.digit(hunds), .seg(seg_hunds));  // ���� �ڸ� ���׸�Ʈ
seven_segment tens_seg(.digit(tens), .seg(seg_tens));     // ���� �ڸ� ���׸�Ʈ
seven_segment units_seg(.digit(units), .seg(seg_units));  // ���� �ڸ� ���׸�Ʈ
endmodule
