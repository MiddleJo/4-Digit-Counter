// 메인 모듈
module counter(clk, rst, seg_out, mode_out);
    input clk, rst;                                         // 클록, 리셋 포트
    output [7:0] seg_out;                                   // 7-세그먼트 포트 a ~ dp
    output [3:0] mode_out;                                  // digit_0 ~ digit_3 포트
    reg [3:0] thous, hunds, tens, units;                    // 자릿수에 사용될 십진수
    wire [7:0] seg_thous, seg_hunds, seg_tens, seg_units;  // 7-세그먼트로 변환된 자릿수
    wire clk_wiz, clk_div;                                 // 분주기를 통해 나온 두가지 클록 신호. clk_wiz는 clocking wizard를 통해 만들어짐.
    integer tmp, cnt;                                      // 자릿수 계산에 사용될 임시 변수, 카운터에 사용될 변수
    reg [3:0] mode_tmp;                                    // 디지털 숫자판 digit_0 ~ digit_3중 어디에 신호를 넣을지 결정하는 배열
    reg [7:0] seg_tmp;                                     // 모드가 결정되면 그에 따른 7-세그먼트를 선언해 주기 위한 변수
    
    assign mode_out = mode_tmp;                            // 어떤 칸을 켤지에 대한 포트. 0010 이면 오른쪽에서 두번째 칸을 킨다.
    assign seg_out = seg_tmp;                              // 결정된 모드에 따라 알맞은 자릿수를 전달하기 위함

// 카운터 모듈 동작부. 분주기 모듈 gen_clk에 의해 동작한다.
    always @(posedge clk_div or posedge rst) begin
        if (rst) begin
            cnt <= 0; units <= 0; tens <= 0; hunds <= 0; thous <= 0;
        end
        else if (cnt == 9999) begin
            cnt <= 0; units <= 0; tens <= 0; hunds <= 0; thous <= 0;
        end
        else begin
            cnt = cnt + 1;                                          // 자릿수 계산. 중간에 tmp 변수를 활용. 
            thous = (cnt - (cnt % 1000)) / 1000; tmp = cnt % 1000;  // 직관적으로 이해할 수 있도록 이것과 같이 코드를 작성하였음.
            hunds = (tmp - (tmp % 100)) / 100; tmp = tmp % 100; 
            tens = (tmp - (tmp % 10)) / 10;
            units = tmp % 10;
        end
    end

// Shift-Resister 방식으로 mode의 값을 순차적으로 왼쪽으로 밀어줌.
// 이것은 fnd의 켜지는 칸을 계속 바꿔주는 작동을 함.
    always @(posedge clk_wiz or posedge rst) begin
        if (rst) begin
            mode_tmp <= 4'b0001; seg_tmp <= 8'b01111111;
        end
        else begin
            mode_tmp[0] <= mode_tmp[3];
            mode_tmp[3:1] <= mode_tmp[2:0];            
        end
        case(mode_out)
            4'b0001 : seg_tmp <= seg_tens; // 위에서 한칸씩 왼쪽으로 이동되므로 하나씩 왼쪽 것을 할당한다.
            4'b0010 : seg_tmp <= seg_hunds;
            4'b0100 : seg_tmp <= seg_thous;
            4'b1000 : seg_tmp <= seg_units;
            default: seg_tmp <= 8'b11000000; 
        endcase
    end

clk_wiz_0 wclk(clk_wiz, clk);                             // Clocking Wizard에 의한 클록 신호. 5 Mhz 보다 낮게 설정 불가
gen_clk gclk(clk_wiz, rst, clk_div);                      // 사용자의 임의대로 만들어질 새로운 클록 신호.
seven_segment thous_seg(.digit(thous), .seg(seg_thous));  // 천의 자리 세그먼트
seven_segment hunds_seg(.digit(hunds), .seg(seg_hunds));  // 백의 자리 세그먼트
seven_segment tens_seg(.digit(tens), .seg(seg_tens));     // 십의 자리 세그먼트
seven_segment units_seg(.digit(units), .seg(seg_units));  // 일의 자리 세그먼트
endmodule
