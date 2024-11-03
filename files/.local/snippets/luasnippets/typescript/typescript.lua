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
  s("p-adonis-psql-import", {
    t({ "import db from '@adonisjs/lucid/services/db'", "" }),
  }),
  s("p-adonis-logger-import", {
    t({ "import logger from '@adonisjs/core/services/logger'", "" }),
  }),
}
