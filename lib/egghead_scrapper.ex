import Algolia

defmodule EggheadScrapper do

    def output_basepath() do
        "output/"
    end

    def output_extension() do
        ".mp4"
    end

    def get_courses(search_filter) do
        search_options = [
            attributesToRetrieve: ["title","url"],
            # hitsPerPage: 15,
            hitsPerPage: 1000,
            page: 0,
        ]
        {:ok,results} =
            "content_production" |> search(search_filter, search_options)
        results["hits"]
            |> Enum.map(fn(item) -> 
                %{
                    title: item["title"] |> String.replace("/", "-"),
                    url: item["url"],
                    lessons: []
                }
            end)
            |> Enum.filter(fn(course) ->
                String.contains?(course.url, "/courses/")
            end)
    end

    def get_lessons(course_url) do
        {"script", _, element} =
            HTTPoison.get!(course_url, [], [timeout: 60_000, recv_timeout: 60_000]).body
            |> Floki.find(".js-react-on-rails-component")
            |> Enum.at(0)

        Poison.decode!(element)["course"]["course"]["lessons"]
        |> Enum.map(fn(lesson) ->
            %{title: lesson["title"] |> String.replace("/", "-"), media_url: lesson["media_urls"]["hls_url"]}
        end)
    end

    def download_courses(search_filter) do
        courses = get_courses(search_filter)
        total_courses = Enum.count(courses)

        courses
        |> Enum.with_index
        |> Enum.each(fn({course, index}) ->
            IO.puts("Start downloading course(" <> Integer.to_string(index + 1) <> "/" <> Integer.to_string(total_courses) <> "): " <> course.title)
            download(%{course | lessons: get_lessons(course.url)})
        end)
    end

    def download(course) do
        total_lessons = Enum.count(course.lessons)
        folder = gen_folder(course)
        File.mkdir_p!(folder)

        course.lessons
        |> Enum.with_index
        |> Enum.map(fn({lesson, index}) ->
            IO.puts("Downloading (" <> Integer.to_string(index + 1) <> "/" <> Integer.to_string(total_lessons) <> "): " <> lesson.title)
            Task.async(fn ->
                VideoDownloader.download(lesson.media_url, folder <> get_output_file(lesson, index + 1))
            end)
        end)
        |> Enum.map(&Task.await(&1, :infinity))
    end

    def gen_folder(course) do
        output_basepath <> course.title <> "/"
    end

    def get_output_file(lesson, index) do
        padding_index = index
            |> Integer.to_string
            |> String.pad_leading(3, "0")

        padding_index <> "." <> lesson.title <> output_extension
    end
end