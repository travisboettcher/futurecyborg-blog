defmodule HelloPhoenix.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:hello_phoenix, :mailgun_domain),
    key: Application.get_env(:hello_phoenix, :mailgun_key)

  @from "admin@futurecyb.org"

  def send_welcome_email(user) do
    send_email to: user.email,
               from: @from,
               subject: "Welcome!",
               text: welcome_text(user),
               html: welcome_html(user)
  end

  defp welcome_text(user) do
    """
    Welcome to HelloPhoenix, #{user.username}!"
    """
  end

  defp welcome_html(user) do
    Phoenix.View.render_to_string(
      HelloPhoenix.EmailView, "welcome.html", %{username: user.username})
  end
end
