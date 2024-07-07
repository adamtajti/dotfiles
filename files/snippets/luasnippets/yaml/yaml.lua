-- YAML snippets will include shell snippets as well, as those can be used in
-- GitHub Actions workflows.
return {
	s("p-gha-write-output", t({ 'echo "WHO=me" >> $GITHUB_OUTPUT' })),
	s("p-gha-read-output", t({ "${{ steps.who-let.outputs.WHO }}" })),
	s(
		"p-gha-concurrency",
		t({ "concurrency:", "  group: ${{ github.workflow }}-${{ github.ref }}", "  cancel-in-progress: true", "" })
	),
	s(
		"p-gha-dump-context",
		t({
			"      - name: Dump GitHub context",
			"        env:",
			"          GITHUB_CONTEXT: ${{ toJson(github) }}",
			"        run: |",
			'          echo "$GITHUB_CONTEXT"',
			"",
		})
	),
	s("p-gha-on-pr", t({ "on:", "  pull_request:", "    types: [opened, reopened, synchronize]" })),
	s(
		"p-gha-install-nix",
		t({
			"    - uses: cachix/install-nix-action@v22",
			"      with:",
			"        nix_path: nixpkgs=channel:nixos-unstable",
			"",
		})
	),
	s(
		"p-gha-build-and-push-to-ecr-example",
		t({
			'name: "Example Workflow for ECR"',
			"",
			"permissions:",
			"  id-token: write # for the creds itself",
			"  contents: read # for checkout",
			"",
			"",
			"jobs:",
			"  example-job-that-uses-ecr:",
			"    runs-on: ubuntu-latest",
			"    steps:",
			"      - uses: actions/checkout@v4",
			"",
			"      - name: configure aws credentials",
			"        uses: aws-actions/configure-aws-credentials@v4",
			"        with:",
			"          role-to-assume: arn:aws:iam::<account-id>:role/<role-name>",
			"          role-session-name: github-action-session",
			"          aws-region: us-east-1",
			"",
			"      - name: Login to Amazon ECR",
			"        id: login-ecr",
			"        uses: aws-actions/amazon-ecr-login@v1",
			"",
			"      - name: Set up Docker Buildx",
			"        uses: docker/setup-buildx-action@v3",
			"",
			"      - name: Get git SHA",
			"        id: git-sha",
			'        run: echo "sha=$(git rev-parse --short=9 HEAD)" >> $GITHUB_OUTPUT',
			"",
			"      - name: Build and push image",
			"        uses: docker/build-push-action@94f8f8c2eec4bc3f1d78c1755580779804cb87b2 # 6.0.1",
			"        with:",
			"          context: path-to-context",
			"          file: path-to-dockerfile",
			"          tags: ${{ steps.login-ecr.outputs.registry }}/name-of-the-docker-registry/image:${{ steps.git-sha.outputs.sha }}",
			"          provenance: false",
			"          push: true",
			"",
		})
	),
	s(
		"p-docker-compose-health-check-s3",
		t({
			"    healthcheck:",
			"      test: /usr/bin/healthcheck.sh",
			"      interval: 10s",
			"      timeout: 10s",
			"      retries: 5",
			"",
		})
	),
	s(
		"p-gha-github-script-sample",
		t({
			"    - name: Call GitHub Script Action",
			"      uses: actions/github-script@v7",
			"      with:",
			"        script: |",
			"          # read about potential calls at https://octokit.github.io/rest.js/v20",
			"",
		})
	),
	s(
		"p-gha-github-script-workflow-dispatch",
		t({
			"    - name: Trigger the workflow-name.yml workflow in another repo",
			"      uses: actions/github-script@v7",
			"      with:",
			"        script: |",
			"          # inputs are optional, max 10",
			"          await github.rest.actions.createWorkflowDispatch({",
			"            owner: '<owner|org>',",
			"            repo: '<repo>',",
			"            workflow_id: '<id or workflow name, update.yaml',",
			"            ref: '<ref:branch,tag,sha>',",
			"            inputs: { input1: 'value', input2: 23 }",
			"          });",
			"",
		})
	),
	s(
		"p-gha-checkout",
		t({
			"      - name: Checkout",
			"        uses: actions/checkout@v4",
			"        with:",
			"          repository: ${{ github.repository }}",
			"          ref: ${{ github.event.inputs.ref}}",
			"          fetch-depth: 1",
		})
	),
	s(
		"p-gha-composite-action-skeleton",
		t({
			"# <describe-the-action>",
			"",
			"name: <name-the-action>",
			"",
			"inputs:",
			"  <input-name>:",
			"    description: |-",
			"			<description-of-input>",
			"    required: false",
			"    type: string",
			"    default: 'if required false'",
			"",
			"runs:",
			"  using: composite",
			"  steps:",
			"    - name: <name-the-step>",
			"      shell: bash",
			"      run: |",
			"				<run-the-script>",
		})
	),
	s(
		"p-gha-call-composite-action",
		t({
			"      - name: Step Name",
			"        uses: ./.github/actions/action-name-folder",
			"        with:",
			"          input: value",
		})
	),
	s(
		"p-gha-update-comment",
		t({

			"# The next three steps were taken from https://github.com/marketplace/actions/create-or-update-comment",
			"# It might be worth to transform this into a composite action in the future.",
			"- name: Find Comment",
			"  uses: peter-evans/find-comment@3eae4d37986fb5a8592848f6a574fdf654e61f9e",
			"  if: github.event_name == 'pull_request'",
			"  id: fc",
			"  with:",
			"  issue-number: ${{ github.event.pull_request.number }}",
			"  comment-author: 'github-actions[bot]'",
			"  body-includes: da9809b341a98f2a9ab02960622bd5f4fb3cbed3 # just a random hash to identify this error",
			"",
			"  # https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts",
			"- name: Create or Update Comment if migration binary is modified",
			"  uses: peter-evans/create-or-update-comment@71345be0265236311c031f5c7866368bd1eff043 #v4.0.0",
			"  if: ${{ github.event_name == 'pull_request' && env.BIN_MODIFIED }}",
			"  with:",
			"  comment-id: ${{ steps.fc.outputs.comment-id }}",
			"  issue-number: ${{ github.event.pull_request.number }}",
			"  body: |",
			"    <!-- da9809b341a98f2a9ab02960622bd5f4fb3cbed3 -->",
			"    > [!WARNING]",
			"    > The changes made in this pull-request results in a different binary than what's already committed in.",
			"    > Use the build.sh script to build the binary and commit it in.",
			"    > [Link to the run](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})",
			"  edit-mode: replace",
			"- name: Update the comment if the issue is resolved",
			"  uses: peter-evans/create-or-update-comment@71345be0265236311c031f5c7866368bd1eff043 #v4.0.0",
			"  if: ${{ github.event_name == 'pull_request' && !env.BIN_MODIFIED && steps.fc.outputs.comment-id != '' }}",
			"  with:",
			"  comment-id: ${{ steps.fc.outputs.comment-id }}",
			"  issue-number: ${{ github.event.pull_request.number }}",
			"  body: |",
			"    <!-- da9809b341a98f2a9ab02960622bd5f4fb3cbed3 -->",
			"    > [!NOTE]",
			"    > The changes made in this pull-request resulted in a different binary than what was already committed in, but it's resolved now!",
			"  edit-mode: replace",
		})
	),
	s(
		'p-gha-if-pull-request',
		t({
			'if [ "${{ github.event_name }}" == "pull_request" ]; then',
			'fi',
		})
	),
	s(
		'p-gha-if-push',
		t({
			'if [ "${{ github.event_name }}" == "push" ]; then',
			'fi',
		})
	),
}
