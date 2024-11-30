defmodule AniminaWeb.BetaRegistrationComponents do
  @moduledoc """
  Provides Waitlist UI components.
  """
  use Phoenix.Component
  import AniminaWeb.Gettext
  use PhoenixHTMLHelpers
  import AniminaWeb.CoreComponents
  import AniminaWeb.AniminaComponents
  import Gettext, only: [with_locale: 2]

  def initial_form(assigns) do
    ~H"""
    <div>
      <.notification_box
        message={
          with_locale(@language, fn ->
            gettext(
              "Our competitors charge monthly, even if you don’t find a match. We only charge €20 after you find yours. And it's free for beta testers! 🎉"
            )
          end)
        }
        avatars_urls={[
          "/images/unsplash/men/prince-akachi-4Yv84VgQkRM-unsplash.jpg",
          "/images/unsplash/women/stefan-stefancik-QXevDflbl8A-unsplash.jpg"
        ]}
      />

      <h2 class="text-2xl mt-3 font-semibold dark:text-white">
        <%= with_locale(@language, fn -> %>
          <%= gettext("Current Potential Partners:") %> 123
        <% end) %>
      </h2>

      <.form
        :let={f}
        id="beta_user_registration_form"
        for={@form}
        class="space-y-6 mt-6 group "
        phx-change="validate"
        phx-submit="submit"
      >
        <h2 class="text-2xl mt-3 font-semibold dark:text-white">
          <%= with_locale(@language, fn -> %>
            <%= gettext("Future Partner Information") %>
          <% end) %>
        </h2>

        <.gender_select f={f} language={@language} />

        <h2 class="text-2xl mt-3 font-semibold dark:text-white">
          <%= with_locale(@language, fn -> %>
            <%= gettext("Information about you") %>
          <% end) %>
        </h2>

        <div class="w-[100%] md:grid grid-cols-2 gap-8">
          <.zip_code_select f={f} language={@language} />
          <.height_select f={f} language={@language} />
          <.birthday_select f={f} language={@language} />
          <.occupation_select f={f} language={@language} />
          <.username_select f={f} language={@language} />
          <.name_select f={f} language={@language} />
        </div>

        <div class="w-[100%] flex justify-start">
          <%= submit("Proceed",
            class:
              "flex  justify-center rounded-md bg-indigo-600 dark:bg-indigo-500 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 " <>
                unless(@form.valid? == false,
                  do: "",
                  else: "opacity-40 cursor-not-allowed hover:bg-blue-500 active:bg-blue-500"
                ),
            disabled: @form.valid? == false
          ) %>
        </div>
      </.form>
    </div>
    """
  end

  defp get_field_errors(field, _name) do
    Enum.map(field.errors, &translate_error(&1))
  end

  defp gender_select(assigns) do
    ~H"""
    <div class="flex flex-col items-start">
      <label
        for="user_gender"
        class="block text-sm font-medium leading-6 text-gray-900 dark:text-white"
      >
        <%= with_locale(@language, fn -> %>
          <%= gettext("Gender") %>
        <% end) %>
      </label>
      <div class="mt-2" phx-no-format>
          <%
            item_code = "male"
            item_title =  with_locale(@language, fn -> gettext("Male") end)
          %>
          <div class="flex items-center mb-4">
            <%= radio_button(@f, :gender, item_code,
              id: "gender_" <> item_code,
              class: "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500",
              checked: true
            ) %>
            <%= label(@f, :gender, item_title,
              for: "gender_" <> item_code,
              class: "ml-3 block text-sm font-medium dark:text-white text-gray-700"
            ) %>
          </div>

          <%
            item_code = "female"
            item_title =  with_locale(@language, fn -> gettext("Female") end)
          %>
          <div class="flex items-center mb-4">
            <%= radio_button(@f, :gender, item_code,
              id: "gender_" <> item_code,
              class: "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500"
            ) %>
            <%= label(@f, :gender, item_title,
              for: "gender_" <> item_code,
              class: "ml-3 block text-sm font-medium dark:text-white text-gray-700"
            ) %>
          </div>

          <%
            item_code = "diverse"
            item_title = with_locale(@language, fn -> gettext("Diverse") end)
          %>
          <div class="flex items-center mb-4">
            <%= radio_button(@f, :gender, item_code,
              id: "gender_" <> item_code,
              class: "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500"
            ) %>
            <%= label(@f, :gender, item_title,
              for: "gender_" <> item_code,
              class: "ml-3 block text-sm font-medium dark:text-white text-gray-700"
            ) %>
          </div>
        </div>
    </div>
    """
  end

  defp zip_code_select(assigns) do
    ~H"""
    <div class="flex flex-col items-start ">
      <label
        for="user_zip_code"
        class="block text-sm font-medium leading-6 text-gray-900 dark:text-white"
      >
        <%= with_locale(@language, fn -> %>
          <%= gettext("Zip code") %>
        <% end) %>
      </label>
      <div phx-feedback-for={@f[:zip_code].name} class="w-[100%] mt-2">
        <%= text_input(@f, :zip_code,
          class:
            "block w-full rounded-md border-0 py-1.5 text-gray-900 dark:bg-gray-700 dark:text-white shadow-sm ring-1 ring-inset placeholder:text-gray-400 focus:ring-2 focus:ring-inset sm:text-sm  phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-indigo-600 sm:leading-6 " <>
              unless(get_field_errors(@f[:zip_code], :zip_code) == [],
                do: "ring-red-600 focus:ring-red-600",
                else: "ring-gray-300 focus:ring-indigo-600"
              ),
          # Easter egg (Bundestag)
          placeholder: "11011",
          value: @f[:zip_code].value,
          inputmode: "numeric",
          autocomplete: gettext("postal code"),
          "phx-debounce": "blur"
        ) %>

        <.error :for={msg <- get_field_errors(@f[:zip_code], :zip_code)}>
          <%= with_locale(@language, fn -> %>
            <%= gettext("Zip code") <> " " <> msg %>
          <% end) %>
        </.error>
      </div>
    </div>
    """
  end

  defp height_select(assigns) do
    ~H"""
    <div class="flex flex-col items-start">
      <label
        for="user_height"
        class="block text-sm font-medium leading-6 text-gray-900 dark:text-white"
      >
        <%= with_locale(@language, fn -> %>
          <%= gettext("Height") %>
        <% end) %>
        <span class="text-gray-400 dark:text-gray-100">
          <%= with_locale(@language, fn -> %>
            (<%= gettext("in cm") %>)
          <% end) %>
        </span>
      </label>
      <div phx-feedback-for={@f[:height].name} class="mt-2 w-[100%]">
        <%= text_input(@f, :height,
          class:
            "block w-full rounded-md border-0 py-1.5 text-gray-900  dark:bg-gray-700 dark:text-white shadow-sm ring-1 ring-inset placeholder:text-gray-400 focus:ring-2 focus:ring-inset sm:text-sm  phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-indigo-600 sm:leading-6 " <>
              unless(get_field_errors(@f[:height], :height) == [],
                do: "ring-red-600 focus:ring-red-600",
                else: "ring-gray-300 focus:ring-indigo-600"
              ),
          placeholder: "160",
          inputmode: "numeric",
          value: @f[:height].value,
          "phx-debounce": "blur"
        ) %>

        <.error :for={msg <- get_field_errors(@f[:height], :height)}>
          <%= with_locale(@language, fn -> %>
            <%= gettext("Height") <> " " <> msg %>
          <% end) %>
        </.error>
      </div>
    </div>
    """
  end

  defp birthday_select(assigns) do
    ~H"""
    <div>
      <label
        for="user_birthday"
        class="block text-sm font-medium leading-6 text-gray-900 dark:text-white"
      >
        <%= with_locale(@language, fn -> %>
          <%= gettext("Date of birth dd/mm/yyyy") %>
        <% end) %>
      </label>

      <div phx-feedback-for={@f[:birthday].name} class="mt-2">
        <%= date_input(@f, :birthday,
          class:
            "block w-full rounded-md border-0 py-1.5 text-gray-900 dark:bg-gray-700 dark:text-white dark:[color-scheme:dark] shadow-sm ring-1 ring-inset placeholder:text-gray-400 focus:ring-2 focus:ring-inset sm:text-sm  phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-indigo-600 sm:leading-6 " <>
              unless(get_field_errors(@f[:birthday], :birthday) == [],
                do: "ring-red-600 focus:ring-red-600",
                else: "ring-gray-300 focus:ring-indigo-600"
              ),
          placeholder: "",
          value: @f[:birthday].value,
          autocomplete: gettext("bday"),
          "phx-debounce": "blur"
        ) %>

        <.error :for={msg <- get_field_errors(@f[:birthday], :birthday)}>
          <%= with_locale(@language, fn -> %>
            <%= gettext("Date of birth") <> " " <> msg %>
          <% end) %>
        </.error>
      </div>
    </div>
    """
  end

  defp occupation_select(assigns) do
    ~H"""
    <div>
      <label
        for="user_occupation"
        class="block text-sm font-medium leading-6 text-gray-900 dark:text-white"
      >
        <%= with_locale(@language, fn -> %>
          <%= gettext("Occupation") %>
        <% end) %>
      </label>
      <div phx-feedback-for={@f[:occupation].name} class="mt-2">
        <%= text_input(@f, :occupation,
          class:
            "block w-full rounded-md border-0 py-1.5 dark:bg-gray-700 dark:text-white text-gray-900 shadow-sm ring-1 ring-inset placeholder:text-gray-400 focus:ring-2 focus:ring-inset sm:text-sm  phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-indigo-600 sm:leading-6 " <>
              unless(get_field_errors(@f[:occupation], :name) == [],
                do: "ring-red-600 focus:ring-red-600",
                else: "ring-gray-300 focus:ring-indigo-600"
              ),
          placeholder: with_locale(@language, fn -> gettext("Dating Coach") end),
          value: @f[:occupation].value,
          type: :text,
          required: false,
          autocomplete: "organization-title"
        ) %>
        <.error :for={msg <- get_field_errors(@f[:occupation], :name)}>
          <%= with_locale(@language, fn -> %>
            <%= gettext("Occupation") <> " " <> msg %>
          <% end) %>
        </.error>
      </div>
    </div>
    """
  end

  defp username_select(assigns) do
    ~H"""
    <div>
      <label
        for="user_username"
        class="block text-sm font-medium leading-6 text-gray-900 dark:text-white"
      >
        <%= with_locale(@language, fn -> %>
          <%= gettext("Username") %>
        <% end) %>
      </label>
      <div phx-feedback-for={@f[:username].name} class="mt-2">
        <%= text_input(
          @f,
          :username,
          class:
            "block w-full rounded-md border-0 py-1.5 text-gray-900 dark:bg-gray-700 dark:text-white shadow-sm ring-1 ring-inset placeholder:text-gray-400 focus:ring-2 focus:ring-inset sm:text-sm  phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-indigo-600 sm:leading-6 " <>
              unless(get_field_errors(@f[:username], :username) == [],
                do: "ring-red-600 focus:ring-red-600",
                else: "ring-gray-300 focus:ring-indigo-600"
              ),
          placeholder: with_locale(@language, fn -> gettext("Pusteblume1977") end),
          value: @f[:username].value,
          type: :text,
          required: true,
          autocomplete: :username,
          "phx-debounce": "200"
        ) %>
        <.error :for={msg <- get_field_errors(@f[:username], :username)}>
          <%= with_locale(@language, fn -> %>
            <%= gettext("Username") <> " " <> msg %>
          <% end) %>
        </.error>
      </div>
    </div>
    """
  end

  defp name_select(assigns) do
    ~H"""
    <div>
      <label for="user_name" class="block text-sm font-medium leading-6 text-gray-900 dark:text-white">
        <%= with_locale(@language, fn -> %>
          <%= gettext("Name") %>
        <% end) %>
      </label>
      <div phx-feedback-for={@f[:name].name} class="mt-2">
        <%= text_input(@f, :name,
          class:
            "block w-full rounded-md border-0 py-1.5 dark:bg-gray-700 dark:text-white text-gray-900 shadow-sm ring-1 ring-inset placeholder:text-gray-400 focus:ring-2 focus:ring-inset sm:text-sm  phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-indigo-600 sm:leading-6 " <>
              unless(get_field_errors(@f[:name], :name) == [],
                do: "ring-red-600 focus:ring-red-600",
                else: "ring-gray-300 focus:ring-indigo-600"
              ),
          placeholder: with_locale(@language, fn -> gettext("Alice") end),
          value: @f[:name].value,
          type: :text,
          required: true,
          autocomplete: "given-name"
        ) %>
        <.error :for={msg <- get_field_errors(@f[:name], :name)}>
          <%= with_locale(@language, fn -> %>
            <%= gettext("Name") <> " " <> msg %>
          <% end) %>
        </.error>
      </div>
    </div>
    """
  end
end
