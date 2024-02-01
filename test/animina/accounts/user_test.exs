defmodule Animina.Accounts.UserTest do
  use Animina.DataCase, async: true

  alias Animina.Accounts.User

  describe "gravatar_hash calculation" do
    test "calculates the gravatar_hash correctly" do
      bob =
        Ash.Seed.seed!(%User{
          email: "bob@example.com",
          username: "bob",
          hashed_password: "zzzzzzzzzzz",
          email_confirmed: true,
          date_of_birth: "1950-01-01",
          subscribed_at: 1706659201,
        })
        |> Animina.Accounts.load!(:gravatar_hash)

      assert bob.gravatar_hash ==
               "5ff860bf1190596c7188ab851db691f0f3169c453936e9e1eba2f9a47f7a0018"
    end
  end
end
