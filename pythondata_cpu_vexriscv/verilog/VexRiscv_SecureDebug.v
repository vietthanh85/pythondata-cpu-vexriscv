// Generator : SpinalHDL v1.4.0    git head : ecb5a80b713566f417ea3ea061f9969e73770a7f
// Date      : 11/12/2020, 16:43:04
// Component : VexRiscv


`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

`define EnvCtrlEnum_defaultEncoding_type [1:0]
`define EnvCtrlEnum_defaultEncoding_NONE 2'b00
`define EnvCtrlEnum_defaultEncoding_XRET 2'b01
`define EnvCtrlEnum_defaultEncoding_WFI 2'b10
`define EnvCtrlEnum_defaultEncoding_ECALL 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11


module InstructionCache (
  input               io_flush,
  input               io_cpu_prefetch_isValid,
  output reg          io_cpu_prefetch_haltIt,
  input      [31:0]   io_cpu_prefetch_pc,
  input               io_cpu_fetch_isValid,
  input               io_cpu_fetch_isStuck,
  input               io_cpu_fetch_isRemoved,
  input      [31:0]   io_cpu_fetch_pc,
  output     [31:0]   io_cpu_fetch_data,
  output              io_cpu_fetch_mmuBus_cmd_isValid,
  output     [31:0]   io_cpu_fetch_mmuBus_cmd_virtualAddress,
  output              io_cpu_fetch_mmuBus_cmd_bypassTranslation,
  input      [31:0]   io_cpu_fetch_mmuBus_rsp_physicalAddress,
  input               io_cpu_fetch_mmuBus_rsp_isIoAccess,
  input               io_cpu_fetch_mmuBus_rsp_allowRead,
  input               io_cpu_fetch_mmuBus_rsp_allowWrite,
  input               io_cpu_fetch_mmuBus_rsp_allowExecute,
  input               io_cpu_fetch_mmuBus_rsp_exception,
  input               io_cpu_fetch_mmuBus_rsp_refilling,
  output              io_cpu_fetch_mmuBus_end,
  input               io_cpu_fetch_mmuBus_busy,
  output     [31:0]   io_cpu_fetch_physicalAddress,
  output              io_cpu_fetch_haltIt,
  input               io_cpu_decode_isValid,
  input               io_cpu_decode_isStuck,
  input      [31:0]   io_cpu_decode_pc,
  output     [31:0]   io_cpu_decode_physicalAddress,
  output     [31:0]   io_cpu_decode_data,
  output              io_cpu_decode_cacheMiss,
  output              io_cpu_decode_error,
  output              io_cpu_decode_mmuRefilling,
  output              io_cpu_decode_mmuException,
  input               io_cpu_decode_isUser,
  input               io_cpu_fill_valid,
  input      [31:0]   io_cpu_fill_payload,
  output              io_mem_cmd_valid,
  input               io_mem_cmd_ready,
  output     [31:0]   io_mem_cmd_payload_address,
  output     [2:0]    io_mem_cmd_payload_size,
  input               io_mem_rsp_valid,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input      [2:0]    _zz_10_,
  input      [31:0]   _zz_11_,
  input               clk,
  input               reset 
);
  reg        [21:0]   _zz_12_;
  reg        [31:0]   _zz_13_;
  wire                _zz_14_;
  wire                _zz_15_;
  wire       [0:0]    _zz_16_;
  wire       [0:0]    _zz_17_;
  wire       [21:0]   _zz_18_;
  reg                 _zz_1_;
  reg                 _zz_2_;
  reg                 lineLoader_fire;
  reg                 lineLoader_valid;
  (* syn_keep , keep *) reg        [31:0]   lineLoader_address /* synthesis syn_keep = 1 */ ;
  reg                 lineLoader_hadError;
  reg                 lineLoader_flushPending;
  reg        [7:0]    lineLoader_flushCounter;
  reg                 _zz_3_;
  reg                 lineLoader_cmdSent;
  reg                 lineLoader_wayToAllocate_willIncrement;
  wire                lineLoader_wayToAllocate_willClear;
  wire                lineLoader_wayToAllocate_willOverflowIfInc;
  wire                lineLoader_wayToAllocate_willOverflow;
  (* syn_keep , keep *) reg        [2:0]    lineLoader_wordIndex /* synthesis syn_keep = 1 */ ;
  wire                lineLoader_write_tag_0_valid;
  wire       [6:0]    lineLoader_write_tag_0_payload_address;
  wire                lineLoader_write_tag_0_payload_data_valid;
  wire                lineLoader_write_tag_0_payload_data_error;
  wire       [19:0]   lineLoader_write_tag_0_payload_data_address;
  wire                lineLoader_write_data_0_valid;
  wire       [9:0]    lineLoader_write_data_0_payload_address;
  wire       [31:0]   lineLoader_write_data_0_payload_data;
  wire                _zz_4_;
  wire       [6:0]    _zz_5_;
  wire                _zz_6_;
  wire                fetchStage_read_waysValues_0_tag_valid;
  wire                fetchStage_read_waysValues_0_tag_error;
  wire       [19:0]   fetchStage_read_waysValues_0_tag_address;
  wire       [21:0]   _zz_7_;
  wire       [9:0]    _zz_8_;
  wire                _zz_9_;
  wire       [31:0]   fetchStage_read_waysValues_0_data;
  wire                fetchStage_hit_hits_0;
  wire                fetchStage_hit_valid;
  wire                fetchStage_hit_error;
  wire       [31:0]   fetchStage_hit_data;
  wire       [31:0]   fetchStage_hit_word;
  reg        [31:0]   io_cpu_fetch_data_regNextWhen;
  reg        [31:0]   decodeStage_mmuRsp_physicalAddress;
  reg                 decodeStage_mmuRsp_isIoAccess;
  reg                 decodeStage_mmuRsp_allowRead;
  reg                 decodeStage_mmuRsp_allowWrite;
  reg                 decodeStage_mmuRsp_allowExecute;
  reg                 decodeStage_mmuRsp_exception;
  reg                 decodeStage_mmuRsp_refilling;
  reg                 decodeStage_hit_valid;
  reg                 decodeStage_hit_error;
  (* ram_style = "block" *) reg [21:0] ways_0_tags [0:127];
  (* ram_style = "block" *) reg [31:0] ways_0_datas [0:1023];

  assign _zz_14_ = (! lineLoader_flushCounter[7]);
  assign _zz_15_ = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_16_ = _zz_7_[0 : 0];
  assign _zz_17_ = _zz_7_[1 : 1];
  assign _zz_18_ = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_18_;
    end
  end

  always @ (posedge clk) begin
    if(_zz_6_) begin
      _zz_12_ <= ways_0_tags[_zz_5_];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_) begin
      ways_0_datas[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_9_) begin
      _zz_13_ <= ways_0_datas[_zz_8_];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if(lineLoader_write_data_0_valid)begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if(lineLoader_write_tag_0_valid)begin
      _zz_2_ = 1'b1;
    end
  end

  assign io_cpu_fetch_haltIt = io_cpu_fetch_mmuBus_busy;
  always @ (*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid)begin
      if((lineLoader_wordIndex == (3'b111)))begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(_zz_14_)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if((! _zz_3_))begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 5],5'h0};
  assign io_mem_cmd_payload_size = (3'b101);
  always @ (*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if((! lineLoader_valid))begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign _zz_4_ = 1'b1;
  assign lineLoader_write_tag_0_valid = ((_zz_4_ && lineLoader_fire) || (! lineLoader_flushCounter[7]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[7] ? lineLoader_address[11 : 5] : lineLoader_flushCounter[6 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[7];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 12];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && _zz_4_);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[11 : 5],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign _zz_5_ = io_cpu_prefetch_pc[11 : 5];
  assign _zz_6_ = (! io_cpu_fetch_isStuck);
  assign _zz_7_ = _zz_12_;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_16_[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_17_[0];
  assign fetchStage_read_waysValues_0_tag_address = _zz_7_[21 : 2];
  assign _zz_8_ = io_cpu_prefetch_pc[11 : 2];
  assign _zz_9_ = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_waysValues_0_data = _zz_13_;
  assign fetchStage_hit_hits_0 = (fetchStage_read_waysValues_0_tag_valid && (fetchStage_read_waysValues_0_tag_address == io_cpu_fetch_mmuBus_rsp_physicalAddress[31 : 12]));
  assign fetchStage_hit_valid = (fetchStage_hit_hits_0 != (1'b0));
  assign fetchStage_hit_error = fetchStage_read_waysValues_0_tag_error;
  assign fetchStage_hit_data = fetchStage_read_waysValues_0_data;
  assign fetchStage_hit_word = fetchStage_hit_data;
  assign io_cpu_fetch_data = fetchStage_hit_word;
  assign io_cpu_decode_data = io_cpu_fetch_data_regNextWhen;
  assign io_cpu_fetch_mmuBus_cmd_isValid = io_cpu_fetch_isValid;
  assign io_cpu_fetch_mmuBus_cmd_virtualAddress = io_cpu_fetch_pc;
  assign io_cpu_fetch_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_fetch_mmuBus_end = ((! io_cpu_fetch_isStuck) || io_cpu_fetch_isRemoved);
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuBus_rsp_physicalAddress;
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = decodeStage_hit_error;
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = ((! decodeStage_mmuRsp_refilling) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @ (posedge clk) begin
    if(reset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= (3'b000);
    end else begin
      if(lineLoader_fire)begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire)begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid)begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush)begin
        lineLoader_flushPending <= 1'b1;
      end
      if(_zz_15_)begin
        lineLoader_flushPending <= 1'b0;
      end
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire)begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid)begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + (3'b001));
        if(io_mem_rsp_payload_error)begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(io_cpu_fill_valid)begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(_zz_14_)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + 8'h01);
    end
    _zz_3_ <= lineLoader_flushCounter[7];
    if(_zz_15_)begin
      lineLoader_flushCounter <= 8'h0;
    end
    if((! io_cpu_decode_isStuck))begin
      io_cpu_fetch_data_regNextWhen <= io_cpu_fetch_data;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_mmuRsp_physicalAddress <= io_cpu_fetch_mmuBus_rsp_physicalAddress;
      decodeStage_mmuRsp_isIoAccess <= io_cpu_fetch_mmuBus_rsp_isIoAccess;
      decodeStage_mmuRsp_allowRead <= io_cpu_fetch_mmuBus_rsp_allowRead;
      decodeStage_mmuRsp_allowWrite <= io_cpu_fetch_mmuBus_rsp_allowWrite;
      decodeStage_mmuRsp_allowExecute <= io_cpu_fetch_mmuBus_rsp_allowExecute;
      decodeStage_mmuRsp_exception <= io_cpu_fetch_mmuBus_rsp_exception;
      decodeStage_mmuRsp_refilling <= io_cpu_fetch_mmuBus_rsp_refilling;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_valid <= fetchStage_hit_valid;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_error <= fetchStage_hit_error;
    end
    if((_zz_10_ != (3'b000)))begin
      io_cpu_fetch_data_regNextWhen <= _zz_11_;
    end
  end


endmodule

module DataCache (
  input               io_cpu_execute_isValid,
  input      [31:0]   io_cpu_execute_address,
  input               io_cpu_execute_args_wr,
  input      [31:0]   io_cpu_execute_args_data,
  input      [1:0]    io_cpu_execute_args_size,
  input               io_cpu_memory_isValid,
  input               io_cpu_memory_isStuck,
  input               io_cpu_memory_isRemoved,
  output              io_cpu_memory_isWrite,
  input      [31:0]   io_cpu_memory_address,
  output              io_cpu_memory_mmuBus_cmd_isValid,
  output     [31:0]   io_cpu_memory_mmuBus_cmd_virtualAddress,
  output              io_cpu_memory_mmuBus_cmd_bypassTranslation,
  input      [31:0]   io_cpu_memory_mmuBus_rsp_physicalAddress,
  input               io_cpu_memory_mmuBus_rsp_isIoAccess,
  input               io_cpu_memory_mmuBus_rsp_allowRead,
  input               io_cpu_memory_mmuBus_rsp_allowWrite,
  input               io_cpu_memory_mmuBus_rsp_allowExecute,
  input               io_cpu_memory_mmuBus_rsp_exception,
  input               io_cpu_memory_mmuBus_rsp_refilling,
  output              io_cpu_memory_mmuBus_end,
  input               io_cpu_memory_mmuBus_busy,
  input               io_cpu_writeBack_isValid,
  input               io_cpu_writeBack_isStuck,
  input               io_cpu_writeBack_isUser,
  output reg          io_cpu_writeBack_haltIt,
  output              io_cpu_writeBack_isWrite,
  output reg [31:0]   io_cpu_writeBack_data,
  input      [31:0]   io_cpu_writeBack_address,
  output              io_cpu_writeBack_mmuException,
  output              io_cpu_writeBack_unalignedAccess,
  output reg          io_cpu_writeBack_accessError,
  output reg          io_cpu_redo,
  input               io_cpu_flush_valid,
  output reg          io_cpu_flush_ready,
  output reg          io_mem_cmd_valid,
  input               io_mem_cmd_ready,
  output reg          io_mem_cmd_payload_wr,
  output reg [31:0]   io_mem_cmd_payload_address,
  output     [31:0]   io_mem_cmd_payload_data,
  output     [3:0]    io_mem_cmd_payload_mask,
  output reg [2:0]    io_mem_cmd_payload_length,
  output reg          io_mem_cmd_payload_last,
  input               io_mem_rsp_valid,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset 
);
  reg        [21:0]   _zz_10_;
  reg        [31:0]   _zz_11_;
  wire                _zz_12_;
  wire                _zz_13_;
  wire                _zz_14_;
  wire                _zz_15_;
  wire                _zz_16_;
  wire       [0:0]    _zz_17_;
  wire       [0:0]    _zz_18_;
  wire       [0:0]    _zz_19_;
  wire       [2:0]    _zz_20_;
  wire       [1:0]    _zz_21_;
  wire       [21:0]   _zz_22_;
  reg                 _zz_1_;
  reg                 _zz_2_;
  wire                haltCpu;
  reg                 tagsReadCmd_valid;
  reg        [6:0]    tagsReadCmd_payload;
  reg                 tagsWriteCmd_valid;
  reg        [0:0]    tagsWriteCmd_payload_way;
  reg        [6:0]    tagsWriteCmd_payload_address;
  reg                 tagsWriteCmd_payload_data_valid;
  reg                 tagsWriteCmd_payload_data_error;
  reg        [19:0]   tagsWriteCmd_payload_data_address;
  reg                 tagsWriteLastCmd_valid;
  reg        [0:0]    tagsWriteLastCmd_payload_way;
  reg        [6:0]    tagsWriteLastCmd_payload_address;
  reg                 tagsWriteLastCmd_payload_data_valid;
  reg                 tagsWriteLastCmd_payload_data_error;
  reg        [19:0]   tagsWriteLastCmd_payload_data_address;
  reg                 dataReadCmd_valid;
  reg        [9:0]    dataReadCmd_payload;
  reg                 dataWriteCmd_valid;
  reg        [0:0]    dataWriteCmd_payload_way;
  reg        [9:0]    dataWriteCmd_payload_address;
  reg        [31:0]   dataWriteCmd_payload_data;
  reg        [3:0]    dataWriteCmd_payload_mask;
  wire                _zz_3_;
  wire                ways_0_tagsReadRsp_valid;
  wire                ways_0_tagsReadRsp_error;
  wire       [19:0]   ways_0_tagsReadRsp_address;
  wire       [21:0]   _zz_4_;
  wire                _zz_5_;
  wire       [31:0]   ways_0_dataReadRsp;
  reg        [3:0]    _zz_6_;
  wire       [3:0]    stage0_mask;
  wire       [0:0]    stage0_colisions;
  reg                 stageA_request_wr;
  reg        [31:0]   stageA_request_data;
  reg        [1:0]    stageA_request_size;
  reg        [3:0]    stageA_mask;
  wire                stageA_wayHits_0;
  reg        [0:0]    stage0_colisions_regNextWhen;
  wire       [0:0]    _zz_7_;
  wire       [0:0]    stageA_colisions;
  reg                 stageB_request_wr;
  reg        [31:0]   stageB_request_data;
  reg        [1:0]    stageB_request_size;
  reg                 stageB_mmuRspFreeze;
  reg        [31:0]   stageB_mmuRsp_physicalAddress;
  reg                 stageB_mmuRsp_isIoAccess;
  reg                 stageB_mmuRsp_allowRead;
  reg                 stageB_mmuRsp_allowWrite;
  reg                 stageB_mmuRsp_allowExecute;
  reg                 stageB_mmuRsp_exception;
  reg                 stageB_mmuRsp_refilling;
  reg                 stageB_tagsReadRsp_0_valid;
  reg                 stageB_tagsReadRsp_0_error;
  reg        [19:0]   stageB_tagsReadRsp_0_address;
  reg        [31:0]   stageB_dataReadRsp_0;
  wire       [0:0]    _zz_8_;
  reg        [0:0]    stageB_waysHits;
  wire                stageB_waysHit;
  wire       [31:0]   stageB_dataMux;
  reg        [3:0]    stageB_mask;
  reg        [0:0]    stageB_colisions;
  reg                 stageB_loaderValid;
  reg                 stageB_flusher_valid;
  reg                 stageB_flusher_start;
  wire       [31:0]   stageB_requestDataBypass;
  wire                stageB_isAmo;
  reg                 stageB_memCmdSent;
  wire       [0:0]    _zz_9_;
  reg                 loader_valid;
  reg                 loader_counter_willIncrement;
  wire                loader_counter_willClear;
  reg        [2:0]    loader_counter_valueNext;
  reg        [2:0]    loader_counter_value;
  wire                loader_counter_willOverflowIfInc;
  wire                loader_counter_willOverflow;
  reg        [0:0]    loader_waysAllocator;
  reg                 loader_error;
  (* ram_style = "block" *) reg [21:0] ways_0_tags [0:127];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol0 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol1 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol2 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol3 [0:1023];
  reg [7:0] _zz_23_;
  reg [7:0] _zz_24_;
  reg [7:0] _zz_25_;
  reg [7:0] _zz_26_;

  assign _zz_12_ = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  assign _zz_13_ = (((stageB_mmuRsp_refilling || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign _zz_14_ = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmo)));
  assign _zz_15_ = (loader_valid && io_mem_rsp_valid);
  assign _zz_16_ = (stageB_mmuRsp_physicalAddress[11 : 5] != 7'h7f);
  assign _zz_17_ = _zz_4_[0 : 0];
  assign _zz_18_ = _zz_4_[1 : 1];
  assign _zz_19_ = loader_counter_willIncrement;
  assign _zz_20_ = {2'd0, _zz_19_};
  assign _zz_21_ = {loader_waysAllocator,loader_waysAllocator[0]};
  assign _zz_22_ = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_3_) begin
      _zz_10_ <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_22_;
    end
  end

  always @ (*) begin
    _zz_11_ = {_zz_26_, _zz_25_, _zz_24_, _zz_23_};
  end
  always @ (posedge clk) begin
    if(_zz_5_) begin
      _zz_23_ <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_24_ <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_25_ <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_26_ <= ways_0_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_1_) begin
      ways_0_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_1_) begin
      ways_0_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_1_) begin
      ways_0_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_1_) begin
      ways_0_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[0]))begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]))begin
      _zz_2_ = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_3_ = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_4_ = _zz_10_;
  assign ways_0_tagsReadRsp_valid = _zz_17_[0];
  assign ways_0_tagsReadRsp_error = _zz_18_[0];
  assign ways_0_tagsReadRsp_address = _zz_4_[21 : 2];
  assign _zz_5_ = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRsp = _zz_11_;
  always @ (*) begin
    tagsReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsReadCmd_payload = 7'h0;
    if(_zz_12_)begin
      tagsReadCmd_payload = io_cpu_execute_address[11 : 5];
    end
  end

  always @ (*) begin
    dataReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataReadCmd_payload = 10'h0;
    if(_zz_12_)begin
      dataReadCmd_payload = io_cpu_execute_address[11 : 2];
    end
  end

  always @ (*) begin
    tagsWriteCmd_valid = 1'b0;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_valid = stageB_flusher_valid;
    end
    if(_zz_13_)begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_way = (1'bx);
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_way = (1'b1);
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_address = 7'h0;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_data_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_error = 1'bx;
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_error = (loader_error || io_mem_rsp_payload_error);
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_address = 20'h0;
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_address = stageB_mmuRsp_physicalAddress[31 : 12];
    end
  end

  always @ (*) begin
    dataWriteCmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((stageB_request_wr && stageB_waysHit))begin
            dataWriteCmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      dataWriteCmd_valid = 1'b0;
    end
    if(_zz_15_)begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_way = (1'bx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_way = stageB_waysHits;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_address = 10'h0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 2];
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[11 : 5],loader_counter_value};
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_data = 32'h0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_data = stageB_requestDataBypass;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_mask = (4'bxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_mask = stageB_mask;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_mask = (4'b1111);
    end
  end

  always @ (*) begin
    case(io_cpu_execute_args_size)
      2'b00 : begin
        _zz_6_ = (4'b0001);
      end
      2'b01 : begin
        _zz_6_ = (4'b0011);
      end
      default : begin
        _zz_6_ = (4'b1111);
      end
    endcase
  end

  assign stage0_mask = (_zz_6_ <<< io_cpu_execute_address[1 : 0]);
  assign stage0_colisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_execute_address[11 : 2])) && ((stage0_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign io_cpu_memory_mmuBus_cmd_isValid = io_cpu_memory_isValid;
  assign io_cpu_memory_mmuBus_cmd_virtualAddress = io_cpu_memory_address;
  assign io_cpu_memory_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_memory_mmuBus_end = ((! io_cpu_memory_isStuck) || io_cpu_memory_isRemoved);
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_wayHits_0 = ((io_cpu_memory_mmuBus_rsp_physicalAddress[31 : 12] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid);
  assign _zz_7_[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_memory_address[11 : 2])) && ((stageA_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign stageA_colisions = (stage0_colisions_regNextWhen | _zz_7_);
  always @ (*) begin
    stageB_mmuRspFreeze = 1'b0;
    if((stageB_loaderValid || loader_valid))begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign _zz_8_[0] = stageA_wayHits_0;
  assign stageB_waysHit = (stageB_waysHits != (1'b0));
  assign stageB_dataMux = stageB_dataReadRsp_0;
  always @ (*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          if(io_mem_cmd_ready)begin
            stageB_loaderValid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      stageB_loaderValid = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_haltIt = io_cpu_writeBack_isValid;
    if(stageB_flusher_valid)begin
      io_cpu_writeBack_haltIt = 1'b1;
    end
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        if((stageB_request_wr ? io_mem_cmd_ready : io_mem_rsp_valid))begin
          io_cpu_writeBack_haltIt = 1'b0;
        end
      end else begin
        if(_zz_14_)begin
          if(((! stageB_request_wr) || io_mem_cmd_ready))begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_cpu_writeBack_haltIt = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_flush_ready = 1'b0;
    if(stageB_flusher_start)begin
      io_cpu_flush_ready = 1'b1;
    end
  end

  assign stageB_requestDataBypass = stageB_request_data;
  assign stageB_isAmo = 1'b0;
  always @ (*) begin
    io_cpu_redo = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((((! stageB_request_wr) || stageB_isAmo) && ((stageB_colisions & stageB_waysHits) != (1'b0))))begin
            io_cpu_redo = 1'b1;
          end
        end
      end
    end
    if((io_cpu_writeBack_isValid && stageB_mmuRsp_refilling))begin
      io_cpu_redo = 1'b1;
    end
    if(loader_valid)begin
      io_cpu_redo = 1'b1;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_accessError = 1'b0;
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_accessError = (io_mem_rsp_valid && io_mem_rsp_payload_error);
    end else begin
      io_cpu_writeBack_accessError = ((stageB_waysHits & _zz_9_) != (1'b0));
    end
  end

  assign io_cpu_writeBack_mmuException = (io_cpu_writeBack_isValid && ((stageB_mmuRsp_exception || ((! stageB_mmuRsp_allowWrite) && stageB_request_wr)) || ((! stageB_mmuRsp_allowRead) && ((! stageB_request_wr) || stageB_isAmo))));
  assign io_cpu_writeBack_unalignedAccess = (io_cpu_writeBack_isValid && (((stageB_request_size == (2'b10)) && (stageB_mmuRsp_physicalAddress[1 : 0] != (2'b00))) || ((stageB_request_size == (2'b01)) && (stageB_mmuRsp_physicalAddress[0 : 0] != (1'b0)))));
  assign io_cpu_writeBack_isWrite = stageB_request_wr;
  always @ (*) begin
    io_mem_cmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_valid = (! stageB_memCmdSent);
      end else begin
        if(_zz_14_)begin
          if(stageB_request_wr)begin
            io_mem_cmd_valid = 1'b1;
          end
        end else begin
          if((! stageB_memCmdSent))begin
            io_mem_cmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_address = 32'h0;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
        end else begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 5],5'h0};
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_length = (3'bxxx);
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_length = (3'b000);
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_length = (3'b000);
        end else begin
          io_mem_cmd_payload_length = (3'b111);
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_last = 1'bx;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_last = 1'b1;
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_last = 1'b1;
        end else begin
          io_mem_cmd_payload_last = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_wr = stageB_request_wr;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          io_mem_cmd_payload_wr = 1'b0;
        end
      end
    end
  end

  assign io_mem_cmd_payload_mask = stageB_mask;
  assign io_mem_cmd_payload_data = stageB_requestDataBypass;
  always @ (*) begin
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_data = io_mem_rsp_payload_data;
    end else begin
      io_cpu_writeBack_data = stageB_dataMux;
    end
  end

  assign _zz_9_[0] = stageB_tagsReadRsp_0_error;
  always @ (*) begin
    loader_counter_willIncrement = 1'b0;
    if(_zz_15_)begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == (3'b111));
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @ (*) begin
    loader_counter_valueNext = (loader_counter_value + _zz_20_);
    if(loader_counter_willClear)begin
      loader_counter_valueNext = (3'b000);
    end
  end

  always @ (posedge clk) begin
    tagsWriteLastCmd_valid <= tagsWriteCmd_valid;
    tagsWriteLastCmd_payload_way <= tagsWriteCmd_payload_way;
    tagsWriteLastCmd_payload_address <= tagsWriteCmd_payload_address;
    tagsWriteLastCmd_payload_data_valid <= tagsWriteCmd_payload_data_valid;
    tagsWriteLastCmd_payload_data_error <= tagsWriteCmd_payload_data_error;
    tagsWriteLastCmd_payload_data_address <= tagsWriteCmd_payload_data_address;
    if((! io_cpu_memory_isStuck))begin
      stageA_request_wr <= io_cpu_execute_args_wr;
      stageA_request_data <= io_cpu_execute_args_data;
      stageA_request_size <= io_cpu_execute_args_size;
    end
    if((! io_cpu_memory_isStuck))begin
      stageA_mask <= stage0_mask;
    end
    if((! io_cpu_memory_isStuck))begin
      stage0_colisions_regNextWhen <= stage0_colisions;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_request_wr <= stageA_request_wr;
      stageB_request_data <= stageA_request_data;
      stageB_request_size <= stageA_request_size;
    end
    if(((! io_cpu_writeBack_isStuck) && (! stageB_mmuRspFreeze)))begin
      stageB_mmuRsp_physicalAddress <= io_cpu_memory_mmuBus_rsp_physicalAddress;
      stageB_mmuRsp_isIoAccess <= io_cpu_memory_mmuBus_rsp_isIoAccess;
      stageB_mmuRsp_allowRead <= io_cpu_memory_mmuBus_rsp_allowRead;
      stageB_mmuRsp_allowWrite <= io_cpu_memory_mmuBus_rsp_allowWrite;
      stageB_mmuRsp_allowExecute <= io_cpu_memory_mmuBus_rsp_allowExecute;
      stageB_mmuRsp_exception <= io_cpu_memory_mmuBus_rsp_exception;
      stageB_mmuRsp_refilling <= io_cpu_memory_mmuBus_rsp_refilling;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_tagsReadRsp_0_valid <= ways_0_tagsReadRsp_valid;
      stageB_tagsReadRsp_0_error <= ways_0_tagsReadRsp_error;
      stageB_tagsReadRsp_0_address <= ways_0_tagsReadRsp_address;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_waysHits <= _zz_8_;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_mask <= stageA_mask;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_colisions <= stageA_colisions;
    end
    if(stageB_flusher_valid)begin
      if(_zz_16_)begin
        stageB_mmuRsp_physicalAddress[11 : 5] <= (stageB_mmuRsp_physicalAddress[11 : 5] + 7'h01);
      end
    end
    if(stageB_flusher_start)begin
      stageB_mmuRsp_physicalAddress[11 : 5] <= 7'h0;
    end
    `ifndef SYNTHESIS
      `ifdef FORMAL
        assert((! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck)))
      `else
        if(!(! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))) begin
          $display("FAILURE writeBack stuck by another plugin is not allowed");
          $finish;
        end
      `endif
    `endif
  end

  always @ (posedge clk) begin
    if(reset) begin
      stageB_flusher_valid <= 1'b0;
      stageB_flusher_start <= 1'b1;
      stageB_memCmdSent <= 1'b0;
      loader_valid <= 1'b0;
      loader_counter_value <= (3'b000);
      loader_waysAllocator <= (1'b1);
      loader_error <= 1'b0;
    end else begin
      if(stageB_flusher_valid)begin
        if(! _zz_16_) begin
          stageB_flusher_valid <= 1'b0;
        end
      end
      stageB_flusher_start <= ((((((! stageB_flusher_start) && io_cpu_flush_valid) && (! io_cpu_execute_isValid)) && (! io_cpu_memory_isValid)) && (! io_cpu_writeBack_isValid)) && (! io_cpu_redo));
      if(stageB_flusher_start)begin
        stageB_flusher_valid <= 1'b1;
      end
      if(io_mem_cmd_ready)begin
        stageB_memCmdSent <= 1'b1;
      end
      if((! io_cpu_writeBack_isStuck))begin
        stageB_memCmdSent <= 1'b0;
      end
      if(stageB_loaderValid)begin
        loader_valid <= 1'b1;
      end
      loader_counter_value <= loader_counter_valueNext;
      if(_zz_15_)begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_counter_willOverflow)begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
      end
      if((! loader_valid))begin
        loader_waysAllocator <= _zz_21_[0:0];
      end
    end
  end


endmodule

module VexRiscv (
  input      [31:0]   externalResetVector,
  input               timerInterrupt,
  input               softwareInterrupt,
  input      [31:0]   externalInterruptArray,
  input               debug_bus_cmd_valid,
  output reg          debug_bus_cmd_ready,
  input               debug_bus_cmd_payload_wr,
  input      [7:0]    debug_bus_cmd_payload_address,
  input      [31:0]   debug_bus_cmd_payload_data,
  output reg [31:0]   debug_bus_rsp_data,
  output              debug_resetOut,
  output reg          iBusWishbone_CYC,
  output reg          iBusWishbone_STB,
  input               iBusWishbone_ACK,
  output              iBusWishbone_WE,
  output     [29:0]   iBusWishbone_ADR,
  input      [31:0]   iBusWishbone_DAT_MISO,
  output     [31:0]   iBusWishbone_DAT_MOSI,
  output     [3:0]    iBusWishbone_SEL,
  input               iBusWishbone_ERR,
  output     [1:0]    iBusWishbone_BTE,
  output     [2:0]    iBusWishbone_CTI,
  output              dBusWishbone_CYC,
  output              dBusWishbone_STB,
  input               dBusWishbone_ACK,
  output              dBusWishbone_WE,
  output     [29:0]   dBusWishbone_ADR,
  input      [31:0]   dBusWishbone_DAT_MISO,
  output     [31:0]   dBusWishbone_DAT_MOSI,
  output     [3:0]    dBusWishbone_SEL,
  input               dBusWishbone_ERR,
  output     [1:0]    dBusWishbone_BTE,
  output     [2:0]    dBusWishbone_CTI,
  input               clk,
  input               reset,
  input               debugReset 
);
  wire                _zz_564_;
  wire                _zz_565_;
  wire                _zz_566_;
  wire                _zz_567_;
  wire                _zz_568_;
  wire                _zz_569_;
  wire                _zz_570_;
  reg                 _zz_571_;
  wire                _zz_572_;
  wire       [31:0]   _zz_573_;
  wire                _zz_574_;
  wire       [31:0]   _zz_575_;
  reg                 _zz_576_;
  wire                _zz_577_;
  wire                _zz_578_;
  wire       [31:0]   _zz_579_;
  wire                _zz_580_;
  wire                _zz_581_;
  reg        [31:0]   _zz_582_;
  reg        [31:0]   _zz_583_;
  reg        [31:0]   _zz_584_;
  reg                 _zz_585_;
  reg                 _zz_586_;
  reg                 _zz_587_;
  reg                 _zz_588_;
  reg                 _zz_589_;
  reg                 _zz_590_;
  wire                IBusCachedPlugin_cache_io_cpu_prefetch_haltIt;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_data;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_haltIt;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  wire                IBusCachedPlugin_cache_io_cpu_decode_error;
  wire                IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling;
  wire                IBusCachedPlugin_cache_io_cpu_decode_mmuException;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_decode_data;
  wire                IBusCachedPlugin_cache_io_cpu_decode_cacheMiss;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_decode_physicalAddress;
  wire                IBusCachedPlugin_cache_io_mem_cmd_valid;
  wire       [31:0]   IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  wire       [2:0]    IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  wire                dataCache_1__io_cpu_memory_isWrite;
  wire                dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  wire       [31:0]   dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  wire                dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
  wire                dataCache_1__io_cpu_memory_mmuBus_end;
  wire                dataCache_1__io_cpu_writeBack_haltIt;
  wire       [31:0]   dataCache_1__io_cpu_writeBack_data;
  wire                dataCache_1__io_cpu_writeBack_mmuException;
  wire                dataCache_1__io_cpu_writeBack_unalignedAccess;
  wire                dataCache_1__io_cpu_writeBack_accessError;
  wire                dataCache_1__io_cpu_writeBack_isWrite;
  wire                dataCache_1__io_cpu_flush_ready;
  wire                dataCache_1__io_cpu_redo;
  wire                dataCache_1__io_mem_cmd_valid;
  wire                dataCache_1__io_mem_cmd_payload_wr;
  wire       [31:0]   dataCache_1__io_mem_cmd_payload_address;
  wire       [31:0]   dataCache_1__io_mem_cmd_payload_data;
  wire       [3:0]    dataCache_1__io_mem_cmd_payload_mask;
  wire       [2:0]    dataCache_1__io_mem_cmd_payload_length;
  wire                dataCache_1__io_mem_cmd_payload_last;
  wire                _zz_591_;
  wire                _zz_592_;
  wire                _zz_593_;
  wire                _zz_594_;
  wire                _zz_595_;
  wire                _zz_596_;
  wire                _zz_597_;
  wire                _zz_598_;
  wire                _zz_599_;
  wire                _zz_600_;
  wire                _zz_601_;
  wire                _zz_602_;
  wire                _zz_603_;
  wire                _zz_604_;
  wire                _zz_605_;
  wire                _zz_606_;
  wire                _zz_607_;
  wire       [1:0]    _zz_608_;
  wire                _zz_609_;
  wire                _zz_610_;
  wire                _zz_611_;
  wire                _zz_612_;
  wire                _zz_613_;
  wire                _zz_614_;
  wire                _zz_615_;
  wire                _zz_616_;
  wire                _zz_617_;
  wire                _zz_618_;
  wire                _zz_619_;
  wire                _zz_620_;
  wire       [1:0]    _zz_621_;
  wire                _zz_622_;
  wire                _zz_623_;
  wire       [5:0]    _zz_624_;
  wire                _zz_625_;
  wire                _zz_626_;
  wire                _zz_627_;
  wire                _zz_628_;
  wire                _zz_629_;
  wire                _zz_630_;
  wire                _zz_631_;
  wire                _zz_632_;
  wire                _zz_633_;
  wire                _zz_634_;
  wire                _zz_635_;
  wire                _zz_636_;
  wire                _zz_637_;
  wire                _zz_638_;
  wire                _zz_639_;
  wire                _zz_640_;
  wire                _zz_641_;
  wire                _zz_642_;
  wire                _zz_643_;
  wire                _zz_644_;
  wire                _zz_645_;
  wire                _zz_646_;
  wire       [1:0]    _zz_647_;
  wire                _zz_648_;
  wire       [1:0]    _zz_649_;
  wire       [0:0]    _zz_650_;
  wire       [0:0]    _zz_651_;
  wire       [51:0]   _zz_652_;
  wire       [51:0]   _zz_653_;
  wire       [51:0]   _zz_654_;
  wire       [32:0]   _zz_655_;
  wire       [51:0]   _zz_656_;
  wire       [49:0]   _zz_657_;
  wire       [51:0]   _zz_658_;
  wire       [49:0]   _zz_659_;
  wire       [51:0]   _zz_660_;
  wire       [0:0]    _zz_661_;
  wire       [0:0]    _zz_662_;
  wire       [0:0]    _zz_663_;
  wire       [0:0]    _zz_664_;
  wire       [0:0]    _zz_665_;
  wire       [0:0]    _zz_666_;
  wire       [32:0]   _zz_667_;
  wire       [31:0]   _zz_668_;
  wire       [32:0]   _zz_669_;
  wire       [0:0]    _zz_670_;
  wire       [0:0]    _zz_671_;
  wire       [0:0]    _zz_672_;
  wire       [0:0]    _zz_673_;
  wire       [0:0]    _zz_674_;
  wire       [0:0]    _zz_675_;
  wire       [0:0]    _zz_676_;
  wire       [0:0]    _zz_677_;
  wire       [0:0]    _zz_678_;
  wire       [0:0]    _zz_679_;
  wire       [3:0]    _zz_680_;
  wire       [2:0]    _zz_681_;
  wire       [31:0]   _zz_682_;
  wire       [11:0]   _zz_683_;
  wire       [31:0]   _zz_684_;
  wire       [19:0]   _zz_685_;
  wire       [11:0]   _zz_686_;
  wire       [31:0]   _zz_687_;
  wire       [31:0]   _zz_688_;
  wire       [19:0]   _zz_689_;
  wire       [11:0]   _zz_690_;
  wire       [2:0]    _zz_691_;
  wire       [2:0]    _zz_692_;
  wire       [31:0]   _zz_693_;
  wire       [31:0]   _zz_694_;
  wire       [31:0]   _zz_695_;
  wire       [31:0]   _zz_696_;
  wire       [31:0]   _zz_697_;
  wire       [31:0]   _zz_698_;
  wire       [31:0]   _zz_699_;
  wire       [31:0]   _zz_700_;
  wire       [31:0]   _zz_701_;
  wire       [31:0]   _zz_702_;
  wire       [31:0]   _zz_703_;
  wire       [31:0]   _zz_704_;
  wire       [31:0]   _zz_705_;
  wire       [31:0]   _zz_706_;
  wire       [31:0]   _zz_707_;
  wire       [31:0]   _zz_708_;
  wire       [31:0]   _zz_709_;
  wire       [31:0]   _zz_710_;
  wire       [31:0]   _zz_711_;
  wire       [31:0]   _zz_712_;
  wire       [31:0]   _zz_713_;
  wire       [31:0]   _zz_714_;
  wire       [31:0]   _zz_715_;
  wire       [31:0]   _zz_716_;
  wire       [31:0]   _zz_717_;
  wire       [31:0]   _zz_718_;
  wire       [31:0]   _zz_719_;
  wire       [31:0]   _zz_720_;
  wire       [31:0]   _zz_721_;
  wire       [31:0]   _zz_722_;
  wire       [31:0]   _zz_723_;
  wire       [31:0]   _zz_724_;
  wire       [31:0]   _zz_725_;
  wire       [31:0]   _zz_726_;
  wire       [31:0]   _zz_727_;
  wire       [31:0]   _zz_728_;
  wire       [31:0]   _zz_729_;
  wire       [31:0]   _zz_730_;
  wire       [31:0]   _zz_731_;
  wire       [31:0]   _zz_732_;
  wire       [31:0]   _zz_733_;
  wire       [31:0]   _zz_734_;
  wire       [31:0]   _zz_735_;
  wire       [31:0]   _zz_736_;
  wire       [31:0]   _zz_737_;
  wire       [31:0]   _zz_738_;
  wire       [31:0]   _zz_739_;
  wire       [31:0]   _zz_740_;
  wire       [15:0]   _zz_741_;
  wire       [15:0]   _zz_742_;
  wire       [15:0]   _zz_743_;
  wire       [15:0]   _zz_744_;
  wire       [15:0]   _zz_745_;
  wire       [15:0]   _zz_746_;
  wire       [0:0]    _zz_747_;
  wire       [2:0]    _zz_748_;
  wire       [4:0]    _zz_749_;
  wire       [11:0]   _zz_750_;
  wire       [11:0]   _zz_751_;
  wire       [31:0]   _zz_752_;
  wire       [31:0]   _zz_753_;
  wire       [31:0]   _zz_754_;
  wire       [31:0]   _zz_755_;
  wire       [31:0]   _zz_756_;
  wire       [31:0]   _zz_757_;
  wire       [31:0]   _zz_758_;
  wire       [11:0]   _zz_759_;
  wire       [19:0]   _zz_760_;
  wire       [11:0]   _zz_761_;
  wire       [31:0]   _zz_762_;
  wire       [31:0]   _zz_763_;
  wire       [31:0]   _zz_764_;
  wire       [11:0]   _zz_765_;
  wire       [19:0]   _zz_766_;
  wire       [11:0]   _zz_767_;
  wire       [2:0]    _zz_768_;
  wire       [1:0]    _zz_769_;
  wire       [1:0]    _zz_770_;
  wire       [65:0]   _zz_771_;
  wire       [65:0]   _zz_772_;
  wire       [31:0]   _zz_773_;
  wire       [31:0]   _zz_774_;
  wire       [0:0]    _zz_775_;
  wire       [5:0]    _zz_776_;
  wire       [32:0]   _zz_777_;
  wire       [31:0]   _zz_778_;
  wire       [31:0]   _zz_779_;
  wire       [32:0]   _zz_780_;
  wire       [32:0]   _zz_781_;
  wire       [32:0]   _zz_782_;
  wire       [32:0]   _zz_783_;
  wire       [0:0]    _zz_784_;
  wire       [32:0]   _zz_785_;
  wire       [0:0]    _zz_786_;
  wire       [32:0]   _zz_787_;
  wire       [0:0]    _zz_788_;
  wire       [31:0]   _zz_789_;
  wire       [0:0]    _zz_790_;
  wire       [0:0]    _zz_791_;
  wire       [0:0]    _zz_792_;
  wire       [0:0]    _zz_793_;
  wire       [0:0]    _zz_794_;
  wire       [0:0]    _zz_795_;
  wire       [0:0]    _zz_796_;
  wire       [0:0]    _zz_797_;
  wire       [0:0]    _zz_798_;
  wire       [0:0]    _zz_799_;
  wire       [0:0]    _zz_800_;
  wire       [0:0]    _zz_801_;
  wire       [0:0]    _zz_802_;
  wire       [0:0]    _zz_803_;
  wire       [0:0]    _zz_804_;
  wire       [0:0]    _zz_805_;
  wire       [0:0]    _zz_806_;
  wire       [0:0]    _zz_807_;
  wire       [0:0]    _zz_808_;
  wire       [0:0]    _zz_809_;
  wire       [0:0]    _zz_810_;
  wire       [0:0]    _zz_811_;
  wire       [0:0]    _zz_812_;
  wire       [0:0]    _zz_813_;
  wire       [0:0]    _zz_814_;
  wire       [0:0]    _zz_815_;
  wire       [0:0]    _zz_816_;
  wire       [0:0]    _zz_817_;
  wire       [0:0]    _zz_818_;
  wire       [0:0]    _zz_819_;
  wire       [0:0]    _zz_820_;
  wire       [0:0]    _zz_821_;
  wire       [0:0]    _zz_822_;
  wire       [0:0]    _zz_823_;
  wire       [0:0]    _zz_824_;
  wire       [0:0]    _zz_825_;
  wire       [0:0]    _zz_826_;
  wire       [0:0]    _zz_827_;
  wire       [0:0]    _zz_828_;
  wire       [0:0]    _zz_829_;
  wire       [0:0]    _zz_830_;
  wire       [0:0]    _zz_831_;
  wire       [0:0]    _zz_832_;
  wire       [0:0]    _zz_833_;
  wire       [0:0]    _zz_834_;
  wire       [0:0]    _zz_835_;
  wire       [0:0]    _zz_836_;
  wire       [0:0]    _zz_837_;
  wire       [0:0]    _zz_838_;
  wire       [0:0]    _zz_839_;
  wire       [0:0]    _zz_840_;
  wire       [0:0]    _zz_841_;
  wire       [0:0]    _zz_842_;
  wire       [0:0]    _zz_843_;
  wire       [0:0]    _zz_844_;
  wire       [0:0]    _zz_845_;
  wire       [0:0]    _zz_846_;
  wire       [0:0]    _zz_847_;
  wire       [0:0]    _zz_848_;
  wire       [0:0]    _zz_849_;
  wire       [0:0]    _zz_850_;
  wire       [0:0]    _zz_851_;
  wire       [0:0]    _zz_852_;
  wire       [0:0]    _zz_853_;
  wire       [0:0]    _zz_854_;
  wire       [0:0]    _zz_855_;
  wire       [0:0]    _zz_856_;
  wire       [0:0]    _zz_857_;
  wire       [0:0]    _zz_858_;
  wire       [0:0]    _zz_859_;
  wire       [0:0]    _zz_860_;
  wire       [26:0]   _zz_861_;
  wire                _zz_862_;
  wire                _zz_863_;
  wire       [1:0]    _zz_864_;
  wire       [3:0]    _zz_865_;
  wire       [3:0]    _zz_866_;
  wire       [3:0]    _zz_867_;
  wire       [3:0]    _zz_868_;
  wire       [3:0]    _zz_869_;
  wire       [3:0]    _zz_870_;
  wire       [31:0]   _zz_871_;
  wire       [31:0]   _zz_872_;
  wire       [31:0]   _zz_873_;
  wire                _zz_874_;
  wire       [0:0]    _zz_875_;
  wire       [13:0]   _zz_876_;
  wire       [31:0]   _zz_877_;
  wire       [31:0]   _zz_878_;
  wire       [31:0]   _zz_879_;
  wire                _zz_880_;
  wire       [0:0]    _zz_881_;
  wire       [7:0]    _zz_882_;
  wire       [31:0]   _zz_883_;
  wire       [31:0]   _zz_884_;
  wire       [31:0]   _zz_885_;
  wire                _zz_886_;
  wire       [0:0]    _zz_887_;
  wire       [1:0]    _zz_888_;
  wire                _zz_889_;
  wire                _zz_890_;
  wire                _zz_891_;
  wire       [0:0]    _zz_892_;
  wire       [4:0]    _zz_893_;
  wire       [0:0]    _zz_894_;
  wire       [4:0]    _zz_895_;
  wire       [0:0]    _zz_896_;
  wire       [4:0]    _zz_897_;
  wire       [0:0]    _zz_898_;
  wire       [4:0]    _zz_899_;
  wire       [0:0]    _zz_900_;
  wire       [4:0]    _zz_901_;
  wire       [0:0]    _zz_902_;
  wire       [4:0]    _zz_903_;
  wire       [31:0]   _zz_904_;
  wire       [31:0]   _zz_905_;
  wire                _zz_906_;
  wire       [0:0]    _zz_907_;
  wire       [1:0]    _zz_908_;
  wire                _zz_909_;
  wire                _zz_910_;
  wire                _zz_911_;
  wire       [1:0]    _zz_912_;
  wire       [1:0]    _zz_913_;
  wire                _zz_914_;
  wire       [0:0]    _zz_915_;
  wire       [26:0]   _zz_916_;
  wire       [31:0]   _zz_917_;
  wire       [31:0]   _zz_918_;
  wire       [31:0]   _zz_919_;
  wire                _zz_920_;
  wire                _zz_921_;
  wire       [31:0]   _zz_922_;
  wire       [31:0]   _zz_923_;
  wire       [31:0]   _zz_924_;
  wire                _zz_925_;
  wire                _zz_926_;
  wire       [0:0]    _zz_927_;
  wire       [0:0]    _zz_928_;
  wire       [0:0]    _zz_929_;
  wire       [0:0]    _zz_930_;
  wire                _zz_931_;
  wire       [0:0]    _zz_932_;
  wire       [24:0]   _zz_933_;
  wire       [31:0]   _zz_934_;
  wire       [31:0]   _zz_935_;
  wire       [31:0]   _zz_936_;
  wire       [31:0]   _zz_937_;
  wire       [31:0]   _zz_938_;
  wire       [31:0]   _zz_939_;
  wire       [31:0]   _zz_940_;
  wire       [31:0]   _zz_941_;
  wire       [31:0]   _zz_942_;
  wire       [31:0]   _zz_943_;
  wire       [0:0]    _zz_944_;
  wire       [0:0]    _zz_945_;
  wire       [1:0]    _zz_946_;
  wire       [1:0]    _zz_947_;
  wire                _zz_948_;
  wire       [0:0]    _zz_949_;
  wire       [22:0]   _zz_950_;
  wire       [31:0]   _zz_951_;
  wire       [31:0]   _zz_952_;
  wire       [31:0]   _zz_953_;
  wire       [31:0]   _zz_954_;
  wire       [31:0]   _zz_955_;
  wire                _zz_956_;
  wire       [0:0]    _zz_957_;
  wire       [0:0]    _zz_958_;
  wire                _zz_959_;
  wire       [0:0]    _zz_960_;
  wire       [19:0]   _zz_961_;
  wire       [31:0]   _zz_962_;
  wire       [31:0]   _zz_963_;
  wire                _zz_964_;
  wire       [0:0]    _zz_965_;
  wire       [0:0]    _zz_966_;
  wire       [31:0]   _zz_967_;
  wire       [31:0]   _zz_968_;
  wire       [0:0]    _zz_969_;
  wire       [4:0]    _zz_970_;
  wire       [0:0]    _zz_971_;
  wire       [0:0]    _zz_972_;
  wire                _zz_973_;
  wire       [0:0]    _zz_974_;
  wire       [15:0]   _zz_975_;
  wire       [31:0]   _zz_976_;
  wire       [31:0]   _zz_977_;
  wire       [31:0]   _zz_978_;
  wire       [31:0]   _zz_979_;
  wire       [31:0]   _zz_980_;
  wire                _zz_981_;
  wire       [0:0]    _zz_982_;
  wire       [2:0]    _zz_983_;
  wire       [31:0]   _zz_984_;
  wire       [31:0]   _zz_985_;
  wire       [0:0]    _zz_986_;
  wire       [0:0]    _zz_987_;
  wire       [0:0]    _zz_988_;
  wire       [0:0]    _zz_989_;
  wire                _zz_990_;
  wire       [0:0]    _zz_991_;
  wire       [13:0]   _zz_992_;
  wire       [31:0]   _zz_993_;
  wire       [31:0]   _zz_994_;
  wire       [31:0]   _zz_995_;
  wire                _zz_996_;
  wire       [0:0]    _zz_997_;
  wire       [0:0]    _zz_998_;
  wire       [31:0]   _zz_999_;
  wire       [31:0]   _zz_1000_;
  wire       [31:0]   _zz_1001_;
  wire       [31:0]   _zz_1002_;
  wire       [1:0]    _zz_1003_;
  wire       [1:0]    _zz_1004_;
  wire                _zz_1005_;
  wire       [0:0]    _zz_1006_;
  wire       [11:0]   _zz_1007_;
  wire       [31:0]   _zz_1008_;
  wire       [31:0]   _zz_1009_;
  wire       [31:0]   _zz_1010_;
  wire       [31:0]   _zz_1011_;
  wire       [31:0]   _zz_1012_;
  wire       [31:0]   _zz_1013_;
  wire                _zz_1014_;
  wire       [0:0]    _zz_1015_;
  wire       [0:0]    _zz_1016_;
  wire                _zz_1017_;
  wire       [0:0]    _zz_1018_;
  wire       [0:0]    _zz_1019_;
  wire                _zz_1020_;
  wire       [0:0]    _zz_1021_;
  wire       [8:0]    _zz_1022_;
  wire       [31:0]   _zz_1023_;
  wire       [31:0]   _zz_1024_;
  wire       [31:0]   _zz_1025_;
  wire                _zz_1026_;
  wire       [0:0]    _zz_1027_;
  wire       [0:0]    _zz_1028_;
  wire                _zz_1029_;
  wire       [0:0]    _zz_1030_;
  wire       [0:0]    _zz_1031_;
  wire                _zz_1032_;
  wire       [0:0]    _zz_1033_;
  wire       [5:0]    _zz_1034_;
  wire       [31:0]   _zz_1035_;
  wire       [31:0]   _zz_1036_;
  wire       [31:0]   _zz_1037_;
  wire       [31:0]   _zz_1038_;
  wire       [31:0]   _zz_1039_;
  wire                _zz_1040_;
  wire       [4:0]    _zz_1041_;
  wire       [4:0]    _zz_1042_;
  wire                _zz_1043_;
  wire       [0:0]    _zz_1044_;
  wire       [2:0]    _zz_1045_;
  wire                _zz_1046_;
  wire       [0:0]    _zz_1047_;
  wire       [1:0]    _zz_1048_;
  wire                _zz_1049_;
  wire       [0:0]    _zz_1050_;
  wire       [0:0]    _zz_1051_;
  wire       [4:0]    _zz_1052_;
  wire       [4:0]    _zz_1053_;
  wire                _zz_1054_;
  wire                _zz_1055_;
  wire       [31:0]   _zz_1056_;
  wire       [31:0]   _zz_1057_;
  wire       [31:0]   _zz_1058_;
  wire       [31:0]   _zz_1059_;
  wire       [31:0]   _zz_1060_;
  wire       [31:0]   _zz_1061_;
  wire       [31:0]   _zz_1062_;
  wire       [31:0]   _zz_1063_;
  wire       [0:0]    _zz_1064_;
  wire       [1:0]    _zz_1065_;
  wire                _zz_1066_;
  wire       [31:0]   _zz_1067_;
  wire       [31:0]   _zz_1068_;
  wire                _zz_1069_;
  wire                _zz_1070_;
  wire                _zz_1071_;
  wire       [31:0]   _zz_1072_;
  wire       [31:0]   _zz_1073_;
  wire       [31:0]   _zz_1074_;
  wire       [31:0]   _zz_1075_;
  wire       [31:0]   _zz_1076_;
  wire       [31:0]   _zz_1077_;
  wire       [31:0]   _zz_1078_;
  wire       [31:0]   _zz_1079_;
  wire       [31:0]   _zz_1080_;
  wire       [31:0]   _zz_1081_;
  wire       [31:0]   _zz_1082_;
  wire       [31:0]   _zz_1083_;
  wire       [31:0]   _zz_1084_;
  wire       [31:0]   _zz_1085_;
  wire       [31:0]   _zz_1086_;
  wire       [31:0]   _zz_1087_;
  wire       [31:0]   _zz_1088_;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_1_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_2_;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_3_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_4_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_5_;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_6_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_7_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_8_;
  wire                decode_IS_RS1_SIGNED;
  wire       [51:0]   memory_MUL_LOW;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_9_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_10_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_11_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_12_;
  wire       `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_13_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_14_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_15_;
  wire                decode_SRC_LESS_UNSIGNED;
  wire                memory_MEMORY_WR;
  wire                decode_MEMORY_WR;
  wire                decode_IS_CSR;
  wire       [33:0]   execute_MUL_HL;
  wire       [31:0]   execute_MUL_LL;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_16_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_17_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_18_;
  wire                decode_MEMORY_MANAGMENT;
  wire                execute_BRANCH_DO;
  wire                decode_IS_RS2_SIGNED;
  wire                decode_IS_DIV;
  wire                decode_SRC2_FORCE_ZERO;
  wire       [31:0]   memory_PC;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_19_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_20_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_21_;
  wire                decode_CSR_WRITE_OPCODE;
  wire                decode_DO_EBREAK;
  wire       [31:0]   writeBack_FORMAL_PC_NEXT;
  wire       [31:0]   memory_FORMAL_PC_NEXT;
  wire       [31:0]   execute_FORMAL_PC_NEXT;
  wire       [31:0]   decode_FORMAL_PC_NEXT;
  wire       [31:0]   execute_SHIFT_RIGHT;
  wire       [1:0]    memory_MEMORY_ADDRESS_LOW;
  wire       [1:0]    execute_MEMORY_ADDRESS_LOW;
  wire       [31:0]   execute_REGFILE_WRITE_DATA;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire       [31:0]   execute_BRANCH_CALC;
  wire       [33:0]   execute_MUL_LH;
  wire       [33:0]   memory_MUL_HH;
  wire       [33:0]   execute_MUL_HH;
  wire                decode_PREDICTION_HAD_BRANCHED2;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_22_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_23_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_24_;
  wire                decode_CSR_READ_OPCODE;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_25_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_26_;
  wire                memory_IS_MUL;
  wire                execute_IS_MUL;
  wire                decode_IS_MUL;
  wire                execute_DO_EBREAK;
  wire                decode_IS_EBREAK;
  wire                execute_IS_RS1_SIGNED;
  wire                execute_IS_DIV;
  wire                execute_IS_RS2_SIGNED;
  wire                memory_IS_DIV;
  wire                writeBack_IS_MUL;
  wire       [33:0]   writeBack_MUL_HH;
  wire       [51:0]   writeBack_MUL_LOW;
  wire       [33:0]   memory_MUL_HL;
  wire       [33:0]   memory_MUL_LH;
  wire       [31:0]   memory_MUL_LL;
  wire                execute_CSR_READ_OPCODE;
  wire                execute_CSR_WRITE_OPCODE;
  wire                execute_IS_CSR;
  wire       `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_27_;
  wire       `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_28_;
  wire       `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_29_;
  wire       [31:0]   memory_BRANCH_CALC;
  wire                memory_BRANCH_DO;
  wire       [31:0]   execute_PC;
  wire                execute_PREDICTION_HAD_BRANCHED2;
  (* syn_keep , keep *) wire       [31:0]   execute_RS1 /* synthesis syn_keep = 1 */ ;
  wire                execute_BRANCH_COND_RESULT;
  wire       `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_30_;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  reg        [31:0]   _zz_31_;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire                memory_REGFILE_WRITE_VALID;
  wire       [31:0]   memory_INSTRUCTION;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   memory_SHIFT_RIGHT;
  reg        [31:0]   _zz_32_;
  wire       `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_33_;
  wire       `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_34_;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       [31:0]   _zz_35_;
  wire       `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_36_;
  wire       `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_37_;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_38_;
  wire       [31:0]   execute_SRC2;
  wire       [31:0]   execute_SRC1;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_39_;
  wire       [31:0]   _zz_40_;
  wire                _zz_41_;
  reg                 _zz_42_;
  wire       [31:0]   decode_INSTRUCTION_ANTICIPATED;
  reg                 decode_REGFILE_WRITE_VALID;
  wire                decode_LEGAL_INSTRUCTION;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_43_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_44_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_45_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_46_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_47_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_48_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_49_;
  reg        [4:0]    _zz_50_;
  reg        [4:0]    _zz_50__14;
  reg        [4:0]    _zz_50__13;
  reg        [4:0]    _zz_50__12;
  reg        [4:0]    _zz_50__11;
  reg        [4:0]    _zz_50__10;
  reg        [4:0]    _zz_50__9;
  reg        [4:0]    _zz_50__8;
  reg        [4:0]    _zz_50__7;
  reg        [4:0]    _zz_50__6;
  reg        [4:0]    _zz_50__5;
  reg        [4:0]    _zz_50__4;
  reg        [4:0]    _zz_50__3;
  reg        [4:0]    _zz_50__2;
  reg        [4:0]    _zz_50__1;
  reg        [4:0]    _zz_50__0;
  reg        [4:0]    _zz_51_;
  reg        [4:0]    _zz_51__14;
  reg        [4:0]    _zz_51__13;
  reg        [4:0]    _zz_51__12;
  reg        [4:0]    _zz_51__11;
  reg        [4:0]    _zz_51__10;
  reg        [4:0]    _zz_51__9;
  reg        [4:0]    _zz_51__8;
  reg        [4:0]    _zz_51__7;
  reg        [4:0]    _zz_51__6;
  reg        [4:0]    _zz_51__5;
  reg        [4:0]    _zz_51__4;
  reg        [4:0]    _zz_51__3;
  reg        [4:0]    _zz_51__2;
  reg        [4:0]    _zz_51__1;
  reg        [4:0]    _zz_51__0;
  reg        [31:0]   _zz_52_;
  wire       [1:0]    writeBack_MEMORY_ADDRESS_LOW;
  wire                writeBack_MEMORY_WR;
  wire       [31:0]   writeBack_REGFILE_WRITE_DATA;
  wire                writeBack_MEMORY_ENABLE;
  wire       [31:0]   memory_REGFILE_WRITE_DATA;
  wire                memory_MEMORY_ENABLE;
  wire                execute_MEMORY_MANAGMENT;
  (* syn_keep , keep *) wire       [31:0]   execute_RS2 /* synthesis syn_keep = 1 */ ;
  wire                execute_MEMORY_WR;
  wire       [31:0]   execute_SRC_ADD;
  wire                execute_MEMORY_ENABLE;
  wire       [31:0]   execute_INSTRUCTION;
  wire                decode_MEMORY_ENABLE;
  wire                decode_FLUSH_ALL;
  reg                 _zz_53_;
  reg                 _zz_53__2;
  reg                 _zz_53__1;
  reg                 _zz_53__0;
  wire       `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_54_;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_55_;
  reg        [31:0]   _zz_56_;
  wire       [31:0]   decode_PC;
  wire       [31:0]   writeBack_PC;
  wire       [31:0]   writeBack_INSTRUCTION;
  reg                 decode_arbitration_haltItself;
  reg                 decode_arbitration_haltByOther;
  reg                 decode_arbitration_removeIt;
  wire                decode_arbitration_flushIt;
  reg                 decode_arbitration_flushNext;
  reg                 decode_arbitration_isValid;
  wire                decode_arbitration_isStuck;
  wire                decode_arbitration_isStuckByOthers;
  wire                decode_arbitration_isFlushed;
  wire                decode_arbitration_isMoving;
  wire                decode_arbitration_isFiring;
  reg                 execute_arbitration_haltItself;
  reg                 execute_arbitration_haltByOther;
  reg                 execute_arbitration_removeIt;
  reg                 execute_arbitration_flushIt;
  reg                 execute_arbitration_flushNext;
  reg                 execute_arbitration_isValid;
  wire                execute_arbitration_isStuck;
  wire                execute_arbitration_isStuckByOthers;
  wire                execute_arbitration_isFlushed;
  wire                execute_arbitration_isMoving;
  wire                execute_arbitration_isFiring;
  reg                 memory_arbitration_haltItself;
  wire                memory_arbitration_haltByOther;
  reg                 memory_arbitration_removeIt;
  wire                memory_arbitration_flushIt;
  reg                 memory_arbitration_flushNext;
  reg                 memory_arbitration_isValid;
  wire                memory_arbitration_isStuck;
  wire                memory_arbitration_isStuckByOthers;
  wire                memory_arbitration_isFlushed;
  wire                memory_arbitration_isMoving;
  wire                memory_arbitration_isFiring;
  reg                 writeBack_arbitration_haltItself;
  wire                writeBack_arbitration_haltByOther;
  reg                 writeBack_arbitration_removeIt;
  reg                 writeBack_arbitration_flushIt;
  reg                 writeBack_arbitration_flushNext;
  reg                 writeBack_arbitration_isValid;
  wire                writeBack_arbitration_isStuck;
  wire                writeBack_arbitration_isStuckByOthers;
  wire                writeBack_arbitration_isFlushed;
  wire                writeBack_arbitration_isMoving;
  wire                writeBack_arbitration_isFiring;
  wire       [31:0]   lastStageInstruction /* verilator public */ ;
  wire       [31:0]   lastStagePc /* verilator public */ ;
  wire                lastStageIsValid /* verilator public */ ;
  wire                lastStageIsFiring /* verilator public */ ;
  reg                 IBusCachedPlugin_fetcherHalt;
  reg                 IBusCachedPlugin_incomingInstruction;
  wire                IBusCachedPlugin_predictionJumpInterface_valid;
  (* syn_keep , keep *) wire       [31:0]   IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  reg                 IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire                IBusCachedPlugin_decodePrediction_rsp_wasWrong;
  wire                IBusCachedPlugin_pcValids_0;
  wire                IBusCachedPlugin_pcValids_1;
  wire                IBusCachedPlugin_pcValids_2;
  wire                IBusCachedPlugin_pcValids_3;
  reg                 IBusCachedPlugin_decodeExceptionPort_valid;
  reg        [3:0]    IBusCachedPlugin_decodeExceptionPort_payload_code;
  wire       [31:0]   IBusCachedPlugin_decodeExceptionPort_payload_badAddr;
  wire                IBusCachedPlugin_mmuBus_cmd_isValid;
  wire       [31:0]   IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire                IBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire       [31:0]   IBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                IBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg                 IBusCachedPlugin_mmuBus_rsp_allowRead;
  reg                 IBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg                 IBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                IBusCachedPlugin_mmuBus_rsp_exception;
  wire                IBusCachedPlugin_mmuBus_rsp_refilling;
  wire                IBusCachedPlugin_mmuBus_end;
  wire                IBusCachedPlugin_mmuBus_busy;
  wire                DBusCachedPlugin_mmuBus_cmd_isValid;
  wire       [31:0]   DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire                DBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire       [31:0]   DBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                DBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg                 DBusCachedPlugin_mmuBus_rsp_allowRead;
  reg                 DBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg                 DBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                DBusCachedPlugin_mmuBus_rsp_exception;
  wire                DBusCachedPlugin_mmuBus_rsp_refilling;
  wire                DBusCachedPlugin_mmuBus_end;
  wire                DBusCachedPlugin_mmuBus_busy;
  reg                 DBusCachedPlugin_redoBranch_valid;
  wire       [31:0]   DBusCachedPlugin_redoBranch_payload;
  reg                 DBusCachedPlugin_exceptionBus_valid;
  reg        [3:0]    DBusCachedPlugin_exceptionBus_payload_code;
  wire       [31:0]   DBusCachedPlugin_exceptionBus_payload_badAddr;
  reg                 _zz_57_;
  wire                decodeExceptionPort_valid;
  wire       [3:0]    decodeExceptionPort_payload_code;
  wire       [31:0]   decodeExceptionPort_payload_badAddr;
  wire                BranchPlugin_jumpInterface_valid;
  wire       [31:0]   BranchPlugin_jumpInterface_payload;
  wire                BranchPlugin_branchExceptionPort_valid;
  wire       [3:0]    BranchPlugin_branchExceptionPort_payload_code;
  wire       [31:0]   BranchPlugin_branchExceptionPort_payload_badAddr;
  reg                 CsrPlugin_inWfi /* verilator public */ ;
  reg                 CsrPlugin_thirdPartyWake;
  reg                 CsrPlugin_jumpInterface_valid;
  reg        [31:0]   CsrPlugin_jumpInterface_payload;
  wire                CsrPlugin_exceptionPendings_0;
  wire                CsrPlugin_exceptionPendings_1;
  wire                CsrPlugin_exceptionPendings_2;
  wire                CsrPlugin_exceptionPendings_3;
  wire                externalInterrupt;
  wire                contextSwitching;
  reg        [1:0]    CsrPlugin_privilege;
  reg                 CsrPlugin_forceMachineWire;
  reg                 CsrPlugin_selfException_valid;
  reg        [3:0]    CsrPlugin_selfException_payload_code;
  wire       [31:0]   CsrPlugin_selfException_payload_badAddr;
  reg                 CsrPlugin_allowInterrupts;
  reg                 CsrPlugin_allowException;
  reg                 IBusCachedPlugin_injectionPort_valid;
  reg                 IBusCachedPlugin_injectionPort_ready;
  wire       [31:0]   IBusCachedPlugin_injectionPort_payload;
  wire                IBusCachedPlugin_externalFlush;
  wire                IBusCachedPlugin_jump_pcLoad_valid;
  wire       [31:0]   IBusCachedPlugin_jump_pcLoad_payload;
  wire       [3:0]    _zz_58_;
  wire       [3:0]    _zz_59_;
  wire                _zz_60_;
  wire                _zz_61_;
  wire                _zz_62_;
  wire                IBusCachedPlugin_fetchPc_output_valid;
  wire                IBusCachedPlugin_fetchPc_output_ready;
  wire       [31:0]   IBusCachedPlugin_fetchPc_output_payload;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg                 IBusCachedPlugin_fetchPc_correction;
  reg                 IBusCachedPlugin_fetchPc_correctionReg;
  wire                IBusCachedPlugin_fetchPc_corrected;
  reg                 IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg                 IBusCachedPlugin_fetchPc_booted;
  reg                 IBusCachedPlugin_fetchPc_inc;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pc;
  wire                IBusCachedPlugin_fetchPc_redo_valid;
  wire       [31:0]   IBusCachedPlugin_fetchPc_redo_payload;
  reg                 IBusCachedPlugin_fetchPc_flushed;
  reg                 IBusCachedPlugin_iBusRsp_redoFetch;
  wire                IBusCachedPlugin_iBusRsp_stages_0_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_0_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_0_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_0_halt;
  wire                IBusCachedPlugin_iBusRsp_stages_1_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_1_halt;
  wire                IBusCachedPlugin_iBusRsp_stages_2_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_2_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_2_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_2_halt;
  wire                _zz_63_;
  wire                _zz_64_;
  wire                _zz_65_;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_66_;
  wire                _zz_67_;
  reg                 _zz_68_;
  wire                _zz_69_;
  reg                 _zz_70_;
  reg        [31:0]   _zz_71_;
  reg                 IBusCachedPlugin_iBusRsp_readyForError;
  wire                IBusCachedPlugin_iBusRsp_output_valid;
  wire                IBusCachedPlugin_iBusRsp_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_pc;
  wire                IBusCachedPlugin_iBusRsp_output_payload_rsp_error;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  wire                IBusCachedPlugin_iBusRsp_output_payload_isRvc;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_0;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_1;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_2;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_3;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_4;
  wire                _zz_72_;
  reg        [18:0]   _zz_73_;
  wire                _zz_74_;
  reg        [10:0]   _zz_75_;
  wire                _zz_76_;
  reg        [18:0]   _zz_77_;
  reg                 _zz_78_;
  wire                _zz_79_;
  reg        [10:0]   _zz_80_;
  wire                _zz_81_;
  reg        [18:0]   _zz_82_;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  wire       [31:0]   _zz_83_;
  reg        [31:0]   IBusCachedPlugin_rspCounter;
  wire                IBusCachedPlugin_s0_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s1_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s2_tightlyCoupledHit;
  wire                IBusCachedPlugin_rsp_iBusRspOutputHalt;
  wire                IBusCachedPlugin_rsp_issueDetected;
  reg                 IBusCachedPlugin_rsp_redoFetch;
  wire                dBus_cmd_valid;
  wire                dBus_cmd_ready;
  wire                dBus_cmd_payload_wr;
  wire       [31:0]   dBus_cmd_payload_address;
  wire       [31:0]   dBus_cmd_payload_data;
  wire       [3:0]    dBus_cmd_payload_mask;
  wire       [2:0]    dBus_cmd_payload_length;
  wire                dBus_cmd_payload_last;
  wire                dBus_rsp_valid;
  wire       [31:0]   dBus_rsp_payload_data;
  wire                dBus_rsp_payload_error;
  wire                dataCache_1__io_mem_cmd_s2mPipe_valid;
  wire                dataCache_1__io_mem_cmd_s2mPipe_ready;
  wire                dataCache_1__io_mem_cmd_s2mPipe_payload_wr;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_payload_address;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_payload_data;
  wire       [3:0]    dataCache_1__io_mem_cmd_s2mPipe_payload_mask;
  wire       [2:0]    dataCache_1__io_mem_cmd_s2mPipe_payload_length;
  wire                dataCache_1__io_mem_cmd_s2mPipe_payload_last;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_rValid;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_rData_wr;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_rData_address;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_rData_data;
  reg        [3:0]    dataCache_1__io_mem_cmd_s2mPipe_rData_mask;
  reg        [2:0]    dataCache_1__io_mem_cmd_s2mPipe_rData_length;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_rData_last;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data;
  wire       [3:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask;
  wire       [2:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_wr;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_address;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_data;
  reg        [3:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_mask;
  reg        [2:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_length;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_last;
  wire       [31:0]   _zz_84_;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_85_;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspShifted;
  wire                _zz_86_;
  reg        [31:0]   _zz_87_;
  wire                _zz_88_;
  reg        [31:0]   _zz_89_;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  reg                 _zz_90_;
  reg                 _zz_91_;
  reg                 _zz_92_;
  reg                 _zz_93_;
  reg        [1:0]    _zz_94_;
  reg        [31:0]   _zz_95_;
  reg                 _zz_96_;
  reg                 _zz_97_;
  reg                 _zz_98_;
  reg                 _zz_99_;
  reg                 _zz_100_;
  reg        [31:0]   _zz_101_;
  reg        [31:0]   _zz_102_;
  wire       [31:0]   _zz_103_;
  wire       [31:0]   _zz_104_;
  wire       [31:0]   _zz_105_;
  reg                 _zz_106_;
  reg                 _zz_107_;
  reg                 _zz_108_;
  reg                 _zz_109_;
  reg        [1:0]    _zz_110_;
  reg        [31:0]   _zz_111_;
  reg                 _zz_112_;
  reg                 _zz_113_;
  reg                 _zz_114_;
  reg                 _zz_115_;
  reg                 _zz_116_;
  reg        [31:0]   _zz_117_;
  reg        [31:0]   _zz_118_;
  wire       [31:0]   _zz_119_;
  wire       [31:0]   _zz_120_;
  wire       [31:0]   _zz_121_;
  reg                 _zz_122_;
  reg                 _zz_123_;
  reg                 _zz_124_;
  reg                 _zz_125_;
  reg        [1:0]    _zz_126_;
  reg        [31:0]   _zz_127_;
  reg                 _zz_128_;
  reg                 _zz_129_;
  reg                 _zz_130_;
  reg                 _zz_131_;
  reg                 _zz_132_;
  reg        [31:0]   _zz_133_;
  reg        [31:0]   _zz_134_;
  wire       [31:0]   _zz_135_;
  wire       [31:0]   _zz_136_;
  wire       [31:0]   _zz_137_;
  reg                 _zz_138_;
  reg                 _zz_139_;
  reg                 _zz_140_;
  reg                 _zz_141_;
  reg        [1:0]    _zz_142_;
  reg        [31:0]   _zz_143_;
  reg                 _zz_144_;
  reg                 _zz_145_;
  reg                 _zz_146_;
  reg                 _zz_147_;
  reg                 _zz_148_;
  reg        [31:0]   _zz_149_;
  reg        [31:0]   _zz_150_;
  wire       [31:0]   _zz_151_;
  wire       [31:0]   _zz_152_;
  wire       [31:0]   _zz_153_;
  reg                 _zz_154_;
  reg                 _zz_155_;
  reg                 _zz_156_;
  reg                 _zz_157_;
  reg        [1:0]    _zz_158_;
  reg        [31:0]   _zz_159_;
  reg                 _zz_160_;
  reg                 _zz_161_;
  reg                 _zz_162_;
  reg                 _zz_163_;
  reg                 _zz_164_;
  reg        [31:0]   _zz_165_;
  reg        [31:0]   _zz_166_;
  wire       [31:0]   _zz_167_;
  wire       [31:0]   _zz_168_;
  wire       [31:0]   _zz_169_;
  reg                 _zz_170_;
  reg                 _zz_171_;
  reg                 _zz_172_;
  reg                 _zz_173_;
  reg        [1:0]    _zz_174_;
  reg        [31:0]   _zz_175_;
  reg                 _zz_176_;
  reg                 _zz_177_;
  reg                 _zz_178_;
  reg                 _zz_179_;
  reg                 _zz_180_;
  reg        [31:0]   _zz_181_;
  reg        [31:0]   _zz_182_;
  wire       [31:0]   _zz_183_;
  wire       [31:0]   _zz_184_;
  wire       [31:0]   _zz_185_;
  reg                 _zz_186_;
  reg                 _zz_187_;
  reg                 _zz_188_;
  reg                 _zz_189_;
  reg        [1:0]    _zz_190_;
  reg        [31:0]   _zz_191_;
  reg                 _zz_192_;
  reg                 _zz_193_;
  reg                 _zz_194_;
  reg                 _zz_195_;
  reg                 _zz_196_;
  reg        [31:0]   _zz_197_;
  reg        [31:0]   _zz_198_;
  wire       [31:0]   _zz_199_;
  wire       [31:0]   _zz_200_;
  wire       [31:0]   _zz_201_;
  reg                 _zz_202_;
  reg                 _zz_203_;
  reg                 _zz_204_;
  reg                 _zz_205_;
  reg        [1:0]    _zz_206_;
  reg        [31:0]   _zz_207_;
  reg                 _zz_208_;
  reg                 _zz_209_;
  reg                 _zz_210_;
  reg                 _zz_211_;
  reg                 _zz_212_;
  reg        [31:0]   _zz_213_;
  reg        [31:0]   _zz_214_;
  wire       [31:0]   _zz_215_;
  wire       [31:0]   _zz_216_;
  wire       [31:0]   _zz_217_;
  reg                 _zz_218_;
  reg                 _zz_219_;
  reg                 _zz_220_;
  reg                 _zz_221_;
  reg        [1:0]    _zz_222_;
  reg        [31:0]   _zz_223_;
  reg                 _zz_224_;
  reg                 _zz_225_;
  reg                 _zz_226_;
  reg                 _zz_227_;
  reg                 _zz_228_;
  reg        [31:0]   _zz_229_;
  reg        [31:0]   _zz_230_;
  wire       [31:0]   _zz_231_;
  wire       [31:0]   _zz_232_;
  wire       [31:0]   _zz_233_;
  reg                 _zz_234_;
  reg                 _zz_235_;
  reg                 _zz_236_;
  reg                 _zz_237_;
  reg        [1:0]    _zz_238_;
  reg        [31:0]   _zz_239_;
  reg                 _zz_240_;
  reg                 _zz_241_;
  reg                 _zz_242_;
  reg                 _zz_243_;
  reg                 _zz_244_;
  reg        [31:0]   _zz_245_;
  reg        [31:0]   _zz_246_;
  wire       [31:0]   _zz_247_;
  wire       [31:0]   _zz_248_;
  wire       [31:0]   _zz_249_;
  reg                 _zz_250_;
  reg                 _zz_251_;
  reg                 _zz_252_;
  reg                 _zz_253_;
  reg        [1:0]    _zz_254_;
  reg        [31:0]   _zz_255_;
  reg                 _zz_256_;
  reg                 _zz_257_;
  reg                 _zz_258_;
  reg                 _zz_259_;
  reg                 _zz_260_;
  reg        [31:0]   _zz_261_;
  reg        [31:0]   _zz_262_;
  wire       [31:0]   _zz_263_;
  wire       [31:0]   _zz_264_;
  wire       [31:0]   _zz_265_;
  reg                 _zz_266_;
  reg                 _zz_267_;
  reg                 _zz_268_;
  reg                 _zz_269_;
  reg        [1:0]    _zz_270_;
  reg        [31:0]   _zz_271_;
  reg                 _zz_272_;
  reg                 _zz_273_;
  reg                 _zz_274_;
  reg                 _zz_275_;
  reg                 _zz_276_;
  reg        [31:0]   _zz_277_;
  reg        [31:0]   _zz_278_;
  wire       [31:0]   _zz_279_;
  wire       [31:0]   _zz_280_;
  wire       [31:0]   _zz_281_;
  reg                 _zz_282_;
  reg                 _zz_283_;
  reg                 _zz_284_;
  reg                 _zz_285_;
  reg        [1:0]    _zz_286_;
  reg        [31:0]   _zz_287_;
  reg                 _zz_288_;
  reg                 _zz_289_;
  reg                 _zz_290_;
  reg                 _zz_291_;
  reg                 _zz_292_;
  reg        [31:0]   _zz_293_;
  reg        [31:0]   _zz_294_;
  wire       [31:0]   _zz_295_;
  wire       [31:0]   _zz_296_;
  wire       [31:0]   _zz_297_;
  reg                 _zz_298_;
  reg                 _zz_299_;
  reg                 _zz_300_;
  reg                 _zz_301_;
  reg        [1:0]    _zz_302_;
  reg        [31:0]   _zz_303_;
  reg                 _zz_304_;
  reg                 _zz_305_;
  reg                 _zz_306_;
  reg                 _zz_307_;
  reg                 _zz_308_;
  reg        [31:0]   _zz_309_;
  reg        [31:0]   _zz_310_;
  wire       [31:0]   _zz_311_;
  wire       [31:0]   _zz_312_;
  wire       [31:0]   _zz_313_;
  reg                 _zz_314_;
  reg                 _zz_315_;
  reg                 _zz_316_;
  reg                 _zz_317_;
  reg        [1:0]    _zz_318_;
  reg        [31:0]   _zz_319_;
  reg                 _zz_320_;
  reg                 _zz_321_;
  reg                 _zz_322_;
  reg                 _zz_323_;
  reg                 _zz_324_;
  reg        [31:0]   _zz_325_;
  reg        [31:0]   _zz_326_;
  wire       [31:0]   _zz_327_;
  wire       [31:0]   _zz_328_;
  wire       [31:0]   _zz_329_;
  reg                 _zz_330_;
  reg                 _zz_331_;
  reg                 _zz_332_;
  reg                 _zz_333_;
  reg        [1:0]    _zz_334_;
  reg        [31:0]   _zz_335_;
  reg                 _zz_336_;
  reg                 _zz_337_;
  reg                 _zz_338_;
  reg                 _zz_339_;
  reg                 _zz_340_;
  reg        [31:0]   _zz_341_;
  reg        [31:0]   _zz_342_;
  wire       [31:0]   _zz_343_;
  wire       [31:0]   _zz_344_;
  wire       [31:0]   _zz_345_;
  wire                PmpPlugin_ports_0_hits_0;
  wire                PmpPlugin_ports_0_hits_1;
  wire                PmpPlugin_ports_0_hits_2;
  wire                PmpPlugin_ports_0_hits_3;
  wire                PmpPlugin_ports_0_hits_4;
  wire                PmpPlugin_ports_0_hits_5;
  wire                PmpPlugin_ports_0_hits_6;
  wire                PmpPlugin_ports_0_hits_7;
  wire                PmpPlugin_ports_0_hits_8;
  wire                PmpPlugin_ports_0_hits_9;
  wire                PmpPlugin_ports_0_hits_10;
  wire                PmpPlugin_ports_0_hits_11;
  wire                PmpPlugin_ports_0_hits_12;
  wire                PmpPlugin_ports_0_hits_13;
  wire                PmpPlugin_ports_0_hits_14;
  wire                PmpPlugin_ports_0_hits_15;
  wire       [15:0]   _zz_346_;
  wire       [15:0]   _zz_347_;
  wire                _zz_348_;
  wire                _zz_349_;
  wire                _zz_350_;
  wire                _zz_351_;
  wire                _zz_352_;
  wire                _zz_353_;
  wire                _zz_354_;
  wire                _zz_355_;
  wire                _zz_356_;
  wire                _zz_357_;
  wire                _zz_358_;
  wire                _zz_359_;
  wire                _zz_360_;
  wire                _zz_361_;
  wire                _zz_362_;
  wire       [15:0]   _zz_363_;
  wire       [15:0]   _zz_364_;
  wire                _zz_365_;
  wire                _zz_366_;
  wire                _zz_367_;
  wire                _zz_368_;
  wire                _zz_369_;
  wire                _zz_370_;
  wire                _zz_371_;
  wire                _zz_372_;
  wire                _zz_373_;
  wire                _zz_374_;
  wire                _zz_375_;
  wire                _zz_376_;
  wire                _zz_377_;
  wire                _zz_378_;
  wire                _zz_379_;
  wire       [15:0]   _zz_380_;
  wire       [15:0]   _zz_381_;
  wire                _zz_382_;
  wire                _zz_383_;
  wire                _zz_384_;
  wire                _zz_385_;
  wire                _zz_386_;
  wire                _zz_387_;
  wire                _zz_388_;
  wire                _zz_389_;
  wire                _zz_390_;
  wire                _zz_391_;
  wire                _zz_392_;
  wire                _zz_393_;
  wire                _zz_394_;
  wire                _zz_395_;
  wire                _zz_396_;
  wire                PmpPlugin_ports_1_hits_0;
  wire                PmpPlugin_ports_1_hits_1;
  wire                PmpPlugin_ports_1_hits_2;
  wire                PmpPlugin_ports_1_hits_3;
  wire                PmpPlugin_ports_1_hits_4;
  wire                PmpPlugin_ports_1_hits_5;
  wire                PmpPlugin_ports_1_hits_6;
  wire                PmpPlugin_ports_1_hits_7;
  wire                PmpPlugin_ports_1_hits_8;
  wire                PmpPlugin_ports_1_hits_9;
  wire                PmpPlugin_ports_1_hits_10;
  wire                PmpPlugin_ports_1_hits_11;
  wire                PmpPlugin_ports_1_hits_12;
  wire                PmpPlugin_ports_1_hits_13;
  wire                PmpPlugin_ports_1_hits_14;
  wire                PmpPlugin_ports_1_hits_15;
  wire       [15:0]   _zz_397_;
  wire       [15:0]   _zz_398_;
  wire                _zz_399_;
  wire                _zz_400_;
  wire                _zz_401_;
  wire                _zz_402_;
  wire                _zz_403_;
  wire                _zz_404_;
  wire                _zz_405_;
  wire                _zz_406_;
  wire                _zz_407_;
  wire                _zz_408_;
  wire                _zz_409_;
  wire                _zz_410_;
  wire                _zz_411_;
  wire                _zz_412_;
  wire                _zz_413_;
  wire       [15:0]   _zz_414_;
  wire       [15:0]   _zz_415_;
  wire                _zz_416_;
  wire                _zz_417_;
  wire                _zz_418_;
  wire                _zz_419_;
  wire                _zz_420_;
  wire                _zz_421_;
  wire                _zz_422_;
  wire                _zz_423_;
  wire                _zz_424_;
  wire                _zz_425_;
  wire                _zz_426_;
  wire                _zz_427_;
  wire                _zz_428_;
  wire                _zz_429_;
  wire                _zz_430_;
  wire       [15:0]   _zz_431_;
  wire       [15:0]   _zz_432_;
  wire                _zz_433_;
  wire                _zz_434_;
  wire                _zz_435_;
  wire                _zz_436_;
  wire                _zz_437_;
  wire                _zz_438_;
  wire                _zz_439_;
  wire                _zz_440_;
  wire                _zz_441_;
  wire                _zz_442_;
  wire                _zz_443_;
  wire                _zz_444_;
  wire                _zz_445_;
  wire                _zz_446_;
  wire                _zz_447_;
  wire       [32:0]   _zz_448_;
  wire                _zz_449_;
  wire                _zz_450_;
  wire                _zz_451_;
  wire                _zz_452_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_453_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_454_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_455_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_456_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_457_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_458_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_459_;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress1;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress2;
  wire       [31:0]   decode_RegFilePlugin_rs1Data;
  wire       [31:0]   decode_RegFilePlugin_rs2Data;
  reg                 lastStageRegFileWrite_valid /* verilator public */ ;
  wire       [4:0]    lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire       [31:0]   lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg                 _zz_460_;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_461_;
  reg        [31:0]   _zz_462_;
  wire                _zz_463_;
  reg        [19:0]   _zz_464_;
  wire                _zz_465_;
  reg        [19:0]   _zz_466_;
  reg        [31:0]   _zz_467_;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_468_;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_469_;
  reg                 _zz_470_;
  reg                 _zz_471_;
  reg                 _zz_472_;
  reg        [4:0]    _zz_473_;
  reg        [31:0]   _zz_474_;
  wire                _zz_475_;
  wire                _zz_476_;
  wire                _zz_477_;
  wire                _zz_478_;
  wire                _zz_479_;
  wire                _zz_480_;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_481_;
  reg                 _zz_482_;
  reg                 _zz_483_;
  wire                _zz_484_;
  reg        [19:0]   _zz_485_;
  wire                _zz_486_;
  reg        [10:0]   _zz_487_;
  wire                _zz_488_;
  reg        [18:0]   _zz_489_;
  reg                 _zz_490_;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_491_;
  reg        [19:0]   _zz_492_;
  wire                _zz_493_;
  reg        [10:0]   _zz_494_;
  wire                _zz_495_;
  reg        [18:0]   _zz_496_;
  wire       [31:0]   execute_BranchPlugin_branchAdder;
  reg        [1:0]    _zz_497_;
  reg        [1:0]    CsrPlugin_misa_base;
  reg        [25:0]   CsrPlugin_misa_extensions;
  reg        [1:0]    CsrPlugin_mtvec_mode;
  reg        [29:0]   CsrPlugin_mtvec_base;
  reg        [31:0]   CsrPlugin_mepc;
  reg                 CsrPlugin_mstatus_MIE;
  reg                 CsrPlugin_mstatus_MPIE;
  reg        [1:0]    CsrPlugin_mstatus_MPP;
  reg                 CsrPlugin_mip_MEIP;
  reg                 CsrPlugin_mip_MTIP;
  reg                 CsrPlugin_mip_MSIP;
  reg                 CsrPlugin_mie_MEIE;
  reg                 CsrPlugin_mie_MTIE;
  reg                 CsrPlugin_mie_MSIE;
  reg        [31:0]   CsrPlugin_mscratch;
  reg                 CsrPlugin_mcause_interrupt;
  reg        [3:0]    CsrPlugin_mcause_exceptionCode;
  reg        [31:0]   CsrPlugin_mtval;
  reg        [63:0]   CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg        [63:0]   CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire                _zz_498_;
  wire                _zz_499_;
  wire                _zz_500_;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg        [3:0]    CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg        [31:0]   CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire       [1:0]    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire       [1:0]    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  wire       [1:0]    _zz_501_;
  wire                _zz_502_;
  reg                 CsrPlugin_interrupt_valid;
  reg        [3:0]    CsrPlugin_interrupt_code /* verilator public */ ;
  reg        [1:0]    CsrPlugin_interrupt_targetPrivilege;
  wire                CsrPlugin_exception;
  reg                 CsrPlugin_lastStageWasWfi;
  reg                 CsrPlugin_pipelineLiberator_pcValids_0;
  reg                 CsrPlugin_pipelineLiberator_pcValids_1;
  reg                 CsrPlugin_pipelineLiberator_pcValids_2;
  wire                CsrPlugin_pipelineLiberator_active;
  reg                 CsrPlugin_pipelineLiberator_done;
  wire                CsrPlugin_interruptJump /* verilator public */ ;
  reg                 CsrPlugin_hadException;
  reg        [1:0]    CsrPlugin_targetPrivilege;
  reg        [3:0]    CsrPlugin_trapCause;
  reg        [1:0]    CsrPlugin_xtvec_mode;
  reg        [29:0]   CsrPlugin_xtvec_base;
  reg                 execute_CsrPlugin_wfiWake;
  wire                execute_CsrPlugin_blockedBySideEffects;
  reg                 execute_CsrPlugin_illegalAccess;
  reg                 execute_CsrPlugin_illegalInstruction;
  wire       [31:0]   execute_CsrPlugin_readData;
  reg                 execute_CsrPlugin_writeInstruction;
  reg                 execute_CsrPlugin_readInstruction;
  wire                execute_CsrPlugin_writeEnable;
  wire                execute_CsrPlugin_readEnable;
  wire       [31:0]   execute_CsrPlugin_readToWriteData;
  reg        [31:0]   execute_CsrPlugin_writeData;
  wire       [11:0]   execute_CsrPlugin_csrAddress;
  reg                 execute_MulPlugin_aSigned;
  reg                 execute_MulPlugin_bSigned;
  wire       [31:0]   execute_MulPlugin_a;
  wire       [31:0]   execute_MulPlugin_b;
  wire       [15:0]   execute_MulPlugin_aULow;
  wire       [15:0]   execute_MulPlugin_bULow;
  wire       [16:0]   execute_MulPlugin_aSLow;
  wire       [16:0]   execute_MulPlugin_bSLow;
  wire       [16:0]   execute_MulPlugin_aHigh;
  wire       [16:0]   execute_MulPlugin_bHigh;
  wire       [65:0]   writeBack_MulPlugin_result;
  reg        [32:0]   memory_DivPlugin_rs1;
  reg        [31:0]   memory_DivPlugin_rs2;
  reg        [64:0]   memory_DivPlugin_accumulator;
  wire                memory_DivPlugin_frontendOk;
  reg                 memory_DivPlugin_div_needRevert;
  reg                 memory_DivPlugin_div_counter_willIncrement;
  reg                 memory_DivPlugin_div_counter_willClear;
  reg        [5:0]    memory_DivPlugin_div_counter_valueNext;
  reg        [5:0]    memory_DivPlugin_div_counter_value;
  wire                memory_DivPlugin_div_counter_willOverflowIfInc;
  wire                memory_DivPlugin_div_counter_willOverflow;
  reg                 memory_DivPlugin_div_done;
  reg        [31:0]   memory_DivPlugin_div_result;
  wire       [31:0]   _zz_503_;
  wire       [32:0]   memory_DivPlugin_div_stage_0_remainderShifted;
  wire       [32:0]   memory_DivPlugin_div_stage_0_remainderMinusDenominator;
  wire       [31:0]   memory_DivPlugin_div_stage_0_outRemainder;
  wire       [31:0]   memory_DivPlugin_div_stage_0_outNumerator;
  wire       [31:0]   _zz_504_;
  wire                _zz_505_;
  wire                _zz_506_;
  reg        [32:0]   _zz_507_;
  reg        [31:0]   externalInterruptArray_regNext;
  reg        [31:0]   _zz_508_;
  wire       [31:0]   _zz_509_;
  reg                 DebugPlugin_firstCycle;
  reg                 DebugPlugin_secondCycle;
  reg                 DebugPlugin_resetIt;
  reg                 DebugPlugin_haltIt;
  reg                 DebugPlugin_stepIt;
  reg                 DebugPlugin_isPipBusy;
  reg                 DebugPlugin_godmode;
  reg                 DebugPlugin_haltedByBreak;
  reg        [31:0]   DebugPlugin_busReadDataReg;
  reg                 _zz_510_;
  wire                DebugPlugin_allowEBreak;
  reg                 DebugPlugin_resetIt_regNext;
  reg                 decode_to_execute_IS_MUL;
  reg                 execute_to_memory_IS_MUL;
  reg                 memory_to_writeBack_IS_MUL;
  reg        `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg                 decode_to_execute_CSR_READ_OPCODE;
  reg        [31:0]   decode_to_execute_RS2;
  reg        `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg                 decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg        [33:0]   execute_to_memory_MUL_HH;
  reg        [33:0]   memory_to_writeBack_MUL_HH;
  reg        [33:0]   execute_to_memory_MUL_LH;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  reg                 decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA;
  reg        [1:0]    execute_to_memory_MEMORY_ADDRESS_LOW;
  reg        [1:0]    memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg        [31:0]   decode_to_execute_RS1;
  reg        [31:0]   execute_to_memory_SHIFT_RIGHT;
  reg        [31:0]   decode_to_execute_INSTRUCTION;
  reg        [31:0]   execute_to_memory_INSTRUCTION;
  reg        [31:0]   memory_to_writeBack_INSTRUCTION;
  reg        [31:0]   decode_to_execute_FORMAL_PC_NEXT;
  reg        [31:0]   execute_to_memory_FORMAL_PC_NEXT;
  reg        [31:0]   memory_to_writeBack_FORMAL_PC_NEXT;
  reg                 decode_to_execute_DO_EBREAK;
  reg                 decode_to_execute_CSR_WRITE_OPCODE;
  reg        `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg        [31:0]   decode_to_execute_PC;
  reg        [31:0]   execute_to_memory_PC;
  reg        [31:0]   memory_to_writeBack_PC;
  reg                 decode_to_execute_SRC2_FORCE_ZERO;
  reg                 decode_to_execute_IS_DIV;
  reg                 execute_to_memory_IS_DIV;
  reg                 decode_to_execute_IS_RS2_SIGNED;
  reg                 execute_to_memory_BRANCH_DO;
  reg                 decode_to_execute_REGFILE_WRITE_VALID;
  reg                 execute_to_memory_REGFILE_WRITE_VALID;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID;
  reg                 decode_to_execute_MEMORY_MANAGMENT;
  reg        `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg        [31:0]   execute_to_memory_MUL_LL;
  reg        [33:0]   execute_to_memory_MUL_HL;
  reg                 decode_to_execute_IS_CSR;
  reg                 decode_to_execute_MEMORY_WR;
  reg                 execute_to_memory_MEMORY_WR;
  reg                 memory_to_writeBack_MEMORY_WR;
  reg                 decode_to_execute_SRC_LESS_UNSIGNED;
  reg        `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg        [51:0]   memory_to_writeBack_MUL_LOW;
  reg                 decode_to_execute_MEMORY_ENABLE;
  reg                 execute_to_memory_MEMORY_ENABLE;
  reg                 memory_to_writeBack_MEMORY_ENABLE;
  reg                 decode_to_execute_IS_RS1_SIGNED;
  reg        `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg        `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg        `ShiftCtrlEnum_defaultEncoding_type execute_to_memory_SHIFT_CTRL;
  reg                 decode_to_execute_SRC_USE_SUB_LESS;
  reg                 decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg                 execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg        [2:0]    _zz_511_;
  reg                 execute_CsrPlugin_csr_3264;
  reg                 execute_CsrPlugin_csr_944;
  reg                 execute_CsrPlugin_csr_945;
  reg                 execute_CsrPlugin_csr_946;
  reg                 execute_CsrPlugin_csr_947;
  reg                 execute_CsrPlugin_csr_948;
  reg                 execute_CsrPlugin_csr_949;
  reg                 execute_CsrPlugin_csr_950;
  reg                 execute_CsrPlugin_csr_951;
  reg                 execute_CsrPlugin_csr_952;
  reg                 execute_CsrPlugin_csr_953;
  reg                 execute_CsrPlugin_csr_954;
  reg                 execute_CsrPlugin_csr_955;
  reg                 execute_CsrPlugin_csr_956;
  reg                 execute_CsrPlugin_csr_957;
  reg                 execute_CsrPlugin_csr_958;
  reg                 execute_CsrPlugin_csr_959;
  reg                 execute_CsrPlugin_csr_928;
  reg                 execute_CsrPlugin_csr_929;
  reg                 execute_CsrPlugin_csr_930;
  reg                 execute_CsrPlugin_csr_931;
  reg                 execute_CsrPlugin_csr_3857;
  reg                 execute_CsrPlugin_csr_3858;
  reg                 execute_CsrPlugin_csr_3859;
  reg                 execute_CsrPlugin_csr_3860;
  reg                 execute_CsrPlugin_csr_769;
  reg                 execute_CsrPlugin_csr_768;
  reg                 execute_CsrPlugin_csr_836;
  reg                 execute_CsrPlugin_csr_772;
  reg                 execute_CsrPlugin_csr_773;
  reg                 execute_CsrPlugin_csr_833;
  reg                 execute_CsrPlugin_csr_832;
  reg                 execute_CsrPlugin_csr_834;
  reg                 execute_CsrPlugin_csr_835;
  reg                 execute_CsrPlugin_csr_2816;
  reg                 execute_CsrPlugin_csr_2944;
  reg                 execute_CsrPlugin_csr_2818;
  reg                 execute_CsrPlugin_csr_2946;
  reg                 execute_CsrPlugin_csr_3072;
  reg                 execute_CsrPlugin_csr_3200;
  reg                 execute_CsrPlugin_csr_3074;
  reg                 execute_CsrPlugin_csr_3202;
  reg                 execute_CsrPlugin_csr_3008;
  reg                 execute_CsrPlugin_csr_4032;
  reg        [31:0]   _zz_512_;
  reg        [31:0]   _zz_513_;
  reg        [31:0]   _zz_514_;
  reg        [31:0]   _zz_515_;
  reg        [31:0]   _zz_516_;
  reg        [31:0]   _zz_517_;
  reg        [31:0]   _zz_518_;
  reg        [31:0]   _zz_519_;
  reg        [31:0]   _zz_520_;
  reg        [31:0]   _zz_521_;
  reg        [31:0]   _zz_522_;
  reg        [31:0]   _zz_523_;
  reg        [31:0]   _zz_524_;
  reg        [31:0]   _zz_525_;
  reg        [31:0]   _zz_526_;
  reg        [31:0]   _zz_527_;
  reg        [31:0]   _zz_528_;
  reg        [31:0]   _zz_529_;
  reg        [31:0]   _zz_530_;
  reg        [31:0]   _zz_531_;
  reg        [31:0]   _zz_532_;
  reg        [31:0]   _zz_533_;
  reg        [31:0]   _zz_534_;
  reg        [31:0]   _zz_535_;
  reg        [31:0]   _zz_536_;
  reg        [31:0]   _zz_537_;
  reg        [31:0]   _zz_538_;
  reg        [31:0]   _zz_539_;
  reg        [31:0]   _zz_540_;
  reg        [31:0]   _zz_541_;
  reg        [31:0]   _zz_542_;
  reg        [31:0]   _zz_543_;
  reg        [31:0]   _zz_544_;
  reg        [31:0]   _zz_545_;
  reg        [31:0]   _zz_546_;
  reg        [31:0]   _zz_547_;
  reg        [31:0]   _zz_548_;
  reg        [31:0]   _zz_549_;
  reg        [31:0]   _zz_550_;
  reg        [31:0]   _zz_551_;
  reg        [31:0]   _zz_552_;
  reg        [31:0]   _zz_553_;
  reg        [31:0]   _zz_554_;
  reg        [2:0]    _zz_555_;
  reg                 _zz_556_;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [2:0]    _zz_557_;
  wire                _zz_558_;
  wire                _zz_559_;
  wire                _zz_560_;
  wire                _zz_561_;
  wire                _zz_562_;
  reg                 _zz_563_;
  reg        [31:0]   dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [71:0] _zz_1__string;
  reg [71:0] _zz_2__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_3__string;
  reg [71:0] _zz_4__string;
  reg [71:0] _zz_5__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_6__string;
  reg [95:0] _zz_7__string;
  reg [95:0] _zz_8__string;
  reg [39:0] _zz_9__string;
  reg [39:0] _zz_10__string;
  reg [39:0] _zz_11__string;
  reg [39:0] _zz_12__string;
  reg [39:0] decode_ENV_CTRL_string;
  reg [39:0] _zz_13__string;
  reg [39:0] _zz_14__string;
  reg [39:0] _zz_15__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_16__string;
  reg [63:0] _zz_17__string;
  reg [63:0] _zz_18__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_19__string;
  reg [39:0] _zz_20__string;
  reg [39:0] _zz_21__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_22__string;
  reg [23:0] _zz_23__string;
  reg [23:0] _zz_24__string;
  reg [31:0] _zz_25__string;
  reg [31:0] _zz_26__string;
  reg [39:0] memory_ENV_CTRL_string;
  reg [39:0] _zz_27__string;
  reg [39:0] execute_ENV_CTRL_string;
  reg [39:0] _zz_28__string;
  reg [39:0] writeBack_ENV_CTRL_string;
  reg [39:0] _zz_29__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_30__string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_33__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_34__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_36__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_37__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_38__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_39__string;
  reg [39:0] _zz_43__string;
  reg [23:0] _zz_44__string;
  reg [63:0] _zz_45__string;
  reg [71:0] _zz_46__string;
  reg [39:0] _zz_47__string;
  reg [95:0] _zz_48__string;
  reg [31:0] _zz_49__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_54__string;
  reg [31:0] _zz_453__string;
  reg [95:0] _zz_454__string;
  reg [39:0] _zz_455__string;
  reg [71:0] _zz_456__string;
  reg [63:0] _zz_457__string;
  reg [23:0] _zz_458__string;
  reg [39:0] _zz_459__string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [39:0] decode_to_execute_ENV_CTRL_string;
  reg [39:0] execute_to_memory_ENV_CTRL_string;
  reg [39:0] memory_to_writeBack_ENV_CTRL_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  `endif

  (* ram_style = "block" *) reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_591_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_592_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_593_ = 1'b1;
  assign _zz_594_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_595_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_596_ = (memory_arbitration_isValid && memory_IS_DIV);
  assign _zz_597_ = ((_zz_568_ && IBusCachedPlugin_cache_io_cpu_decode_error) && (! _zz_53__2));
  assign _zz_598_ = ((_zz_568_ && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! _zz_53__1));
  assign _zz_599_ = ((_zz_568_ && IBusCachedPlugin_cache_io_cpu_decode_mmuException) && (! _zz_53__0));
  assign _zz_600_ = ((_zz_568_ && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign _zz_601_ = ({decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid} != (2'b00));
  assign _zz_602_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_WFI));
  assign _zz_603_ = (execute_arbitration_isValid && execute_DO_EBREAK);
  assign _zz_604_ = (({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00)) == 1'b0);
  assign _zz_605_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_606_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_607_ = (DebugPlugin_stepIt && IBusCachedPlugin_incomingInstruction);
  assign _zz_608_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_609_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_610_ = (_zz_51_ == 5'h0);
  assign _zz_611_ = (_zz_50_ == 5'h0);
  assign _zz_612_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_613_ = (1'b0 || (! 1'b1));
  assign _zz_614_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_615_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_616_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_617_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_618_ = (CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]);
  assign _zz_619_ = (execute_CsrPlugin_illegalAccess || execute_CsrPlugin_illegalInstruction);
  assign _zz_620_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_ECALL));
  assign _zz_621_ = execute_INSTRUCTION[13 : 12];
  assign _zz_622_ = (memory_DivPlugin_frontendOk && (! memory_DivPlugin_div_done));
  assign _zz_623_ = (! memory_arbitration_isStuck);
  assign _zz_624_ = debug_bus_cmd_payload_address[7 : 2];
  assign _zz_625_ = (iBus_cmd_valid || (_zz_555_ != (3'b000)));
  assign _zz_626_ = (_zz_581_ && (! dataCache_1__io_mem_cmd_s2mPipe_ready));
  assign _zz_627_ = (! _zz_99_);
  assign _zz_628_ = (! _zz_115_);
  assign _zz_629_ = (! _zz_131_);
  assign _zz_630_ = (! _zz_147_);
  assign _zz_631_ = (! _zz_163_);
  assign _zz_632_ = (! _zz_179_);
  assign _zz_633_ = (! _zz_195_);
  assign _zz_634_ = (! _zz_211_);
  assign _zz_635_ = (! _zz_227_);
  assign _zz_636_ = (! _zz_243_);
  assign _zz_637_ = (! _zz_259_);
  assign _zz_638_ = (! _zz_275_);
  assign _zz_639_ = (! _zz_291_);
  assign _zz_640_ = (! _zz_307_);
  assign _zz_641_ = (! _zz_323_);
  assign _zz_642_ = (! _zz_339_);
  assign _zz_643_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_644_ = ((_zz_498_ && 1'b1) && (! 1'b0));
  assign _zz_645_ = ((_zz_499_ && 1'b1) && (! 1'b0));
  assign _zz_646_ = ((_zz_500_ && 1'b1) && (! 1'b0));
  assign _zz_647_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_648_ = execute_INSTRUCTION[13];
  assign _zz_649_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_650_ = _zz_448_[2 : 2];
  assign _zz_651_ = _zz_448_[15 : 15];
  assign _zz_652_ = ($signed(_zz_653_) + $signed(_zz_658_));
  assign _zz_653_ = ($signed(_zz_654_) + $signed(_zz_656_));
  assign _zz_654_ = 52'h0;
  assign _zz_655_ = {1'b0,memory_MUL_LL};
  assign _zz_656_ = {{19{_zz_655_[32]}}, _zz_655_};
  assign _zz_657_ = ({16'd0,memory_MUL_LH} <<< 16);
  assign _zz_658_ = {{2{_zz_657_[49]}}, _zz_657_};
  assign _zz_659_ = ({16'd0,memory_MUL_HL} <<< 16);
  assign _zz_660_ = {{2{_zz_659_[49]}}, _zz_659_};
  assign _zz_661_ = _zz_448_[17 : 17];
  assign _zz_662_ = _zz_448_[9 : 9];
  assign _zz_663_ = _zz_448_[28 : 28];
  assign _zz_664_ = _zz_448_[18 : 18];
  assign _zz_665_ = _zz_448_[16 : 16];
  assign _zz_666_ = _zz_448_[24 : 24];
  assign _zz_667_ = ($signed(_zz_669_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_668_ = _zz_667_[31 : 0];
  assign _zz_669_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_670_ = _zz_448_[5 : 5];
  assign _zz_671_ = _zz_448_[11 : 11];
  assign _zz_672_ = _zz_448_[12 : 12];
  assign _zz_673_ = _zz_448_[29 : 29];
  assign _zz_674_ = _zz_448_[21 : 21];
  assign _zz_675_ = _zz_448_[10 : 10];
  assign _zz_676_ = _zz_448_[20 : 20];
  assign _zz_677_ = _zz_448_[19 : 19];
  assign _zz_678_ = _zz_448_[8 : 8];
  assign _zz_679_ = _zz_448_[27 : 27];
  assign _zz_680_ = (_zz_58_ - (4'b0001));
  assign _zz_681_ = {IBusCachedPlugin_fetchPc_inc,(2'b00)};
  assign _zz_682_ = {29'd0, _zz_681_};
  assign _zz_683_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_684_ = {{_zz_73_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_685_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_686_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_687_ = {{_zz_75_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_688_ = {{_zz_77_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_689_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_690_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_691_ = (writeBack_MEMORY_WR ? (3'b111) : (3'b101));
  assign _zz_692_ = (writeBack_MEMORY_WR ? (3'b110) : (3'b100));
  assign _zz_693_ = (_zz_95_ + 32'h00000001);
  assign _zz_694_ = (_zz_695_ <<< 3);
  assign _zz_695_ = (_zz_104_ + 32'h00000001);
  assign _zz_696_ = (_zz_111_ + 32'h00000001);
  assign _zz_697_ = (_zz_698_ <<< 3);
  assign _zz_698_ = (_zz_120_ + 32'h00000001);
  assign _zz_699_ = (_zz_127_ + 32'h00000001);
  assign _zz_700_ = (_zz_701_ <<< 3);
  assign _zz_701_ = (_zz_136_ + 32'h00000001);
  assign _zz_702_ = (_zz_143_ + 32'h00000001);
  assign _zz_703_ = (_zz_704_ <<< 3);
  assign _zz_704_ = (_zz_152_ + 32'h00000001);
  assign _zz_705_ = (_zz_159_ + 32'h00000001);
  assign _zz_706_ = (_zz_707_ <<< 3);
  assign _zz_707_ = (_zz_168_ + 32'h00000001);
  assign _zz_708_ = (_zz_175_ + 32'h00000001);
  assign _zz_709_ = (_zz_710_ <<< 3);
  assign _zz_710_ = (_zz_184_ + 32'h00000001);
  assign _zz_711_ = (_zz_191_ + 32'h00000001);
  assign _zz_712_ = (_zz_713_ <<< 3);
  assign _zz_713_ = (_zz_200_ + 32'h00000001);
  assign _zz_714_ = (_zz_207_ + 32'h00000001);
  assign _zz_715_ = (_zz_716_ <<< 3);
  assign _zz_716_ = (_zz_216_ + 32'h00000001);
  assign _zz_717_ = (_zz_223_ + 32'h00000001);
  assign _zz_718_ = (_zz_719_ <<< 3);
  assign _zz_719_ = (_zz_232_ + 32'h00000001);
  assign _zz_720_ = (_zz_239_ + 32'h00000001);
  assign _zz_721_ = (_zz_722_ <<< 3);
  assign _zz_722_ = (_zz_248_ + 32'h00000001);
  assign _zz_723_ = (_zz_255_ + 32'h00000001);
  assign _zz_724_ = (_zz_725_ <<< 3);
  assign _zz_725_ = (_zz_264_ + 32'h00000001);
  assign _zz_726_ = (_zz_271_ + 32'h00000001);
  assign _zz_727_ = (_zz_728_ <<< 3);
  assign _zz_728_ = (_zz_280_ + 32'h00000001);
  assign _zz_729_ = (_zz_287_ + 32'h00000001);
  assign _zz_730_ = (_zz_731_ <<< 3);
  assign _zz_731_ = (_zz_296_ + 32'h00000001);
  assign _zz_732_ = (_zz_303_ + 32'h00000001);
  assign _zz_733_ = (_zz_734_ <<< 3);
  assign _zz_734_ = (_zz_312_ + 32'h00000001);
  assign _zz_735_ = (_zz_319_ + 32'h00000001);
  assign _zz_736_ = (_zz_737_ <<< 3);
  assign _zz_737_ = (_zz_328_ + 32'h00000001);
  assign _zz_738_ = (_zz_335_ + 32'h00000001);
  assign _zz_739_ = (_zz_740_ <<< 3);
  assign _zz_740_ = (_zz_344_ + 32'h00000001);
  assign _zz_741_ = (_zz_346_ - 16'h0001);
  assign _zz_742_ = (_zz_363_ - 16'h0001);
  assign _zz_743_ = (_zz_380_ - 16'h0001);
  assign _zz_744_ = (_zz_397_ - 16'h0001);
  assign _zz_745_ = (_zz_414_ - 16'h0001);
  assign _zz_746_ = (_zz_431_ - 16'h0001);
  assign _zz_747_ = execute_SRC_LESS;
  assign _zz_748_ = (3'b100);
  assign _zz_749_ = execute_INSTRUCTION[19 : 15];
  assign _zz_750_ = execute_INSTRUCTION[31 : 20];
  assign _zz_751_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_752_ = ($signed(_zz_753_) + $signed(_zz_756_));
  assign _zz_753_ = ($signed(_zz_754_) + $signed(_zz_755_));
  assign _zz_754_ = execute_SRC1;
  assign _zz_755_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_756_ = (execute_SRC_USE_SUB_LESS ? _zz_757_ : _zz_758_);
  assign _zz_757_ = 32'h00000001;
  assign _zz_758_ = 32'h0;
  assign _zz_759_ = execute_INSTRUCTION[31 : 20];
  assign _zz_760_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_761_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_762_ = {_zz_485_,execute_INSTRUCTION[31 : 20]};
  assign _zz_763_ = {{_zz_487_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_764_ = {{_zz_489_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_765_ = execute_INSTRUCTION[31 : 20];
  assign _zz_766_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_767_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_768_ = (3'b100);
  assign _zz_769_ = (_zz_501_ & (~ _zz_770_));
  assign _zz_770_ = (_zz_501_ - (2'b01));
  assign _zz_771_ = {{14{writeBack_MUL_LOW[51]}}, writeBack_MUL_LOW};
  assign _zz_772_ = ({32'd0,writeBack_MUL_HH} <<< 32);
  assign _zz_773_ = writeBack_MUL_LOW[31 : 0];
  assign _zz_774_ = writeBack_MulPlugin_result[63 : 32];
  assign _zz_775_ = memory_DivPlugin_div_counter_willIncrement;
  assign _zz_776_ = {5'd0, _zz_775_};
  assign _zz_777_ = {1'd0, memory_DivPlugin_rs2};
  assign _zz_778_ = memory_DivPlugin_div_stage_0_remainderMinusDenominator[31:0];
  assign _zz_779_ = memory_DivPlugin_div_stage_0_remainderShifted[31:0];
  assign _zz_780_ = {_zz_503_,(! memory_DivPlugin_div_stage_0_remainderMinusDenominator[32])};
  assign _zz_781_ = _zz_782_;
  assign _zz_782_ = _zz_783_;
  assign _zz_783_ = ({1'b0,(memory_DivPlugin_div_needRevert ? (~ _zz_504_) : _zz_504_)} + _zz_785_);
  assign _zz_784_ = memory_DivPlugin_div_needRevert;
  assign _zz_785_ = {32'd0, _zz_784_};
  assign _zz_786_ = _zz_506_;
  assign _zz_787_ = {32'd0, _zz_786_};
  assign _zz_788_ = _zz_505_;
  assign _zz_789_ = {31'd0, _zz_788_};
  assign _zz_790_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_791_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_792_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_793_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_794_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_795_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_796_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_797_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_798_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_799_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_800_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_801_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_802_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_803_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_804_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_805_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_806_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_807_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_808_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_809_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_810_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_811_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_812_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_813_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_814_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_815_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_816_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_817_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_818_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_819_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_820_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_821_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_822_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_823_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_824_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_825_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_826_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_827_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_828_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_829_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_830_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_831_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_832_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_833_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_834_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_835_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_836_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_837_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_838_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_839_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_840_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_841_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_842_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_843_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_844_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_845_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_846_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_847_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_848_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_849_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_850_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_851_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_852_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_853_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_854_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_855_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_856_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_857_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_858_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_859_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_860_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_861_ = (iBus_cmd_payload_address >>> 5);
  assign _zz_862_ = 1'b1;
  assign _zz_863_ = 1'b1;
  assign _zz_864_ = {_zz_62_,_zz_61_};
  assign _zz_865_ = {_zz_362_,{_zz_361_,{_zz_360_,_zz_359_}}};
  assign _zz_866_ = {_zz_379_,{_zz_378_,{_zz_377_,_zz_376_}}};
  assign _zz_867_ = {_zz_396_,{_zz_395_,{_zz_394_,_zz_393_}}};
  assign _zz_868_ = {_zz_413_,{_zz_412_,{_zz_411_,_zz_410_}}};
  assign _zz_869_ = {_zz_430_,{_zz_429_,{_zz_428_,_zz_427_}}};
  assign _zz_870_ = {_zz_447_,{_zz_446_,{_zz_445_,_zz_444_}}};
  assign _zz_871_ = 32'h0000107f;
  assign _zz_872_ = (decode_INSTRUCTION & 32'h0000207f);
  assign _zz_873_ = 32'h00002073;
  assign _zz_874_ = ((decode_INSTRUCTION & 32'h0000407f) == 32'h00004063);
  assign _zz_875_ = ((decode_INSTRUCTION & 32'h0000207f) == 32'h00002013);
  assign _zz_876_ = {((decode_INSTRUCTION & 32'h0000603f) == 32'h00000023),{((decode_INSTRUCTION & 32'h0000207f) == 32'h00000003),{((decode_INSTRUCTION & _zz_877_) == 32'h00000003),{(_zz_878_ == _zz_879_),{_zz_880_,{_zz_881_,_zz_882_}}}}}};
  assign _zz_877_ = 32'h0000505f;
  assign _zz_878_ = (decode_INSTRUCTION & 32'h0000707b);
  assign _zz_879_ = 32'h00000063;
  assign _zz_880_ = ((decode_INSTRUCTION & 32'h0000607f) == 32'h0000000f);
  assign _zz_881_ = ((decode_INSTRUCTION & 32'hfc00007f) == 32'h00000033);
  assign _zz_882_ = {((decode_INSTRUCTION & 32'h01f0707f) == 32'h0000500f),{((decode_INSTRUCTION & 32'hbc00707f) == 32'h00005013),{((decode_INSTRUCTION & _zz_883_) == 32'h00001013),{(_zz_884_ == _zz_885_),{_zz_886_,{_zz_887_,_zz_888_}}}}}};
  assign _zz_883_ = 32'hfc00307f;
  assign _zz_884_ = (decode_INSTRUCTION & 32'hbe00707f);
  assign _zz_885_ = 32'h00005033;
  assign _zz_886_ = ((decode_INSTRUCTION & 32'hbe00707f) == 32'h00000033);
  assign _zz_887_ = ((decode_INSTRUCTION & 32'hdfffffff) == 32'h10200073);
  assign _zz_888_ = {((decode_INSTRUCTION & 32'hffefffff) == 32'h00000073),((decode_INSTRUCTION & 32'hffffffff) == 32'h10500073)};
  assign _zz_889_ = decode_INSTRUCTION[31];
  assign _zz_890_ = decode_INSTRUCTION[31];
  assign _zz_891_ = decode_INSTRUCTION[7];
  assign _zz_892_ = PmpPlugin_ports_0_hits_5;
  assign _zz_893_ = {PmpPlugin_ports_0_hits_4,{PmpPlugin_ports_0_hits_3,{PmpPlugin_ports_0_hits_2,{PmpPlugin_ports_0_hits_1,PmpPlugin_ports_0_hits_0}}}};
  assign _zz_894_ = PmpPlugin_ports_0_hits_5;
  assign _zz_895_ = {PmpPlugin_ports_0_hits_4,{PmpPlugin_ports_0_hits_3,{PmpPlugin_ports_0_hits_2,{PmpPlugin_ports_0_hits_1,PmpPlugin_ports_0_hits_0}}}};
  assign _zz_896_ = PmpPlugin_ports_0_hits_5;
  assign _zz_897_ = {PmpPlugin_ports_0_hits_4,{PmpPlugin_ports_0_hits_3,{PmpPlugin_ports_0_hits_2,{PmpPlugin_ports_0_hits_1,PmpPlugin_ports_0_hits_0}}}};
  assign _zz_898_ = PmpPlugin_ports_1_hits_5;
  assign _zz_899_ = {PmpPlugin_ports_1_hits_4,{PmpPlugin_ports_1_hits_3,{PmpPlugin_ports_1_hits_2,{PmpPlugin_ports_1_hits_1,PmpPlugin_ports_1_hits_0}}}};
  assign _zz_900_ = PmpPlugin_ports_1_hits_5;
  assign _zz_901_ = {PmpPlugin_ports_1_hits_4,{PmpPlugin_ports_1_hits_3,{PmpPlugin_ports_1_hits_2,{PmpPlugin_ports_1_hits_1,PmpPlugin_ports_1_hits_0}}}};
  assign _zz_902_ = PmpPlugin_ports_1_hits_5;
  assign _zz_903_ = {PmpPlugin_ports_1_hits_4,{PmpPlugin_ports_1_hits_3,{PmpPlugin_ports_1_hits_2,{PmpPlugin_ports_1_hits_1,PmpPlugin_ports_1_hits_0}}}};
  assign _zz_904_ = (decode_INSTRUCTION & 32'h00002040);
  assign _zz_905_ = 32'h00002040;
  assign _zz_906_ = ((decode_INSTRUCTION & _zz_917_) == 32'h00001040);
  assign _zz_907_ = (_zz_918_ == _zz_919_);
  assign _zz_908_ = {_zz_920_,_zz_921_};
  assign _zz_909_ = ((decode_INSTRUCTION & _zz_922_) == 32'h10000050);
  assign _zz_910_ = ((decode_INSTRUCTION & _zz_923_) == 32'h00000050);
  assign _zz_911_ = ((decode_INSTRUCTION & _zz_924_) == 32'h00000050);
  assign _zz_912_ = {_zz_925_,_zz_926_};
  assign _zz_913_ = (2'b00);
  assign _zz_914_ = ({_zz_927_,_zz_928_} != (2'b00));
  assign _zz_915_ = (_zz_929_ != _zz_930_);
  assign _zz_916_ = {_zz_931_,{_zz_932_,_zz_933_}};
  assign _zz_917_ = 32'h00001040;
  assign _zz_918_ = (decode_INSTRUCTION & 32'h00100040);
  assign _zz_919_ = 32'h00000040;
  assign _zz_920_ = ((decode_INSTRUCTION & _zz_934_) == 32'h00000040);
  assign _zz_921_ = ((decode_INSTRUCTION & _zz_935_) == 32'h0);
  assign _zz_922_ = 32'h10203050;
  assign _zz_923_ = 32'h10103050;
  assign _zz_924_ = 32'h00103050;
  assign _zz_925_ = ((decode_INSTRUCTION & _zz_936_) == 32'h00000020);
  assign _zz_926_ = ((decode_INSTRUCTION & _zz_937_) == 32'h00000020);
  assign _zz_927_ = (_zz_938_ == _zz_939_);
  assign _zz_928_ = (_zz_940_ == _zz_941_);
  assign _zz_929_ = (_zz_942_ == _zz_943_);
  assign _zz_930_ = (1'b0);
  assign _zz_931_ = ({_zz_944_,_zz_945_} != (2'b00));
  assign _zz_932_ = (_zz_946_ != _zz_947_);
  assign _zz_933_ = {_zz_948_,{_zz_949_,_zz_950_}};
  assign _zz_934_ = 32'h00000050;
  assign _zz_935_ = 32'h00000038;
  assign _zz_936_ = 32'h00000034;
  assign _zz_937_ = 32'h00000064;
  assign _zz_938_ = (decode_INSTRUCTION & 32'h00001050);
  assign _zz_939_ = 32'h00001050;
  assign _zz_940_ = (decode_INSTRUCTION & 32'h00002050);
  assign _zz_941_ = 32'h00002050;
  assign _zz_942_ = (decode_INSTRUCTION & 32'h00005048);
  assign _zz_943_ = 32'h00001008;
  assign _zz_944_ = _zz_450_;
  assign _zz_945_ = ((decode_INSTRUCTION & _zz_951_) == 32'h00000020);
  assign _zz_946_ = {_zz_450_,(_zz_952_ == _zz_953_)};
  assign _zz_947_ = (2'b00);
  assign _zz_948_ = ((_zz_954_ == _zz_955_) != (1'b0));
  assign _zz_949_ = (_zz_956_ != (1'b0));
  assign _zz_950_ = {(_zz_957_ != _zz_958_),{_zz_959_,{_zz_960_,_zz_961_}}};
  assign _zz_951_ = 32'h00000070;
  assign _zz_952_ = (decode_INSTRUCTION & 32'h00000020);
  assign _zz_953_ = 32'h0;
  assign _zz_954_ = (decode_INSTRUCTION & 32'h02004064);
  assign _zz_955_ = 32'h02004020;
  assign _zz_956_ = ((decode_INSTRUCTION & 32'h00004014) == 32'h00004010);
  assign _zz_957_ = ((decode_INSTRUCTION & 32'h00006014) == 32'h00002010);
  assign _zz_958_ = (1'b0);
  assign _zz_959_ = ({(_zz_962_ == _zz_963_),{_zz_964_,{_zz_965_,_zz_966_}}} != (4'b0000));
  assign _zz_960_ = ((_zz_967_ == _zz_968_) != (1'b0));
  assign _zz_961_ = {({_zz_969_,_zz_970_} != 6'h0),{(_zz_971_ != _zz_972_),{_zz_973_,{_zz_974_,_zz_975_}}}};
  assign _zz_962_ = (decode_INSTRUCTION & 32'h00000044);
  assign _zz_963_ = 32'h0;
  assign _zz_964_ = ((decode_INSTRUCTION & _zz_976_) == 32'h0);
  assign _zz_965_ = (_zz_977_ == _zz_978_);
  assign _zz_966_ = (_zz_979_ == _zz_980_);
  assign _zz_967_ = (decode_INSTRUCTION & 32'h00000064);
  assign _zz_968_ = 32'h00000024;
  assign _zz_969_ = _zz_449_;
  assign _zz_970_ = {_zz_981_,{_zz_982_,_zz_983_}};
  assign _zz_971_ = (_zz_984_ == _zz_985_);
  assign _zz_972_ = (1'b0);
  assign _zz_973_ = ({_zz_986_,_zz_987_} != (2'b00));
  assign _zz_974_ = (_zz_988_ != _zz_989_);
  assign _zz_975_ = {_zz_990_,{_zz_991_,_zz_992_}};
  assign _zz_976_ = 32'h00000018;
  assign _zz_977_ = (decode_INSTRUCTION & 32'h00006004);
  assign _zz_978_ = 32'h00002000;
  assign _zz_979_ = (decode_INSTRUCTION & 32'h00005004);
  assign _zz_980_ = 32'h00001000;
  assign _zz_981_ = ((decode_INSTRUCTION & _zz_993_) == 32'h00001010);
  assign _zz_982_ = (_zz_994_ == _zz_995_);
  assign _zz_983_ = {_zz_996_,{_zz_997_,_zz_998_}};
  assign _zz_984_ = (decode_INSTRUCTION & 32'h00004048);
  assign _zz_985_ = 32'h00004008;
  assign _zz_986_ = (_zz_999_ == _zz_1000_);
  assign _zz_987_ = (_zz_1001_ == _zz_1002_);
  assign _zz_988_ = _zz_452_;
  assign _zz_989_ = (1'b0);
  assign _zz_990_ = (_zz_452_ != (1'b0));
  assign _zz_991_ = (_zz_1003_ != _zz_1004_);
  assign _zz_992_ = {_zz_1005_,{_zz_1006_,_zz_1007_}};
  assign _zz_993_ = 32'h00001010;
  assign _zz_994_ = (decode_INSTRUCTION & 32'h00002010);
  assign _zz_995_ = 32'h00002010;
  assign _zz_996_ = ((decode_INSTRUCTION & 32'h00000050) == 32'h00000010);
  assign _zz_997_ = ((decode_INSTRUCTION & _zz_1008_) == 32'h00000004);
  assign _zz_998_ = ((decode_INSTRUCTION & _zz_1009_) == 32'h0);
  assign _zz_999_ = (decode_INSTRUCTION & 32'h00002010);
  assign _zz_1000_ = 32'h00002000;
  assign _zz_1001_ = (decode_INSTRUCTION & 32'h00005000);
  assign _zz_1002_ = 32'h00001000;
  assign _zz_1003_ = {(_zz_1010_ == _zz_1011_),(_zz_1012_ == _zz_1013_)};
  assign _zz_1004_ = (2'b00);
  assign _zz_1005_ = ({_zz_1014_,{_zz_1015_,_zz_1016_}} != (3'b000));
  assign _zz_1006_ = (_zz_1017_ != (1'b0));
  assign _zz_1007_ = {(_zz_1018_ != _zz_1019_),{_zz_1020_,{_zz_1021_,_zz_1022_}}};
  assign _zz_1008_ = 32'h0000000c;
  assign _zz_1009_ = 32'h00000028;
  assign _zz_1010_ = (decode_INSTRUCTION & 32'h00007034);
  assign _zz_1011_ = 32'h00005010;
  assign _zz_1012_ = (decode_INSTRUCTION & 32'h02007064);
  assign _zz_1013_ = 32'h00005020;
  assign _zz_1014_ = ((decode_INSTRUCTION & 32'h40003054) == 32'h40001010);
  assign _zz_1015_ = ((decode_INSTRUCTION & _zz_1023_) == 32'h00001010);
  assign _zz_1016_ = ((decode_INSTRUCTION & _zz_1024_) == 32'h00001010);
  assign _zz_1017_ = ((decode_INSTRUCTION & 32'h10103050) == 32'h00100050);
  assign _zz_1018_ = ((decode_INSTRUCTION & _zz_1025_) == 32'h02000030);
  assign _zz_1019_ = (1'b0);
  assign _zz_1020_ = ({_zz_1026_,{_zz_1027_,_zz_1028_}} != (3'b000));
  assign _zz_1021_ = (_zz_1029_ != (1'b0));
  assign _zz_1022_ = {(_zz_1030_ != _zz_1031_),{_zz_1032_,{_zz_1033_,_zz_1034_}}};
  assign _zz_1023_ = 32'h00007034;
  assign _zz_1024_ = 32'h02007054;
  assign _zz_1025_ = 32'h02004074;
  assign _zz_1026_ = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000040);
  assign _zz_1027_ = ((decode_INSTRUCTION & _zz_1035_) == 32'h00002010);
  assign _zz_1028_ = ((decode_INSTRUCTION & _zz_1036_) == 32'h40000030);
  assign _zz_1029_ = ((decode_INSTRUCTION & 32'h00000020) == 32'h00000020);
  assign _zz_1030_ = ((decode_INSTRUCTION & _zz_1037_) == 32'h0);
  assign _zz_1031_ = (1'b0);
  assign _zz_1032_ = ((_zz_1038_ == _zz_1039_) != (1'b0));
  assign _zz_1033_ = (_zz_1040_ != (1'b0));
  assign _zz_1034_ = {(_zz_1041_ != _zz_1042_),{_zz_1043_,{_zz_1044_,_zz_1045_}}};
  assign _zz_1035_ = 32'h00002014;
  assign _zz_1036_ = 32'h40000034;
  assign _zz_1037_ = 32'h00000058;
  assign _zz_1038_ = (decode_INSTRUCTION & 32'h00001000);
  assign _zz_1039_ = 32'h00001000;
  assign _zz_1040_ = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz_1041_ = {_zz_450_,{_zz_1046_,{_zz_1047_,_zz_1048_}}};
  assign _zz_1042_ = 5'h0;
  assign _zz_1043_ = ({_zz_1049_,_zz_451_} != (2'b00));
  assign _zz_1044_ = ({_zz_1050_,_zz_1051_} != (2'b00));
  assign _zz_1045_ = {(_zz_1052_ != _zz_1053_),{_zz_1054_,_zz_1055_}};
  assign _zz_1046_ = ((decode_INSTRUCTION & 32'h00002030) == 32'h00002010);
  assign _zz_1047_ = ((decode_INSTRUCTION & _zz_1056_) == 32'h00000010);
  assign _zz_1048_ = {(_zz_1057_ == _zz_1058_),(_zz_1059_ == _zz_1060_)};
  assign _zz_1049_ = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz_1050_ = ((decode_INSTRUCTION & _zz_1061_) == 32'h00000004);
  assign _zz_1051_ = _zz_451_;
  assign _zz_1052_ = {(_zz_1062_ == _zz_1063_),{_zz_450_,{_zz_1064_,_zz_1065_}}};
  assign _zz_1053_ = 5'h0;
  assign _zz_1054_ = ({_zz_449_,_zz_1066_} != (2'b00));
  assign _zz_1055_ = ((_zz_1067_ == _zz_1068_) != (1'b0));
  assign _zz_1056_ = 32'h00001030;
  assign _zz_1057_ = (decode_INSTRUCTION & 32'h02002060);
  assign _zz_1058_ = 32'h00002020;
  assign _zz_1059_ = (decode_INSTRUCTION & 32'h02003020);
  assign _zz_1060_ = 32'h00000020;
  assign _zz_1061_ = 32'h00000044;
  assign _zz_1062_ = (decode_INSTRUCTION & 32'h00000040);
  assign _zz_1063_ = 32'h00000040;
  assign _zz_1064_ = ((decode_INSTRUCTION & 32'h00004020) == 32'h00004020);
  assign _zz_1065_ = {((decode_INSTRUCTION & 32'h00000030) == 32'h00000010),((decode_INSTRUCTION & 32'h02000020) == 32'h00000020)};
  assign _zz_1066_ = ((decode_INSTRUCTION & 32'h0000001c) == 32'h00000004);
  assign _zz_1067_ = (decode_INSTRUCTION & 32'h00000058);
  assign _zz_1068_ = 32'h00000040;
  assign _zz_1069_ = execute_INSTRUCTION[31];
  assign _zz_1070_ = execute_INSTRUCTION[31];
  assign _zz_1071_ = execute_INSTRUCTION[7];
  assign _zz_1072_ = (_zz_512_ | _zz_513_);
  assign _zz_1073_ = (_zz_514_ | _zz_515_);
  assign _zz_1074_ = (_zz_516_ | _zz_517_);
  assign _zz_1075_ = (_zz_518_ | _zz_519_);
  assign _zz_1076_ = (_zz_520_ | _zz_521_);
  assign _zz_1077_ = (_zz_522_ | _zz_523_);
  assign _zz_1078_ = (_zz_524_ | _zz_525_);
  assign _zz_1079_ = (_zz_526_ | _zz_527_);
  assign _zz_1080_ = (_zz_528_ | _zz_529_);
  assign _zz_1081_ = (_zz_530_ | _zz_531_);
  assign _zz_1082_ = (_zz_532_ | _zz_533_);
  assign _zz_1083_ = (_zz_534_ | _zz_535_);
  assign _zz_1084_ = (_zz_1088_ | _zz_536_);
  assign _zz_1085_ = (_zz_537_ | _zz_538_);
  assign _zz_1086_ = (_zz_539_ | _zz_540_);
  assign _zz_1087_ = (_zz_541_ | _zz_542_);
  assign _zz_1088_ = 32'h0;
  always @ (posedge clk) begin
    if(_zz_862_) begin
      _zz_582_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_863_) begin
      _zz_583_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge clk) begin
    if(_zz_42_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache ( 
    .io_flush                                     (_zz_564_                                                             ), //i
    .io_cpu_prefetch_isValid                      (_zz_565_                                                             ), //i
    .io_cpu_prefetch_haltIt                       (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt                        ), //o
    .io_cpu_prefetch_pc                           (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]                ), //i
    .io_cpu_fetch_isValid                         (_zz_566_                                                             ), //i
    .io_cpu_fetch_isStuck                         (_zz_567_                                                             ), //i
    .io_cpu_fetch_isRemoved                       (IBusCachedPlugin_externalFlush                                       ), //i
    .io_cpu_fetch_pc                              (IBusCachedPlugin_iBusRsp_stages_1_input_payload[31:0]                ), //i
    .io_cpu_fetch_data                            (IBusCachedPlugin_cache_io_cpu_fetch_data[31:0]                       ), //o
    .io_cpu_fetch_mmuBus_cmd_isValid              (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid               ), //o
    .io_cpu_fetch_mmuBus_cmd_virtualAddress       (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress[31:0]  ), //o
    .io_cpu_fetch_mmuBus_cmd_bypassTranslation    (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation     ), //o
    .io_cpu_fetch_mmuBus_rsp_physicalAddress      (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]                    ), //i
    .io_cpu_fetch_mmuBus_rsp_isIoAccess           (IBusCachedPlugin_mmuBus_rsp_isIoAccess                               ), //i
    .io_cpu_fetch_mmuBus_rsp_allowRead            (IBusCachedPlugin_mmuBus_rsp_allowRead                                ), //i
    .io_cpu_fetch_mmuBus_rsp_allowWrite           (IBusCachedPlugin_mmuBus_rsp_allowWrite                               ), //i
    .io_cpu_fetch_mmuBus_rsp_allowExecute         (IBusCachedPlugin_mmuBus_rsp_allowExecute                             ), //i
    .io_cpu_fetch_mmuBus_rsp_exception            (IBusCachedPlugin_mmuBus_rsp_exception                                ), //i
    .io_cpu_fetch_mmuBus_rsp_refilling            (IBusCachedPlugin_mmuBus_rsp_refilling                                ), //i
    .io_cpu_fetch_mmuBus_end                      (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end                       ), //o
    .io_cpu_fetch_mmuBus_busy                     (IBusCachedPlugin_mmuBus_busy                                         ), //i
    .io_cpu_fetch_physicalAddress                 (IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress[31:0]            ), //o
    .io_cpu_fetch_haltIt                          (IBusCachedPlugin_cache_io_cpu_fetch_haltIt                           ), //o
    .io_cpu_decode_isValid                        (_zz_568_                                                             ), //i
    .io_cpu_decode_isStuck                        (_zz_569_                                                             ), //i
    .io_cpu_decode_pc                             (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]                ), //i
    .io_cpu_decode_physicalAddress                (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]           ), //o
    .io_cpu_decode_data                           (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]                      ), //o
    .io_cpu_decode_cacheMiss                      (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss                       ), //o
    .io_cpu_decode_error                          (IBusCachedPlugin_cache_io_cpu_decode_error                           ), //o
    .io_cpu_decode_mmuRefilling                   (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling                    ), //o
    .io_cpu_decode_mmuException                   (IBusCachedPlugin_cache_io_cpu_decode_mmuException                    ), //o
    .io_cpu_decode_isUser                         (_zz_570_                                                             ), //i
    .io_cpu_fill_valid                            (_zz_571_                                                             ), //i
    .io_cpu_fill_payload                          (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]           ), //i
    .io_mem_cmd_valid                             (IBusCachedPlugin_cache_io_mem_cmd_valid                              ), //o
    .io_mem_cmd_ready                             (iBus_cmd_ready                                                       ), //i
    .io_mem_cmd_payload_address                   (IBusCachedPlugin_cache_io_mem_cmd_payload_address[31:0]              ), //o
    .io_mem_cmd_payload_size                      (IBusCachedPlugin_cache_io_mem_cmd_payload_size[2:0]                  ), //o
    .io_mem_rsp_valid                             (iBus_rsp_valid                                                       ), //i
    .io_mem_rsp_payload_data                      (iBus_rsp_payload_data[31:0]                                          ), //i
    .io_mem_rsp_payload_error                     (iBus_rsp_payload_error                                               ), //i
    ._zz_10_                                      (_zz_511_[2:0]                                                        ), //i
    ._zz_11_                                      (IBusCachedPlugin_injectionPort_payload[31:0]                         ), //i
    .clk                                          (clk                                                                  ), //i
    .reset                                        (reset                                                                )  //i
  );
  DataCache dataCache_1_ ( 
    .io_cpu_execute_isValid                        (_zz_572_                                                    ), //i
    .io_cpu_execute_address                        (_zz_573_[31:0]                                              ), //i
    .io_cpu_execute_args_wr                        (execute_MEMORY_WR                                           ), //i
    .io_cpu_execute_args_data                      (_zz_85_[31:0]                                               ), //i
    .io_cpu_execute_args_size                      (execute_DBusCachedPlugin_size[1:0]                          ), //i
    .io_cpu_memory_isValid                         (_zz_574_                                                    ), //i
    .io_cpu_memory_isStuck                         (memory_arbitration_isStuck                                  ), //i
    .io_cpu_memory_isRemoved                       (memory_arbitration_removeIt                                 ), //i
    .io_cpu_memory_isWrite                         (dataCache_1__io_cpu_memory_isWrite                          ), //o
    .io_cpu_memory_address                         (_zz_575_[31:0]                                              ), //i
    .io_cpu_memory_mmuBus_cmd_isValid              (dataCache_1__io_cpu_memory_mmuBus_cmd_isValid               ), //o
    .io_cpu_memory_mmuBus_cmd_virtualAddress       (dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress[31:0]  ), //o
    .io_cpu_memory_mmuBus_cmd_bypassTranslation    (dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation     ), //o
    .io_cpu_memory_mmuBus_rsp_physicalAddress      (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]           ), //i
    .io_cpu_memory_mmuBus_rsp_isIoAccess           (_zz_576_                                                    ), //i
    .io_cpu_memory_mmuBus_rsp_allowRead            (DBusCachedPlugin_mmuBus_rsp_allowRead                       ), //i
    .io_cpu_memory_mmuBus_rsp_allowWrite           (DBusCachedPlugin_mmuBus_rsp_allowWrite                      ), //i
    .io_cpu_memory_mmuBus_rsp_allowExecute         (DBusCachedPlugin_mmuBus_rsp_allowExecute                    ), //i
    .io_cpu_memory_mmuBus_rsp_exception            (DBusCachedPlugin_mmuBus_rsp_exception                       ), //i
    .io_cpu_memory_mmuBus_rsp_refilling            (DBusCachedPlugin_mmuBus_rsp_refilling                       ), //i
    .io_cpu_memory_mmuBus_end                      (dataCache_1__io_cpu_memory_mmuBus_end                       ), //o
    .io_cpu_memory_mmuBus_busy                     (DBusCachedPlugin_mmuBus_busy                                ), //i
    .io_cpu_writeBack_isValid                      (_zz_577_                                                    ), //i
    .io_cpu_writeBack_isStuck                      (writeBack_arbitration_isStuck                               ), //i
    .io_cpu_writeBack_isUser                       (_zz_578_                                                    ), //i
    .io_cpu_writeBack_haltIt                       (dataCache_1__io_cpu_writeBack_haltIt                        ), //o
    .io_cpu_writeBack_isWrite                      (dataCache_1__io_cpu_writeBack_isWrite                       ), //o
    .io_cpu_writeBack_data                         (dataCache_1__io_cpu_writeBack_data[31:0]                    ), //o
    .io_cpu_writeBack_address                      (_zz_579_[31:0]                                              ), //i
    .io_cpu_writeBack_mmuException                 (dataCache_1__io_cpu_writeBack_mmuException                  ), //o
    .io_cpu_writeBack_unalignedAccess              (dataCache_1__io_cpu_writeBack_unalignedAccess               ), //o
    .io_cpu_writeBack_accessError                  (dataCache_1__io_cpu_writeBack_accessError                   ), //o
    .io_cpu_redo                                   (dataCache_1__io_cpu_redo                                    ), //o
    .io_cpu_flush_valid                            (_zz_580_                                                    ), //i
    .io_cpu_flush_ready                            (dataCache_1__io_cpu_flush_ready                             ), //o
    .io_mem_cmd_valid                              (dataCache_1__io_mem_cmd_valid                               ), //o
    .io_mem_cmd_ready                              (_zz_581_                                                    ), //i
    .io_mem_cmd_payload_wr                         (dataCache_1__io_mem_cmd_payload_wr                          ), //o
    .io_mem_cmd_payload_address                    (dataCache_1__io_mem_cmd_payload_address[31:0]               ), //o
    .io_mem_cmd_payload_data                       (dataCache_1__io_mem_cmd_payload_data[31:0]                  ), //o
    .io_mem_cmd_payload_mask                       (dataCache_1__io_mem_cmd_payload_mask[3:0]                   ), //o
    .io_mem_cmd_payload_length                     (dataCache_1__io_mem_cmd_payload_length[2:0]                 ), //o
    .io_mem_cmd_payload_last                       (dataCache_1__io_mem_cmd_payload_last                        ), //o
    .io_mem_rsp_valid                              (dBus_rsp_valid                                              ), //i
    .io_mem_rsp_payload_data                       (dBus_rsp_payload_data[31:0]                                 ), //i
    .io_mem_rsp_payload_error                      (dBus_rsp_payload_error                                      ), //i
    .clk                                           (clk                                                         ), //i
    .reset                                         (reset                                                       )  //i
  );
  always @(*) begin
    case(_zz_864_)
      2'b00 : begin
        _zz_584_ = DBusCachedPlugin_redoBranch_payload;
      end
      2'b01 : begin
        _zz_584_ = CsrPlugin_jumpInterface_payload;
      end
      2'b10 : begin
        _zz_584_ = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_584_ = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  always @(*) begin
    case(_zz_865_)
      4'b0000 : begin
        _zz_585_ = _zz_96_;
      end
      4'b0001 : begin
        _zz_585_ = _zz_112_;
      end
      4'b0010 : begin
        _zz_585_ = _zz_128_;
      end
      4'b0011 : begin
        _zz_585_ = _zz_144_;
      end
      4'b0100 : begin
        _zz_585_ = _zz_160_;
      end
      4'b0101 : begin
        _zz_585_ = _zz_176_;
      end
      4'b0110 : begin
        _zz_585_ = _zz_192_;
      end
      4'b0111 : begin
        _zz_585_ = _zz_208_;
      end
      4'b1000 : begin
        _zz_585_ = _zz_224_;
      end
      4'b1001 : begin
        _zz_585_ = _zz_240_;
      end
      4'b1010 : begin
        _zz_585_ = _zz_256_;
      end
      4'b1011 : begin
        _zz_585_ = _zz_272_;
      end
      4'b1100 : begin
        _zz_585_ = _zz_288_;
      end
      4'b1101 : begin
        _zz_585_ = _zz_304_;
      end
      4'b1110 : begin
        _zz_585_ = _zz_320_;
      end
      default : begin
        _zz_585_ = _zz_336_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_866_)
      4'b0000 : begin
        _zz_586_ = _zz_97_;
      end
      4'b0001 : begin
        _zz_586_ = _zz_113_;
      end
      4'b0010 : begin
        _zz_586_ = _zz_129_;
      end
      4'b0011 : begin
        _zz_586_ = _zz_145_;
      end
      4'b0100 : begin
        _zz_586_ = _zz_161_;
      end
      4'b0101 : begin
        _zz_586_ = _zz_177_;
      end
      4'b0110 : begin
        _zz_586_ = _zz_193_;
      end
      4'b0111 : begin
        _zz_586_ = _zz_209_;
      end
      4'b1000 : begin
        _zz_586_ = _zz_225_;
      end
      4'b1001 : begin
        _zz_586_ = _zz_241_;
      end
      4'b1010 : begin
        _zz_586_ = _zz_257_;
      end
      4'b1011 : begin
        _zz_586_ = _zz_273_;
      end
      4'b1100 : begin
        _zz_586_ = _zz_289_;
      end
      4'b1101 : begin
        _zz_586_ = _zz_305_;
      end
      4'b1110 : begin
        _zz_586_ = _zz_321_;
      end
      default : begin
        _zz_586_ = _zz_337_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_867_)
      4'b0000 : begin
        _zz_587_ = _zz_98_;
      end
      4'b0001 : begin
        _zz_587_ = _zz_114_;
      end
      4'b0010 : begin
        _zz_587_ = _zz_130_;
      end
      4'b0011 : begin
        _zz_587_ = _zz_146_;
      end
      4'b0100 : begin
        _zz_587_ = _zz_162_;
      end
      4'b0101 : begin
        _zz_587_ = _zz_178_;
      end
      4'b0110 : begin
        _zz_587_ = _zz_194_;
      end
      4'b0111 : begin
        _zz_587_ = _zz_210_;
      end
      4'b1000 : begin
        _zz_587_ = _zz_226_;
      end
      4'b1001 : begin
        _zz_587_ = _zz_242_;
      end
      4'b1010 : begin
        _zz_587_ = _zz_258_;
      end
      4'b1011 : begin
        _zz_587_ = _zz_274_;
      end
      4'b1100 : begin
        _zz_587_ = _zz_290_;
      end
      4'b1101 : begin
        _zz_587_ = _zz_306_;
      end
      4'b1110 : begin
        _zz_587_ = _zz_322_;
      end
      default : begin
        _zz_587_ = _zz_338_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_868_)
      4'b0000 : begin
        _zz_588_ = _zz_96_;
      end
      4'b0001 : begin
        _zz_588_ = _zz_112_;
      end
      4'b0010 : begin
        _zz_588_ = _zz_128_;
      end
      4'b0011 : begin
        _zz_588_ = _zz_144_;
      end
      4'b0100 : begin
        _zz_588_ = _zz_160_;
      end
      4'b0101 : begin
        _zz_588_ = _zz_176_;
      end
      4'b0110 : begin
        _zz_588_ = _zz_192_;
      end
      4'b0111 : begin
        _zz_588_ = _zz_208_;
      end
      4'b1000 : begin
        _zz_588_ = _zz_224_;
      end
      4'b1001 : begin
        _zz_588_ = _zz_240_;
      end
      4'b1010 : begin
        _zz_588_ = _zz_256_;
      end
      4'b1011 : begin
        _zz_588_ = _zz_272_;
      end
      4'b1100 : begin
        _zz_588_ = _zz_288_;
      end
      4'b1101 : begin
        _zz_588_ = _zz_304_;
      end
      4'b1110 : begin
        _zz_588_ = _zz_320_;
      end
      default : begin
        _zz_588_ = _zz_336_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_869_)
      4'b0000 : begin
        _zz_589_ = _zz_97_;
      end
      4'b0001 : begin
        _zz_589_ = _zz_113_;
      end
      4'b0010 : begin
        _zz_589_ = _zz_129_;
      end
      4'b0011 : begin
        _zz_589_ = _zz_145_;
      end
      4'b0100 : begin
        _zz_589_ = _zz_161_;
      end
      4'b0101 : begin
        _zz_589_ = _zz_177_;
      end
      4'b0110 : begin
        _zz_589_ = _zz_193_;
      end
      4'b0111 : begin
        _zz_589_ = _zz_209_;
      end
      4'b1000 : begin
        _zz_589_ = _zz_225_;
      end
      4'b1001 : begin
        _zz_589_ = _zz_241_;
      end
      4'b1010 : begin
        _zz_589_ = _zz_257_;
      end
      4'b1011 : begin
        _zz_589_ = _zz_273_;
      end
      4'b1100 : begin
        _zz_589_ = _zz_289_;
      end
      4'b1101 : begin
        _zz_589_ = _zz_305_;
      end
      4'b1110 : begin
        _zz_589_ = _zz_321_;
      end
      default : begin
        _zz_589_ = _zz_337_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_870_)
      4'b0000 : begin
        _zz_590_ = _zz_98_;
      end
      4'b0001 : begin
        _zz_590_ = _zz_114_;
      end
      4'b0010 : begin
        _zz_590_ = _zz_130_;
      end
      4'b0011 : begin
        _zz_590_ = _zz_146_;
      end
      4'b0100 : begin
        _zz_590_ = _zz_162_;
      end
      4'b0101 : begin
        _zz_590_ = _zz_178_;
      end
      4'b0110 : begin
        _zz_590_ = _zz_194_;
      end
      4'b0111 : begin
        _zz_590_ = _zz_210_;
      end
      4'b1000 : begin
        _zz_590_ = _zz_226_;
      end
      4'b1001 : begin
        _zz_590_ = _zz_242_;
      end
      4'b1010 : begin
        _zz_590_ = _zz_258_;
      end
      4'b1011 : begin
        _zz_590_ = _zz_274_;
      end
      4'b1100 : begin
        _zz_590_ = _zz_290_;
      end
      4'b1101 : begin
        _zz_590_ = _zz_306_;
      end
      4'b1110 : begin
        _zz_590_ = _zz_322_;
      end
      default : begin
        _zz_590_ = _zz_338_;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(_zz_1_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_1__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_1__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_1__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_1__string = "SRA_1    ";
      default : _zz_1__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_2__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_2__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_2__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_2__string = "SRA_1    ";
      default : _zz_2__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_3__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_3__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_3__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_3__string = "SRA_1    ";
      default : _zz_3__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_4__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_4__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_4__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_4__string = "SRA_1    ";
      default : _zz_4__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_5__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_5__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_5__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_5__string = "SRA_1    ";
      default : _zz_5__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_6__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_6__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_6__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_6__string = "URS1        ";
      default : _zz_6__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_7__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_7__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_7__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_7__string = "URS1        ";
      default : _zz_7__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_8__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_8__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_8__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_8__string = "URS1        ";
      default : _zz_8__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_9__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_9__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_9__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_9__string = "ECALL";
      default : _zz_9__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_10__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_10__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_10__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_10__string = "ECALL";
      default : _zz_10__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_11__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_11__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_11__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_11__string = "ECALL";
      default : _zz_11__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_12__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_12__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_12__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_12__string = "ECALL";
      default : _zz_12__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : decode_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_ENV_CTRL_string = "ECALL";
      default : decode_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_13__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_13__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_13__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_13__string = "ECALL";
      default : _zz_13__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_14_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_14__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_14__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_14__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_14__string = "ECALL";
      default : _zz_14__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_15__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_15__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_15__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_15__string = "ECALL";
      default : _zz_15__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_16__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_16__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_16__string = "BITWISE ";
      default : _zz_16__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_17__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_17__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_17__string = "BITWISE ";
      default : _zz_17__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_18__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_18__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_18__string = "BITWISE ";
      default : _zz_18__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_19__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_19__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_19__string = "AND_1";
      default : _zz_19__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_20__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_20__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_20__string = "AND_1";
      default : _zz_20__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_21__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_21__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_21__string = "AND_1";
      default : _zz_21__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_22__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_22__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_22__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_22__string = "PC ";
      default : _zz_22__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_23__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_23__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_23__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_23__string = "PC ";
      default : _zz_23__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_24__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_24__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_24__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_24__string = "PC ";
      default : _zz_24__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_25_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_25__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_25__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_25__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_25__string = "JALR";
      default : _zz_25__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_26_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_26__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_26__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_26__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_26__string = "JALR";
      default : _zz_26__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : memory_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_ENV_CTRL_string = "ECALL";
      default : memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_27_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_27__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_27__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_27__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_27__string = "ECALL";
      default : _zz_27__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : execute_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_ENV_CTRL_string = "ECALL";
      default : execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_28_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_28__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_28__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_28__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_28__string = "ECALL";
      default : _zz_28__string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : writeBack_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : writeBack_ENV_CTRL_string = "ECALL";
      default : writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_29_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_29__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_29__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_29__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_29__string = "ECALL";
      default : _zz_29__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_30_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_30__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_30__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_30__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_30__string = "JALR";
      default : _zz_30__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : memory_SHIFT_CTRL_string = "SRA_1    ";
      default : memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_33_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_33__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_33__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_33__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_33__string = "SRA_1    ";
      default : _zz_33__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_34_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_34__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_34__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_34__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_34__string = "SRA_1    ";
      default : _zz_34__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_36_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_36__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_36__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_36__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_36__string = "PC ";
      default : _zz_36__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_37_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_37__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_37__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_37__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_37__string = "URS1        ";
      default : _zz_37__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_38_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_38__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_38__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_38__string = "BITWISE ";
      default : _zz_38__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_39_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_39__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_39__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_39__string = "AND_1";
      default : _zz_39__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_43_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_43__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_43__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_43__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_43__string = "ECALL";
      default : _zz_43__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_44_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_44__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_44__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_44__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_44__string = "PC ";
      default : _zz_44__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_45_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_45__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_45__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_45__string = "BITWISE ";
      default : _zz_45__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_46_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_46__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_46__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_46__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_46__string = "SRA_1    ";
      default : _zz_46__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_47_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_47__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_47__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_47__string = "AND_1";
      default : _zz_47__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_48__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_48__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_48__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_48__string = "URS1        ";
      default : _zz_48__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_49_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_49__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_49__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_49__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_49__string = "JALR";
      default : _zz_49__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_54_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_54__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_54__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_54__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_54__string = "JALR";
      default : _zz_54__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_453_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_453__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_453__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_453__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_453__string = "JALR";
      default : _zz_453__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_454_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_454__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_454__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_454__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_454__string = "URS1        ";
      default : _zz_454__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_455_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_455__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_455__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_455__string = "AND_1";
      default : _zz_455__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_456_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_456__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_456__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_456__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_456__string = "SRA_1    ";
      default : _zz_456__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_457_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_457__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_457__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_457__string = "BITWISE ";
      default : _zz_457__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_458_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_458__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_458__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_458__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_458__string = "PC ";
      default : _zz_458__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_459_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_459__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_459__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_459__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_459__string = "ECALL";
      default : _zz_459__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : decode_to_execute_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_to_execute_ENV_CTRL_string = "ECALL";
      default : decode_to_execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : execute_to_memory_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_to_memory_ENV_CTRL_string = "ECALL";
      default : execute_to_memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : memory_to_writeBack_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_to_writeBack_ENV_CTRL_string = "ECALL";
      default : memory_to_writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  `endif

  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_650_[0];
  assign _zz_1_ = _zz_2_;
  assign decode_SHIFT_CTRL = _zz_3_;
  assign _zz_4_ = _zz_5_;
  assign decode_SRC1_CTRL = _zz_6_;
  assign _zz_7_ = _zz_8_;
  assign decode_IS_RS1_SIGNED = _zz_651_[0];
  assign memory_MUL_LOW = ($signed(_zz_652_) + $signed(_zz_660_));
  assign _zz_9_ = _zz_10_;
  assign _zz_11_ = _zz_12_;
  assign decode_ENV_CTRL = _zz_13_;
  assign _zz_14_ = _zz_15_;
  assign decode_SRC_LESS_UNSIGNED = _zz_661_[0];
  assign memory_MEMORY_WR = execute_to_memory_MEMORY_WR;
  assign decode_MEMORY_WR = _zz_662_[0];
  assign decode_IS_CSR = _zz_663_[0];
  assign execute_MUL_HL = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bSLow));
  assign execute_MUL_LL = (execute_MulPlugin_aULow * execute_MulPlugin_bULow);
  assign decode_ALU_CTRL = _zz_16_;
  assign _zz_17_ = _zz_18_;
  assign decode_MEMORY_MANAGMENT = _zz_664_[0];
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign decode_IS_RS2_SIGNED = _zz_665_[0];
  assign decode_IS_DIV = _zz_666_[0];
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign memory_PC = execute_to_memory_PC;
  assign decode_ALU_BITWISE_CTRL = _zz_19_;
  assign _zz_20_ = _zz_21_;
  assign decode_CSR_WRITE_OPCODE = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == 5'h0)) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == 5'h0))));
  assign decode_DO_EBREAK = (((! DebugPlugin_haltIt) && (decode_IS_EBREAK || 1'b0)) && DebugPlugin_allowEBreak);
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + 32'h00000004);
  assign execute_SHIFT_RIGHT = _zz_668_;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_573_[1 : 0];
  assign execute_REGFILE_WRITE_DATA = _zz_461_;
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_670_[0];
  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign execute_MUL_LH = ($signed(execute_MulPlugin_aSLow) * $signed(execute_MulPlugin_bHigh));
  assign memory_MUL_HH = execute_to_memory_MUL_HH;
  assign execute_MUL_HH = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bHigh));
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign decode_SRC2_CTRL = _zz_22_;
  assign _zz_23_ = _zz_24_;
  assign decode_CSR_READ_OPCODE = (decode_INSTRUCTION[13 : 7] != 7'h20);
  assign _zz_25_ = _zz_26_;
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign decode_IS_MUL = _zz_671_[0];
  assign execute_DO_EBREAK = decode_to_execute_DO_EBREAK;
  assign decode_IS_EBREAK = _zz_672_[0];
  assign execute_IS_RS1_SIGNED = decode_to_execute_IS_RS1_SIGNED;
  assign execute_IS_DIV = decode_to_execute_IS_DIV;
  assign execute_IS_RS2_SIGNED = decode_to_execute_IS_RS2_SIGNED;
  assign memory_IS_DIV = execute_to_memory_IS_DIV;
  assign writeBack_IS_MUL = memory_to_writeBack_IS_MUL;
  assign writeBack_MUL_HH = memory_to_writeBack_MUL_HH;
  assign writeBack_MUL_LOW = memory_to_writeBack_MUL_LOW;
  assign memory_MUL_HL = execute_to_memory_MUL_HL;
  assign memory_MUL_LH = execute_to_memory_MUL_LH;
  assign memory_MUL_LL = execute_to_memory_MUL_LL;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_27_;
  assign execute_ENV_CTRL = _zz_28_;
  assign writeBack_ENV_CTRL = _zz_29_;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_PC = decode_to_execute_PC;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_COND_RESULT = _zz_483_;
  assign execute_BRANCH_CTRL = _zz_30_;
  assign decode_RS2_USE = _zz_673_[0];
  assign decode_RS1_USE = _zz_674_[0];
  always @ (*) begin
    _zz_31_ = execute_REGFILE_WRITE_DATA;
    if(_zz_591_)begin
      _zz_31_ = execute_CsrPlugin_readData;
    end
  end

  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(_zz_472_)begin
      if((_zz_473_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_474_;
      end
    end
    if(_zz_592_)begin
      if(_zz_593_)begin
        if(_zz_476_)begin
          decode_RS2 = _zz_52_;
        end
      end
    end
    if(_zz_594_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_478_)begin
          decode_RS2 = _zz_32_;
        end
      end
    end
    if(_zz_595_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_480_)begin
          decode_RS2 = _zz_31_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(_zz_472_)begin
      if((_zz_473_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_474_;
      end
    end
    if(_zz_592_)begin
      if(_zz_593_)begin
        if(_zz_475_)begin
          decode_RS1 = _zz_52_;
        end
      end
    end
    if(_zz_594_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_477_)begin
          decode_RS1 = _zz_32_;
        end
      end
    end
    if(_zz_595_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_479_)begin
          decode_RS1 = _zz_31_;
        end
      end
    end
  end

  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_32_ = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_32_ = _zz_469_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_32_ = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if(_zz_596_)begin
      _zz_32_ = memory_DivPlugin_div_result;
    end
  end

  assign memory_SHIFT_CTRL = _zz_33_;
  assign execute_SHIFT_CTRL = _zz_34_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_35_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_36_;
  assign execute_SRC1_CTRL = _zz_37_;
  assign decode_SRC_USE_SUB_LESS = _zz_675_[0];
  assign decode_SRC_ADD_ZERO = _zz_676_[0];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_38_;
  assign execute_SRC2 = _zz_467_;
  assign execute_SRC1 = _zz_462_;
  assign execute_ALU_BITWISE_CTRL = _zz_39_;
  assign _zz_40_ = writeBack_INSTRUCTION;
  assign _zz_41_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_42_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_42_ = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_677_[0];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = ({((decode_INSTRUCTION & 32'h0000005f) == 32'h00000017),{((decode_INSTRUCTION & 32'h0000007f) == 32'h0000006f),{((decode_INSTRUCTION & 32'h0000106f) == 32'h00000003),{((decode_INSTRUCTION & _zz_871_) == 32'h00001073),{(_zz_872_ == _zz_873_),{_zz_874_,{_zz_875_,_zz_876_}}}}}}} != 21'h0);
  always @ (*) begin
    _zz_50_ = _zz_50__14;
    if(PmpPlugin_ports_1_hits_15)begin
      _zz_50_ = (_zz_50__14 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__14 = _zz_50__13;
    if(PmpPlugin_ports_1_hits_14)begin
      _zz_50__14 = (_zz_50__13 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__13 = _zz_50__12;
    if(PmpPlugin_ports_1_hits_13)begin
      _zz_50__13 = (_zz_50__12 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__12 = _zz_50__11;
    if(PmpPlugin_ports_1_hits_12)begin
      _zz_50__12 = (_zz_50__11 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__11 = _zz_50__10;
    if(PmpPlugin_ports_1_hits_11)begin
      _zz_50__11 = (_zz_50__10 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__10 = _zz_50__9;
    if(PmpPlugin_ports_1_hits_10)begin
      _zz_50__10 = (_zz_50__9 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__9 = _zz_50__8;
    if(PmpPlugin_ports_1_hits_9)begin
      _zz_50__9 = (_zz_50__8 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__8 = _zz_50__7;
    if(PmpPlugin_ports_1_hits_8)begin
      _zz_50__8 = (_zz_50__7 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__7 = _zz_50__6;
    if(PmpPlugin_ports_1_hits_7)begin
      _zz_50__7 = (_zz_50__6 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__6 = _zz_50__5;
    if(PmpPlugin_ports_1_hits_6)begin
      _zz_50__6 = (_zz_50__5 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__5 = _zz_50__4;
    if(PmpPlugin_ports_1_hits_5)begin
      _zz_50__5 = (_zz_50__4 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__4 = _zz_50__3;
    if(PmpPlugin_ports_1_hits_4)begin
      _zz_50__4 = (_zz_50__3 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__3 = _zz_50__2;
    if(PmpPlugin_ports_1_hits_3)begin
      _zz_50__3 = (_zz_50__2 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__2 = _zz_50__1;
    if(PmpPlugin_ports_1_hits_2)begin
      _zz_50__2 = (_zz_50__1 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__1 = _zz_50__0;
    if(PmpPlugin_ports_1_hits_1)begin
      _zz_50__1 = (_zz_50__0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__0 = 5'h0;
    if(PmpPlugin_ports_1_hits_0)begin
      _zz_50__0 = (5'h0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51_ = _zz_51__14;
    if(PmpPlugin_ports_0_hits_15)begin
      _zz_51_ = (_zz_51__14 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__14 = _zz_51__13;
    if(PmpPlugin_ports_0_hits_14)begin
      _zz_51__14 = (_zz_51__13 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__13 = _zz_51__12;
    if(PmpPlugin_ports_0_hits_13)begin
      _zz_51__13 = (_zz_51__12 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__12 = _zz_51__11;
    if(PmpPlugin_ports_0_hits_12)begin
      _zz_51__12 = (_zz_51__11 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__11 = _zz_51__10;
    if(PmpPlugin_ports_0_hits_11)begin
      _zz_51__11 = (_zz_51__10 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__10 = _zz_51__9;
    if(PmpPlugin_ports_0_hits_10)begin
      _zz_51__10 = (_zz_51__9 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__9 = _zz_51__8;
    if(PmpPlugin_ports_0_hits_9)begin
      _zz_51__9 = (_zz_51__8 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__8 = _zz_51__7;
    if(PmpPlugin_ports_0_hits_8)begin
      _zz_51__8 = (_zz_51__7 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__7 = _zz_51__6;
    if(PmpPlugin_ports_0_hits_7)begin
      _zz_51__7 = (_zz_51__6 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__6 = _zz_51__5;
    if(PmpPlugin_ports_0_hits_6)begin
      _zz_51__6 = (_zz_51__5 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__5 = _zz_51__4;
    if(PmpPlugin_ports_0_hits_5)begin
      _zz_51__5 = (_zz_51__4 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__4 = _zz_51__3;
    if(PmpPlugin_ports_0_hits_4)begin
      _zz_51__4 = (_zz_51__3 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__3 = _zz_51__2;
    if(PmpPlugin_ports_0_hits_3)begin
      _zz_51__3 = (_zz_51__2 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__2 = _zz_51__1;
    if(PmpPlugin_ports_0_hits_2)begin
      _zz_51__2 = (_zz_51__1 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__1 = _zz_51__0;
    if(PmpPlugin_ports_0_hits_1)begin
      _zz_51__1 = (_zz_51__0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__0 = 5'h0;
    if(PmpPlugin_ports_0_hits_0)begin
      _zz_51__0 = (5'h0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_52_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_52_ = writeBack_DBusCachedPlugin_rspFormated;
    end
    if((writeBack_arbitration_isValid && writeBack_IS_MUL))begin
      case(_zz_649_)
        2'b00 : begin
          _zz_52_ = _zz_773_;
        end
        default : begin
          _zz_52_ = _zz_774_;
        end
      endcase
    end
  end

  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_WR = memory_to_writeBack_MEMORY_WR;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_MEMORY_MANAGMENT = decode_to_execute_MEMORY_MANAGMENT;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_MEMORY_WR = decode_to_execute_MEMORY_WR;
  assign execute_SRC_ADD = execute_SrcPlugin_addSub;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign decode_MEMORY_ENABLE = _zz_678_[0];
  assign decode_FLUSH_ALL = _zz_679_[0];
  always @ (*) begin
    _zz_53_ = _zz_53__2;
    if(_zz_597_)begin
      _zz_53_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53__2 = _zz_53__1;
    if(_zz_598_)begin
      _zz_53__2 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53__1 = _zz_53__0;
    if(_zz_599_)begin
      _zz_53__1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53__0 = IBusCachedPlugin_rsp_issueDetected;
    if(_zz_600_)begin
      _zz_53__0 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_54_;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @ (*) begin
    _zz_55_ = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_55_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_56_ = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_56_ = IBusCachedPlugin_predictionJumpInterface_payload;
    end
  end

  assign decode_PC = IBusCachedPlugin_iBusRsp_output_payload_pc;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @ (*) begin
    decode_arbitration_haltItself = 1'b0;
    if(((DBusCachedPlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE))begin
      decode_arbitration_haltItself = 1'b1;
    end
    case(_zz_511_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
        decode_arbitration_haltItself = 1'b1;
      end
      3'b011 : begin
      end
      3'b100 : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((decode_arbitration_isValid && (_zz_470_ || _zz_471_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if(CsrPlugin_pipelineLiberator_active)begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(_zz_601_)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
    if(_zz_601_)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if((_zz_580_ && (! dataCache_1__io_cpu_flush_ready)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(((dataCache_1__io_cpu_redo && execute_arbitration_isValid) && execute_MEMORY_ENABLE))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_602_)begin
      if((! execute_CsrPlugin_wfiWake))begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
    if(_zz_591_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_arbitration_haltByOther = 1'b0;
    if(_zz_603_)begin
      execute_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_flushIt = 1'b0;
    if(_zz_603_)begin
      if(_zz_604_)begin
        execute_arbitration_flushIt = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
    if(_zz_603_)begin
      if(_zz_604_)begin
        execute_arbitration_flushNext = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if(_zz_596_)begin
      if(((! memory_DivPlugin_frontendOk) || (! memory_DivPlugin_div_done)))begin
        memory_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(BranchPlugin_branchExceptionPort_valid)begin
      memory_arbitration_removeIt = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
    if(BranchPlugin_branchExceptionPort_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_haltItself = 1'b0;
    if(dataCache_1__io_cpu_writeBack_haltIt)begin
      writeBack_arbitration_haltItself = 1'b1;
    end
  end

  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushIt = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_605_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_606_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusCachedPlugin_fetcherHalt = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValids_memory,{CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_605_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_606_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_603_)begin
      if(_zz_604_)begin
        IBusCachedPlugin_fetcherHalt = 1'b1;
      end
    end
    if(DebugPlugin_haltIt)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_607_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if((IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_stages_2_input_valid))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  always @ (*) begin
    _zz_57_ = 1'b0;
    if(DebugPlugin_godmode)begin
      _zz_57_ = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_inWfi = 1'b0;
    if(_zz_602_)begin
      CsrPlugin_inWfi = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_thirdPartyWake = 1'b0;
    if(DebugPlugin_haltIt)begin
      CsrPlugin_thirdPartyWake = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_605_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_606_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = 32'h0;
    if(_zz_605_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_606_)begin
      case(_zz_608_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  always @ (*) begin
    CsrPlugin_forceMachineWire = 1'b0;
    if(DebugPlugin_godmode)begin
      CsrPlugin_forceMachineWire = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_allowInterrupts = 1'b1;
    if((DebugPlugin_haltIt || DebugPlugin_stepIt))begin
      CsrPlugin_allowInterrupts = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_allowException = 1'b1;
    if(DebugPlugin_godmode)begin
      CsrPlugin_allowException = 1'b0;
    end
  end

  assign IBusCachedPlugin_externalFlush = ({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000));
  assign IBusCachedPlugin_jump_pcLoad_valid = ({CsrPlugin_jumpInterface_valid,{BranchPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}}} != (4'b0000));
  assign _zz_58_ = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}}};
  assign _zz_59_ = (_zz_58_ & (~ _zz_680_));
  assign _zz_60_ = _zz_59_[3];
  assign _zz_61_ = (_zz_59_[1] || _zz_60_);
  assign _zz_62_ = (_zz_59_[2] || _zz_60_);
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_584_;
  always @ (*) begin
    IBusCachedPlugin_fetchPc_correction = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_corrected = (IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_correctionReg);
  always @ (*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_682_);
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_fetchPc_redo_payload;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
    IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_flushed = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_redoFetch = 1'b0;
    if(IBusCachedPlugin_rsp_redoFetch)begin
      IBusCachedPlugin_iBusRsp_redoFetch = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_63_ = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_63_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_63_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_fetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_64_ = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_64_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_64_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((_zz_53_ || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_65_ = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_65_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_65_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_66_;
  assign _zz_66_ = ((1'b0 && (! _zz_67_)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_67_ = _zz_68_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_67_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_69_)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_69_ = _zz_70_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_69_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_71_;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if((! IBusCachedPlugin_pcValids_0))begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_4;
  assign IBusCachedPlugin_iBusRsp_output_ready = (! decode_arbitration_isStuck);
  always @ (*) begin
    decode_arbitration_isValid = IBusCachedPlugin_iBusRsp_output_valid;
    case(_zz_511_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
        decode_arbitration_isValid = 1'b1;
      end
      3'b011 : begin
        decode_arbitration_isValid = 1'b1;
      end
      3'b100 : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_72_ = _zz_683_[11];
  always @ (*) begin
    _zz_73_[18] = _zz_72_;
    _zz_73_[17] = _zz_72_;
    _zz_73_[16] = _zz_72_;
    _zz_73_[15] = _zz_72_;
    _zz_73_[14] = _zz_72_;
    _zz_73_[13] = _zz_72_;
    _zz_73_[12] = _zz_72_;
    _zz_73_[11] = _zz_72_;
    _zz_73_[10] = _zz_72_;
    _zz_73_[9] = _zz_72_;
    _zz_73_[8] = _zz_72_;
    _zz_73_[7] = _zz_72_;
    _zz_73_[6] = _zz_72_;
    _zz_73_[5] = _zz_72_;
    _zz_73_[4] = _zz_72_;
    _zz_73_[3] = _zz_72_;
    _zz_73_[2] = _zz_72_;
    _zz_73_[1] = _zz_72_;
    _zz_73_[0] = _zz_72_;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_684_[31]));
    if(_zz_78_)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_74_ = _zz_685_[19];
  always @ (*) begin
    _zz_75_[10] = _zz_74_;
    _zz_75_[9] = _zz_74_;
    _zz_75_[8] = _zz_74_;
    _zz_75_[7] = _zz_74_;
    _zz_75_[6] = _zz_74_;
    _zz_75_[5] = _zz_74_;
    _zz_75_[4] = _zz_74_;
    _zz_75_[3] = _zz_74_;
    _zz_75_[2] = _zz_74_;
    _zz_75_[1] = _zz_74_;
    _zz_75_[0] = _zz_74_;
  end

  assign _zz_76_ = _zz_686_[11];
  always @ (*) begin
    _zz_77_[18] = _zz_76_;
    _zz_77_[17] = _zz_76_;
    _zz_77_[16] = _zz_76_;
    _zz_77_[15] = _zz_76_;
    _zz_77_[14] = _zz_76_;
    _zz_77_[13] = _zz_76_;
    _zz_77_[12] = _zz_76_;
    _zz_77_[11] = _zz_76_;
    _zz_77_[10] = _zz_76_;
    _zz_77_[9] = _zz_76_;
    _zz_77_[8] = _zz_76_;
    _zz_77_[7] = _zz_76_;
    _zz_77_[6] = _zz_76_;
    _zz_77_[5] = _zz_76_;
    _zz_77_[4] = _zz_76_;
    _zz_77_[3] = _zz_76_;
    _zz_77_[2] = _zz_76_;
    _zz_77_[1] = _zz_76_;
    _zz_77_[0] = _zz_76_;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_78_ = _zz_687_[1];
      end
      default : begin
        _zz_78_ = _zz_688_[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_79_ = _zz_689_[19];
  always @ (*) begin
    _zz_80_[10] = _zz_79_;
    _zz_80_[9] = _zz_79_;
    _zz_80_[8] = _zz_79_;
    _zz_80_[7] = _zz_79_;
    _zz_80_[6] = _zz_79_;
    _zz_80_[5] = _zz_79_;
    _zz_80_[4] = _zz_79_;
    _zz_80_[3] = _zz_79_;
    _zz_80_[2] = _zz_79_;
    _zz_80_[1] = _zz_79_;
    _zz_80_[0] = _zz_79_;
  end

  assign _zz_81_ = _zz_690_[11];
  always @ (*) begin
    _zz_82_[18] = _zz_81_;
    _zz_82_[17] = _zz_81_;
    _zz_82_[16] = _zz_81_;
    _zz_82_[15] = _zz_81_;
    _zz_82_[14] = _zz_81_;
    _zz_82_[13] = _zz_81_;
    _zz_82_[12] = _zz_81_;
    _zz_82_[11] = _zz_81_;
    _zz_82_[10] = _zz_81_;
    _zz_82_[9] = _zz_81_;
    _zz_82_[8] = _zz_81_;
    _zz_82_[7] = _zz_81_;
    _zz_82_[6] = _zz_81_;
    _zz_82_[5] = _zz_81_;
    _zz_82_[4] = _zz_81_;
    _zz_82_[3] = _zz_81_;
    _zz_82_[2] = _zz_81_;
    _zz_82_[1] = _zz_81_;
    _zz_82_[0] = _zz_81_;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_80_,{{{_zz_889_,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_82_,{{{_zz_890_,_zz_891_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_565_ = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_566_ = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_567_ = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_568_ = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_569_ = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_570_ = (CsrPlugin_privilege == (2'b00));
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_600_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_598_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @ (*) begin
    _zz_571_ = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_598_)begin
      _zz_571_ = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_valid = 1'b0;
    if(_zz_599_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
    if(_zz_597_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_payload_code = (4'bxxxx);
    if(_zz_599_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b1100);
    end
    if(_zz_597_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b0001);
    end
  end

  assign IBusCachedPlugin_decodeExceptionPort_payload_badAddr = {IBusCachedPlugin_iBusRsp_stages_2_input_payload[31 : 2],(2'b00)};
  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign IBusCachedPlugin_mmuBus_cmd_isValid = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  assign IBusCachedPlugin_mmuBus_cmd_virtualAddress = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_cmd_bypassTranslation = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  assign IBusCachedPlugin_mmuBus_end = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  assign _zz_564_ = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dataCache_1__io_mem_cmd_s2mPipe_valid = (dataCache_1__io_mem_cmd_valid || dataCache_1__io_mem_cmd_s2mPipe_rValid);
  assign _zz_581_ = (! dataCache_1__io_mem_cmd_s2mPipe_rValid);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_wr = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_wr : dataCache_1__io_mem_cmd_payload_wr);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_address = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_address : dataCache_1__io_mem_cmd_payload_address);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_data = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_data : dataCache_1__io_mem_cmd_payload_data);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_mask = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_mask : dataCache_1__io_mem_cmd_payload_mask);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_length = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_length : dataCache_1__io_mem_cmd_payload_length);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_last = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_last : dataCache_1__io_mem_cmd_payload_last);
  assign dataCache_1__io_mem_cmd_s2mPipe_ready = ((1'b1 && (! dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid)) || dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready);
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_wr;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_address;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_data;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_mask;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_length;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_last;
  assign dBus_cmd_valid = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready = dBus_cmd_ready;
  assign dBus_cmd_payload_wr = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr;
  assign dBus_cmd_payload_address = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address;
  assign dBus_cmd_payload_data = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data;
  assign dBus_cmd_payload_mask = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask;
  assign dBus_cmd_payload_length = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length;
  assign dBus_cmd_payload_last = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last;
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  assign _zz_572_ = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_573_ = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_85_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_85_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_85_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_580_ = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_574_ = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_575_ = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_isValid = dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  assign DBusCachedPlugin_mmuBus_cmd_virtualAddress = dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  assign DBusCachedPlugin_mmuBus_cmd_bypassTranslation = dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
  always @ (*) begin
    _zz_576_ = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((_zz_57_ && (! dataCache_1__io_cpu_memory_isWrite)))begin
      _zz_576_ = 1'b1;
    end
  end

  assign DBusCachedPlugin_mmuBus_end = dataCache_1__io_cpu_memory_mmuBus_end;
  assign _zz_577_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_578_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_579_ = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if(_zz_609_)begin
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_valid = 1'b0;
    if(_zz_609_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b0;
      end
    end
  end

  assign DBusCachedPlugin_exceptionBus_payload_badAddr = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_payload_code = (4'bxxxx);
    if(_zz_609_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_691_};
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_692_};
      end
      if(dataCache_1__io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_payload_code = (writeBack_MEMORY_WR ? (4'b1111) : (4'b1101));
      end
    end
  end

  always @ (*) begin
    writeBack_DBusCachedPlugin_rspShifted = dataCache_1__io_cpu_writeBack_data;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_1__io_cpu_writeBack_data[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusCachedPlugin_rspShifted[15 : 0] = dataCache_1__io_cpu_writeBack_data[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_1__io_cpu_writeBack_data[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_86_ = (writeBack_DBusCachedPlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_87_[31] = _zz_86_;
    _zz_87_[30] = _zz_86_;
    _zz_87_[29] = _zz_86_;
    _zz_87_[28] = _zz_86_;
    _zz_87_[27] = _zz_86_;
    _zz_87_[26] = _zz_86_;
    _zz_87_[25] = _zz_86_;
    _zz_87_[24] = _zz_86_;
    _zz_87_[23] = _zz_86_;
    _zz_87_[22] = _zz_86_;
    _zz_87_[21] = _zz_86_;
    _zz_87_[20] = _zz_86_;
    _zz_87_[19] = _zz_86_;
    _zz_87_[18] = _zz_86_;
    _zz_87_[17] = _zz_86_;
    _zz_87_[16] = _zz_86_;
    _zz_87_[15] = _zz_86_;
    _zz_87_[14] = _zz_86_;
    _zz_87_[13] = _zz_86_;
    _zz_87_[12] = _zz_86_;
    _zz_87_[11] = _zz_86_;
    _zz_87_[10] = _zz_86_;
    _zz_87_[9] = _zz_86_;
    _zz_87_[8] = _zz_86_;
    _zz_87_[7 : 0] = writeBack_DBusCachedPlugin_rspShifted[7 : 0];
  end

  assign _zz_88_ = (writeBack_DBusCachedPlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_89_[31] = _zz_88_;
    _zz_89_[30] = _zz_88_;
    _zz_89_[29] = _zz_88_;
    _zz_89_[28] = _zz_88_;
    _zz_89_[27] = _zz_88_;
    _zz_89_[26] = _zz_88_;
    _zz_89_[25] = _zz_88_;
    _zz_89_[24] = _zz_88_;
    _zz_89_[23] = _zz_88_;
    _zz_89_[22] = _zz_88_;
    _zz_89_[21] = _zz_88_;
    _zz_89_[20] = _zz_88_;
    _zz_89_[19] = _zz_88_;
    _zz_89_[18] = _zz_88_;
    _zz_89_[17] = _zz_88_;
    _zz_89_[16] = _zz_88_;
    _zz_89_[15 : 0] = writeBack_DBusCachedPlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_647_)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_87_;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_89_;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspShifted;
      end
    endcase
  end

  assign _zz_103_ = (_zz_95_ <<< 2);
  assign _zz_104_ = (_zz_95_ & (~ _zz_693_));
  assign _zz_105_ = ((_zz_95_ & (~ _zz_104_)) <<< 2);
  assign _zz_119_ = (_zz_111_ <<< 2);
  assign _zz_120_ = (_zz_111_ & (~ _zz_696_));
  assign _zz_121_ = ((_zz_111_ & (~ _zz_120_)) <<< 2);
  assign _zz_135_ = (_zz_127_ <<< 2);
  assign _zz_136_ = (_zz_127_ & (~ _zz_699_));
  assign _zz_137_ = ((_zz_127_ & (~ _zz_136_)) <<< 2);
  assign _zz_151_ = (_zz_143_ <<< 2);
  assign _zz_152_ = (_zz_143_ & (~ _zz_702_));
  assign _zz_153_ = ((_zz_143_ & (~ _zz_152_)) <<< 2);
  assign _zz_167_ = (_zz_159_ <<< 2);
  assign _zz_168_ = (_zz_159_ & (~ _zz_705_));
  assign _zz_169_ = ((_zz_159_ & (~ _zz_168_)) <<< 2);
  assign _zz_183_ = (_zz_175_ <<< 2);
  assign _zz_184_ = (_zz_175_ & (~ _zz_708_));
  assign _zz_185_ = ((_zz_175_ & (~ _zz_184_)) <<< 2);
  assign _zz_199_ = (_zz_191_ <<< 2);
  assign _zz_200_ = (_zz_191_ & (~ _zz_711_));
  assign _zz_201_ = ((_zz_191_ & (~ _zz_200_)) <<< 2);
  assign _zz_215_ = (_zz_207_ <<< 2);
  assign _zz_216_ = (_zz_207_ & (~ _zz_714_));
  assign _zz_217_ = ((_zz_207_ & (~ _zz_216_)) <<< 2);
  assign _zz_231_ = (_zz_223_ <<< 2);
  assign _zz_232_ = (_zz_223_ & (~ _zz_717_));
  assign _zz_233_ = ((_zz_223_ & (~ _zz_232_)) <<< 2);
  assign _zz_247_ = (_zz_239_ <<< 2);
  assign _zz_248_ = (_zz_239_ & (~ _zz_720_));
  assign _zz_249_ = ((_zz_239_ & (~ _zz_248_)) <<< 2);
  assign _zz_263_ = (_zz_255_ <<< 2);
  assign _zz_264_ = (_zz_255_ & (~ _zz_723_));
  assign _zz_265_ = ((_zz_255_ & (~ _zz_264_)) <<< 2);
  assign _zz_279_ = (_zz_271_ <<< 2);
  assign _zz_280_ = (_zz_271_ & (~ _zz_726_));
  assign _zz_281_ = ((_zz_271_ & (~ _zz_280_)) <<< 2);
  assign _zz_295_ = (_zz_287_ <<< 2);
  assign _zz_296_ = (_zz_287_ & (~ _zz_729_));
  assign _zz_297_ = ((_zz_287_ & (~ _zz_296_)) <<< 2);
  assign _zz_311_ = (_zz_303_ <<< 2);
  assign _zz_312_ = (_zz_303_ & (~ _zz_732_));
  assign _zz_313_ = ((_zz_303_ & (~ _zz_312_)) <<< 2);
  assign _zz_327_ = (_zz_319_ <<< 2);
  assign _zz_328_ = (_zz_319_ & (~ _zz_735_));
  assign _zz_329_ = ((_zz_319_ & (~ _zz_328_)) <<< 2);
  assign _zz_343_ = (_zz_335_ <<< 2);
  assign _zz_344_ = (_zz_335_ & (~ _zz_738_));
  assign _zz_345_ = ((_zz_335_ & (~ _zz_344_)) <<< 2);
  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign PmpPlugin_ports_0_hits_0 = (((_zz_100_ && (_zz_101_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_102_)) && (_zz_99_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_1 = (((_zz_116_ && (_zz_117_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_118_)) && (_zz_115_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_2 = (((_zz_132_ && (_zz_133_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_134_)) && (_zz_131_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_3 = (((_zz_148_ && (_zz_149_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_150_)) && (_zz_147_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_4 = (((_zz_164_ && (_zz_165_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_166_)) && (_zz_163_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_5 = (((_zz_180_ && (_zz_181_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_182_)) && (_zz_179_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_6 = (((_zz_196_ && (_zz_197_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_198_)) && (_zz_195_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_7 = (((_zz_212_ && (_zz_213_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_214_)) && (_zz_211_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_8 = (((_zz_228_ && (_zz_229_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_230_)) && (_zz_227_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_9 = (((_zz_244_ && (_zz_245_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_246_)) && (_zz_243_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_10 = (((_zz_260_ && (_zz_261_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_262_)) && (_zz_259_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_11 = (((_zz_276_ && (_zz_277_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_278_)) && (_zz_275_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_12 = (((_zz_292_ && (_zz_293_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_294_)) && (_zz_291_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_13 = (((_zz_308_ && (_zz_309_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_310_)) && (_zz_307_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_14 = (((_zz_324_ && (_zz_325_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_326_)) && (_zz_323_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_15 = (((_zz_340_ && (_zz_341_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_342_)) && (_zz_339_ || (! (CsrPlugin_privilege == (2'b11)))));
  always @ (*) begin
    if(_zz_610_)begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = (CsrPlugin_privilege == (2'b11));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = _zz_585_;
    end
  end

  always @ (*) begin
    if(_zz_610_)begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = (CsrPlugin_privilege == (2'b11));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = _zz_586_;
    end
  end

  always @ (*) begin
    if(_zz_610_)begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = (CsrPlugin_privilege == (2'b11));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = _zz_587_;
    end
  end

  assign _zz_346_ = {PmpPlugin_ports_0_hits_15,{PmpPlugin_ports_0_hits_14,{PmpPlugin_ports_0_hits_13,{PmpPlugin_ports_0_hits_12,{PmpPlugin_ports_0_hits_11,{PmpPlugin_ports_0_hits_10,{PmpPlugin_ports_0_hits_9,{PmpPlugin_ports_0_hits_8,{PmpPlugin_ports_0_hits_7,{PmpPlugin_ports_0_hits_6,{_zz_892_,_zz_893_}}}}}}}}}}};
  assign _zz_347_ = (_zz_346_ & (~ _zz_741_));
  assign _zz_348_ = _zz_347_[3];
  assign _zz_349_ = _zz_347_[5];
  assign _zz_350_ = _zz_347_[6];
  assign _zz_351_ = _zz_347_[7];
  assign _zz_352_ = _zz_347_[9];
  assign _zz_353_ = _zz_347_[10];
  assign _zz_354_ = _zz_347_[11];
  assign _zz_355_ = _zz_347_[12];
  assign _zz_356_ = _zz_347_[13];
  assign _zz_357_ = _zz_347_[14];
  assign _zz_358_ = _zz_347_[15];
  assign _zz_359_ = (((((((_zz_347_[1] || _zz_348_) || _zz_349_) || _zz_351_) || _zz_352_) || _zz_354_) || _zz_356_) || _zz_358_);
  assign _zz_360_ = (((((((_zz_347_[2] || _zz_348_) || _zz_350_) || _zz_351_) || _zz_353_) || _zz_354_) || _zz_357_) || _zz_358_);
  assign _zz_361_ = (((((((_zz_347_[4] || _zz_349_) || _zz_350_) || _zz_351_) || _zz_355_) || _zz_356_) || _zz_357_) || _zz_358_);
  assign _zz_362_ = (((((((_zz_347_[8] || _zz_352_) || _zz_353_) || _zz_354_) || _zz_355_) || _zz_356_) || _zz_357_) || _zz_358_);
  assign _zz_363_ = {PmpPlugin_ports_0_hits_15,{PmpPlugin_ports_0_hits_14,{PmpPlugin_ports_0_hits_13,{PmpPlugin_ports_0_hits_12,{PmpPlugin_ports_0_hits_11,{PmpPlugin_ports_0_hits_10,{PmpPlugin_ports_0_hits_9,{PmpPlugin_ports_0_hits_8,{PmpPlugin_ports_0_hits_7,{PmpPlugin_ports_0_hits_6,{_zz_894_,_zz_895_}}}}}}}}}}};
  assign _zz_364_ = (_zz_363_ & (~ _zz_742_));
  assign _zz_365_ = _zz_364_[3];
  assign _zz_366_ = _zz_364_[5];
  assign _zz_367_ = _zz_364_[6];
  assign _zz_368_ = _zz_364_[7];
  assign _zz_369_ = _zz_364_[9];
  assign _zz_370_ = _zz_364_[10];
  assign _zz_371_ = _zz_364_[11];
  assign _zz_372_ = _zz_364_[12];
  assign _zz_373_ = _zz_364_[13];
  assign _zz_374_ = _zz_364_[14];
  assign _zz_375_ = _zz_364_[15];
  assign _zz_376_ = (((((((_zz_364_[1] || _zz_365_) || _zz_366_) || _zz_368_) || _zz_369_) || _zz_371_) || _zz_373_) || _zz_375_);
  assign _zz_377_ = (((((((_zz_364_[2] || _zz_365_) || _zz_367_) || _zz_368_) || _zz_370_) || _zz_371_) || _zz_374_) || _zz_375_);
  assign _zz_378_ = (((((((_zz_364_[4] || _zz_366_) || _zz_367_) || _zz_368_) || _zz_372_) || _zz_373_) || _zz_374_) || _zz_375_);
  assign _zz_379_ = (((((((_zz_364_[8] || _zz_369_) || _zz_370_) || _zz_371_) || _zz_372_) || _zz_373_) || _zz_374_) || _zz_375_);
  assign _zz_380_ = {PmpPlugin_ports_0_hits_15,{PmpPlugin_ports_0_hits_14,{PmpPlugin_ports_0_hits_13,{PmpPlugin_ports_0_hits_12,{PmpPlugin_ports_0_hits_11,{PmpPlugin_ports_0_hits_10,{PmpPlugin_ports_0_hits_9,{PmpPlugin_ports_0_hits_8,{PmpPlugin_ports_0_hits_7,{PmpPlugin_ports_0_hits_6,{_zz_896_,_zz_897_}}}}}}}}}}};
  assign _zz_381_ = (_zz_380_ & (~ _zz_743_));
  assign _zz_382_ = _zz_381_[3];
  assign _zz_383_ = _zz_381_[5];
  assign _zz_384_ = _zz_381_[6];
  assign _zz_385_ = _zz_381_[7];
  assign _zz_386_ = _zz_381_[9];
  assign _zz_387_ = _zz_381_[10];
  assign _zz_388_ = _zz_381_[11];
  assign _zz_389_ = _zz_381_[12];
  assign _zz_390_ = _zz_381_[13];
  assign _zz_391_ = _zz_381_[14];
  assign _zz_392_ = _zz_381_[15];
  assign _zz_393_ = (((((((_zz_381_[1] || _zz_382_) || _zz_383_) || _zz_385_) || _zz_386_) || _zz_388_) || _zz_390_) || _zz_392_);
  assign _zz_394_ = (((((((_zz_381_[2] || _zz_382_) || _zz_384_) || _zz_385_) || _zz_387_) || _zz_388_) || _zz_391_) || _zz_392_);
  assign _zz_395_ = (((((((_zz_381_[4] || _zz_383_) || _zz_384_) || _zz_385_) || _zz_389_) || _zz_390_) || _zz_391_) || _zz_392_);
  assign _zz_396_ = (((((((_zz_381_[8] || _zz_386_) || _zz_387_) || _zz_388_) || _zz_389_) || _zz_390_) || _zz_391_) || _zz_392_);
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = IBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign PmpPlugin_ports_1_hits_0 = (((_zz_100_ && (_zz_101_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_102_)) && (_zz_99_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_1 = (((_zz_116_ && (_zz_117_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_118_)) && (_zz_115_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_2 = (((_zz_132_ && (_zz_133_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_134_)) && (_zz_131_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_3 = (((_zz_148_ && (_zz_149_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_150_)) && (_zz_147_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_4 = (((_zz_164_ && (_zz_165_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_166_)) && (_zz_163_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_5 = (((_zz_180_ && (_zz_181_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_182_)) && (_zz_179_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_6 = (((_zz_196_ && (_zz_197_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_198_)) && (_zz_195_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_7 = (((_zz_212_ && (_zz_213_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_214_)) && (_zz_211_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_8 = (((_zz_228_ && (_zz_229_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_230_)) && (_zz_227_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_9 = (((_zz_244_ && (_zz_245_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_246_)) && (_zz_243_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_10 = (((_zz_260_ && (_zz_261_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_262_)) && (_zz_259_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_11 = (((_zz_276_ && (_zz_277_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_278_)) && (_zz_275_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_12 = (((_zz_292_ && (_zz_293_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_294_)) && (_zz_291_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_13 = (((_zz_308_ && (_zz_309_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_310_)) && (_zz_307_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_14 = (((_zz_324_ && (_zz_325_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_326_)) && (_zz_323_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_15 = (((_zz_340_ && (_zz_341_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_342_)) && (_zz_339_ || (! (CsrPlugin_privilege == (2'b11)))));
  always @ (*) begin
    if(_zz_611_)begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = (CsrPlugin_privilege == (2'b11));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = _zz_588_;
    end
  end

  always @ (*) begin
    if(_zz_611_)begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = (CsrPlugin_privilege == (2'b11));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = _zz_589_;
    end
  end

  always @ (*) begin
    if(_zz_611_)begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = (CsrPlugin_privilege == (2'b11));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = _zz_590_;
    end
  end

  assign _zz_397_ = {PmpPlugin_ports_1_hits_15,{PmpPlugin_ports_1_hits_14,{PmpPlugin_ports_1_hits_13,{PmpPlugin_ports_1_hits_12,{PmpPlugin_ports_1_hits_11,{PmpPlugin_ports_1_hits_10,{PmpPlugin_ports_1_hits_9,{PmpPlugin_ports_1_hits_8,{PmpPlugin_ports_1_hits_7,{PmpPlugin_ports_1_hits_6,{_zz_898_,_zz_899_}}}}}}}}}}};
  assign _zz_398_ = (_zz_397_ & (~ _zz_744_));
  assign _zz_399_ = _zz_398_[3];
  assign _zz_400_ = _zz_398_[5];
  assign _zz_401_ = _zz_398_[6];
  assign _zz_402_ = _zz_398_[7];
  assign _zz_403_ = _zz_398_[9];
  assign _zz_404_ = _zz_398_[10];
  assign _zz_405_ = _zz_398_[11];
  assign _zz_406_ = _zz_398_[12];
  assign _zz_407_ = _zz_398_[13];
  assign _zz_408_ = _zz_398_[14];
  assign _zz_409_ = _zz_398_[15];
  assign _zz_410_ = (((((((_zz_398_[1] || _zz_399_) || _zz_400_) || _zz_402_) || _zz_403_) || _zz_405_) || _zz_407_) || _zz_409_);
  assign _zz_411_ = (((((((_zz_398_[2] || _zz_399_) || _zz_401_) || _zz_402_) || _zz_404_) || _zz_405_) || _zz_408_) || _zz_409_);
  assign _zz_412_ = (((((((_zz_398_[4] || _zz_400_) || _zz_401_) || _zz_402_) || _zz_406_) || _zz_407_) || _zz_408_) || _zz_409_);
  assign _zz_413_ = (((((((_zz_398_[8] || _zz_403_) || _zz_404_) || _zz_405_) || _zz_406_) || _zz_407_) || _zz_408_) || _zz_409_);
  assign _zz_414_ = {PmpPlugin_ports_1_hits_15,{PmpPlugin_ports_1_hits_14,{PmpPlugin_ports_1_hits_13,{PmpPlugin_ports_1_hits_12,{PmpPlugin_ports_1_hits_11,{PmpPlugin_ports_1_hits_10,{PmpPlugin_ports_1_hits_9,{PmpPlugin_ports_1_hits_8,{PmpPlugin_ports_1_hits_7,{PmpPlugin_ports_1_hits_6,{_zz_900_,_zz_901_}}}}}}}}}}};
  assign _zz_415_ = (_zz_414_ & (~ _zz_745_));
  assign _zz_416_ = _zz_415_[3];
  assign _zz_417_ = _zz_415_[5];
  assign _zz_418_ = _zz_415_[6];
  assign _zz_419_ = _zz_415_[7];
  assign _zz_420_ = _zz_415_[9];
  assign _zz_421_ = _zz_415_[10];
  assign _zz_422_ = _zz_415_[11];
  assign _zz_423_ = _zz_415_[12];
  assign _zz_424_ = _zz_415_[13];
  assign _zz_425_ = _zz_415_[14];
  assign _zz_426_ = _zz_415_[15];
  assign _zz_427_ = (((((((_zz_415_[1] || _zz_416_) || _zz_417_) || _zz_419_) || _zz_420_) || _zz_422_) || _zz_424_) || _zz_426_);
  assign _zz_428_ = (((((((_zz_415_[2] || _zz_416_) || _zz_418_) || _zz_419_) || _zz_421_) || _zz_422_) || _zz_425_) || _zz_426_);
  assign _zz_429_ = (((((((_zz_415_[4] || _zz_417_) || _zz_418_) || _zz_419_) || _zz_423_) || _zz_424_) || _zz_425_) || _zz_426_);
  assign _zz_430_ = (((((((_zz_415_[8] || _zz_420_) || _zz_421_) || _zz_422_) || _zz_423_) || _zz_424_) || _zz_425_) || _zz_426_);
  assign _zz_431_ = {PmpPlugin_ports_1_hits_15,{PmpPlugin_ports_1_hits_14,{PmpPlugin_ports_1_hits_13,{PmpPlugin_ports_1_hits_12,{PmpPlugin_ports_1_hits_11,{PmpPlugin_ports_1_hits_10,{PmpPlugin_ports_1_hits_9,{PmpPlugin_ports_1_hits_8,{PmpPlugin_ports_1_hits_7,{PmpPlugin_ports_1_hits_6,{_zz_902_,_zz_903_}}}}}}}}}}};
  assign _zz_432_ = (_zz_431_ & (~ _zz_746_));
  assign _zz_433_ = _zz_432_[3];
  assign _zz_434_ = _zz_432_[5];
  assign _zz_435_ = _zz_432_[6];
  assign _zz_436_ = _zz_432_[7];
  assign _zz_437_ = _zz_432_[9];
  assign _zz_438_ = _zz_432_[10];
  assign _zz_439_ = _zz_432_[11];
  assign _zz_440_ = _zz_432_[12];
  assign _zz_441_ = _zz_432_[13];
  assign _zz_442_ = _zz_432_[14];
  assign _zz_443_ = _zz_432_[15];
  assign _zz_444_ = (((((((_zz_432_[1] || _zz_433_) || _zz_434_) || _zz_436_) || _zz_437_) || _zz_439_) || _zz_441_) || _zz_443_);
  assign _zz_445_ = (((((((_zz_432_[2] || _zz_433_) || _zz_435_) || _zz_436_) || _zz_438_) || _zz_439_) || _zz_442_) || _zz_443_);
  assign _zz_446_ = (((((((_zz_432_[4] || _zz_434_) || _zz_435_) || _zz_436_) || _zz_440_) || _zz_441_) || _zz_442_) || _zz_443_);
  assign _zz_447_ = (((((((_zz_432_[8] || _zz_437_) || _zz_438_) || _zz_439_) || _zz_440_) || _zz_441_) || _zz_442_) || _zz_443_);
  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = DBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_449_ = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_450_ = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_451_ = ((decode_INSTRUCTION & 32'h00004050) == 32'h00004050);
  assign _zz_452_ = ((decode_INSTRUCTION & 32'h00001000) == 32'h0);
  assign _zz_448_ = {({(_zz_904_ == _zz_905_),{_zz_906_,{_zz_907_,_zz_908_}}} != 5'h0),{({_zz_909_,_zz_910_} != (2'b00)),{(_zz_911_ != (1'b0)),{(_zz_912_ != _zz_913_),{_zz_914_,{_zz_915_,_zz_916_}}}}}};
  assign _zz_453_ = _zz_448_[1 : 0];
  assign _zz_49_ = _zz_453_;
  assign _zz_454_ = _zz_448_[4 : 3];
  assign _zz_48_ = _zz_454_;
  assign _zz_455_ = _zz_448_[7 : 6];
  assign _zz_47_ = _zz_455_;
  assign _zz_456_ = _zz_448_[14 : 13];
  assign _zz_46_ = _zz_456_;
  assign _zz_457_ = _zz_448_[23 : 22];
  assign _zz_45_ = _zz_457_;
  assign _zz_458_ = _zz_448_[26 : 25];
  assign _zz_44_ = _zz_458_;
  assign _zz_459_ = _zz_448_[31 : 30];
  assign _zz_43_ = _zz_459_;
  assign decodeExceptionPort_valid = (decode_arbitration_isValid && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_582_;
  assign decode_RegFilePlugin_rs2Data = _zz_583_;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_41_ && writeBack_arbitration_isFiring);
    if(_zz_460_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_40_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_52_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_461_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_461_ = {31'd0, _zz_747_};
      end
      default : begin
        _zz_461_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_462_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_462_ = {29'd0, _zz_748_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_462_ = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_462_ = {27'd0, _zz_749_};
      end
    endcase
  end

  assign _zz_463_ = _zz_750_[11];
  always @ (*) begin
    _zz_464_[19] = _zz_463_;
    _zz_464_[18] = _zz_463_;
    _zz_464_[17] = _zz_463_;
    _zz_464_[16] = _zz_463_;
    _zz_464_[15] = _zz_463_;
    _zz_464_[14] = _zz_463_;
    _zz_464_[13] = _zz_463_;
    _zz_464_[12] = _zz_463_;
    _zz_464_[11] = _zz_463_;
    _zz_464_[10] = _zz_463_;
    _zz_464_[9] = _zz_463_;
    _zz_464_[8] = _zz_463_;
    _zz_464_[7] = _zz_463_;
    _zz_464_[6] = _zz_463_;
    _zz_464_[5] = _zz_463_;
    _zz_464_[4] = _zz_463_;
    _zz_464_[3] = _zz_463_;
    _zz_464_[2] = _zz_463_;
    _zz_464_[1] = _zz_463_;
    _zz_464_[0] = _zz_463_;
  end

  assign _zz_465_ = _zz_751_[11];
  always @ (*) begin
    _zz_466_[19] = _zz_465_;
    _zz_466_[18] = _zz_465_;
    _zz_466_[17] = _zz_465_;
    _zz_466_[16] = _zz_465_;
    _zz_466_[15] = _zz_465_;
    _zz_466_[14] = _zz_465_;
    _zz_466_[13] = _zz_465_;
    _zz_466_[12] = _zz_465_;
    _zz_466_[11] = _zz_465_;
    _zz_466_[10] = _zz_465_;
    _zz_466_[9] = _zz_465_;
    _zz_466_[8] = _zz_465_;
    _zz_466_[7] = _zz_465_;
    _zz_466_[6] = _zz_465_;
    _zz_466_[5] = _zz_465_;
    _zz_466_[4] = _zz_465_;
    _zz_466_[3] = _zz_465_;
    _zz_466_[2] = _zz_465_;
    _zz_466_[1] = _zz_465_;
    _zz_466_[0] = _zz_465_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_467_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_467_ = {_zz_464_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_467_ = {_zz_466_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_467_ = _zz_35_;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_752_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_468_[0] = execute_SRC1[31];
    _zz_468_[1] = execute_SRC1[30];
    _zz_468_[2] = execute_SRC1[29];
    _zz_468_[3] = execute_SRC1[28];
    _zz_468_[4] = execute_SRC1[27];
    _zz_468_[5] = execute_SRC1[26];
    _zz_468_[6] = execute_SRC1[25];
    _zz_468_[7] = execute_SRC1[24];
    _zz_468_[8] = execute_SRC1[23];
    _zz_468_[9] = execute_SRC1[22];
    _zz_468_[10] = execute_SRC1[21];
    _zz_468_[11] = execute_SRC1[20];
    _zz_468_[12] = execute_SRC1[19];
    _zz_468_[13] = execute_SRC1[18];
    _zz_468_[14] = execute_SRC1[17];
    _zz_468_[15] = execute_SRC1[16];
    _zz_468_[16] = execute_SRC1[15];
    _zz_468_[17] = execute_SRC1[14];
    _zz_468_[18] = execute_SRC1[13];
    _zz_468_[19] = execute_SRC1[12];
    _zz_468_[20] = execute_SRC1[11];
    _zz_468_[21] = execute_SRC1[10];
    _zz_468_[22] = execute_SRC1[9];
    _zz_468_[23] = execute_SRC1[8];
    _zz_468_[24] = execute_SRC1[7];
    _zz_468_[25] = execute_SRC1[6];
    _zz_468_[26] = execute_SRC1[5];
    _zz_468_[27] = execute_SRC1[4];
    _zz_468_[28] = execute_SRC1[3];
    _zz_468_[29] = execute_SRC1[2];
    _zz_468_[30] = execute_SRC1[1];
    _zz_468_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_468_ : execute_SRC1);
  always @ (*) begin
    _zz_469_[0] = memory_SHIFT_RIGHT[31];
    _zz_469_[1] = memory_SHIFT_RIGHT[30];
    _zz_469_[2] = memory_SHIFT_RIGHT[29];
    _zz_469_[3] = memory_SHIFT_RIGHT[28];
    _zz_469_[4] = memory_SHIFT_RIGHT[27];
    _zz_469_[5] = memory_SHIFT_RIGHT[26];
    _zz_469_[6] = memory_SHIFT_RIGHT[25];
    _zz_469_[7] = memory_SHIFT_RIGHT[24];
    _zz_469_[8] = memory_SHIFT_RIGHT[23];
    _zz_469_[9] = memory_SHIFT_RIGHT[22];
    _zz_469_[10] = memory_SHIFT_RIGHT[21];
    _zz_469_[11] = memory_SHIFT_RIGHT[20];
    _zz_469_[12] = memory_SHIFT_RIGHT[19];
    _zz_469_[13] = memory_SHIFT_RIGHT[18];
    _zz_469_[14] = memory_SHIFT_RIGHT[17];
    _zz_469_[15] = memory_SHIFT_RIGHT[16];
    _zz_469_[16] = memory_SHIFT_RIGHT[15];
    _zz_469_[17] = memory_SHIFT_RIGHT[14];
    _zz_469_[18] = memory_SHIFT_RIGHT[13];
    _zz_469_[19] = memory_SHIFT_RIGHT[12];
    _zz_469_[20] = memory_SHIFT_RIGHT[11];
    _zz_469_[21] = memory_SHIFT_RIGHT[10];
    _zz_469_[22] = memory_SHIFT_RIGHT[9];
    _zz_469_[23] = memory_SHIFT_RIGHT[8];
    _zz_469_[24] = memory_SHIFT_RIGHT[7];
    _zz_469_[25] = memory_SHIFT_RIGHT[6];
    _zz_469_[26] = memory_SHIFT_RIGHT[5];
    _zz_469_[27] = memory_SHIFT_RIGHT[4];
    _zz_469_[28] = memory_SHIFT_RIGHT[3];
    _zz_469_[29] = memory_SHIFT_RIGHT[2];
    _zz_469_[30] = memory_SHIFT_RIGHT[1];
    _zz_469_[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_470_ = 1'b0;
    if(_zz_612_)begin
      if(_zz_613_)begin
        if(_zz_475_)begin
          _zz_470_ = 1'b1;
        end
      end
    end
    if(_zz_614_)begin
      if(_zz_615_)begin
        if(_zz_477_)begin
          _zz_470_ = 1'b1;
        end
      end
    end
    if(_zz_616_)begin
      if(_zz_617_)begin
        if(_zz_479_)begin
          _zz_470_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_470_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_471_ = 1'b0;
    if(_zz_612_)begin
      if(_zz_613_)begin
        if(_zz_476_)begin
          _zz_471_ = 1'b1;
        end
      end
    end
    if(_zz_614_)begin
      if(_zz_615_)begin
        if(_zz_478_)begin
          _zz_471_ = 1'b1;
        end
      end
    end
    if(_zz_616_)begin
      if(_zz_617_)begin
        if(_zz_480_)begin
          _zz_471_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_471_ = 1'b0;
    end
  end

  assign _zz_475_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_476_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_477_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_478_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_479_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_480_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_481_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_481_ == (3'b000))) begin
        _zz_482_ = execute_BranchPlugin_eq;
    end else if((_zz_481_ == (3'b001))) begin
        _zz_482_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_481_ & (3'b101)) == (3'b101)))) begin
        _zz_482_ = (! execute_SRC_LESS);
    end else begin
        _zz_482_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_483_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_483_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_483_ = 1'b1;
      end
      default : begin
        _zz_483_ = _zz_482_;
      end
    endcase
  end

  assign _zz_484_ = _zz_759_[11];
  always @ (*) begin
    _zz_485_[19] = _zz_484_;
    _zz_485_[18] = _zz_484_;
    _zz_485_[17] = _zz_484_;
    _zz_485_[16] = _zz_484_;
    _zz_485_[15] = _zz_484_;
    _zz_485_[14] = _zz_484_;
    _zz_485_[13] = _zz_484_;
    _zz_485_[12] = _zz_484_;
    _zz_485_[11] = _zz_484_;
    _zz_485_[10] = _zz_484_;
    _zz_485_[9] = _zz_484_;
    _zz_485_[8] = _zz_484_;
    _zz_485_[7] = _zz_484_;
    _zz_485_[6] = _zz_484_;
    _zz_485_[5] = _zz_484_;
    _zz_485_[4] = _zz_484_;
    _zz_485_[3] = _zz_484_;
    _zz_485_[2] = _zz_484_;
    _zz_485_[1] = _zz_484_;
    _zz_485_[0] = _zz_484_;
  end

  assign _zz_486_ = _zz_760_[19];
  always @ (*) begin
    _zz_487_[10] = _zz_486_;
    _zz_487_[9] = _zz_486_;
    _zz_487_[8] = _zz_486_;
    _zz_487_[7] = _zz_486_;
    _zz_487_[6] = _zz_486_;
    _zz_487_[5] = _zz_486_;
    _zz_487_[4] = _zz_486_;
    _zz_487_[3] = _zz_486_;
    _zz_487_[2] = _zz_486_;
    _zz_487_[1] = _zz_486_;
    _zz_487_[0] = _zz_486_;
  end

  assign _zz_488_ = _zz_761_[11];
  always @ (*) begin
    _zz_489_[18] = _zz_488_;
    _zz_489_[17] = _zz_488_;
    _zz_489_[16] = _zz_488_;
    _zz_489_[15] = _zz_488_;
    _zz_489_[14] = _zz_488_;
    _zz_489_[13] = _zz_488_;
    _zz_489_[12] = _zz_488_;
    _zz_489_[11] = _zz_488_;
    _zz_489_[10] = _zz_488_;
    _zz_489_[9] = _zz_488_;
    _zz_489_[8] = _zz_488_;
    _zz_489_[7] = _zz_488_;
    _zz_489_[6] = _zz_488_;
    _zz_489_[5] = _zz_488_;
    _zz_489_[4] = _zz_488_;
    _zz_489_[3] = _zz_488_;
    _zz_489_[2] = _zz_488_;
    _zz_489_[1] = _zz_488_;
    _zz_489_[0] = _zz_488_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_490_ = (_zz_762_[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_490_ = _zz_763_[1];
      end
      default : begin
        _zz_490_ = _zz_764_[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_490_);
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_491_ = _zz_765_[11];
  always @ (*) begin
    _zz_492_[19] = _zz_491_;
    _zz_492_[18] = _zz_491_;
    _zz_492_[17] = _zz_491_;
    _zz_492_[16] = _zz_491_;
    _zz_492_[15] = _zz_491_;
    _zz_492_[14] = _zz_491_;
    _zz_492_[13] = _zz_491_;
    _zz_492_[12] = _zz_491_;
    _zz_492_[11] = _zz_491_;
    _zz_492_[10] = _zz_491_;
    _zz_492_[9] = _zz_491_;
    _zz_492_[8] = _zz_491_;
    _zz_492_[7] = _zz_491_;
    _zz_492_[6] = _zz_491_;
    _zz_492_[5] = _zz_491_;
    _zz_492_[4] = _zz_491_;
    _zz_492_[3] = _zz_491_;
    _zz_492_[2] = _zz_491_;
    _zz_492_[1] = _zz_491_;
    _zz_492_[0] = _zz_491_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_492_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_494_,{{{_zz_1069_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_496_,{{{_zz_1070_,_zz_1071_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_768_};
        end
      end
    endcase
  end

  assign _zz_493_ = _zz_766_[19];
  always @ (*) begin
    _zz_494_[10] = _zz_493_;
    _zz_494_[9] = _zz_493_;
    _zz_494_[8] = _zz_493_;
    _zz_494_[7] = _zz_493_;
    _zz_494_[6] = _zz_493_;
    _zz_494_[5] = _zz_493_;
    _zz_494_[4] = _zz_493_;
    _zz_494_[3] = _zz_493_;
    _zz_494_[2] = _zz_493_;
    _zz_494_[1] = _zz_493_;
    _zz_494_[0] = _zz_493_;
  end

  assign _zz_495_ = _zz_767_[11];
  always @ (*) begin
    _zz_496_[18] = _zz_495_;
    _zz_496_[17] = _zz_495_;
    _zz_496_[16] = _zz_495_;
    _zz_496_[15] = _zz_495_;
    _zz_496_[14] = _zz_495_;
    _zz_496_[13] = _zz_495_;
    _zz_496_[12] = _zz_495_;
    _zz_496_[11] = _zz_495_;
    _zz_496_[10] = _zz_495_;
    _zz_496_[9] = _zz_495_;
    _zz_496_[8] = _zz_495_;
    _zz_496_[7] = _zz_495_;
    _zz_496_[6] = _zz_495_;
    _zz_496_[5] = _zz_495_;
    _zz_496_[4] = _zz_495_;
    _zz_496_[3] = _zz_495_;
    _zz_496_[2] = _zz_495_;
    _zz_496_[1] = _zz_495_;
    _zz_496_[0] = _zz_495_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign BranchPlugin_branchExceptionPort_valid = (memory_arbitration_isValid && (memory_BRANCH_DO && memory_BRANCH_CALC[1]));
  assign BranchPlugin_branchExceptionPort_payload_code = (4'b0000);
  assign BranchPlugin_branchExceptionPort_payload_badAddr = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  always @ (*) begin
    CsrPlugin_privilege = _zz_497_;
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign _zz_498_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_499_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_500_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  assign _zz_501_ = {decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid};
  assign _zz_502_ = _zz_769_[0];
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(_zz_601_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(BranchPlugin_branchExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPendings_0 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  assign CsrPlugin_exceptionPendings_1 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  assign CsrPlugin_exceptionPendings_2 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  assign CsrPlugin_exceptionPendings_3 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && CsrPlugin_allowException);
  assign CsrPlugin_pipelineLiberator_active = ((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts) && decode_arbitration_isValid);
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = CsrPlugin_pipelineLiberator_pcValids_2;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interrupt_code;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = 30'h0;
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    if(execute_CsrPlugin_csr_3264)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_944)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_945)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_946)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_947)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_948)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_949)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_950)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_951)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_952)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_953)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_954)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_955)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_956)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_957)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_958)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_959)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_928)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_929)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_930)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_931)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_3857)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3858)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3859)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3860)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_769)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_768)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_836)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_772)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_773)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_833)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_832)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_834)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_835)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2816)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2944)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2818)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2946)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_3072)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3200)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3074)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3202)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3008)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_4032)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(_zz_618_)begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_valid = 1'b0;
    if(_zz_619_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
    if(_zz_620_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_payload_code = (4'bxxxx);
    if(_zz_619_)begin
      CsrPlugin_selfException_payload_code = (4'b0010);
    end
    if(_zz_620_)begin
      case(CsrPlugin_privilege)
        2'b00 : begin
          CsrPlugin_selfException_payload_code = (4'b1000);
        end
        default : begin
          CsrPlugin_selfException_payload_code = (4'b1011);
        end
      endcase
    end
  end

  assign CsrPlugin_selfException_payload_badAddr = execute_INSTRUCTION;
  always @ (*) begin
    execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
    if(_zz_618_)begin
      execute_CsrPlugin_writeInstruction = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
    if(_zz_618_)begin
      execute_CsrPlugin_readInstruction = 1'b0;
    end
  end

  assign execute_CsrPlugin_writeEnable = (execute_CsrPlugin_writeInstruction && (! execute_arbitration_isStuck));
  assign execute_CsrPlugin_readEnable = (execute_CsrPlugin_readInstruction && (! execute_arbitration_isStuck));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_648_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign execute_MulPlugin_a = execute_RS1;
  assign execute_MulPlugin_b = execute_RS2;
  always @ (*) begin
    case(_zz_621_)
      2'b01 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      default : begin
        execute_MulPlugin_aSigned = 1'b0;
      end
    endcase
  end

  always @ (*) begin
    case(_zz_621_)
      2'b01 : begin
        execute_MulPlugin_bSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
      default : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
    endcase
  end

  assign execute_MulPlugin_aULow = execute_MulPlugin_a[15 : 0];
  assign execute_MulPlugin_bULow = execute_MulPlugin_b[15 : 0];
  assign execute_MulPlugin_aSLow = {1'b0,execute_MulPlugin_a[15 : 0]};
  assign execute_MulPlugin_bSLow = {1'b0,execute_MulPlugin_b[15 : 0]};
  assign execute_MulPlugin_aHigh = {(execute_MulPlugin_aSigned && execute_MulPlugin_a[31]),execute_MulPlugin_a[31 : 16]};
  assign execute_MulPlugin_bHigh = {(execute_MulPlugin_bSigned && execute_MulPlugin_b[31]),execute_MulPlugin_b[31 : 16]};
  assign writeBack_MulPlugin_result = ($signed(_zz_771_) + $signed(_zz_772_));
  assign memory_DivPlugin_frontendOk = 1'b1;
  always @ (*) begin
    memory_DivPlugin_div_counter_willIncrement = 1'b0;
    if(_zz_596_)begin
      if(_zz_622_)begin
        memory_DivPlugin_div_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_DivPlugin_div_counter_willClear = 1'b0;
    if(_zz_623_)begin
      memory_DivPlugin_div_counter_willClear = 1'b1;
    end
  end

  assign memory_DivPlugin_div_counter_willOverflowIfInc = (memory_DivPlugin_div_counter_value == 6'h21);
  assign memory_DivPlugin_div_counter_willOverflow = (memory_DivPlugin_div_counter_willOverflowIfInc && memory_DivPlugin_div_counter_willIncrement);
  always @ (*) begin
    if(memory_DivPlugin_div_counter_willOverflow)begin
      memory_DivPlugin_div_counter_valueNext = 6'h0;
    end else begin
      memory_DivPlugin_div_counter_valueNext = (memory_DivPlugin_div_counter_value + _zz_776_);
    end
    if(memory_DivPlugin_div_counter_willClear)begin
      memory_DivPlugin_div_counter_valueNext = 6'h0;
    end
  end

  assign _zz_503_ = memory_DivPlugin_rs1[31 : 0];
  assign memory_DivPlugin_div_stage_0_remainderShifted = {memory_DivPlugin_accumulator[31 : 0],_zz_503_[31]};
  assign memory_DivPlugin_div_stage_0_remainderMinusDenominator = (memory_DivPlugin_div_stage_0_remainderShifted - _zz_777_);
  assign memory_DivPlugin_div_stage_0_outRemainder = ((! memory_DivPlugin_div_stage_0_remainderMinusDenominator[32]) ? _zz_778_ : _zz_779_);
  assign memory_DivPlugin_div_stage_0_outNumerator = _zz_780_[31:0];
  assign _zz_504_ = (memory_INSTRUCTION[13] ? memory_DivPlugin_accumulator[31 : 0] : memory_DivPlugin_rs1[31 : 0]);
  assign _zz_505_ = (execute_RS2[31] && execute_IS_RS2_SIGNED);
  assign _zz_506_ = (1'b0 || ((execute_IS_DIV && execute_RS1[31]) && execute_IS_RS1_SIGNED));
  always @ (*) begin
    _zz_507_[32] = (execute_IS_RS1_SIGNED && execute_RS1[31]);
    _zz_507_[31 : 0] = execute_RS1;
  end

  assign _zz_509_ = (_zz_508_ & externalInterruptArray_regNext);
  assign externalInterrupt = (_zz_509_ != 32'h0);
  always @ (*) begin
    debug_bus_cmd_ready = 1'b1;
    if(debug_bus_cmd_valid)begin
      case(_zz_624_)
        6'b000000 : begin
        end
        6'b000001 : begin
          if(debug_bus_cmd_payload_wr)begin
            debug_bus_cmd_ready = IBusCachedPlugin_injectionPort_ready;
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (*) begin
    debug_bus_rsp_data = DebugPlugin_busReadDataReg;
    if((! _zz_510_))begin
      debug_bus_rsp_data[0] = DebugPlugin_resetIt;
      debug_bus_rsp_data[1] = DebugPlugin_haltIt;
      debug_bus_rsp_data[2] = DebugPlugin_isPipBusy;
      debug_bus_rsp_data[3] = DebugPlugin_haltedByBreak;
      debug_bus_rsp_data[4] = DebugPlugin_stepIt;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_injectionPort_valid = 1'b0;
    if(debug_bus_cmd_valid)begin
      case(_zz_624_)
        6'b000000 : begin
        end
        6'b000001 : begin
          if(debug_bus_cmd_payload_wr)begin
            IBusCachedPlugin_injectionPort_valid = 1'b1;
          end
        end
        default : begin
        end
      endcase
    end
  end

  assign IBusCachedPlugin_injectionPort_payload = debug_bus_cmd_payload_data;
  assign DebugPlugin_allowEBreak = (CsrPlugin_privilege == (2'b11));
  assign debug_resetOut = DebugPlugin_resetIt_regNext;
  assign _zz_26_ = decode_BRANCH_CTRL;
  assign _zz_54_ = _zz_49_;
  assign _zz_30_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_24_ = decode_SRC2_CTRL;
  assign _zz_22_ = _zz_44_;
  assign _zz_36_ = decode_to_execute_SRC2_CTRL;
  assign _zz_21_ = decode_ALU_BITWISE_CTRL;
  assign _zz_19_ = _zz_47_;
  assign _zz_39_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_18_ = decode_ALU_CTRL;
  assign _zz_16_ = _zz_45_;
  assign _zz_38_ = decode_to_execute_ALU_CTRL;
  assign _zz_15_ = decode_ENV_CTRL;
  assign _zz_12_ = execute_ENV_CTRL;
  assign _zz_10_ = memory_ENV_CTRL;
  assign _zz_13_ = _zz_43_;
  assign _zz_28_ = decode_to_execute_ENV_CTRL;
  assign _zz_27_ = execute_to_memory_ENV_CTRL;
  assign _zz_29_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_8_ = decode_SRC1_CTRL;
  assign _zz_6_ = _zz_48_;
  assign _zz_37_ = decode_to_execute_SRC1_CTRL;
  assign _zz_5_ = decode_SHIFT_CTRL;
  assign _zz_2_ = execute_SHIFT_CTRL;
  assign _zz_3_ = _zz_46_;
  assign _zz_34_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_33_ = execute_to_memory_SHIFT_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (*) begin
    IBusCachedPlugin_injectionPort_ready = 1'b0;
    case(_zz_511_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
      end
      3'b011 : begin
      end
      3'b100 : begin
        IBusCachedPlugin_injectionPort_ready = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_512_ = 32'h0;
    if(execute_CsrPlugin_csr_3264)begin
      _zz_512_[12 : 0] = 13'h1000;
      _zz_512_[25 : 20] = 6'h20;
    end
  end

  always @ (*) begin
    _zz_513_ = 32'h0;
    if(execute_CsrPlugin_csr_944)begin
      _zz_513_[31 : 0] = _zz_95_;
    end
  end

  always @ (*) begin
    _zz_514_ = 32'h0;
    if(execute_CsrPlugin_csr_945)begin
      _zz_514_[31 : 0] = _zz_111_;
    end
  end

  always @ (*) begin
    _zz_515_ = 32'h0;
    if(execute_CsrPlugin_csr_946)begin
      _zz_515_[31 : 0] = _zz_127_;
    end
  end

  always @ (*) begin
    _zz_516_ = 32'h0;
    if(execute_CsrPlugin_csr_947)begin
      _zz_516_[31 : 0] = _zz_143_;
    end
  end

  always @ (*) begin
    _zz_517_ = 32'h0;
    if(execute_CsrPlugin_csr_948)begin
      _zz_517_[31 : 0] = _zz_159_;
    end
  end

  always @ (*) begin
    _zz_518_ = 32'h0;
    if(execute_CsrPlugin_csr_949)begin
      _zz_518_[31 : 0] = _zz_175_;
    end
  end

  always @ (*) begin
    _zz_519_ = 32'h0;
    if(execute_CsrPlugin_csr_950)begin
      _zz_519_[31 : 0] = _zz_191_;
    end
  end

  always @ (*) begin
    _zz_520_ = 32'h0;
    if(execute_CsrPlugin_csr_951)begin
      _zz_520_[31 : 0] = _zz_207_;
    end
  end

  always @ (*) begin
    _zz_521_ = 32'h0;
    if(execute_CsrPlugin_csr_952)begin
      _zz_521_[31 : 0] = _zz_223_;
    end
  end

  always @ (*) begin
    _zz_522_ = 32'h0;
    if(execute_CsrPlugin_csr_953)begin
      _zz_522_[31 : 0] = _zz_239_;
    end
  end

  always @ (*) begin
    _zz_523_ = 32'h0;
    if(execute_CsrPlugin_csr_954)begin
      _zz_523_[31 : 0] = _zz_255_;
    end
  end

  always @ (*) begin
    _zz_524_ = 32'h0;
    if(execute_CsrPlugin_csr_955)begin
      _zz_524_[31 : 0] = _zz_271_;
    end
  end

  always @ (*) begin
    _zz_525_ = 32'h0;
    if(execute_CsrPlugin_csr_956)begin
      _zz_525_[31 : 0] = _zz_287_;
    end
  end

  always @ (*) begin
    _zz_526_ = 32'h0;
    if(execute_CsrPlugin_csr_957)begin
      _zz_526_[31 : 0] = _zz_303_;
    end
  end

  always @ (*) begin
    _zz_527_ = 32'h0;
    if(execute_CsrPlugin_csr_958)begin
      _zz_527_[31 : 0] = _zz_319_;
    end
  end

  always @ (*) begin
    _zz_528_ = 32'h0;
    if(execute_CsrPlugin_csr_959)begin
      _zz_528_[31 : 0] = _zz_335_;
    end
  end

  always @ (*) begin
    _zz_529_ = 32'h0;
    if(execute_CsrPlugin_csr_928)begin
      _zz_529_[31 : 31] = _zz_141_;
      _zz_529_[23 : 23] = _zz_125_;
      _zz_529_[15 : 15] = _zz_109_;
      _zz_529_[7 : 7] = _zz_93_;
      _zz_529_[28 : 27] = _zz_142_;
      _zz_529_[26 : 26] = _zz_140_;
      _zz_529_[25 : 25] = _zz_139_;
      _zz_529_[24 : 24] = _zz_138_;
      _zz_529_[20 : 19] = _zz_126_;
      _zz_529_[18 : 18] = _zz_124_;
      _zz_529_[17 : 17] = _zz_123_;
      _zz_529_[16 : 16] = _zz_122_;
      _zz_529_[12 : 11] = _zz_110_;
      _zz_529_[10 : 10] = _zz_108_;
      _zz_529_[9 : 9] = _zz_107_;
      _zz_529_[8 : 8] = _zz_106_;
      _zz_529_[4 : 3] = _zz_94_;
      _zz_529_[2 : 2] = _zz_92_;
      _zz_529_[1 : 1] = _zz_91_;
      _zz_529_[0 : 0] = _zz_90_;
    end
  end

  always @ (*) begin
    _zz_530_ = 32'h0;
    if(execute_CsrPlugin_csr_929)begin
      _zz_530_[31 : 31] = _zz_205_;
      _zz_530_[23 : 23] = _zz_189_;
      _zz_530_[15 : 15] = _zz_173_;
      _zz_530_[7 : 7] = _zz_157_;
      _zz_530_[28 : 27] = _zz_206_;
      _zz_530_[26 : 26] = _zz_204_;
      _zz_530_[25 : 25] = _zz_203_;
      _zz_530_[24 : 24] = _zz_202_;
      _zz_530_[20 : 19] = _zz_190_;
      _zz_530_[18 : 18] = _zz_188_;
      _zz_530_[17 : 17] = _zz_187_;
      _zz_530_[16 : 16] = _zz_186_;
      _zz_530_[12 : 11] = _zz_174_;
      _zz_530_[10 : 10] = _zz_172_;
      _zz_530_[9 : 9] = _zz_171_;
      _zz_530_[8 : 8] = _zz_170_;
      _zz_530_[4 : 3] = _zz_158_;
      _zz_530_[2 : 2] = _zz_156_;
      _zz_530_[1 : 1] = _zz_155_;
      _zz_530_[0 : 0] = _zz_154_;
    end
  end

  always @ (*) begin
    _zz_531_ = 32'h0;
    if(execute_CsrPlugin_csr_930)begin
      _zz_531_[31 : 31] = _zz_269_;
      _zz_531_[23 : 23] = _zz_253_;
      _zz_531_[15 : 15] = _zz_237_;
      _zz_531_[7 : 7] = _zz_221_;
      _zz_531_[28 : 27] = _zz_270_;
      _zz_531_[26 : 26] = _zz_268_;
      _zz_531_[25 : 25] = _zz_267_;
      _zz_531_[24 : 24] = _zz_266_;
      _zz_531_[20 : 19] = _zz_254_;
      _zz_531_[18 : 18] = _zz_252_;
      _zz_531_[17 : 17] = _zz_251_;
      _zz_531_[16 : 16] = _zz_250_;
      _zz_531_[12 : 11] = _zz_238_;
      _zz_531_[10 : 10] = _zz_236_;
      _zz_531_[9 : 9] = _zz_235_;
      _zz_531_[8 : 8] = _zz_234_;
      _zz_531_[4 : 3] = _zz_222_;
      _zz_531_[2 : 2] = _zz_220_;
      _zz_531_[1 : 1] = _zz_219_;
      _zz_531_[0 : 0] = _zz_218_;
    end
  end

  always @ (*) begin
    _zz_532_ = 32'h0;
    if(execute_CsrPlugin_csr_931)begin
      _zz_532_[31 : 31] = _zz_333_;
      _zz_532_[23 : 23] = _zz_317_;
      _zz_532_[15 : 15] = _zz_301_;
      _zz_532_[7 : 7] = _zz_285_;
      _zz_532_[28 : 27] = _zz_334_;
      _zz_532_[26 : 26] = _zz_332_;
      _zz_532_[25 : 25] = _zz_331_;
      _zz_532_[24 : 24] = _zz_330_;
      _zz_532_[20 : 19] = _zz_318_;
      _zz_532_[18 : 18] = _zz_316_;
      _zz_532_[17 : 17] = _zz_315_;
      _zz_532_[16 : 16] = _zz_314_;
      _zz_532_[12 : 11] = _zz_302_;
      _zz_532_[10 : 10] = _zz_300_;
      _zz_532_[9 : 9] = _zz_299_;
      _zz_532_[8 : 8] = _zz_298_;
      _zz_532_[4 : 3] = _zz_286_;
      _zz_532_[2 : 2] = _zz_284_;
      _zz_532_[1 : 1] = _zz_283_;
      _zz_532_[0 : 0] = _zz_282_;
    end
  end

  always @ (*) begin
    _zz_533_ = 32'h0;
    if(execute_CsrPlugin_csr_3857)begin
      _zz_533_[0 : 0] = (1'b1);
    end
  end

  always @ (*) begin
    _zz_534_ = 32'h0;
    if(execute_CsrPlugin_csr_3858)begin
      _zz_534_[1 : 0] = (2'b10);
    end
  end

  always @ (*) begin
    _zz_535_ = 32'h0;
    if(execute_CsrPlugin_csr_3859)begin
      _zz_535_[1 : 0] = (2'b11);
    end
  end

  always @ (*) begin
    _zz_536_ = 32'h0;
    if(execute_CsrPlugin_csr_769)begin
      _zz_536_[31 : 30] = CsrPlugin_misa_base;
      _zz_536_[25 : 0] = CsrPlugin_misa_extensions;
    end
  end

  always @ (*) begin
    _zz_537_ = 32'h0;
    if(execute_CsrPlugin_csr_768)begin
      _zz_537_[12 : 11] = CsrPlugin_mstatus_MPP;
      _zz_537_[7 : 7] = CsrPlugin_mstatus_MPIE;
      _zz_537_[3 : 3] = CsrPlugin_mstatus_MIE;
    end
  end

  always @ (*) begin
    _zz_538_ = 32'h0;
    if(execute_CsrPlugin_csr_836)begin
      _zz_538_[11 : 11] = CsrPlugin_mip_MEIP;
      _zz_538_[7 : 7] = CsrPlugin_mip_MTIP;
      _zz_538_[3 : 3] = CsrPlugin_mip_MSIP;
    end
  end

  always @ (*) begin
    _zz_539_ = 32'h0;
    if(execute_CsrPlugin_csr_772)begin
      _zz_539_[11 : 11] = CsrPlugin_mie_MEIE;
      _zz_539_[7 : 7] = CsrPlugin_mie_MTIE;
      _zz_539_[3 : 3] = CsrPlugin_mie_MSIE;
    end
  end

  always @ (*) begin
    _zz_540_ = 32'h0;
    if(execute_CsrPlugin_csr_773)begin
      _zz_540_[31 : 2] = CsrPlugin_mtvec_base;
      _zz_540_[1 : 0] = CsrPlugin_mtvec_mode;
    end
  end

  always @ (*) begin
    _zz_541_ = 32'h0;
    if(execute_CsrPlugin_csr_833)begin
      _zz_541_[31 : 0] = CsrPlugin_mepc;
    end
  end

  always @ (*) begin
    _zz_542_ = 32'h0;
    if(execute_CsrPlugin_csr_832)begin
      _zz_542_[31 : 0] = CsrPlugin_mscratch;
    end
  end

  always @ (*) begin
    _zz_543_ = 32'h0;
    if(execute_CsrPlugin_csr_834)begin
      _zz_543_[31 : 31] = CsrPlugin_mcause_interrupt;
      _zz_543_[3 : 0] = CsrPlugin_mcause_exceptionCode;
    end
  end

  always @ (*) begin
    _zz_544_ = 32'h0;
    if(execute_CsrPlugin_csr_835)begin
      _zz_544_[31 : 0] = CsrPlugin_mtval;
    end
  end

  always @ (*) begin
    _zz_545_ = 32'h0;
    if(execute_CsrPlugin_csr_2816)begin
      _zz_545_[31 : 0] = CsrPlugin_mcycle[31 : 0];
    end
  end

  always @ (*) begin
    _zz_546_ = 32'h0;
    if(execute_CsrPlugin_csr_2944)begin
      _zz_546_[31 : 0] = CsrPlugin_mcycle[63 : 32];
    end
  end

  always @ (*) begin
    _zz_547_ = 32'h0;
    if(execute_CsrPlugin_csr_2818)begin
      _zz_547_[31 : 0] = CsrPlugin_minstret[31 : 0];
    end
  end

  always @ (*) begin
    _zz_548_ = 32'h0;
    if(execute_CsrPlugin_csr_2946)begin
      _zz_548_[31 : 0] = CsrPlugin_minstret[63 : 32];
    end
  end

  always @ (*) begin
    _zz_549_ = 32'h0;
    if(execute_CsrPlugin_csr_3072)begin
      _zz_549_[31 : 0] = CsrPlugin_mcycle[31 : 0];
    end
  end

  always @ (*) begin
    _zz_550_ = 32'h0;
    if(execute_CsrPlugin_csr_3200)begin
      _zz_550_[31 : 0] = CsrPlugin_mcycle[63 : 32];
    end
  end

  always @ (*) begin
    _zz_551_ = 32'h0;
    if(execute_CsrPlugin_csr_3074)begin
      _zz_551_[31 : 0] = CsrPlugin_minstret[31 : 0];
    end
  end

  always @ (*) begin
    _zz_552_ = 32'h0;
    if(execute_CsrPlugin_csr_3202)begin
      _zz_552_[31 : 0] = CsrPlugin_minstret[63 : 32];
    end
  end

  always @ (*) begin
    _zz_553_ = 32'h0;
    if(execute_CsrPlugin_csr_3008)begin
      _zz_553_[31 : 0] = _zz_508_;
    end
  end

  always @ (*) begin
    _zz_554_ = 32'h0;
    if(execute_CsrPlugin_csr_4032)begin
      _zz_554_[31 : 0] = _zz_509_;
    end
  end

  assign execute_CsrPlugin_readData = (((((_zz_1072_ | _zz_1073_) | (_zz_1074_ | _zz_1075_)) | ((_zz_1076_ | _zz_1077_) | (_zz_1078_ | _zz_1079_))) | (((_zz_1080_ | _zz_1081_) | (_zz_1082_ | _zz_1083_)) | ((_zz_1084_ | _zz_1085_) | (_zz_1086_ | _zz_1087_)))) | ((((_zz_543_ | _zz_544_) | (_zz_545_ | _zz_546_)) | ((_zz_547_ | _zz_548_) | (_zz_549_ | _zz_550_))) | ((_zz_551_ | _zz_552_) | (_zz_553_ | _zz_554_))));
  assign iBusWishbone_ADR = {_zz_861_,_zz_555_};
  assign iBusWishbone_CTI = ((_zz_555_ == (3'b111)) ? (3'b111) : (3'b010));
  assign iBusWishbone_BTE = (2'b00);
  assign iBusWishbone_SEL = (4'b1111);
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'h0;
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_625_)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_625_)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_556_;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_562_ = (dBus_cmd_payload_length != (3'b000));
  assign _zz_558_ = dBus_cmd_valid;
  assign _zz_560_ = dBus_cmd_payload_wr;
  assign _zz_561_ = (_zz_557_ == dBus_cmd_payload_length);
  assign dBus_cmd_ready = (_zz_559_ && (_zz_560_ || _zz_561_));
  assign dBusWishbone_ADR = ((_zz_562_ ? {{dBus_cmd_payload_address[31 : 5],_zz_557_},(2'b00)} : {dBus_cmd_payload_address[31 : 2],(2'b00)}) >>> 2);
  assign dBusWishbone_CTI = (_zz_562_ ? (_zz_561_ ? (3'b111) : (3'b010)) : (3'b000));
  assign dBusWishbone_BTE = (2'b00);
  assign dBusWishbone_SEL = (_zz_560_ ? dBus_cmd_payload_mask : (4'b1111));
  assign dBusWishbone_WE = _zz_560_;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_559_ = (_zz_558_ && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_558_;
  assign dBusWishbone_STB = _zz_558_;
  assign dBus_rsp_valid = _zz_563_;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= externalResetVector;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_68_ <= 1'b0;
      _zz_70_ <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_83_;
      IBusCachedPlugin_rspCounter <= 32'h0;
      dataCache_1__io_mem_cmd_s2mPipe_rValid <= 1'b0;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid <= 1'b0;
      DBusCachedPlugin_rspCounter <= _zz_84_;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_93_ <= 1'b0;
      _zz_94_ <= (2'b00);
      _zz_99_ <= 1'b0;
      _zz_100_ <= 1'b0;
      _zz_109_ <= 1'b0;
      _zz_110_ <= (2'b00);
      _zz_115_ <= 1'b0;
      _zz_116_ <= 1'b0;
      _zz_125_ <= 1'b0;
      _zz_126_ <= (2'b00);
      _zz_131_ <= 1'b0;
      _zz_132_ <= 1'b0;
      _zz_141_ <= 1'b0;
      _zz_142_ <= (2'b00);
      _zz_147_ <= 1'b0;
      _zz_148_ <= 1'b0;
      _zz_157_ <= 1'b0;
      _zz_158_ <= (2'b00);
      _zz_163_ <= 1'b0;
      _zz_164_ <= 1'b0;
      _zz_173_ <= 1'b0;
      _zz_174_ <= (2'b00);
      _zz_179_ <= 1'b0;
      _zz_180_ <= 1'b0;
      _zz_189_ <= 1'b0;
      _zz_190_ <= (2'b00);
      _zz_195_ <= 1'b0;
      _zz_196_ <= 1'b0;
      _zz_205_ <= 1'b0;
      _zz_206_ <= (2'b00);
      _zz_211_ <= 1'b0;
      _zz_212_ <= 1'b0;
      _zz_221_ <= 1'b0;
      _zz_222_ <= (2'b00);
      _zz_227_ <= 1'b0;
      _zz_228_ <= 1'b0;
      _zz_237_ <= 1'b0;
      _zz_238_ <= (2'b00);
      _zz_243_ <= 1'b0;
      _zz_244_ <= 1'b0;
      _zz_253_ <= 1'b0;
      _zz_254_ <= (2'b00);
      _zz_259_ <= 1'b0;
      _zz_260_ <= 1'b0;
      _zz_269_ <= 1'b0;
      _zz_270_ <= (2'b00);
      _zz_275_ <= 1'b0;
      _zz_276_ <= 1'b0;
      _zz_285_ <= 1'b0;
      _zz_286_ <= (2'b00);
      _zz_291_ <= 1'b0;
      _zz_292_ <= 1'b0;
      _zz_301_ <= 1'b0;
      _zz_302_ <= (2'b00);
      _zz_307_ <= 1'b0;
      _zz_308_ <= 1'b0;
      _zz_317_ <= 1'b0;
      _zz_318_ <= (2'b00);
      _zz_323_ <= 1'b0;
      _zz_324_ <= 1'b0;
      _zz_333_ <= 1'b0;
      _zz_334_ <= (2'b00);
      _zz_339_ <= 1'b0;
      _zz_340_ <= 1'b0;
      _zz_460_ <= 1'b1;
      _zz_472_ <= 1'b0;
      _zz_497_ <= (2'b11);
      CsrPlugin_misa_base <= (2'b01);
      CsrPlugin_misa_extensions <= 26'h0101064;
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_lastStageWasWfi <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      memory_DivPlugin_div_counter_value <= 6'h0;
      _zz_508_ <= 32'h0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_511_ <= (3'b000);
      memory_to_writeBack_REGFILE_WRITE_DATA <= 32'h0;
      memory_to_writeBack_INSTRUCTION <= 32'h0;
      _zz_555_ <= (3'b000);
      _zz_556_ <= 1'b0;
      _zz_557_ <= (3'b000);
      _zz_563_ <= 1'b0;
    end else begin
      if(IBusCachedPlugin_fetchPc_correction)begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b1;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      end
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if((IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_pcRegPropagate))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetchPc_correction) || IBusCachedPlugin_fetchPc_pcRegPropagate)))begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_68_ <= 1'b0;
      end
      if(_zz_66_)begin
        _zz_68_ <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_70_ <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_70_ <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_1_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_2_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= IBusCachedPlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(iBus_rsp_valid)begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + 32'h00000001);
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        dataCache_1__io_mem_cmd_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_626_)begin
        dataCache_1__io_mem_cmd_s2mPipe_rValid <= dataCache_1__io_mem_cmd_valid;
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid <= dataCache_1__io_mem_cmd_s2mPipe_valid;
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      if(_zz_627_)begin
        _zz_99_ <= _zz_93_;
        _zz_100_ <= 1'b1;
        case(_zz_94_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_100_ <= 1'b0;
          end
        endcase
      end
      if(_zz_628_)begin
        _zz_115_ <= _zz_109_;
        _zz_116_ <= 1'b1;
        case(_zz_110_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_116_ <= 1'b0;
          end
        endcase
      end
      if(_zz_629_)begin
        _zz_131_ <= _zz_125_;
        _zz_132_ <= 1'b1;
        case(_zz_126_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_132_ <= 1'b0;
          end
        endcase
      end
      if(_zz_630_)begin
        _zz_147_ <= _zz_141_;
        _zz_148_ <= 1'b1;
        case(_zz_142_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_148_ <= 1'b0;
          end
        endcase
      end
      if(_zz_631_)begin
        _zz_163_ <= _zz_157_;
        _zz_164_ <= 1'b1;
        case(_zz_158_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_164_ <= 1'b0;
          end
        endcase
      end
      if(_zz_632_)begin
        _zz_179_ <= _zz_173_;
        _zz_180_ <= 1'b1;
        case(_zz_174_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_180_ <= 1'b0;
          end
        endcase
      end
      if(_zz_633_)begin
        _zz_195_ <= _zz_189_;
        _zz_196_ <= 1'b1;
        case(_zz_190_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_196_ <= 1'b0;
          end
        endcase
      end
      if(_zz_634_)begin
        _zz_211_ <= _zz_205_;
        _zz_212_ <= 1'b1;
        case(_zz_206_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_212_ <= 1'b0;
          end
        endcase
      end
      if(_zz_635_)begin
        _zz_227_ <= _zz_221_;
        _zz_228_ <= 1'b1;
        case(_zz_222_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_228_ <= 1'b0;
          end
        endcase
      end
      if(_zz_636_)begin
        _zz_243_ <= _zz_237_;
        _zz_244_ <= 1'b1;
        case(_zz_238_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_244_ <= 1'b0;
          end
        endcase
      end
      if(_zz_637_)begin
        _zz_259_ <= _zz_253_;
        _zz_260_ <= 1'b1;
        case(_zz_254_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_260_ <= 1'b0;
          end
        endcase
      end
      if(_zz_638_)begin
        _zz_275_ <= _zz_269_;
        _zz_276_ <= 1'b1;
        case(_zz_270_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_276_ <= 1'b0;
          end
        endcase
      end
      if(_zz_639_)begin
        _zz_291_ <= _zz_285_;
        _zz_292_ <= 1'b1;
        case(_zz_286_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_292_ <= 1'b0;
          end
        endcase
      end
      if(_zz_640_)begin
        _zz_307_ <= _zz_301_;
        _zz_308_ <= 1'b1;
        case(_zz_302_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_308_ <= 1'b0;
          end
        endcase
      end
      if(_zz_641_)begin
        _zz_323_ <= _zz_317_;
        _zz_324_ <= 1'b1;
        case(_zz_318_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_324_ <= 1'b0;
          end
        endcase
      end
      if(_zz_642_)begin
        _zz_339_ <= _zz_333_;
        _zz_340_ <= 1'b1;
        case(_zz_334_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_340_ <= 1'b0;
          end
        endcase
      end
      _zz_460_ <= 1'b0;
      _zz_472_ <= (_zz_41_ && writeBack_arbitration_isFiring);
      if((! decode_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
      end
      if((! execute_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= (CsrPlugin_exceptionPortCtrl_exceptionValids_decode && (! decode_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end
      if((! memory_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute && (! execute_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end
      if((! writeBack_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory && (! memory_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_643_)begin
        if(_zz_644_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_645_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_646_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_lastStageWasWfi <= (writeBack_arbitration_isFiring && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_WFI));
      if(CsrPlugin_pipelineLiberator_active)begin
        if((! execute_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b1;
        end
        if((! memory_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_1 <= CsrPlugin_pipelineLiberator_pcValids_0;
        end
        if((! writeBack_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_2 <= CsrPlugin_pipelineLiberator_pcValids_1;
        end
      end
      if(((! CsrPlugin_pipelineLiberator_active) || decode_arbitration_removeIt))begin
        CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
        CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
        CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      end
      if(CsrPlugin_interruptJump)begin
        CsrPlugin_interrupt_valid <= 1'b0;
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_605_)begin
        _zz_497_ <= CsrPlugin_targetPrivilege;
        case(CsrPlugin_targetPrivilege)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_606_)begin
        case(_zz_608_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
            _zz_497_ <= CsrPlugin_mstatus_MPP;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= (({_zz_500_,{_zz_499_,_zz_498_}} != (3'b000)) || CsrPlugin_thirdPartyWake);
      memory_DivPlugin_div_counter_value <= memory_DivPlugin_div_counter_valueNext;
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_32_;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      case(_zz_511_)
        3'b000 : begin
          if(IBusCachedPlugin_injectionPort_valid)begin
            _zz_511_ <= (3'b001);
          end
        end
        3'b001 : begin
          _zz_511_ <= (3'b010);
        end
        3'b010 : begin
          _zz_511_ <= (3'b011);
        end
        3'b011 : begin
          if((! decode_arbitration_isStuck))begin
            _zz_511_ <= (3'b100);
          end
        end
        3'b100 : begin
          _zz_511_ <= (3'b000);
        end
        default : begin
        end
      endcase
      if(execute_CsrPlugin_csr_928)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_141_ <= _zz_790_[0];
          _zz_125_ <= _zz_791_[0];
          _zz_109_ <= _zz_792_[0];
          _zz_93_ <= _zz_793_[0];
          _zz_142_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_126_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_110_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_94_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_929)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_205_ <= _zz_806_[0];
          _zz_189_ <= _zz_807_[0];
          _zz_173_ <= _zz_808_[0];
          _zz_157_ <= _zz_809_[0];
          _zz_206_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_190_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_174_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_158_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_930)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_269_ <= _zz_822_[0];
          _zz_253_ <= _zz_823_[0];
          _zz_237_ <= _zz_824_[0];
          _zz_221_ <= _zz_825_[0];
          _zz_270_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_254_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_238_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_222_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_931)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_333_ <= _zz_838_[0];
          _zz_317_ <= _zz_839_[0];
          _zz_301_ <= _zz_840_[0];
          _zz_285_ <= _zz_841_[0];
          _zz_334_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_318_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_302_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_286_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_769)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_misa_base <= execute_CsrPlugin_writeData[31 : 30];
          CsrPlugin_misa_extensions <= execute_CsrPlugin_writeData[25 : 0];
        end
      end
      if(execute_CsrPlugin_csr_768)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
          CsrPlugin_mstatus_MPIE <= _zz_854_[0];
          CsrPlugin_mstatus_MIE <= _zz_855_[0];
        end
      end
      if(execute_CsrPlugin_csr_772)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mie_MEIE <= _zz_857_[0];
          CsrPlugin_mie_MTIE <= _zz_858_[0];
          CsrPlugin_mie_MSIE <= _zz_859_[0];
        end
      end
      if(execute_CsrPlugin_csr_3008)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_508_ <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      if(_zz_625_)begin
        if(iBusWishbone_ACK)begin
          _zz_555_ <= (_zz_555_ + (3'b001));
        end
      end
      _zz_556_ <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_558_ && _zz_559_))begin
        _zz_557_ <= (_zz_557_ + (3'b001));
        if(_zz_561_)begin
          _zz_557_ <= (3'b000);
        end
      end
      _zz_563_ <= ((_zz_558_ && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_71_ <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_626_)begin
      dataCache_1__io_mem_cmd_s2mPipe_rData_wr <= dataCache_1__io_mem_cmd_payload_wr;
      dataCache_1__io_mem_cmd_s2mPipe_rData_address <= dataCache_1__io_mem_cmd_payload_address;
      dataCache_1__io_mem_cmd_s2mPipe_rData_data <= dataCache_1__io_mem_cmd_payload_data;
      dataCache_1__io_mem_cmd_s2mPipe_rData_mask <= dataCache_1__io_mem_cmd_payload_mask;
      dataCache_1__io_mem_cmd_s2mPipe_rData_length <= dataCache_1__io_mem_cmd_payload_length;
      dataCache_1__io_mem_cmd_s2mPipe_rData_last <= dataCache_1__io_mem_cmd_payload_last;
    end
    if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_wr <= dataCache_1__io_mem_cmd_s2mPipe_payload_wr;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_address <= dataCache_1__io_mem_cmd_s2mPipe_payload_address;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_data <= dataCache_1__io_mem_cmd_s2mPipe_payload_data;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_mask <= dataCache_1__io_mem_cmd_s2mPipe_payload_mask;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_length <= dataCache_1__io_mem_cmd_s2mPipe_payload_length;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_last <= dataCache_1__io_mem_cmd_s2mPipe_payload_last;
    end
    if(_zz_627_)begin
      _zz_96_ <= _zz_90_;
      _zz_97_ <= _zz_91_;
      _zz_98_ <= _zz_92_;
      case(_zz_94_)
        2'b01 : begin
          _zz_101_ <= 32'h0;
          _zz_102_ <= _zz_103_;
        end
        2'b10 : begin
          _zz_101_ <= _zz_103_;
          _zz_102_ <= (_zz_103_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_101_ <= _zz_105_;
          _zz_102_ <= (_zz_105_ + _zz_694_);
        end
        default : begin
          _zz_102_ <= _zz_103_;
        end
      endcase
    end
    if(_zz_628_)begin
      _zz_112_ <= _zz_106_;
      _zz_113_ <= _zz_107_;
      _zz_114_ <= _zz_108_;
      case(_zz_110_)
        2'b01 : begin
          _zz_117_ <= _zz_102_;
          _zz_118_ <= _zz_119_;
        end
        2'b10 : begin
          _zz_117_ <= _zz_119_;
          _zz_118_ <= (_zz_119_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_117_ <= _zz_121_;
          _zz_118_ <= (_zz_121_ + _zz_697_);
        end
        default : begin
          _zz_118_ <= _zz_119_;
        end
      endcase
    end
    if(_zz_629_)begin
      _zz_128_ <= _zz_122_;
      _zz_129_ <= _zz_123_;
      _zz_130_ <= _zz_124_;
      case(_zz_126_)
        2'b01 : begin
          _zz_133_ <= _zz_118_;
          _zz_134_ <= _zz_135_;
        end
        2'b10 : begin
          _zz_133_ <= _zz_135_;
          _zz_134_ <= (_zz_135_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_133_ <= _zz_137_;
          _zz_134_ <= (_zz_137_ + _zz_700_);
        end
        default : begin
          _zz_134_ <= _zz_135_;
        end
      endcase
    end
    if(_zz_630_)begin
      _zz_144_ <= _zz_138_;
      _zz_145_ <= _zz_139_;
      _zz_146_ <= _zz_140_;
      case(_zz_142_)
        2'b01 : begin
          _zz_149_ <= _zz_134_;
          _zz_150_ <= _zz_151_;
        end
        2'b10 : begin
          _zz_149_ <= _zz_151_;
          _zz_150_ <= (_zz_151_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_149_ <= _zz_153_;
          _zz_150_ <= (_zz_153_ + _zz_703_);
        end
        default : begin
          _zz_150_ <= _zz_151_;
        end
      endcase
    end
    if(_zz_631_)begin
      _zz_160_ <= _zz_154_;
      _zz_161_ <= _zz_155_;
      _zz_162_ <= _zz_156_;
      case(_zz_158_)
        2'b01 : begin
          _zz_165_ <= _zz_150_;
          _zz_166_ <= _zz_167_;
        end
        2'b10 : begin
          _zz_165_ <= _zz_167_;
          _zz_166_ <= (_zz_167_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_165_ <= _zz_169_;
          _zz_166_ <= (_zz_169_ + _zz_706_);
        end
        default : begin
          _zz_166_ <= _zz_167_;
        end
      endcase
    end
    if(_zz_632_)begin
      _zz_176_ <= _zz_170_;
      _zz_177_ <= _zz_171_;
      _zz_178_ <= _zz_172_;
      case(_zz_174_)
        2'b01 : begin
          _zz_181_ <= _zz_166_;
          _zz_182_ <= _zz_183_;
        end
        2'b10 : begin
          _zz_181_ <= _zz_183_;
          _zz_182_ <= (_zz_183_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_181_ <= _zz_185_;
          _zz_182_ <= (_zz_185_ + _zz_709_);
        end
        default : begin
          _zz_182_ <= _zz_183_;
        end
      endcase
    end
    if(_zz_633_)begin
      _zz_192_ <= _zz_186_;
      _zz_193_ <= _zz_187_;
      _zz_194_ <= _zz_188_;
      case(_zz_190_)
        2'b01 : begin
          _zz_197_ <= _zz_182_;
          _zz_198_ <= _zz_199_;
        end
        2'b10 : begin
          _zz_197_ <= _zz_199_;
          _zz_198_ <= (_zz_199_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_197_ <= _zz_201_;
          _zz_198_ <= (_zz_201_ + _zz_712_);
        end
        default : begin
          _zz_198_ <= _zz_199_;
        end
      endcase
    end
    if(_zz_634_)begin
      _zz_208_ <= _zz_202_;
      _zz_209_ <= _zz_203_;
      _zz_210_ <= _zz_204_;
      case(_zz_206_)
        2'b01 : begin
          _zz_213_ <= _zz_198_;
          _zz_214_ <= _zz_215_;
        end
        2'b10 : begin
          _zz_213_ <= _zz_215_;
          _zz_214_ <= (_zz_215_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_213_ <= _zz_217_;
          _zz_214_ <= (_zz_217_ + _zz_715_);
        end
        default : begin
          _zz_214_ <= _zz_215_;
        end
      endcase
    end
    if(_zz_635_)begin
      _zz_224_ <= _zz_218_;
      _zz_225_ <= _zz_219_;
      _zz_226_ <= _zz_220_;
      case(_zz_222_)
        2'b01 : begin
          _zz_229_ <= _zz_214_;
          _zz_230_ <= _zz_231_;
        end
        2'b10 : begin
          _zz_229_ <= _zz_231_;
          _zz_230_ <= (_zz_231_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_229_ <= _zz_233_;
          _zz_230_ <= (_zz_233_ + _zz_718_);
        end
        default : begin
          _zz_230_ <= _zz_231_;
        end
      endcase
    end
    if(_zz_636_)begin
      _zz_240_ <= _zz_234_;
      _zz_241_ <= _zz_235_;
      _zz_242_ <= _zz_236_;
      case(_zz_238_)
        2'b01 : begin
          _zz_245_ <= _zz_230_;
          _zz_246_ <= _zz_247_;
        end
        2'b10 : begin
          _zz_245_ <= _zz_247_;
          _zz_246_ <= (_zz_247_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_245_ <= _zz_249_;
          _zz_246_ <= (_zz_249_ + _zz_721_);
        end
        default : begin
          _zz_246_ <= _zz_247_;
        end
      endcase
    end
    if(_zz_637_)begin
      _zz_256_ <= _zz_250_;
      _zz_257_ <= _zz_251_;
      _zz_258_ <= _zz_252_;
      case(_zz_254_)
        2'b01 : begin
          _zz_261_ <= _zz_246_;
          _zz_262_ <= _zz_263_;
        end
        2'b10 : begin
          _zz_261_ <= _zz_263_;
          _zz_262_ <= (_zz_263_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_261_ <= _zz_265_;
          _zz_262_ <= (_zz_265_ + _zz_724_);
        end
        default : begin
          _zz_262_ <= _zz_263_;
        end
      endcase
    end
    if(_zz_638_)begin
      _zz_272_ <= _zz_266_;
      _zz_273_ <= _zz_267_;
      _zz_274_ <= _zz_268_;
      case(_zz_270_)
        2'b01 : begin
          _zz_277_ <= _zz_262_;
          _zz_278_ <= _zz_279_;
        end
        2'b10 : begin
          _zz_277_ <= _zz_279_;
          _zz_278_ <= (_zz_279_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_277_ <= _zz_281_;
          _zz_278_ <= (_zz_281_ + _zz_727_);
        end
        default : begin
          _zz_278_ <= _zz_279_;
        end
      endcase
    end
    if(_zz_639_)begin
      _zz_288_ <= _zz_282_;
      _zz_289_ <= _zz_283_;
      _zz_290_ <= _zz_284_;
      case(_zz_286_)
        2'b01 : begin
          _zz_293_ <= _zz_278_;
          _zz_294_ <= _zz_295_;
        end
        2'b10 : begin
          _zz_293_ <= _zz_295_;
          _zz_294_ <= (_zz_295_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_293_ <= _zz_297_;
          _zz_294_ <= (_zz_297_ + _zz_730_);
        end
        default : begin
          _zz_294_ <= _zz_295_;
        end
      endcase
    end
    if(_zz_640_)begin
      _zz_304_ <= _zz_298_;
      _zz_305_ <= _zz_299_;
      _zz_306_ <= _zz_300_;
      case(_zz_302_)
        2'b01 : begin
          _zz_309_ <= _zz_294_;
          _zz_310_ <= _zz_311_;
        end
        2'b10 : begin
          _zz_309_ <= _zz_311_;
          _zz_310_ <= (_zz_311_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_309_ <= _zz_313_;
          _zz_310_ <= (_zz_313_ + _zz_733_);
        end
        default : begin
          _zz_310_ <= _zz_311_;
        end
      endcase
    end
    if(_zz_641_)begin
      _zz_320_ <= _zz_314_;
      _zz_321_ <= _zz_315_;
      _zz_322_ <= _zz_316_;
      case(_zz_318_)
        2'b01 : begin
          _zz_325_ <= _zz_310_;
          _zz_326_ <= _zz_327_;
        end
        2'b10 : begin
          _zz_325_ <= _zz_327_;
          _zz_326_ <= (_zz_327_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_325_ <= _zz_329_;
          _zz_326_ <= (_zz_329_ + _zz_736_);
        end
        default : begin
          _zz_326_ <= _zz_327_;
        end
      endcase
    end
    if(_zz_642_)begin
      _zz_336_ <= _zz_330_;
      _zz_337_ <= _zz_331_;
      _zz_338_ <= _zz_332_;
      case(_zz_334_)
        2'b01 : begin
          _zz_341_ <= _zz_326_;
          _zz_342_ <= _zz_343_;
        end
        2'b10 : begin
          _zz_341_ <= _zz_343_;
          _zz_342_ <= (_zz_343_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_341_ <= _zz_345_;
          _zz_342_ <= (_zz_345_ + _zz_739_);
        end
        default : begin
          _zz_342_ <= _zz_343_;
        end
      endcase
    end
    _zz_473_ <= _zz_40_[11 : 7];
    _zz_474_ <= _zz_52_;
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + 64'h0000000000000001);
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + 64'h0000000000000001);
    end
    if(_zz_601_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_502_ ? IBusCachedPlugin_decodeExceptionPort_payload_code : decodeExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_502_ ? IBusCachedPlugin_decodeExceptionPort_payload_badAddr : decodeExceptionPort_payload_badAddr);
    end
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= CsrPlugin_selfException_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= CsrPlugin_selfException_payload_badAddr;
    end
    if(BranchPlugin_branchExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= BranchPlugin_branchExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= BranchPlugin_branchExceptionPort_payload_badAddr;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusCachedPlugin_exceptionBus_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusCachedPlugin_exceptionBus_payload_badAddr;
    end
    if(_zz_643_)begin
      if(_zz_644_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_645_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_646_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_605_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        default : begin
        end
      endcase
    end
    if((memory_DivPlugin_div_counter_value == 6'h20))begin
      memory_DivPlugin_div_done <= 1'b1;
    end
    if((! memory_arbitration_isStuck))begin
      memory_DivPlugin_div_done <= 1'b0;
    end
    if(_zz_596_)begin
      if(_zz_622_)begin
        memory_DivPlugin_rs1[31 : 0] <= memory_DivPlugin_div_stage_0_outNumerator;
        memory_DivPlugin_accumulator[31 : 0] <= memory_DivPlugin_div_stage_0_outRemainder;
        if((memory_DivPlugin_div_counter_value == 6'h20))begin
          memory_DivPlugin_div_result <= _zz_781_[31:0];
        end
      end
    end
    if(_zz_623_)begin
      memory_DivPlugin_accumulator <= 65'h0;
      memory_DivPlugin_rs1 <= ((_zz_506_ ? (~ _zz_507_) : _zz_507_) + _zz_787_);
      memory_DivPlugin_rs2 <= ((_zz_505_ ? (~ execute_RS2) : execute_RS2) + _zz_789_);
      memory_DivPlugin_div_needRevert <= ((_zz_506_ ^ (_zz_505_ && (! execute_INSTRUCTION[13]))) && (! (((execute_RS2 == 32'h0) && execute_IS_RS2_SIGNED) && (! execute_INSTRUCTION[13]))));
    end
    externalInterruptArray_regNext <= externalInterruptArray;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_MUL <= decode_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_MUL <= execute_IS_MUL;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_IS_MUL <= memory_IS_MUL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_25_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_23_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HH <= execute_MUL_HH;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_HH <= memory_MUL_HH;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LH <= execute_MUL_LH;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_31_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_56_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_55_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_DO_EBREAK <= decode_DO_EBREAK;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_20_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_35_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_DIV <= decode_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_DIV <= execute_IS_DIV;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS2_SIGNED <= decode_IS_RS2_SIGNED;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_17_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LL <= execute_MUL_LL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HL <= execute_MUL_HL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_WR <= decode_MEMORY_WR;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_WR <= execute_MEMORY_WR;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_WR <= memory_MEMORY_WR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_14_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_11_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_9_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_LOW <= memory_MUL_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS1_SIGNED <= decode_IS_RS1_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_7_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_4_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_1_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3264 <= (decode_INSTRUCTION[31 : 20] == 12'hcc0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_944 <= (decode_INSTRUCTION[31 : 20] == 12'h3b0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_945 <= (decode_INSTRUCTION[31 : 20] == 12'h3b1);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_946 <= (decode_INSTRUCTION[31 : 20] == 12'h3b2);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_947 <= (decode_INSTRUCTION[31 : 20] == 12'h3b3);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_948 <= (decode_INSTRUCTION[31 : 20] == 12'h3b4);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_949 <= (decode_INSTRUCTION[31 : 20] == 12'h3b5);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_950 <= (decode_INSTRUCTION[31 : 20] == 12'h3b6);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_951 <= (decode_INSTRUCTION[31 : 20] == 12'h3b7);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_952 <= (decode_INSTRUCTION[31 : 20] == 12'h3b8);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_953 <= (decode_INSTRUCTION[31 : 20] == 12'h3b9);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_954 <= (decode_INSTRUCTION[31 : 20] == 12'h3ba);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_955 <= (decode_INSTRUCTION[31 : 20] == 12'h3bb);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_956 <= (decode_INSTRUCTION[31 : 20] == 12'h3bc);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_957 <= (decode_INSTRUCTION[31 : 20] == 12'h3bd);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_958 <= (decode_INSTRUCTION[31 : 20] == 12'h3be);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_959 <= (decode_INSTRUCTION[31 : 20] == 12'h3bf);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_928 <= (decode_INSTRUCTION[31 : 20] == 12'h3a0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_929 <= (decode_INSTRUCTION[31 : 20] == 12'h3a1);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_930 <= (decode_INSTRUCTION[31 : 20] == 12'h3a2);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_931 <= (decode_INSTRUCTION[31 : 20] == 12'h3a3);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3857 <= (decode_INSTRUCTION[31 : 20] == 12'hf11);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3858 <= (decode_INSTRUCTION[31 : 20] == 12'hf12);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3859 <= (decode_INSTRUCTION[31 : 20] == 12'hf13);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3860 <= (decode_INSTRUCTION[31 : 20] == 12'hf14);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_769 <= (decode_INSTRUCTION[31 : 20] == 12'h301);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_768 <= (decode_INSTRUCTION[31 : 20] == 12'h300);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_836 <= (decode_INSTRUCTION[31 : 20] == 12'h344);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_772 <= (decode_INSTRUCTION[31 : 20] == 12'h304);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_773 <= (decode_INSTRUCTION[31 : 20] == 12'h305);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_833 <= (decode_INSTRUCTION[31 : 20] == 12'h341);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_832 <= (decode_INSTRUCTION[31 : 20] == 12'h340);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_834 <= (decode_INSTRUCTION[31 : 20] == 12'h342);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_835 <= (decode_INSTRUCTION[31 : 20] == 12'h343);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2816 <= (decode_INSTRUCTION[31 : 20] == 12'hb00);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2944 <= (decode_INSTRUCTION[31 : 20] == 12'hb80);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2818 <= (decode_INSTRUCTION[31 : 20] == 12'hb02);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2946 <= (decode_INSTRUCTION[31 : 20] == 12'hb82);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3072 <= (decode_INSTRUCTION[31 : 20] == 12'hc00);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3200 <= (decode_INSTRUCTION[31 : 20] == 12'hc80);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3074 <= (decode_INSTRUCTION[31 : 20] == 12'hc02);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3202 <= (decode_INSTRUCTION[31 : 20] == 12'hc82);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3008 <= (decode_INSTRUCTION[31 : 20] == 12'hbc0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_4032 <= (decode_INSTRUCTION[31 : 20] == 12'hfc0);
    end
    if(execute_CsrPlugin_csr_944)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_95_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_945)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_111_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_946)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_127_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_947)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_143_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_948)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_159_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_949)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_175_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_950)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_191_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_951)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_207_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_952)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_223_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_953)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_239_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_954)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_255_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_955)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_271_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_956)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_287_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_957)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_303_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_958)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_319_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_959)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_335_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_928)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_140_ <= _zz_794_[0];
        _zz_139_ <= _zz_795_[0];
        _zz_138_ <= _zz_796_[0];
        _zz_124_ <= _zz_797_[0];
        _zz_123_ <= _zz_798_[0];
        _zz_122_ <= _zz_799_[0];
        _zz_108_ <= _zz_800_[0];
        _zz_107_ <= _zz_801_[0];
        _zz_106_ <= _zz_802_[0];
        _zz_92_ <= _zz_803_[0];
        _zz_91_ <= _zz_804_[0];
        _zz_90_ <= _zz_805_[0];
      end
    end
    if(execute_CsrPlugin_csr_929)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_204_ <= _zz_810_[0];
        _zz_203_ <= _zz_811_[0];
        _zz_202_ <= _zz_812_[0];
        _zz_188_ <= _zz_813_[0];
        _zz_187_ <= _zz_814_[0];
        _zz_186_ <= _zz_815_[0];
        _zz_172_ <= _zz_816_[0];
        _zz_171_ <= _zz_817_[0];
        _zz_170_ <= _zz_818_[0];
        _zz_156_ <= _zz_819_[0];
        _zz_155_ <= _zz_820_[0];
        _zz_154_ <= _zz_821_[0];
      end
    end
    if(execute_CsrPlugin_csr_930)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_268_ <= _zz_826_[0];
        _zz_267_ <= _zz_827_[0];
        _zz_266_ <= _zz_828_[0];
        _zz_252_ <= _zz_829_[0];
        _zz_251_ <= _zz_830_[0];
        _zz_250_ <= _zz_831_[0];
        _zz_236_ <= _zz_832_[0];
        _zz_235_ <= _zz_833_[0];
        _zz_234_ <= _zz_834_[0];
        _zz_220_ <= _zz_835_[0];
        _zz_219_ <= _zz_836_[0];
        _zz_218_ <= _zz_837_[0];
      end
    end
    if(execute_CsrPlugin_csr_931)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_332_ <= _zz_842_[0];
        _zz_331_ <= _zz_843_[0];
        _zz_330_ <= _zz_844_[0];
        _zz_316_ <= _zz_845_[0];
        _zz_315_ <= _zz_846_[0];
        _zz_314_ <= _zz_847_[0];
        _zz_300_ <= _zz_848_[0];
        _zz_299_ <= _zz_849_[0];
        _zz_298_ <= _zz_850_[0];
        _zz_284_ <= _zz_851_[0];
        _zz_283_ <= _zz_852_[0];
        _zz_282_ <= _zz_853_[0];
      end
    end
    if(execute_CsrPlugin_csr_836)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mip_MSIP <= _zz_856_[0];
      end
    end
    if(execute_CsrPlugin_csr_773)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mtvec_base <= execute_CsrPlugin_writeData[31 : 2];
        CsrPlugin_mtvec_mode <= execute_CsrPlugin_writeData[1 : 0];
      end
    end
    if(execute_CsrPlugin_csr_833)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mepc <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_832)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mscratch <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_834)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mcause_interrupt <= _zz_860_[0];
        CsrPlugin_mcause_exceptionCode <= execute_CsrPlugin_writeData[3 : 0];
      end
    end
    if(execute_CsrPlugin_csr_835)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mtval <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2816)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mcycle[31 : 0] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2944)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mcycle[63 : 32] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2818)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_minstret[31 : 0] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2946)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_minstret[63 : 32] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    iBusWishbone_DAT_MISO_regNext <= iBusWishbone_DAT_MISO;
    dBusWishbone_DAT_MISO_regNext <= dBusWishbone_DAT_MISO;
  end

  always @ (posedge clk) begin
    DebugPlugin_firstCycle <= 1'b0;
    if(debug_bus_cmd_ready)begin
      DebugPlugin_firstCycle <= 1'b1;
    end
    DebugPlugin_secondCycle <= DebugPlugin_firstCycle;
    DebugPlugin_isPipBusy <= (({writeBack_arbitration_isValid,{memory_arbitration_isValid,{execute_arbitration_isValid,decode_arbitration_isValid}}} != (4'b0000)) || IBusCachedPlugin_incomingInstruction);
    if(writeBack_arbitration_isValid)begin
      DebugPlugin_busReadDataReg <= _zz_52_;
    end
    _zz_510_ <= debug_bus_cmd_payload_address[2];
    if(_zz_603_)begin
      DebugPlugin_busReadDataReg <= execute_PC;
    end
    DebugPlugin_resetIt_regNext <= DebugPlugin_resetIt;
  end

  always @ (posedge clk) begin
    if(debugReset) begin
      DebugPlugin_resetIt <= 1'b0;
      DebugPlugin_haltIt <= 1'b0;
      DebugPlugin_stepIt <= 1'b0;
      DebugPlugin_godmode <= 1'b0;
      DebugPlugin_haltedByBreak <= 1'b0;
    end else begin
      if((DebugPlugin_haltIt && (! DebugPlugin_isPipBusy)))begin
        DebugPlugin_godmode <= 1'b1;
      end
      if(debug_bus_cmd_valid)begin
        case(_zz_624_)
          6'b000000 : begin
            if(debug_bus_cmd_payload_wr)begin
              DebugPlugin_stepIt <= debug_bus_cmd_payload_data[4];
              if(debug_bus_cmd_payload_data[16])begin
                DebugPlugin_resetIt <= 1'b1;
              end
              if(debug_bus_cmd_payload_data[24])begin
                DebugPlugin_resetIt <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[17])begin
                DebugPlugin_haltIt <= 1'b1;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_haltIt <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_haltedByBreak <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_godmode <= 1'b0;
              end
            end
          end
          6'b000001 : begin
          end
          default : begin
          end
        endcase
      end
      if(_zz_603_)begin
        if(_zz_604_)begin
          DebugPlugin_haltIt <= 1'b1;
          DebugPlugin_haltedByBreak <= 1'b1;
        end
      end
      if(_zz_607_)begin
        if(decode_arbitration_isValid)begin
          DebugPlugin_haltIt <= 1'b1;
        end
      end
    end
  end


endmodule
