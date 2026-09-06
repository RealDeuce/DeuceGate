# Third-party and synchronized files

Unless listed below, DeuceGate is available under the BSD 2-Clause License in
[`LICENSE`](LICENSE).

## Synchronet code-page conversion

`utf8_codepages.c` and `utf8_codepages.h` are synchronized from
`SynchronetBBS/sbbs`. They are copyright 2020-2026 Stephen Hurd and are made
available in this repository under the BSD 2-Clause License.

## Synchronet Base64 implementation

`base64.c` is copyright Rob Swindell and is distributed under the GNU Library
General Public License version 2 or, at the recipient's option, any later
version. See [`LICENSES/LGPL-2.0-or-later.txt`](LICENSES/LGPL-2.0-or-later.txt).

`base64.h` is synchronized and distributed verbatim with its upstream notice,
which states GNU General Public License version 2 or, at the recipient's
option, any later version. See
[`LICENSES/GPL-2.0-or-later.txt`](LICENSES/GPL-2.0-or-later.txt).

The synchronization workflow preserves the upstream contents of these files;
their notices and licenses are not replaced by DeuceGate's project license.

## Fetched dependencies

The build fetches these dependencies into its build directory; they are not
vendored into the DeuceGate source tree:

- `xpdev` is distributed under the GNU Library General Public License version
  2 or, at the recipient's option, any later version.
- DeuceSSH is distributed under the BSD 2-Clause License.

Each fetched source tree includes its own license and copyright notices.
