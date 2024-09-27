return {
	s(
		"p-ts-jest-mock-module",
		t({
			"jest.mock('./utilities.js', () => ({",
			"  ...jest.requireActual('./utilities.js'),",
			"  speak: jest.fn(),",
			"}));",
		})
	),
}
