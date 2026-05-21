`timescale 1ns / 1ps

module tb_binarynet();
    reg ap_clk = 0;
    reg ap_rst = 0;
    reg ap_start = 0;

    wire ap_done;
    wire ap_idle;
    wire ap_ready;
    wire [15:0] data0;
    wire data0_ap_vld;

    reg [15:0] input_vec = 0;

    always #5 ap_clk = ~ap_clk;

    bd_0_wrapper bd_0_i (
        .ap_clk(ap_clk),
        .ap_rst(ap_rst),
        .ap_ctrl_start(ap_start),
        .ap_ctrl_done(ap_done),
        .ap_ctrl_idle(ap_idle),
        .ap_ctrl_ready(ap_ready),
        .data0(data0),
        .data0_ap_vld(data0_ap_vld),
        .data1_0(input_vec[0]),
        .data1_1(input_vec[1]),
        .data1_2(input_vec[2]),
        .data1_3(input_vec[3]),
        .data1_4(input_vec[4]),
        .data1_5(input_vec[5]),
        .data1_6(input_vec[6]),
        .data1_7(input_vec[7]),
        .data1_8(input_vec[8]),
        .data1_9(input_vec[9]),
        .data1_10(input_vec[10]),
        .data1_11(input_vec[11]),
        .data1_12(input_vec[12]),
        .data1_13(input_vec[13]),
        .data1_14(input_vec[14]),
        .data1_15(input_vec[15])
    );

    integer i;
    integer seed;
    integer latency_cycles;
    integer min_latency;
    integer max_latency;
    integer total_latency;
    integer NVECS;

    initial begin
        NVECS = 10000;
        seed = 32'h19A84C2D;
        ap_rst = 1;
        ap_start = 0;
        input_vec = 0;
        min_latency = 32'h7fffffff;
        max_latency = 0;
        total_latency = 0;
        repeat(5) @(posedge ap_clk);
        ap_rst = 0;
        repeat(5) @(posedge ap_clk);
        $display("[%t] Reset released. Starting sustained workload (%0d vectors)...", $time, NVECS);
        for (i = 0; i < NVECS; i = i + 1) begin
            @(negedge ap_clk);
            input_vec = $random(seed);
            ap_start = 1'b1;
            $display("[%t] VECTOR %0d: input loaded, ap_start asserted", $time, i + 1);

            latency_cycles = 0;
            @(posedge ap_clk);
            while (ap_ready !== 1'b1) begin
                latency_cycles = latency_cycles + 1;
                $display("[%t] VECTOR %0d: waiting for ap_ready", $time, i + 1);
                @(posedge ap_clk);
            end
            $display("[%t] VECTOR %0d: ap_ready/ap_done observed after %0d cycles", $time, i + 1, latency_cycles);

            @(negedge ap_clk);
            ap_start = 1'b0;
            $display("[%t] VECTOR %0d: ap_start deasserted", $time, i + 1);
            if (latency_cycles < min_latency) min_latency = latency_cycles;
            if (latency_cycles > max_latency) max_latency = latency_cycles;
            total_latency = total_latency + latency_cycles;
            $display("[%t] PROGRESS: Vector %0d / %0d, latency %0d cycles, avg latency %.2f cycles", $time, i + 1, NVECS, latency_cycles, (total_latency * 1.0) / (i + 1));
        end
        $display("[%t] Workload complete. Latency cycles min=%0d max=%0d avg=%.2f", $time, min_latency, max_latency, (total_latency * 1.0) / NVECS);
        repeat (20) @(posedge ap_clk);
        $finish;
    end
endmodule
