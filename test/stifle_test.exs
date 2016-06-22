defmodule StifleTest do
  use ExSpec, async: true
  doctest Stifle
  import Stifle

  describe "stifle" do
    it "wraps correct return values" do
      ok_fn = fn -> "ok_fn" end
      assert({:ok, "ok_fn"} == stifle(ok_fn).())
    end

    it "wraps raises" do
      raise_fn = fn -> raise "raise_fn" end
      assert({:error, %RuntimeError{message: "raise_fn"}, _} = stifle(raise_fn).())
    end

    it "wraps exits" do
      exit_fn = fn -> exit "exit_fn" end
      assert({:exit, "exit_fn"} == stifle(exit_fn).())
    end

    it "wraps throws" do
      throw_fn = fn -> throw "throw_fn" end
      assert({:throw, "throw_fn"} == stifle(throw_fn).())
    end
  end

  describe "unstifle" do
    it "unwraps correct return values" do
      ok_fn = fn -> "ok_fn" end
      assert("ok_fn" == stifle(ok_fn).() |> unstifle)
    end

    it "unwraps raises" do
      raise_fn = fn -> raise "raise_fn" end
      assert_raise RuntimeError, "raise_fn", fn ->
        stifle(raise_fn).() |> unstifle
      end
    end

    it "unwraps exits" do
      exit_fn = fn -> exit "exit_fn" end
      try do
        assert("this assertion should not happen" == stifle(exit_fn).() |> unstifle)
      catch
        :exit, x -> assert("exit_fn" == x)
      end
    end

    it "unwraps throws" do
      throw_fn = fn -> throw "throw_fn" end
      try do
        assert("this assertion should not happen" == stifle(throw_fn).() |> unstifle)
      catch
        t -> assert("throw_fn" == t)
      end
    end

    it "raises on bad input" do
      assert_raise RuntimeError, ~r/^invalid input to unstifle/, fn ->
        unstifle(22)
      end
    end
  end
end

