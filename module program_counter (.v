module program_counter (
    input  wire        clock,
    input  wire        rst,
    input  wire [31:0] pc_next,// ده الinstructionnالجديد
    output reg  [31:0] pc_current//العنوان الواقف عليه البرنامج و بيقراه
);
 
    always @(posedge clock) begin
        if (rst) begin
            pc_current <= 32'h00000000;
        end else begin
            pc_current <= pc_next;
        end
    end
 
endmodule
//هنا بيشتغل ازاي لو الreset =0
// بيبقي الانسركشن الجديد بيتحط فيcurrent