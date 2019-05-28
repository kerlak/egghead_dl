import FFmpex
use FFmpex.Options

defmodule VideoDownloader do
   def download(m3u8_url, output_path) do
    :ok = FFmpex.new_command
            |> add_global_option(option_y())
            |> add_input_file(m3u8_url)
            |> add_output_file(output_path)
            |> add_file_option(option_c("copy"))
            |> execute
   end
end