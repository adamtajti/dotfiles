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
}
