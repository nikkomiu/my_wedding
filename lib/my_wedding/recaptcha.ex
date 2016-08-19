defmodule MyWedding.Recaptcha do
  defstruct [:success, :challenge_ts, :hostname]

  def verify_response(recaptcha_response) do
    HTTPotion.post "https://www.google.com/recaptcha/api/siteverify?" <>
      "secret=" <> Application.get_env(:my_wedding, :recaptcha_secret) <>
      "&response=" <> recaptcha_response
  end
end
