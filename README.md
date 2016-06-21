# Stifle

Stifle is a library for suppressing side-effects (exits, raises, throws)
in Elixir functions, allowing the developer to replay side effects
in the current process or inspect the effect/return value safely.

## Example

```elixir
iex> raise_hell_fn = fn -> raise "hell" end
iex> stifled_fn = Stifle.stifle(raise_hell_fn)
iex> stifled_return_value = stifled_fn.() # => {:error, %RuntimeError{message: "hell"}, [...]}
iex> Stifle.unstifle(stifled_return_value)
** (RuntimeError) hell
```

## [Full Documentation](https://hexdocs.pm/stifle/Stifle.html)

Full documentation is [available on
hexdocs.pm](https://hexdocs.pm/stifle/Stifle.html).


## Authorship and License

Stifle is copyright 2016 Appcues, Inc.

Stifle is released under the [MIT License](LICENSE.txt).

