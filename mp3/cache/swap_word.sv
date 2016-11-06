module swap_word #(data_words = 8)
(
	input [127:0] data_out,
	output logic [15:0] out_word,
	input [15:0] swap_word,
	input [2:0] word_offset,
	output logic [127:0] swap_data,
	input [1:0] mem_byte_enable
);


logic [15:0] internal_word_track;
logic [15:0] write_word;
always_comb begin
swap_data = 'z;
out_word = 'z;
internal_word_track = 'z;
	case(mem_byte_enable)
		2'b00 :	write_word = 16'b0;
		2'b01 :	write_word = {8'b0,swap_word[7:0]};
		2'b10 :	write_word = {swap_word[15:8],8'b0};
		2'b11 :	write_word = swap_word;
	endcase

	for(int i = 0; i < data_words; i++) begin
	  if(word_offset == i) begin
			for(int data_bit = 0; data_bit < 16; data_bit++) begin
				internal_word_track[data_bit] = data_out[16*i + data_bit];
				swap_data[16*i + data_bit] = write_word[data_bit];
			end
		end
		else begin
			for(int data_bit = 0; data_bit < 16; data_bit++) begin
				swap_data[16*i + data_bit] = data_out[16*i + data_bit];
			end
		end
	end
	
	case(mem_byte_enable)
		2'b00 :	out_word = 16'b0;
		2'b01 :	out_word = {8'b0,internal_word_track[7:0]};
		2'b10 :	out_word = {internal_word_track[15:8],8'b0};
		2'b11 :	out_word = internal_word_track;
	endcase
end
endmodule : swap_word
