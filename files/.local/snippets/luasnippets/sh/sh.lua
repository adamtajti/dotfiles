local function simple_restore(args, _)
  -- return sn(nil, { i(1, args[1]), i(2, "user_text") })
  return sn(nil, { i(1, args[1]) })
end

return {
  s(
    "p-shellcheck-disable-rules-comment",
    t({ "# shellcheck disable=SC2059,..." })
  ),
  s(
    "p-if-file-exists",
    t({
      'if [[ -e "${0:filepath}" ]]; then',
      "fi",
    })
  ),
  s(
    "p-if-file-exists-and-is-regular",
    t({
      'if [[ -f "${0:filepath}" ]]; then',
      "fi",
    })
  ),
  s(
    "p-xargyq",
    t({
      "find . -type f | xargs -I {} yq --front-matter extract '.tags += \"niflheim \"' {}",
    })
  ),
  s(
    "p-unzip-silently",
    t({
      'unzip -qq "path-to-file.zip"',
    })
  ),
  s(
    "p-go-test-code-coverage",
    t({
      "go test -cover -race -covermode atomic -coverprofile=covprofile ./...",
    })
  ),
  s(
    "p-aws-secretsmanager-create-secret-from-file",
    t({
      "AWS_PROFILE=<profile-name> aws secretsmanager create-secret \\",
      "  --name <name-of-the-secret> \\",
      '  --description "<description>" \\',
      "  --secret-string file:///Users/adamtajti/Downloads/credentials.yaml",
    })
  ),
  s(
    "p-nix-flake-extract-version",
    t({
      "nix flake show . --json | jq -r '.defaultPackage.\"aarch64-darwin\".name' | cut -d'-' -f2-",
    })
  ),
  s(
    "p-aws-ecr-docker-login-root-private",
    t({
      "aws ecr get-login-password --region us-east-1 | \\",
      '  docker login --username AWS --password-stdin "<account-id>.dkr.ecr.us-east-1.amazonaws.com"',
    })
  ),
  s(
    "p-aws-ecr-docker-login-root-public",
    t({
      "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/u4f7y3k8",
    })
  ),
  s(
    "p-pass-args-as-array",
    t({
      "declare -a additional_args=()",
      'additional_args+=("--platform=linux/amd64")',
      'docker build --progress plain -t test:latest -f ./Dockerfile ./ "${additional_args[@]}"',
    })
  ),
  s(
    "p-gha-get-branch-name",
    t({
      "branch_name=${{ github.event.pull_request && github.head_ref || github.ref_name }}",
    })
  ),
  s(
    "p-pipe-stdout-to-stderr",
    t({
      "1>&2",
    })
  ),
  s(
    "p-pipe-stderr-to-stdout",
    t({
      "2>&1",
    })
  ),
  s(
    "p-nvim-execute-command-startup",
    t({
      "-c \":execute 'PossessionLoad notebook'\"",
    })
  ),
  s(
    "p-if-application-installed",
    t({
      "if command -v ydotool &> /dev/null; then",
      "fi",
    })
  ),
  s(
    "p-out-multiline-heredoc",
    t({
      "cat << 'EOF' >/etc/important-configuration.conf",
      "CONTENT OF THE FILE",
      "EOF",
      "",
    })
  ),
  s("p-sudo-out-multiline-heredoc", {
    t({ "# ", "" }),
    t({ 'sudo tee -a "' }),
    i(1, "OUTPUT_PATH"),
    t({ '" > /dev/null <<EOF', "" }),
    t({ "# <- no tabs/spaces before first character", "" }),
    t({ "# same applies to the following EOF:", "" }),
    t({ "EOF", "" }),
  }),
  s("p-personal-function-template", {
    t({ "p-" }),
    i(1, "function-name"),
    t({ "()  {", "" }),
    t({ '  if [ "$#" -ne 1 ]; then', "" }),
    t({ '    echo "usage: p-' }),
    d(2, simple_restore, 1),
    t({ ' <argument-name>"', "" }),
    t({ "    return 1", "" }),
    t({ "  fi", "" }),
    t({ "}", "" }),
  }),
}
