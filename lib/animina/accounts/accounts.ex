defmodule Animina.Accounts do
  @moduledoc """
  This is the Accounts module.
  """

  use Ash.Api

  resources do
    resource Animina.Accounts.User
    resource Animina.Accounts.Token
  end
end