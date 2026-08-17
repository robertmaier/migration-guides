# js-migration-guides

A structured, machine-readable database of migration guides for JavaScript and Node.js packages — intended to be served to AI agents and tooling.

## Structure

```
index.json              # Package discovery — lists every package and its file path
schema.json             # JSON Schema for all package files
packages/
  rspack.json           # One file per package
  ...
```

### `index.json`

Flat list of all packages. Use this as the entry point to discover what's available.

```json
{
  "packages": [
    { "package": "@rspack/core", "file": "packages/rspack.json", "ecosystem": "javascript" }
  ]
}
```

### `packages/<name>.json`

One file per package, validated against `schema.json`.

```json
{
  "package": "@rspack/core",
  "ecosystem": "javascript",
  "migrations": [
    {
      "from": "1.x",
      "to": "2.0",
      "title": "Upgrading from v1 to v2",
      "url": "https://rspack.rs/guide/migration/rspack_1.x",
      "breaking": true
    }
  ]
}
```

**`from` / `to` fields** are flexible strings — semver ranges (`^1.0.0`), shorthand (`1.x`), or a package name for cross-package migrations (e.g. `webpack` → `rspack`).

## Contributing

1. Create `packages/<package-name>.json` using the schema.
2. Add an entry to `index.json`.
3. Open a PR.

Validate your file against the schema before submitting:

```bash
npx ajv-cli validate -s schema.json -d "packages/*.json"
```

## Usage as an agent tool

An MCP server or HTTP endpoint can expose this data by:

1. Serving `GET /index` → `index.json`
2. Serving `GET /package/:name` → the matching `packages/<name>.json`
3. Serving `GET /migrate?package=rspack&from=1.x&to=2.0` → the matching migration entry

This repo acts as the static data layer; the server layer is separate.
