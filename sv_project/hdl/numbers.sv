module numbers 
    (
        input wire [7:0] number_ind,
        output logic [7:0][4:0] number
    );

    logic [7:0][4:0] numbers [9:0];
    //heartsnocm
    logic [7:0][4:0] number_0;
    assign number_0[0] = 5'b01110;
    assign number_0[1] = 5'b10001;
    assign number_0[2] = 5'b10001;
    assign number_0[3] = 5'b10101;
    assign number_0[4] = 5'b10101;
    assign number_0[5] = 5'b10001;
    assign number_0[6] = 5'b10001;
    assign number_0[7] = 5'b01110;

    logic [7:0][4:0] number_1;
    assign number_1[0] = 5'b00100;
    assign number_1[1] = 5'b01100;
    assign number_1[2] = 5'b10100;
    assign number_1[3] = 5'b00100;
    assign number_1[4] = 5'b00100;
    assign number_1[5] = 5'b00100;
    assign number_1[6] = 5'b00100;
    assign number_1[7] = 5'b11111;

    logic [7:0][4:0] number_2;
    assign number_2[0] = 5'b01110;
    assign number_2[1] = 5'b10001;
    assign number_2[2] = 5'b00001;
    assign number_2[3] = 5'b00010;
    assign number_2[4] = 5'b00100;
    assign number_2[5] = 5'b01000;
    assign number_2[6] = 5'b10000;
    assign number_2[7] = 5'b11111;

    logic [7:0][4:0] number_3;
    assign number_3[0] = 5'b01110;
    assign number_3[1] = 5'b10001;
    assign number_3[2] = 5'b00001;
    assign number_3[3] = 5'b01110;
    assign number_3[4] = 5'b00001;
    assign number_3[5] = 5'b00001;
    assign number_3[6] = 5'b10001;
    assign number_3[7] = 5'b01110;

    logic [7:0][4:0] number_4;
    assign number_4[0] = 5'b00001;
    assign number_4[1] = 5'b00011;
    assign number_4[2] = 5'b00101;
    assign number_4[3] = 5'b01001;
    assign number_4[4] = 5'b10001;
    assign number_4[5] = 5'b11111;
    assign number_4[6] = 5'b00001;
    assign number_4[7] = 5'b00001;

    logic [7:0][4:0] number_5;
    assign number_5[0] = 5'b11111;
    assign number_5[1] = 5'b10000;
    assign number_5[2] = 5'b10000;
    assign number_5[3] = 5'b11110;
    assign number_5[4] = 5'b00001;
    assign number_5[5] = 5'b00001;
    assign number_5[6] = 5'b00001;
    assign number_5[7] = 5'b11110;

    logic [7:0][4:0] number_6;
    assign number_6[0] = 5'b01110;
    assign number_6[1] = 5'b10001;
    assign number_6[2] = 5'b10000;
    assign number_6[3] = 5'b11110;
    assign number_6[4] = 5'b10001;
    assign number_6[5] = 5'b10001;
    assign number_6[6] = 5'b10001;
    assign number_6[7] = 5'b01110;

    logic [7:0][4:0] number_7;
    assign number_7[0] = 5'b11111;
    assign number_7[1] = 5'b10001;
    assign number_7[2] = 5'b00010;
    assign number_7[3] = 5'b00100;
    assign number_7[4] = 5'b00100;
    assign number_7[5] = 5'b01000;
    assign number_7[6] = 5'b01000;
    assign number_7[7] = 5'b01000;

    logic [7:0][4:0] number_8;
    assign number_8[0] = 5'b01110;
    assign number_8[1] = 5'b10001;
    assign number_8[2] = 5'b10001;
    assign number_8[3] = 5'b01110;
    assign number_8[4] = 5'b10001;
    assign number_8[5] = 5'b10001;
    assign number_8[6] = 5'b10001;
    assign number_8[7] = 5'b01110;

    logic [7:0][4:0] number_9;
    assign number_9[0] = 5'b01110;
    assign number_9[1] = 5'b10001;
    assign number_9[2] = 5'b10001;
    assign number_9[3] = 5'b01111;
    assign number_9[4] = 5'b00001;
    assign number_9[5] = 5'b00001;
    assign number_9[6] = 5'b10001;
    assign number_9[7] = 5'b01110;

    assign numbers[0] = number_0;
    assign numbers[1] = number_1;
    assign numbers[2] = number_2;
    assign numbers[3] = number_3;
    assign numbers[4] = number_4;
    assign numbers[5] = number_5;
    assign numbers[6] = number_6;
    assign numbers[7] = number_7;
    assign numbers[8] = number_8;
    assign numbers[9] = number_9;

    assign number = numbers[number_ind];



endmodule