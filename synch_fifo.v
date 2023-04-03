module synch_fifo (
            rst, clk, we, re, data_in, data_out,full,empty
);

parameter ptr_size='d3;                  //declaring as parameters to make variable memory
parameter depth='d8;                     // depth_size =2^(pointer_size-1)
parameter width='d4;
integer i;


reg [width-1:0]mem[depth-1:0];            //memory declaration
 
reg  [ptr_size-1:0]wr_ptr,rd_ptr;

reg [3:0]count;

input rst,clk,we,re;
input [width-1:0]data_in;
 
output reg [width-1:0]data_out;
output reg full,empty;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        for(i=0;i<depth;i=i+1)                  //resetting fifo
           mem[i]=4'b0;
           wr_ptr=3'b0;
            rd_ptr=3'b0;
            full=1'b0;
            empty=1'b1;
            count=3'b0;
    end

    else if ((we==1) && (re==0))                                 //write condition
    begin
        if ((wr_ptr==rd_ptr) && (count==4'b1000))                              //checking memory full or not
        begin
             full=1'b1;
             empty=1'b0;                                      //if yes making full as high                          
         end
        else
        begin
             mem[wr_ptr]=data_in;                         
             wr_ptr=wr_ptr+1; 
             count=count+1;
        end
        
    end

    else if ((we==0) && (re==1))                   //read condition
    begin

        if ((wr_ptr==rd_ptr) && (count==4'b0000)) 
        begin
            empty=1'b1;
            full=1'b0;
           
         end

         else
         begin
             data_out=mem[rd_ptr];
             rd_ptr=rd_ptr+1;
             count=count-1;
         end


    end

    else
    begin
        wr_ptr=wr_ptr;
        rd_ptr=rd_ptr;
        count=count;

    end

end

    
endmodule

module synch_fifo_tb; 

parameter ptr_size='d3;                
parameter depth='d8;                   
parameter width='d4; 


reg rst,clk,we,re;
reg [width-1:0]data_in;

wire [width-1:0]data_out;
wire full,empty;

synch_fifo dut( .rst(rst), .clk(clk), .we(we), .re(re), .data_in(data_in), .data_out(data_out),.full(full),.empty(empty));

initial 
begin
    clk=0; rst=0; re=0; we=0; data_in=4'b1010;
    #10 rst=1'b1; 
    #10 rst=1'b0;

              re=0; we=1;
             #5  data_in='d0;
             #20 re=0; we=1; data_in='d1;
             #20 re=0; we=1; data_in='d2;
             #20 re=0; we=1; data_in='d3;
             #20 re=0; we=1; data_in='d4;
             #20 re=0; we=1; data_in='d5;
             #20 re=0; we=1; data_in='d6;
             #20 re=0; we=1; data_in='d7;
             #25 re=0; we=0;
          
        
             #20  re=1; we=0;
             #20  re=1; we=0;
             #20  re=1; we=0;
             #20  re=1; we=0;
             #20  re=1; we=0;
             #20  re=1; we=0;
             #20  re=1; we=0; 
             #20  re=1; we=0;    
             #20 re=0;we=0;

end
    
    always #10 clk=~clk;
endmodule


