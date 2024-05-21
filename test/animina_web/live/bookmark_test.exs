defmodule AniminaWeb.BookmarkTest do
  use AniminaWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Animina.Accounts.User

  describe "Tests the Bookmark Live" do
    setup do
      public_user = create_public_user()

      private_user = create_private_user()

      [
        public_user: public_user,
        private_user: private_user
      ]
    end

    test "The  visited tab on the bookmarks page redirect to the '/my/bookmarks/visited' route",
         %{
           conn: conn,
           public_user: public_user
         } do
      {:ok, index_live, _html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/my/bookmarks")

      {_, {:live_redirect, %{kind: :push, to: url}}} =
        index_live
        |> element("#visited_tab", "Visited")
        |> render_click()

      assert url == "/my/bookmarks/visited"
    end

    test "The  liked tab on the bookmarks page redirect to the '/my/bookmarks/liked' route",
         %{
           conn: conn,
           public_user: public_user
         } do
      {:ok, index_live, _html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/my/bookmarks")

      {_, {:live_redirect, %{kind: :push, to: url}}} =
        index_live
        |> element("#liked_tab", "Liked")
        |> render_click()

      assert url == "/my/bookmarks/liked"
    end

    test "The most often visited tab on the bookmarks page redirect to the '/my/bookmarks/most_often_visited' route",
         %{
           conn: conn,
           public_user: public_user
         } do
      {:ok, index_live, _html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/my/bookmarks")

      {_, {:live_redirect, %{kind: :push, to: url}}} =
        index_live
        |> element("#most_often_visited_tab", "Most Often Visited")
        |> render_click()

      assert url == "/my/bookmarks/most_often_visited"
    end

    test "The longest overall visited tab on the bookmarks page redirect to the '/my/bookmarks/longest_overall_visited' route",
         %{
           conn: conn,
           public_user: public_user
         } do
      {:ok, index_live, _html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/my/bookmarks")

      {_, {:live_redirect, %{kind: :push, to: url}}} =
        index_live
        |> element("#longest_overall_visited_tab", "Longest Overall Visited")
        |> render_click()

      assert url == "/my/bookmarks/longest_overall_visited"
    end

    test "Once  a logged in user views a profile , a bookmark is created and they can see it in the most often visited route for bookmarks",
         %{
           conn: conn,
           public_user: public_user,
           private_user: private_user
         } do
      # we visit the page of private_user , a bookmark and visit_log_entry is created
      {:ok, _index_live, _html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/#{private_user.username}")

      {:ok, index_live, html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/my/bookmarks")

      assert html =~ "Bookmarks"

      assert html =~ "Liked Profiles"

      refute html =~ Ash.CiString.value(private_user.username)

      {_, {:live_redirect, %{kind: :push, to: url}}} =
        index_live
        |> element("#most_often_visited_tab", "Most Often Visited")
        |> render_click()

      assert url == "/my/bookmarks/most_often_visited"

      {:ok, _index_live, html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live("#{url}")

      assert html =~ "Most Often Visited Profiles"
      refute html =~ "Liked Profiles"

      assert html =~ Ash.CiString.value(private_user.username)
    end

    test "Once  a logged in user views a profile , a bookmark is created and they can see it in the longest overall visited route for bookmarks",
         %{
           conn: conn,
           public_user: public_user,
           private_user: private_user
         } do
      # we visit the page of private_user , a bookmark and visit_log_entry is created
      {:ok, _index_live, _html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/#{private_user.username}")

      {:ok, index_live, html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live(~p"/my/bookmarks")

      assert html =~ "Bookmarks"

      assert html =~ "Liked Profiles"

      refute html =~ Ash.CiString.value(private_user.username)

      {_, {:live_redirect, %{kind: :push, to: url}}} =
        index_live
        |> element("#longest_overall_visited_tab", "Longest Overall Visited")
        |> render_click()

      assert url == "/my/bookmarks/longest_overall_visited"

      {:ok, _index_live, html} =
        conn
        |> login_user(%{
          "username_or_email" => public_user.username,
          "password" => "MichaelTheEngineer"
        })
        |> live("#{url}")

      assert html =~ "Longest Overall Visited Profiles"
      refute html =~ "Liked Profiles"

      assert html =~ Ash.CiString.value(private_user.username)
    end
  end

  defp create_public_user do
    {:ok, user} =
      User.create(%{
        email: "adam@example.com",
        username: "adam",
        name: "Adam Newuser",
        hashed_password: Bcrypt.hash_pwd_salt("MichaelTheEngineer"),
        birthday: "1950-01-01",
        height: 180,
        zip_code: "56068",
        gender: "male",
        mobile_phone: "0151-12345678",
        language: "en",
        legal_terms_accepted: true
      })

    user
  end

  defp create_private_user do
    {:ok, user} =
      User.create(%{
        email: "private@example.com",
        username: "private",
        name: "Private",
        hashed_password: Bcrypt.hash_pwd_salt("MichaelTheEngineer"),
        birthday: "1950-01-01",
        height: 180,
        zip_code: "56068",
        gender: "male",
        mobile_phone: "0151-22345678",
        language: "en",
        is_private: true,
        legal_terms_accepted: true
      })

    user
  end

  defp login_user(conn, attributes) do
    {:ok, lv, _html} = live(conn, ~p"/sign-in/")

    form =
      form(lv, "#basic_user_sign_in_form", user: attributes)

    submit_form(form, conn)
  end
end
