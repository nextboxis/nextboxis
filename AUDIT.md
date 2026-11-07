# Repo Audit: nextboxis (checked against the public repos)

## Important: your master resume data is out of date
| Item in `README.md` resume data | What the repos actually show |
|---|---|
| NexShield = Python / FastAPI / MongoDB / scikit-learn | v6.1 is **100% pure Rust** (std-only, 13 crates). Python lives in `archive/legacy_python` |
| "Cached NVD lookups in MongoDB, cutting API queries 80%" | Not in the Rust README; likely a legacy-Python claim. Verify before keeping it |
| DNS-Sinkhole = Python / Scapy / TShark / **React UI** | Backend is **Flask** + static HTML/JS (`public/`), no React |
| Zeno-MCP = Python / Rust / TypeScript | Rust-only (`Cargo.toml`, edition 2024) |
| Library Skill Agents, BlackArch | Not cloned/audited here |

Fix these on your resume and profile before an interviewer reads the code.

## Findings per repo
| Repo | Issues | Fix in this pack |
|---|---|---|
| **DNS-Sinkhole** | No tests, no LICENSE, no SECURITY.md, no .gitignore. `cd.yml` only `echo`es a fake deploy and fails on any path containing `token`/`password`/`.env`. Entropy was computed over the whole FQDN (false positives: `strengths.example.com` -> medium). Alphanumeric DGAs missed. Score exceeded the documented 0-100. Upload errors leaked exception text | **Done and tested** (48 tests): patch + files |
| **NexShield** | README badge says *Proprietary* but no LICENSE file. No CI. No tests in the Rust workspace outside the archived Python. `crypto.rs` flagged by my scan is a test fixture (`SuperSecretPassword123!`), not a real secret | Rust CI workflow. **You decide the license** |
| **zeno-mcp** | No CI. 50 `#[test]`s exist but never run automatically. Cargo `authors` is a placeholder | Rust CI workflow |
| **Pishentry** | 12+ binaries committed (`.pkl` models, `.webm` videos, PDFs); `.git` is ~42 MB. No CI | `cleanup-binaries.sh` |
| **MataZero** | Good: license, tests, Dockerfile. Missing SECURITY.md; only CI is a container publish job (does not run tests) | Add a pytest job to CI (see below) |
| **xPing** | Good: license, SECURITY, CHANGELOG, CONTRIBUTING. No tests or CI | Python CI workflow |

## Not verified
I had no Rust toolchain in this environment, so the Rust CI files (`cargo fmt/clippy -D warnings`) are untested. `clippy -D warnings` may fail on existing code. Start with `cargo clippy` without `-D warnings` if it does.

## MataZero CI snippet
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - run: pip install -r requirements.txt -r requirements-dev.txt
      - run: python -m pytest -q
```
