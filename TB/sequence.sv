
  import uvm_pkg::* ;
  import SPI_pkg::* ;



  class base_sequence extends uvm_sequence #(seq_item) ;
    `uvm_object_utils (base_sequence) 

    function new (string name = "base_sequence" );
      super.new(name);
      `uvm_info(get_type_name(),"Inside constructor of base sequence Class",UVM_HIGH) 
    endfunction

  endclass: base_sequence 









  // Reset Sequence Class 
  class reset_sequence extends base_sequence  ;
    `uvm_object_utils (reset_sequence) 
    seq_item reset_item ;

    // Constructor 
    function new (string name = "reset_sequence" );
      super.new(name);
      `uvm_info(get_type_name(),"Inside constructor of reset sequence Class",UVM_HIGH) 
    endfunction

    // Reset Constraints 
    task body() ;
      reset_item = seq_item::type_id::create("reset_item") ;

      start_item(reset_item) ;
      assert(reset_item.randomize() with {i_Rst==1; i_TX_Byte==0;}) ;
      finish_item(reset_item) ;
    endtask: body

  endclass: reset_sequence











  // SPI Sequence Class 
  class SPI_sequence extends base_sequence ;
    `uvm_object_utils (SPI_sequence) 
    seq_item SPI_item ;

    // Constructor 
    function new (string name = "SPI_sequence" );
      super.new(name);
      `uvm_info(get_type_name(),"Inside constructor of SPI sequence Class",UVM_HIGH) 
    endfunction

    // SPI Constraints 



    task body() ;
      SPI_item = seq_item::type_id::create("SPI_item") ;



      start_item(SPI_item) ;
      assert(SPI_item.randomize() with {
        SPI_item.i_Rst      dist {1 := 0, 0 := 1};
        SPI_item.i_TX_Byte  dist {0 := 10, [1:254] := 40, 8'hff := 10};
        SPI_item.r_MISO     dist {0 := 2, [1:254] := 8, 8'hff := 2};
        SPI_item.i_TX_Valid == 1 ;} ) ;


      finish_item(SPI_item) ;

    endtask: body

  endclass: SPI_sequence







