import uvm_pkg::* ;
import SPI_pkg::* ;


class scoreboard extends uvm_scoreboard  ;
  `uvm_component_utils(scoreboard);


  uvm_analysis_imp #(seq_item, scoreboard) monitor_export ; // to connect monitor to scoreboard

  // Constructor
  function new (string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new



  // Build Phase 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase) ;
    monitor_export = new ("monitor_export" ,this);
  endfunction : build_phase




  // Write Function 
  function void write(seq_item monitor_seq) ;

    bit pass ;
    bit reset_pass ;

    if (monitor_seq.i_Rst) begin 

      reset_pass = (monitor_seq.o_TX_Ready == 0 && monitor_seq.r_MOSI == 0 && monitor_seq.o_RX_Byte == 0 && monitor_seq.o_RX_Valid == 0) ;
      if (reset_pass == 1) begin 
        $display("Reset Passed Succesefully") ;
        $display("o_TX_Ready : %d , r_MOSI : %d , o_RX_Byte : %d , o_RX_Valid : %d", monitor_seq.o_TX_Ready, monitor_seq.r_MOSI , monitor_seq.o_RX_Byte , monitor_seq.o_RX_Valid) ;
      end
      else begin
        $display("Reset Failed") ;
        $display("o_TX_Ready : %d , MOSI : %d , o_RX_Byte : %d , o_RX_Valid : %d", monitor_seq.o_TX_Ready, monitor_seq.r_MOSI , monitor_seq.o_RX_Byte , monitor_seq.o_RX_Valid) ;
      end
    end
    else begin
      pass = (monitor_seq.o_RX_Byte == monitor_seq.serial_input) &&
      (monitor_seq.r_MOSI == monitor_seq.i_TX_Byte ) ;
      

      if (pass == 1) begin 
        $display("") ;
        `uvm_info("SELF CHECKER", {"PASS "}, UVM_LOW)
        $display("o_RX_Byte => Expected Value : %d , Actual Value : %d",monitor_seq.serial_input , monitor_seq.o_RX_Byte) ;
        $display("r_MOSI => Expected Value : %d , Actual Value : %d",monitor_seq.i_TX_Byte , monitor_seq.r_MOSI) ;
      end

      else if (pass == 0) begin 
        $display("") ;
        `uvm_error ("SELF CHECKER", {"FAIL "})
        $display("o_RX_Byte => Expected Value : %d , Actual Value : %d",monitor_seq.serial_input          ,monitor_seq.o_RX_Byte) ;
        $display("r_MOSI => Expected Value : %d , Actual Value : %d",monitor_seq.i_TX_Byte                ,monitor_seq.r_MOSI) ;
      end
    end
  endfunction : write


endclass : scoreboard 


