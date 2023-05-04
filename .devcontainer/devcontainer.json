{
  "name": "Codespace to perform GitHub Actions Importer Labs",
  "remoteEnv": {
    "INSTALLATION_TYPE": "labs"
  },
  "hostRequirements": {
    "cpus": 4,
    "memory": "8gb",
    "storage": "32gb"
  },
  "customizations": {
    "vscode": {
      "settings": {
        "files.autoSave": "onFocusChange",
        "editor.tabSize": 2
      },
      "extensions": [
        "ms-azuretools.vscode-docker"
      ]
    }
  },
  "postCreateCommand": "gh extension install github/gh-actions-importer || echo 'Could not auto-build. Skipping.' "
}
