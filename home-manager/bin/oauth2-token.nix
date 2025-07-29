{ pkgs, clientIdFile, clientSecretFile, refreshTokenFile, ... }:

let

  script = pkgs.writeShellScriptBin "oauth2-token" ''
         #!/usr/bin/env bash

        client_id="$(cat ${clientIdFile})"
        client_secret="$(cat ${clientSecretFile})"
        refresh_token="$(cat ${refreshTokenFile})"
    access_token=$(curl -s \
          --request POST \
          --data "client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token&grant_type=refresh_token" \
          https://oauth2.googleapis.com/token | jq -r '.access_token')

        echo "$access_token"
  '';

in {

  oauth2-token = script;

}
