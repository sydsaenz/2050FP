module letters 
    (
        input wire [7:0] letter_num,
        output logic [7:0][4:0] letter
    );

    logic [7:0][4:0] letters [10:0];
    //heartsnocm
    logic [7:0][4:0] letter_h;
    assign letter_h[0] = 5'b10001;
    assign letter_h[1] = 5'b10001;
    assign letter_h[2] = 5'b10001;
    assign letter_h[3] = 5'b11111;
    assign letter_h[4] = 5'b10001;
    assign letter_h[5] = 5'b10001;
    assign letter_h[6] = 5'b10001;
    assign letter_h[7] = 5'b10001;

    logic [7:0][4:0] letter_e;
    assign letter_e[0] = 5'b11111;
    assign letter_e[1] = 5'b10000;
    assign letter_e[2] = 5'b10000;
    assign letter_e[3] = 5'b11110;
    assign letter_e[4] = 5'b10000;
    assign letter_e[5] = 5'b10000;
    assign letter_e[6] = 5'b10000;
    assign letter_e[7] = 5'b11111;

    logic [7:0][4:0] letter_a;
    assign letter_a[0] = 5'b01110;
    assign letter_a[1] = 5'b10001;
    assign letter_a[2] = 5'b10001;
    assign letter_a[3] = 5'b10001;
    assign letter_a[4] = 5'b11111;
    assign letter_a[5] = 5'b10001;
    assign letter_a[6] = 5'b10001;
    assign letter_a[7] = 5'b10001;

    logic [7:0][4:0] letter_r;
    assign letter_r[0] = 5'b11110;
    assign letter_r[1] = 5'b10001;
    assign letter_r[2] = 5'b10001;
    assign letter_r[3] = 5'b10001;
    assign letter_r[4] = 5'b11110;
    assign letter_r[5] = 5'b10100;
    assign letter_r[6] = 5'b10010;
    assign letter_r[7] = 5'b10001;

    logic [7:0][4:0] letter_t;
    assign letter_t[0] = 5'b11111;
    assign letter_t[1] = 5'b00100;
    assign letter_t[2] = 5'b00100;
    assign letter_t[3] = 5'b00100;
    assign letter_t[4] = 5'b00100;
    assign letter_t[5] = 5'b00100;
    assign letter_t[6] = 5'b00100;
    assign letter_t[7] = 5'b00100;

    logic [7:0][4:0] letter_s;
    assign letter_s[0] = 5'b01111;
    assign letter_s[1] = 5'b10000;
    assign letter_s[2] = 5'b10000;
    assign letter_s[3] = 5'b01110;
    assign letter_s[4] = 5'b00001;
    assign letter_s[5] = 5'b00001;
    assign letter_s[6] = 5'b00001;
    assign letter_s[7] = 5'b11110;

    logic [7:0][4:0] letter_n;
    assign letter_n[0] = 5'b10001;
    assign letter_n[1] = 5'b11001;
    assign letter_n[2] = 5'b11001;
    assign letter_n[3] = 5'b10101;
    assign letter_n[4] = 5'b10101;
    assign letter_n[5] = 5'b10011;
    assign letter_n[6] = 5'b10011;
    assign letter_n[7] = 5'b10001;

    logic [7:0][4:0] letter_o;
    assign letter_o[0] = 5'b01110;
    assign letter_o[1] = 5'b10001;
    assign letter_o[2] = 5'b10001;
    assign letter_o[3] = 5'b10001;
    assign letter_o[4] = 5'b10001;
    assign letter_o[5] = 5'b10001;
    assign letter_o[6] = 5'b10001;
    assign letter_o[7] = 5'b01110;

    logic [7:0][4:0] letter_c;
    assign letter_c[0] = 5'b01110;
    assign letter_c[1] = 5'b10001;
    assign letter_c[2] = 5'b10000;
    assign letter_c[3] = 5'b10000;
    assign letter_c[4] = 5'b10000;
    assign letter_c[5] = 5'b10000;
    assign letter_c[6] = 5'b10001;
    assign letter_c[7] = 5'b01110;

    logic [7:0][4:0] letter_m;
    assign letter_m[0] = 5'b10001;
    assign letter_m[1] = 5'b11011;
    assign letter_m[2] = 5'b11011;
    assign letter_m[3] = 5'b10101;
    assign letter_m[4] = 5'b10101;
    assign letter_m[5] = 5'b10001;
    assign letter_m[6] = 5'b10001;
    assign letter_m[7] = 5'b10001;

    logic [7:0][4:0] letter_sp;
    assign letter_sp[0] = 5'b00000;
    assign letter_sp[1] = 5'b00000;
    assign letter_sp[2] = 5'b00000;
    assign letter_sp[3] = 5'b00000;
    assign letter_sp[4] = 5'b00000;
    assign letter_sp[5] = 5'b00000;
    assign letter_sp[6] = 5'b00000;
    assign letter_sp[7] = 5'b00000;

    assign letters[0] = letter_h;
    assign letters[1] = letter_e;
    assign letters[2] = letter_a;
    assign letters[3] = letter_r;
    assign letters[4] = letter_t;
    assign letters[5] = letter_s;
    assign letters[6] = letter_n;
    assign letters[7] = letter_o;
    assign letters[8] = letter_c;
    assign letters[9] = letter_m;
    assign letters[10] = letter_sp;

    assign letter = letters[letter_num];



endmodule