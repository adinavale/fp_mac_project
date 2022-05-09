module KeyPadScanner(input reset,
  input KeyRd,
  input Clock, 
  input [3:0] RowIn, 
  output [3:0] ColOut, 
  output ready,
  output reg[15:0] mem_reg);
  
  parameter Scan=3'b000, Calculate=3'b001, Analyze=3'b010, WaitForRead=3'b011, Display=3'b100;
  
  reg [2:0] HexState;
  reg [15:0] Data;
  reg [3:0] Col;
  reg [3:0] Sum;
  reg waitbit;
  reg [1:0] display_id;
  reg[3:0] data_reg;
  reg ready_q;
  
  /*Column out to the hexpad*/
  assign ColOut[0] = Col[0] ? 1'bz : 1'b0; 
  assign ColOut[1] = Col[1] ? 1'bz : 1'b0; 
  assign ColOut[2] = Col[2] ? 1'bz : 1'b0; 
  assign ColOut[3] = Col[3] ? 1'bz : 1'b0; 
  assign ready = ready_q;
  
  /*Key pad scanner module*/
  always @(posedge Clock or posedge reset) 
  begin
    ready_q = 0;
    if (reset == 1 ) 
    begin
      HexState <= Scan;
      Col <= 4'b0111;
      Data <= 16'hFFFF;
      Sum <= 0;
      display_id <=2'b00;
      mem_reg <= 0;
      waitbit <= 0;
    end
    else 
    begin
      case(HexState)
        Scan: 
        begin
          case(Col)
            4'b0111: 
            begin 
              if(waitbit == 1) 
              begin
                Data[15:12] <= RowIn;
                Col <= 4'b1011;
                waitbit <= 0;
              end
              else
              begin
                waitbit <= 1;
              end
            end
            4'b1011: 
            begin
              if(waitbit == 1) 
              begin
                Data[11:8] <= RowIn;
                Col <= 4'b1101;
                waitbit <= 0;
              end
              else
              begin
                waitbit <= 1;
              end
            end
            4'b1101: 
            begin
              if(waitbit == 1) 
              begin
                Data[7:4] <= RowIn;
                Col <= 4'b1110;
                waitbit <= 0;
              end
              else
              begin
                waitbit <= 1;
              end
            end
            4'b1110: 
            begin
              if(waitbit == 1) 
              begin
                Data[3:0] <= RowIn;
                Col <= 4'b0111;
                HexState <= Calculate;	
                waitbit <= 0;
              end
              else 
              begin
                waitbit <= 1;
              end
            end
            default: 
            begin
              Col <= 4'b1110;
            end
          endcase	
        end 
        Calculate: 
        begin
          Sum <= ~Data[0] + ~Data[1] + ~Data[2] + ~Data[3]
          + ~Data[4] + ~Data[5] + ~Data[6] + ~Data[7]
          + ~Data[8] + ~Data[9] + ~Data[10] + ~Data[11]
          + ~Data[12] + ~Data[13] + ~Data[14] + ~Data[15]; 
          HexState <= Analyze;
        end
        
        Analyze: 
        begin
          if(Sum == 4'b0001) 
          begin
            case(Data)
              16'hFFFE : data_reg <= 4'hD;
              16'hFFFD : data_reg <= 4'hE;
              16'hFFFB : data_reg <= 4'h0;
              16'hFFF7 : data_reg <= 4'hF;
              16'hFFEF : data_reg <= 4'hC;
              16'hFFDF : data_reg <= 4'h9;
              16'hFFBF : data_reg <= 4'h8;
              16'hFF7F : data_reg <= 4'h7;
              16'hFEFF : data_reg <= 4'hB;
              16'hFDFF : data_reg <= 4'h6;
              16'hFBFF : data_reg <= 4'h5;
              16'hF7FF : data_reg <= 4'h4;
              16'hEFFF : data_reg <= 4'hA;
              16'hDFFF : data_reg <= 4'h3;
              16'hBFFF : data_reg <= 4'h2;
              16'h7FFF : data_reg <= 4'h1;
              default  :; 
            endcase				
            HexState <= WaitForRead;
          end
          else 
          begin 		
            HexState <= Scan;  
          end
        end
        WaitForRead: 
        begin 
          if( KeyRd == 1) 
          begin
            HexState <= Display;
          end
        end 
        Display : 
        begin
          case(display_id)
            3 : 
            begin 
              mem_reg[3:0]=data_reg; 
              ready_q = 1;
            end//LSB
            2 : 
            begin 
              mem_reg[7:4]=data_reg;
              ready_q = 1;
            end
            1 : 
            begin
              mem_reg[11:8]=data_reg;
              ready_q = 1;
            end
            0 : 
            begin 
              mem_reg[15:12]=data_reg;
              ready_q = 1;
            end //MSB
          endcase
          display_id = display_id +1;			
          HexState <= Scan;
        end
        
        default: 
        begin 
          HexState <= Scan;
          Col <= 4'b1110;
          Data <= 16'hFFFF;
          Sum <= 0;
        end
      endcase
    end 
  end    
  
endmodule 





