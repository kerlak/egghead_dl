defmodule EggheadDl do

  def save_all() do
    save("")
  end

  def save(topic) do
    EggheadScrapper.download_courses(topic)
  end
end
