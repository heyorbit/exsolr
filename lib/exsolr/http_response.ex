defmodule Exsolr.HttpResponse do
  @moduledoc """
  Isolate the handling of Solr HTTP responses.
  """

  require Logger

  def body({status, response}) do
    case {status, response} do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        Logger.debug(fn -> response_body end)
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        Logger.warn(fn -> "status_code: #{status_code} - #{response_body}" end)
        {:error, status_code}

      {_, %HTTPoison.Error{id: _, reason: error_reason}} ->
        Logger.error(fn -> error_reason end)
        {:error, error_reason}
    end
  end
end
