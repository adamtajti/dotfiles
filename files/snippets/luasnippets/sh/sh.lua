return {
	s("p-shellcheck-disable-rules-comment", t({ "# shellcheck disable=SC2059,..." })),
	s(
		"p-sh-if-file-exists",
		t({
			'if [[ -e "${0:filepath}" ]]; then',
			"fi",
		})
	),
	s(
		"p-sh-if-file-exists-and-is-regular",
		t({
			'if [[ -f "${0:filepath}" ]]; then',
			"fi",
		})
	),
	s(
		"p-sh-multilineoutput",
		t({ "cat << 'EOF' >/etc/important-configuration.conf", "CONTENT OF THE FILE", "EOF", "" })
	),
	s(
		"p-sh-xargyq",
		t({
			"find . -type f | xargs -I {} yq --front-matter extract '.tags += \"niflheim \"' {}",
		})
	),
	s(
		"p-sh-unzip-silently",
		t({
			'unzip -qq "path-to-file.zip"',
		})
	),
	s(
		"p-sh-go-test-code-coverage",
		t({
			"go test -cover -race -covermode atomic -coverprofile=covprofile ./...",
		})
	),
	s(
		"p-sh-aws-secretsmanager-create-secret-from-file",
		t({
			"AWS_PROFILE=<profile-name> aws secretsmanager create-secret \\",
			"  --name <name-of-the-secret> \\",
			'  --description "<description>" \\',
			"  --secret-string file:///Users/adamtajti/Downloads/credentials.yaml",
		})
	),
	s(
		"p-sh-nix-flake-extract-version",
		t({ "nix flake show . --json | jq -r '.defaultPackage.\"aarch64-darwin\".name' | cut -d'-' -f2-" })
	),
	s(
		"p-sh-aws-ecr-docker-login-root-private",
		t({
			"aws ecr get-login-password --region us-east-1 | \\",
			'  docker login --username AWS --password-stdin "<account-id>.dkr.ecr.us-east-1.amazonaws.com"',
		})
	),
	s(
		"p-sh-aws-ecr-docker-login-root-public",
		t({
			"aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/u4f7y3k8",
		})
	),
	s(
		"p-sh-pass-args-as-array",
		t({
			"declare -a additional_args=()",
			'additional_args+=("--platform=linux/amd64")',
			'docker build --progress plain -t test:latest -f ./Dockerfile ./ "${additional_args[@]}"',
		})
	),
	s(
		"p-sh-gha-get-branch-name",
		t({ "branch_name=${{ github.event.pull_request && github.head_ref || github.ref_name }}" })
	),
	s(
		'p-sh-pipe-stdout-to-stderr',
		t({
			'1>&2',
		})
	),
	s(
		'p-sh-pipe-stderr-to-stdout',
		t({
			'2>&1',
		})
	),
	s(
		'p-sh-nvim-execute-command-startup',
		t({
			"-c \":execute 'PossessionLoad notebook'\"",
		})
	),
	s(
		'p-sh-if-application-installed',
		t({
			'if command -v ydotool &> /dev/null; then',
			'fi',
		})
	),
}
