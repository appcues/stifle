defmodule Stifle do
  @moduledoc ~s"""
  Stifle is a library for suppressing side-effects (raises, exits, etc)
  in Elixir functions, allowing the developer to replay side effects
  in the current process or inspect the effect/return value safely.

  ## Example

      iex> raise_hell_fn = fn -> raise "hell" end
      iex> stifled_fn = Stifle.stifle(raise_hell_fn)
      iex> stifled_return_value = stifled_fn.() # => {:error, %RuntimeError{message: "hell"}, [...]}
      iex> Stifle.unstifle(stifled_return_value)
      ** (RuntimeError) hell

  ## Installation

  Add Stifle to `mix.exs`:

      def deps do
        [{:stifle, "~> #{Stifle.Mixfile.project[:version]}"}]
      end

      def application do
        [applications: [:stifle]]
      end

  """

  @type stifled_return_value ::
          {:ok, any} |
          {:exit, any} |
          {:throw, any} |
          {:error, Exception.t, [:erlang.stack_item]}


  @doc ~S"""
  Given a function that may have side-effects (exits, raises, throws), returns
  a side-effect-free function that returns a value representing the return
  value or side effect.
  """
  @spec stifle((... -> any | no_return)) :: (... -> stifled_return_value)
  def stifle(fun) do
    fn ->
      try do
        {:ok, fun.()}
      rescue
        e -> {:error, e, System.stacktrace}
      catch
        :exit, x -> {:exit, x}
        t -> {:throw, t}
      end
    end
  end

  @doc ~S"""
  Given the return value of a function emitted from `stifle/1`, either return
  the return value or recreate the stifled side effects (exits, raises, throws)
  in the current process.
  """
  @spec unstifle(stifled_return_value) :: any | no_return
  def unstifle(stifled_return_value) do
    case stifled_return_value do
      {:ok, val} -> val
      {:error, e, trace} -> reraise(e, trace)
      {:throw, t} -> throw t
      {:exit, x} -> exit x
      v -> raise "invalid input to unstifle: #{inspect(v)}"
    end
  end
end

