# EggheadDl
With EggheadDl you can download the public videos for offline views.
Please, mind the [Terms and Conditions of Use](https://egghead.io/privacy)

Remember that these guys make a great job and invest lots of time to provide these useful information.
:star:[Become a pro member!](https://egghead.io/pricing) and level-up your career:school_satchel:

## Requirements
`ffmpeg`

## Setup

Set algolia credentials on `config.exs` file:

At this time, the application_id value for [egghead.io](https://egghead.io) is `78FD8NWNJK`
You can try with a public temporal api_key: `d1b3f68acf6c2817900630bc0ac6c389`

```elixir
config :algolia,
  application_id: "ALGOLIA_APLICATION_ID",
  api_key: "ALGOLIA_API_KEY"
```


```bash
$ mix deps.get
```

## Execution

```bash
$ iex -S mix

  # Download all courses
  iex> EggheadDl.save_all()

  # Download coursers related to <some_filter>
  iex> EggheadDl.save("Dart")
```
