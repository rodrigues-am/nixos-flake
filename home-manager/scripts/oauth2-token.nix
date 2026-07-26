{
  pkgs,
  clientIdFile,
  clientSecretFile,
  refreshTokenFile,
  ...
}:

let
  script = pkgs.writeShellApplication {
    name = "oauth2-token";

    runtimeInputs = with pkgs; [
      curl
      jq
      coreutils
    ];

    text = ''
      set -euo pipefail

      client_id="$(cat "${clientIdFile}")"
      client_secret="$(cat "${clientSecretFile}")"
      refresh_token="$(cat "${refreshTokenFile}")"

      response="$(
        curl -sS \
          --request POST \
          --data-urlencode "client_id=$client_id" \
          --data-urlencode "client_secret=$client_secret" \
          --data-urlencode "refresh_token=$refresh_token" \
          --data-urlencode "grant_type=refresh_token" \
          https://oauth2.googleapis.com/token
      )"

      access_token="$(
        printf '%s' "$response" | jq -r '.access_token // empty'
      )"

      if [ -z "$access_token" ]; then
        echo "Erro ao obter access_token OAuth2." >&2
        echo "Resposta do Google:" >&2
        printf '%s\n' "$response" >&2
        exit 1
      fi

      printf '%s\n' "$access_token"
    '';
  };
in
{
  oauth2-token = script;
}
